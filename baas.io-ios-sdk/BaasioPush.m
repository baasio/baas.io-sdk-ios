//
// Created by cetauri on 12. 11. 26..
//
// To change the template use AppCode | Preferences | File Templates.
//

#import "BaasioPush.h"
#import "BaasioNetworkManager.h"

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
    NSString *uuid = [[NSUserDefaults standardUserDefaults]objectForKey:PUSH_DEVICE_ID];
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
- (BaasioRequest*)unregisterInBackground:(void (^)(void))successBlock
                  failureBlock:(void (^)(NSError *error))failureBlock
{
    NSString *uuid = [[NSUserDefaults standardUserDefaults]objectForKey:PUSH_DEVICE_ID];
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

- (void)register:(NSString *)deviceID
            tags:(NSArray *)tags
           error:(NSError**)error
{
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
    return;
}
- (BaasioRequest*)registerInBackground:(NSString *)deviceID
                        tags:(NSArray *)tags
                successBlock:(void (^)(void))successBlock
                failureBlock:(void (^)(NSError *error))failureBlock
{
    NSDictionary *params = @{
                                @"platform" : @"I",
                                @"token" : deviceID,
                                @"tags" : tags
                            };
    NSString *path = @"pushes/devices";
    return [[BaasioNetworkManager sharedInstance] connectWithHTTP:path
                                withMethod:@"POST"
                                    params:params
                                   success:^(id result){
                                       NSDictionary *response = (NSDictionary *)result;
                                       
                                       NSDictionary *entity = response[@"entities"][0];
                                       NSString *uuid = [entity objectForKey:@"uuid"];
                                       //                                                                                            NSLog(@"uuid : %@", uuid);
                                       [[NSUserDefaults standardUserDefaults] setObject:uuid forKey:PUSH_DEVICE_ID];
                                       successBlock();
                                   }
                                   failure:failureBlock];

}

@end