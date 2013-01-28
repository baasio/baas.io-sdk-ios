//
//  BaasioGroup.m
//  baas.io-ios-sdk
//
//  Created by cetauri on 12. 12. 11..
//  Copyright (c) 2012년 kth. All rights reserved.
//

#import "BaasioGroup.h"
#import "BaasioNetworkManager.h"

@implementation BaasioGroup{
    NSString *_user;
    NSString *_group;
}

-(id) init
{
    self = [super init];
    if (self){
        self.entityName = @"groups";
    }
    return self;
}

- (void)setGroupName:(NSString*)group{
    _group = group;
    
}
- (void)setUserName:(NSString*)user{
    _user = user;
}


- (void)add:(NSError **)error
{
    NSString *path = [NSString stringWithFormat:@"groups/%@/users/%@", _group, _user];
    [[BaasioNetworkManager sharedInstance] connectWithHTTPSync:path
                                                    withMethod:@"POST"
                                                        params:nil
                                                         error:error];
    return;
}

- (BaasioRequest*)addInBackground:(void (^)(BaasioGroup *group))successBlock
                     failureBlock:(void (^)(NSError *error))failureBlock{

    NSString *path = [NSString stringWithFormat:@"groups/%@/users/%@", _group, _user];
    return [[BaasioNetworkManager sharedInstance] connectWithHTTP:path
                                withMethod:@"POST"
                                    params:nil
                                   success:^(id result){
                                       NSDictionary *dictionary = result[@"entities"][0];
                                       
                                       BaasioGroup *group = [[BaasioGroup alloc]init];
                                       [group set:dictionary];
                                       successBlock(group);
                                       
                                   }
                                   failure:failureBlock];
}

- (void)remove:(NSError **)error
{
    NSString *path = [NSString stringWithFormat:@"groups/%@/users/%@", _group, _user];
    [[BaasioNetworkManager sharedInstance] connectWithHTTPSync:path
                                                    withMethod:@"DELETE"
                                                        params:nil
                                                         error:error];
    return;
}

- (BaasioRequest*)removeInBackground:(void (^)(void))successBlock
                        failureBlock:(void (^)(NSError *error))failureBlock{

    NSString *path = [NSString stringWithFormat:@"groups/%@/users/%@", _group, _user];
    return [[BaasioNetworkManager sharedInstance] connectWithHTTP:path
                                withMethod:@"DELETE"
                                    params:nil
                                   success:^(id result){
                                       successBlock();
                                   }
                                   failure:failureBlock];
}

+ (BaasioRequest*)getInBackground:(NSString *)uuid
                     successBlock:(void (^)(BaasioGroup *entity))successBlock
                     failureBlock:(void (^)(NSError *error))failureBlock
{
    return [BaasioFile getInBackground:@"groups"
                                  uuid:uuid
                          successBlock:^(BaasioEntity *entity) {
                              BaasioGroup *group = [[BaasioGroup alloc]init];
                              [group set:entity.dictionary];
                              successBlock(group);
                          }
                          failureBlock:failureBlock];
}

+ (BaasioGroup *)get:(NSString *)uuid
               error:(NSError **)error{
    BaasioEntity *entity = [super get:@"groups" uuid:uuid error:error];
    BaasioGroup *group = [[BaasioGroup alloc]init];
    [group set:entity.dictionary];
    return group;
}


- (BaasioGroup *)save:(NSError **)error
{
    BaasioEntity *entity = [super save:error];
    BaasioGroup *group = [[BaasioGroup alloc]init];
    [group set:entity.dictionary];
    return group;
}

- (BaasioRequest*)saveInBackground:(void (^)(BaasioGroup *group))successBlock
                      failureBlock:(void (^)(NSError *error))failureBlock{
    return [super saveInBackground:^(BaasioEntity *entity){
        BaasioGroup *group = [[BaasioGroup alloc]init];
        [group set:entity.dictionary];
        successBlock(group);
    }
                      failureBlock:failureBlock];
}

- (BaasioGroup *)update:(NSError **)error
{
    BaasioEntity *entity = [super update:error];
    BaasioGroup *group = [[BaasioGroup alloc]init];
    [group set:entity.dictionary];
    return group;
}


- (BaasioRequest*)updateInBackground:(void (^)(BaasioGroup *group))successBlock
                        failureBlock:(void (^)(NSError *error))failureBlock
{
    return [super updateInBackground:^(BaasioEntity *entity){
        BaasioGroup *group = [[BaasioGroup alloc]init];
        [group set:entity.dictionary];
        successBlock(group);
    }
                        failureBlock:failureBlock];
}

@end
