//
// Created by cetauri on 12. 11. 26..
//
// To change the template use AppCode | Preferences | File Templates.
//

#import "BaasioPush.h"
#import "BaasioNetworkManager.h"
#import "BaasioQuery.h"
@implementation BaasioPush {

}

- (void)sendPush:(BaasioMessage *)message
           error:(NSError**)error
{
    NSDictionary *params = [message dictionary];
    [[BaasioNetworkManager sharedInstance] connectWithHTTPSync:@"pushes"
                                                    withMethod:@"POST"
                                                        params:params
                                                         error:error];
    return;
}

- (BaasioRequest*)sendPushInBackground:(BaasioMessage *)message
                successBlock:(void (^)(void))successBlock
                failureBlock:(void (^)(NSError *error))failureBlock
{
    NSDictionary *params = [message dictionary];
    
    return [[BaasioNetworkManager sharedInstance] connectWithHTTP:@"pushes"
                                withMethod:@"POST"
                                    params:params
                                   success:^(id result){
                                       successBlock();
                                   }
                                   failure:failureBlock];
}


- (void)unregister:(NSError**)error
{
    NSString *deviceID = [[NSUserDefaults standardUserDefaults]objectForKey:PUSH_DEVICE_ID];
    if (deviceID == nil)    return;

    BaasioQuery *query = [BaasioQuery queryWithCollection:@"devices"];
    [query setWheres:[NSString stringWithFormat:@"token = '%@'", deviceID]];
    NSArray *response = [query query:error];

    NSString *path = [@"pushes/devices/" stringByAppendingString:response[0][@"uuid"]];
    NSDictionary *params = @{
        @"state" : [NSNumber numberWithBool:false]
    };
    
    [[BaasioNetworkManager sharedInstance] connectWithHTTPSync:path
                                                    withMethod:@"DELETE"
                                                        params:params
                                                         error:error];
    return;
}

- (BaasioRequest*)unregisterInBackground:(void (^)(void))successBlock
                  failureBlock:(void (^)(NSError *error))failureBlock
{
    NSString *deviceID = [[NSUserDefaults standardUserDefaults]objectForKey:PUSH_DEVICE_ID];
    if (deviceID == nil)    {
        successBlock();
        return nil;
    }
    
    BaasioQuery *query = [BaasioQuery queryWithCollection:@"devices"];
    [query setWheres:[NSString stringWithFormat:@"token = '%@'", deviceID]];
    return [query queryInBackground:^(NSArray *response){
                    if (response.count == 0) {
                        successBlock();
                        return;
                    }
                    NSString *path = [@"pushes/devices/" stringByAppendingString:response[0][@"uuid"]];
                    NSDictionary *params = @{
                                             @"state" : [NSNumber numberWithBool:false]
                                             };
        
                    [[BaasioNetworkManager sharedInstance] connectWithHTTP:path
                                                                withMethod:@"DELETE"
                                                                    params:params
                                                                   success:^(id result){
                                                                       successBlock();
                                                                   }
                                                                   failure:^(NSError *error){
                                                                       if (error.code == 101) {
                                                                           successBlock();
                                                                       }else{
                                                                           failureBlock(error);
                                                                       }
                                                                   }];
                }
                failureBlock:failureBlock];
}

- (void)register:(NSString *)deviceID
            tags:(NSArray *)tags
           error:(NSError**)error
{
    [self unregister:error];

    NSDictionary *params = @{
                                @"platform" : @"I",
                                @"token" : deviceID,
                                @"tags" : tags
                            };
    NSString *path = @"pushes/devices";

    [[BaasioNetworkManager sharedInstance] connectWithHTTPSync:path
                                                    withMethod:@"POST"
                                                        params:params
                                                         error:error];

    [[NSUserDefaults standardUserDefaults] setObject:deviceID forKey:PUSH_DEVICE_ID];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    return;
}
- (BaasioRequest*)registerInBackground:(NSString *)deviceID
                        tags:(NSArray *)tags
                successBlock:(void (^)(void))successBlock
                failureBlock:(void (^)(NSError *error))failureBlock
{
    return [self unregisterInBackground:^(void){
                        NSDictionary *params = @{
                                                     @"platform" : @"I",
                                                     @"token" : deviceID,
                                                     @"tags" : tags
                                                 };
        
                        NSString *path = @"pushes/devices";
                        [[BaasioNetworkManager sharedInstance] connectWithHTTP:path
                                                                   withMethod:@"POST"
                                                                       params:params
                                                                      success:^(id result){
                                                                          [[NSUserDefaults standardUserDefaults] setObject:deviceID forKey:PUSH_DEVICE_ID];
                                                                          [[NSUserDefaults standardUserDefaults] synchronize];
                                                                          successBlock();
                                                                      }
                                                                      failure:failureBlock];
                    }
                    failureBlock:failureBlock];
}

