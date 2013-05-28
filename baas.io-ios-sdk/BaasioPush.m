//
// Created by cetauri on 12. 11. 26..
//
// To change the template use AppCode | Preferences | File Templates.
//

#import "BaasioPush.h"
#import "BaasioNetworkManager.h"
#import "BaasioQuery.h"
@interface BaasioPush()
/**
 디바이스 삭제
 @param error error
 */
- (void)unregister:(NSError**)error;

/**
 디바이스 삭제 asynchronously
 @param successBlock successBlock
 @param failureBlock failureBlock
 */
- (BaasioRequest*)unregisterInBackground:(void (^)(void))successBlock
                            failureBlock:(void (^)(NSError *error))failureBlock;

@end

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

- (void)registerForRemoteNotificationTypes:(UIRemoteNotificationType)types{
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:types];
}

- (void)unregisterForRemoteNotifications:(void (^)(void))successBlock
                            failureBlock:(void (^)(NSError *error))failureBlock{
    [self unregisterInBackground:^{
                        [[UIApplication sharedApplication] unregisterForRemoteNotifications];
                        successBlock();
                    }
                    failureBlock:^(NSError *error) {
                        failureBlock(error);
                    }];
}

- (void)unregister:(NSError**)error
{
    NSString *deviceID = [[NSUserDefaults standardUserDefaults]objectForKey:PUSH_DEVICE_ID];
    if (deviceID == nil)    return;

    BaasioQuery *query = [BaasioQuery queryWithCollection:@"devices"];
    [query setWheres:[NSString stringWithFormat:@"token = '%@'", deviceID]];
    NSArray *response = [query query:error];

    NSString *path = [@"devices/" stringByAppendingString:response[0][@"uuid"]];
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
                    NSString *path = [@"devices/" stringByAppendingString:response[0][@"uuid"]];
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

- (BaasioRequest*)didRegisterForRemoteNotifications:(NSData *)deviceToken
                                               tags:(NSArray *)tags
                                       successBlock:(void (^)(void))successBlock
                                       failureBlock:(void (^)(NSError *error))failureBlock
{
    return [self unregisterInBackground:^(void){
        NSMutableString *deviceID = [NSMutableString string];
        const unsigned char* ptr = (const unsigned char*) [deviceToken bytes];
        for(int i = 0 ; i < 32 ; i++)
        {
            [deviceID appendFormat:@"%02x", ptr[i]];
        }
        NSDictionary *params = @{
                                 @"platform" : @"I",
                                 @"token" : deviceID,
                                 @"tags" : tags
                                 };
        
        NSString *path = @"devices";
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
    
    NSString *path = [@"devices/" stringByAppendingString:uuid];
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
    
    NSString *path = [@"devices/" stringByAppendingString:uuid];
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
    
    NSString *path = [@"devices/" stringByAppendingString:uuid];
    
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
    
    NSString *path = [@"devices/" stringByAppendingString:uuid];
    
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
    
    NSString *path = [@"devices/" stringByAppendingString:uuid];
    
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
    
    NSString *path = [@"devices/" stringByAppendingString:uuid];
    
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