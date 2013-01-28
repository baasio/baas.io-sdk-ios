//
// Created by cetauri on 12. 11. 19..
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "BaasioEntity.h"
#import "BaasioFile.h"
#import "BaasioNetworkManager.h"
#import "Baasio+Private.h"

@implementation BaasioEntity {
    NSMutableDictionary *_entity;
}

-(id) init
{
    self = [super init];
    if (self){
        _entity = [NSMutableDictionary dictionary];
    }
    return self;
}

-(void)set:(NSDictionary *)entity
{
    _entity = [NSMutableDictionary dictionaryWithDictionary:entity];
}

+ (BaasioEntity *)entitytWithName:(NSString *)entityName {
    BaasioEntity *entity = [[BaasioEntity alloc] init];
    entity.entityName = entityName;
    return entity ;
}


- (void) connect:(BaasioEntity *)entity
    relationship:(NSString*)relationship
           error:(NSError **)error{
    NSString *path = [self.entityName stringByAppendingFormat:@"/%@/%@/%@/%@", self.uuid, relationship, entity.entityName, entity.uuid];

    [[BaasioNetworkManager sharedInstance] connectWithHTTPSync:path
                                                    withMethod:@"POST"
                                                        params:_entity
                                                         error:error];
    return;
}
- (BaasioRequest*)connectInBackground:(BaasioEntity *)entity
                         relationship:(NSString*)relationship
                         successBlock:(void (^)(void))successBlock
                         failureBlock:(void (^)(NSError *error))failureBlock
{
    NSString *path = [self.entityName stringByAppendingFormat:@"/%@/%@/%@/%@", self.uuid, relationship, entity.entityName, entity.uuid];
    
    return [[BaasioNetworkManager sharedInstance] connectWithHTTP:path
                                withMethod:@"POST"
                                    params:_entity
                                   success:^(id result){
                                       successBlock();
                                   }
                                   failure:failureBlock];
}

- (void) disconnect:(BaasioEntity *)entity
    relationship:(NSString*)relationship
           error:(NSError **)error{
    NSString *path = [self.entityName stringByAppendingFormat:@"/%@/%@/%@/%@", self.uuid, relationship, entity.entityName, entity.uuid];

    [[BaasioNetworkManager sharedInstance] connectWithHTTPSync:path
                                                    withMethod:@"DELETE"
                                                        params:_entity
                                                         error:error];
    return;
}
- (BaasioRequest*)disconnectInBackground:(BaasioEntity *)entity
                            relationship:(NSString*)relationship
                            successBlock:(void (^)(void))successBlock
                            failureBlock:(void (^)(NSError *error))failureBlock
{
    NSString *path = [self.entityName stringByAppendingFormat:@"/%@/%@/%@/%@", self.uuid, relationship, entity.entityName, entity.uuid];
    
    return [[BaasioNetworkManager sharedInstance] connectWithHTTP:path
                                withMethod:@"DELETE"
                                    params:_entity
                                   success:^(id result){
                                       successBlock();
                                   }
                                   failure:failureBlock];
}

#pragma mark - Data
- (id)objectForKey:(NSString *)key {
    return _entity[key];
}

// XXX relation??
- (void)setObject:(id)value forKey:(NSString *)key {
    if ([value isMemberOfClass:[BaasioFile class]]){
        [_entity setObject:((BaasioFile*) value).dictionary forKey:key];
    } else if ([value isMemberOfClass:[BaasioUser class]]){
        [_entity setObject:((BaasioUser*) value).dictionary forKey:key];
    } else{
        [_entity setObject:value forKey:key];
    }
}

#pragma mark - Entity

+ (BaasioEntity *)get:(NSString *)entityName
                 uuid:(NSString *)uuid
                error:(NSError **)error
{
    NSString *path = [entityName stringByAppendingFormat:@"/%@", uuid];
    return [[BaasioNetworkManager sharedInstance] connectWithHTTPSync:path
                                                           withMethod:@"GET"
                                                               params:nil
                                                                error:error];
}