- (void)tagUpdate:(NSArray *)tags
            error:(NSError**)error
{
    NSString *uuid = [[NSUserDefaults standardUserDefaults]objectForKey:PUSH_DEVICE_ID];
    if (uuid == nil)    return;
    
    NSString *path = [@"pushes/devices/" stringByAppendingString:uuid];
    NSDictionary *params = @{
                             @"tags" : tags
                             };
    
    [[BaasioNetworkManager sharedInstance] connectWithHTTPSync:path
                                                    withMethod:@"PUT"
                                                        params:params
                                                         error:error];
    return;
}

- (BaasioRequest*)tagUpdateInBackground:(NSArray *)tags
                           successBlock:(void (^)(void))successBlock
                           failureBlock:(void (^)(NSError *error))failureBlock
{
    NSString *uuid = [[NSUserDefaults standardUserDefaults]objectForKey:PUSH_DEVICE_ID];
    if (uuid == nil)    {
        successBlock();
        return nil;
    }
    
    NSString *path = [@"pushes/devices/" stringByAppendingString:uuid];
    NSDictionary *params = @{
                             @"tags" : tags
                             };
    
    return [[BaasioNetworkManager sharedInstance] connectWithHTTP:path
                                                       withMethod:@"PUT"
                                                           params:params
                                                          success:^(id result){
                                                              successBlock();
                                                          }
                                                          failure:failureBlock];
}

- (void)pushOn:(NSError**)error
{
    NSString *uuid = [[NSUserDefaults standardUserDefaults]objectForKey:PUSH_DEVICE_ID];
    if (uuid == nil)    return;
    
    NSString *path = [@"pushes/devices/" stringByAppendingString:uuid];
    
    NSDictionary *params = @{
                             @"state" : [NSNumber numberWithBool:true]
                             };
    
    [[BaasioNetworkManager sharedInstance] connectWithHTTPSync:path
                                                    withMethod:@"PUT"
                                                        params:params
                                                         error:error];
    return;
}

- (BaasioRequest*)pushOnInBackground:(void (^)(void))successBlock
                        failureBlock:(void (^)(NSError *error))failureBlock
{
    NSString *uuid = [[NSUserDefaults standardUserDefaults]objectForKey:PUSH_DEVICE_ID];
    if (uuid == nil)    {
        successBlock();
        return nil;
    }
    
    NSString *path = [@"pushes/devices/" stringByAppendingString:uuid];
    
    NSDictionary *params = @{
                             @"state" : [NSNumber numberWithBool:true]
                             };
    
    return [[BaasioNetworkManager sharedInstance] connectWithHTTP:path
                                                       withMethod:@"PUT"
                                                           params:params
                                                          success:^(id result){
                                                              successBlock();
                                                          }
                                                          failure:failureBlock];
}

- (void)pushOff:(NSError**)error
{
    NSString *uuid = [[NSUserDefaults standardUserDefaults]objectForKey:PUSH_DEVICE_ID];
    if (uuid == nil)    return;
    
    NSString *path = [@"pushes/devices/" stringByAppendingString:uuid];
    
    NSDictionary *params = @{
                             @"state" : [NSNumber numberWithBool:false]
                             };
    
    [[BaasioNetworkManager sharedInstance] connectWithHTTPSync:path
                                                    withMethod:@"PUT"
                                                        params:params
                                                         error:error];
    return;
}

- (BaasioRequest*)pushOffInBackground:(void (^)(void))successBlock
                         failureBlock:(void (^)(NSError *error))failureBlock
{
    NSString *uuid = [[NSUserDefaults standardUserDefaults]objectForKey:PUSH_DEVICE_ID];
    if (uuid == nil)    {
        successBlock();
        return nil;
    }
    
    NSString *path = [@"pushes/devices/" stringByAppendingString:uuid];
    
    NSDictionary *params = @{
                             @"state" : [NSNumber numberWithBool:false]
                             };
    
    return [[BaasioNetworkManager sharedInstance] connectWithHTTP:path
                                                       withMethod:@"PUT"
                                                           params:params
                                                          success:^(id result){
                                                              successBlock();
                                                          }
                                                          failure:failureBlock];
}
@end