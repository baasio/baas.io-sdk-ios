//
// Created by cetauri on 12. 11. 19..
//
// To change the template use AppCode | Preferences | File Templates.
//

#import "BaasioQuery.h"
#import "BaasioNetworkManager.h"

@implementation BaasioQuery {
    
    NSString *_collectionName;
    NSString *_projectionIn;
    NSString *_wheres;
    NSString *_orderKey;
    NSString* _group;
    
    NSMutableArray *_cursors;
    
    BaasioQuerySortOrder _order;
    
    int _limit;
    int _pos;
}

+ (BaasioQuery *)queryWithCollection:(NSString *)name
{
    return [[BaasioQuery alloc] initWithCollectionName:name];
}

+ (BaasioQuery *)queryWithGroup:(NSString *)name
{
    return [[BaasioQuery alloc] initWitGroupName:name];
}

+ (BaasioQuery *)queryWithRelationship:(NSString *)name
{
    return [[BaasioQuery alloc] initWitGroupName:name];
}

-(id) initWithCollectionName:(NSString *)collectionName
{
    self = [super init];
    if (self){
        _collectionName = collectionName;
        _cursors = [NSMutableArray array];
        _pos = -1;
        
    }
    return self;
}

-(id) initWitGroupName:(NSString *)group
{
    self = [super init];
    if (self){
        _group = group;
        _cursors = [NSMutableArray array];
        _pos = -1;
    }
    return self;
}

//-(void)setRelation:(BaasioRelation*)relation;


-(void)setProjectionIn:(NSString *)projectionIn{
    _projectionIn = projectionIn;
}
-(void)setWheres:(NSString *)wheres{
    _wheres = wheres;
}

-(void)setOrderBy:(NSString *)key order:(BaasioQuerySortOrder)order{
    _orderKey = key;
    _order = order;
}

-(void)setLimit: (int)limit{
    _limit = limit;
};

-(NSString *)cursor{
    if (_pos == -1) {
        return @"";
    }
    return _cursors[_pos];
}
-(void)setCursor:(NSString *)cursor{
    _pos = 0;
    _cursors[_pos] = cursor;
}

-(void)clearCursor{
    _pos = -1;
    _cursors = [NSMutableArray array];
}

-(BOOL)hasMoreEntities{
    
    if (_pos == -1){
        return false;
    } else if (_cursors[_pos] == nil){
        return false;
    }
    return true;
}


-(NSString *)description {
    
    NSString *ql = @"select ";
    
    if (_projectionIn != nil) {
        ql= [ql stringByAppendingString:_projectionIn];
    } else {
        ql= [ql stringByAppendingString:@"*"];
    }
    
    if (_wheres != nil) {
        ql= [ql stringByAppendingFormat:@" where %@", _wheres];
    }
    
    if (_orderKey != nil) {
        ql= [ql stringByAppendingFormat:@" order by %@ %@", _orderKey, (_order == BaasioQuerySortOrderDESC) ? @"desc" : @"asc"];
    }
    
    NSString *_sql = [NSString stringWithFormat:@"?ql=%@", [ql stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    if (_limit != 0 ||_limit != 10){
        _sql = [_sql stringByAppendingFormat:@"&limit=%i", _limit];
    }
    
    //    if (_cursors[_pos] != nil){
    if (_pos != -1){
        _sql = [_sql stringByAppendingFormat:@"&cursor=%@", _cursors[_pos] ];
    }
    
    return _sql;
}


-(NSArray *)query:(NSError**)error
{
    NSString *prefixPath = _collectionName;
    if (_group != nil) {
        prefixPath = [NSString stringWithFormat:@"groups/%@/users", _group];
    }
    
    NSString *path = [prefixPath stringByAppendingString:self.description];
    
    return [[BaasioNetworkManager sharedInstance] connectWithHTTPSync:path
                                                           withMethod:@"GET"
                                                               params:nil
                                                                error:error];
}
-(BaasioRequest *)queryInBackground:(void (^)(NSArray *objects))successBlock
                       failureBlock:(void (^)(NSError *error))failureBlock{
    
    NSString *prefixPath = _collectionName;
    if (_group != nil) {
        prefixPath = [NSString stringWithFormat:@"groups/%@/users", _group];
    }
    
    NSString *path = [prefixPath stringByAppendingString:self.description];
    
    return [[BaasioNetworkManager sharedInstance] connectWithHTTP:path
                                                       withMethod:@"GET"
                                                           params:nil
                                                          success:^(id result){
                                                              NSDictionary *response = (NSDictionary *)result;
                                                              
                                                              NSString *cursor = response[@"cursor"];
                                                              if (cursor != nil) {
                                                                  _cursors[++_pos] = response[@"cursor"];
                                                                  NSLog(@"%i == %@", _pos, _cursors[_pos]);
                                                              }else{
                                                                  NSLog(@"---");
                                                              }
                                                              
                                                              NSArray *objects = [NSArray arrayWithArray:response[@"entities"]];
                                                              successBlock(objects);
                                                              
                                                          }
                                                          failure:failureBlock];
}

-(NSArray *)next:(NSError**)error

{
    if(![self hasMoreEntities]){
        NSMutableDictionary* details = [NSMutableDictionary dictionary];
        [details setValue:@"Next entities isn't exist." forKey:NSLocalizedDescriptionKey];
        
        NSString *domain = @"NSObjectNotAvailableException";
        NSError *e = [NSError errorWithDomain:domain code:-1 userInfo:details];
        
        e = *error;
        return nil;
    }
    return [self query:error];
    
}

-(BaasioRequest *)nextInBackground:(void (^)(NSArray *objects))successBlock
                      failureBlock:(void (^)(NSError *error))failureBlock
{
    if(![self hasMoreEntities]){
        NSMutableDictionary* details = [NSMutableDictionary dictionary];
        [details setValue:@"Next entities isn't exist." forKey:NSLocalizedDescriptionKey];
        
        NSString *domain = @"NSObjectNotAvailableException";
        NSError *e = [NSError errorWithDomain:domain code:-1 userInfo:details];
        
        failureBlock(e);
        return nil;
    }
    return [self queryInBackground:successBlock failureBlock:failureBlock];
}

-(NSArray *)prev:(NSError**)error
{
    _pos -= 2;
    if(_pos < 0 ){
        NSMutableDictionary* details = [NSMutableDictionary dictionary];
        [details setValue:@"Prev entities isn't exist." forKey:NSLocalizedDescriptionKey];
        
        NSString *domain = @"NSObjectNotAvailableException";
        NSError *e = [NSError errorWithDomain:domain code:-1 userInfo:details];
        
        e = *error;
        return nil;
    }
    return [self query:error];
}

-(BaasioRequest *)prevInBackground:(void (^)(NSArray *objects))successBlock
                      failureBlock:(void (^)(NSError *error))failureBlock
{
    _pos -= 2;
    if(_pos < 0 ){
        NSMutableDictionary* details = [NSMutableDictionary dictionary];
        [details setValue:@"Prev entities isn't exist." forKey:NSLocalizedDescriptionKey];
        
        NSString *domain = @"NSObjectNotAvailableException";
        NSError *e = [NSError errorWithDomain:domain code:-1 userInfo:details];
        
        failureBlock(e);
        return nil;
    }
    return [self queryInBackground:successBlock failureBlock:failureBlock];
}



@end