+ (BaasioRequest*)getInBackground:(NSString *)entityName
                             uuid:(NSString *)uuid
                     successBlock:(void (^)(BaasioEntity *entity))successBlock
                     failureBlock:(void (^)(NSError *error))failureBlock;
{
    NSString *path = [entityName stringByAppendingFormat:@"/%@", uuid];

    return [[BaasioNetworkManager sharedInstance] connectWithHTTP:path
                                withMethod:@"GET"
                                    params:nil
                                   success:^(id result){
                                       NSDictionary *response = (NSDictionary *)result;
                                       
                                       NSDictionary *dictionary = [NSDictionary dictionaryWithDictionary:response[@"entities"][0]];
                                       NSString *type = response[@"type"];
                                       
                                       BaasioEntity *entity = [BaasioEntity entitytWithName:type];
                                       [entity set:dictionary];
                                       
                                       successBlock(entity);
                                   }
                                   failure:failureBlock];
}

- (BaasioEntity *)save:(NSError **)error {
    
    return [[BaasioNetworkManager sharedInstance] connectWithHTTPSync:self.entityName
                                                           withMethod:@"POST"
                                                               params:_entity
                                                                error:error];
}

- (BaasioRequest*)saveInBackground:(void (^)(BaasioEntity *entity))successBlock
                      failureBlock:(void (^)(NSError *error))failureBlock{
    
    return [[BaasioNetworkManager sharedInstance] connectWithHTTP:self.entityName
                                                       withMethod:@"POST"
                                                           params:_entity
                                                          success:^(id result){
                                                              NSDictionary *response = (NSDictionary *)result;
                                                              
                                                              NSDictionary *dictionary = [NSDictionary dictionaryWithDictionary:response[@"entities"][0]];
                                                              NSString *type = response[@"type"];
                                                              
                                                              BaasioEntity *entity = [BaasioEntity entitytWithName:type];
                                                              [entity set:dictionary];
                                                              
                                                              successBlock(entity);
                                                          }
                                                          failure:failureBlock];
}

- (void)delete:(NSError **)error{
    NSString *path = [self.entityName stringByAppendingFormat:@"/%@", self.uuid];
    
    [[BaasioNetworkManager sharedInstance] connectWithHTTPSync:path
                                                    withMethod:@"DELETE"
                                                        params:nil
                                                         error:error];
    return;
}

- (BaasioRequest*)deleteInBackground:(void (^)(void))successBlock
                        failureBlock:(void (^)(NSError *error))failureBlock{
    
    NSString *path = [self.entityName stringByAppendingFormat:@"/%@", self.uuid];
    
    return [[BaasioNetworkManager sharedInstance] connectWithHTTP:path
                                                       withMethod:@"DELETE"
                                                           params:nil
                                                          success:^(id result){
                                                              successBlock();
                                                          }
                                                          failure:failureBlock];
}

- (BaasioEntity *)update:(NSError **)error{
    
    NSString *path = [self.entityName stringByAppendingFormat:@"/%@", self.uuid];
    return [[BaasioNetworkManager sharedInstance] connectWithHTTPSync:path
                                                           withMethod:@"PUT"
                                                               params:_entity
                                                                error:error];
}

- (BaasioRequest*)updateInBackground:(void (^)(id entity))successBlock
                        failureBlock:(void (^)(NSError *error))failureBlock{
    
    NSString *path = [self.entityName stringByAppendingFormat:@"/%@", self.uuid];
    
    return [[BaasioNetworkManager sharedInstance] connectWithHTTP:path
                                                       withMethod:@"PUT"
                                                           params:_entity
                                                          success:^(id result){
                                                              NSDictionary *response = (NSDictionary *)result;
                                                              
                                                              NSDictionary *dictionary = [NSDictionary dictionaryWithDictionary:response[@"entities"][0]];
                                                              NSString *type = response[@"type"];
                                                              
                                                              BaasioEntity *entity = [BaasioEntity entitytWithName:type];
                                                              [entity set:dictionary];
                                                              
                                                              successBlock(entity);
                                                          }
                                                          failure:failureBlock];
}

#pragma mark - super
- (NSString *)description{
    return _entity.description;
}

#pragma mark - etc
- (NSDictionary *)dictionary{
    return _entity;
}

-(NSString*)created{
    return _entity[@"created"];
}
-(NSString*)modified{
    return _entity[@"modified"];
}
-(NSString*)uuid{
    return _entity[@"uuid"];
}
-(NSString*)type{
    return _entity[@"type"];
}

-(void)setUuid:(NSString*)uuid{
    _entity[@"uuid"] = uuid;
}

@end