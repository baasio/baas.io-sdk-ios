//
// Created by cetauri on 12. 11. 26..
//
// To change the template use AppCode | Preferences | File Templates.
//

#define PUSH_DELIMETER @"\b"
#define PUSH_API_ENDPOINT @"devices"

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

+ (void)registerForRemoteNotificationTypes:(UIRemoteNotificationType)types{
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
    NSString *deviceID = [self storedPushDeviceID];
    if (deviceID == nil) return;

    NSString *path = [NSString stringWithFormat:@"%@/%@", PUSH_API_ENDPOINT, deviceID];
    [[BaasioNetworkManager sharedInstance] connectWithHTTPSync:path
                                                    withMethod:@"DELETE"
                                                        params:nil
                                                         error:error];
    return;
}

- (BaasioRequest*)unregisterInBackground:(void (^)(void))successBlock
                  failureBlock:(void (^)(NSError *error))failureBlock
{
    NSString *deviceID = [self storedPushDeviceID];
    if (deviceID == nil)    {
        successBlock();
        return nil;
    }

    NSString *path = [NSString stringWithFormat:@"%@/%@", PUSH_API_ENDPOINT, deviceID];
    return [[BaasioNetworkManager sharedInstance] connectWithHTTP:path
                                                    withMethod:@"DELETE"
                                                        params:nil
                                                       success:^(id result){
                                                           successBlock();
                                                       }
                                                       failure:^(NSError *error){
                                                              //TODO XXX MERGE 후 주석 제거
    //                                                       if (error.code == RESOURCE_NOT_FOUND_ERROR) {
    //                                                           successBlock();
    //                                                       }else{
                                                               failureBlock(error);
    //                                                       }
                                                       }];

}

- (BaasioRequest*)didRegisterForRemoteNotifications:(NSData *)deviceToken
                                               tags:(NSArray *)tags
                                       successBlock:(void (^)(void))successBlock
                                       failureBlock:(void (^)(NSError *error))failureBlock
{
    if (tags == nil) tags = [NSArray array];

    NSMutableString *deviceID = [NSMutableString string];
    const unsigned char* ptr = (const unsigned char*) [deviceToken bytes];
    for(int i = 0 ; i < 32 ; i++)
    {
        [deviceID appendFormat:@"%02x", ptr[i]];
    }

    NSString *oldDeviceID = [self storedPushDeviceID];


    if (oldDeviceID){

        NSLog(@"baasPush : Already registration");
        
        NSString *currentUser = [BaasioUser currentUser].uuid;
        NSString *storedUser = [self storedPushUserUUID];
        
        if ([storedUser isEqual:[NSNull null]]) storedUser = @"";
        if (currentUser == nil) currentUser = @"";

        if ([deviceID isEqualToString:oldDeviceID] && [storedUser isEqualToString:currentUser]) {

            NSLog(@"baasPush : No Change");
            successBlock();
            return nil;

        } else {
            
            NSLog(@"baasPush : Something Change");
            NSDictionary *params = @{
                                       @"token" : deviceID,
                                       @"tags" : tags
                                   };

            NSString *path = [NSString stringWithFormat:@"%@/%@", PUSH_API_ENDPOINT, oldDeviceID];
            return [[BaasioNetworkManager sharedInstance] connectWithHTTP:path
                                                        withMethod:@"PUT"
                                                            params:params
                                                           success:^(id result) {

                                                               [self storedPushDeviceInfo:deviceID];
                                                               successBlock();

                                                           }failure:^(NSError *error){
                                                               failureBlock(error);
                                                           }];
        }

    }  else {
        
        NSLog(@"baasPush : First registration");
        return [self registerForFirst:tags
                         successBlock:successBlock
                         failureBlock:failureBlock
                             deviceID:deviceID];
    }

}

- (BaasioRequest *)registerForFirst:(NSArray *)tags
                       successBlock:(void (^)())successBlock
                       failureBlock:(void (^)(NSError *))failureBlock
                           deviceID:(NSMutableString *)deviceID {
    NSDictionary *params = @{
                                @"token" : deviceID,
                                @"platform" : @"I",
                                @"tags" : tags
                            };

    return [[BaasioNetworkManager sharedInstance] connectWithHTTP:PUSH_API_ENDPOINT
                                                           withMethod:@"POST"
                                                               params:params
                                                              success:^(id result){

                                                                  [self storedPushDeviceInfo:deviceID];
                                                                  successBlock();
                                                              }
                                                              failure:^(NSError *error) {
                                                                  // Device가 등록되어 있어서 PUT함
                                                                  if (error.code == 913) {   //TODO error code = DUPLICATED_UNIQUE_PROPERTY_ERROR.

                                                                      NSString *path = [NSString stringWithFormat:@"%@/%@", PUSH_API_ENDPOINT, deviceID];
                                                                      [[BaasioNetworkManager sharedInstance] connectWithHTTP:path
                                                                                                                  withMethod:@"PUT"
                                                                                                                      params:params
                                                                                                                     success:^(id result) {

                                                                                                                         [self storedPushDeviceInfo:deviceID];
                                                                                                                         successBlock();
                                                                                                                     }
                                                                                                                     failure:failureBlock];
                                                                  }else{
                                                                      failureBlock(error);
                                                                  }
                                                              }];
}

- (void)tagUpdate:(NSArray *)tags
            error:(NSError**)error
{
    NSString *deviceID = [self storedPushDeviceID];
    if (deviceID == nil)    return;
    
    NSString *path = [NSString stringWithFormat:@"%@/%@", PUSH_API_ENDPOINT, deviceID];
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
    NSString *deviceID = [self storedPushDeviceID];
    if (deviceID == nil)    {
        successBlock();
        return nil;
    }

    NSDictionary *params = @{
                                 @"tags" : tags
                             };

    NSString *path = [NSString stringWithFormat:@"%@/%@", PUSH_API_ENDPOINT, deviceID];
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
    NSString *deviceID = [self storedPushDeviceID];
    if (deviceID == nil)    return;

    NSDictionary *params = @{
                                 @"state" : [NSNumber numberWithBool:true]
                             };

    NSString *path = [NSString stringWithFormat:@"%@/%@", PUSH_API_ENDPOINT, deviceID];
    [[BaasioNetworkManager sharedInstance] connectWithHTTPSync:path
                                                    withMethod:@"PUT"
                                                        params:params
                                                         error:error];
    return;
}

- (BaasioRequest*)pushOnInBackground:(void (^)(void))successBlock
                        failureBlock:(void (^)(NSError *error))failureBlock
{
    NSString *deviceID = [self storedPushDeviceID];
    if (deviceID == nil)    {
        successBlock();
        return nil;
    }

    NSString *path = [NSString stringWithFormat:@"%@/%@", PUSH_API_ENDPOINT, deviceID];
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
    NSString *deviceID = [self storedPushDeviceID];
    if (deviceID == nil)    return;

    NSDictionary *params = @{
                                @"state" : [NSNumber numberWithBool:false]
                             };

    NSString *path = [NSString stringWithFormat:@"%@/%@", PUSH_API_ENDPOINT, deviceID];
    [[BaasioNetworkManager sharedInstance] connectWithHTTPSync:path
                                                    withMethod:@"PUT"
                                                        params:params
                                                         error:error];
    return;
}

- (BaasioRequest*)pushOffInBackground:(void (^)(void))successBlock
                         failureBlock:(void (^)(NSError *error))failureBlock
{
    NSString *deviceID = [self storedPushDeviceID];
    if (deviceID == nil)    {
        successBlock();
        return nil;
    }

    NSDictionary *params = @{
                                 @"state" : [NSNumber numberWithBool:false]
                             };
    NSString *path = [NSString stringWithFormat:@"%@/%@", PUSH_API_ENDPOINT, deviceID];
    return [[BaasioNetworkManager sharedInstance] connectWithHTTP:path
                                                       withMethod:@"PUT"
                                                           params:params
                                                          success:^(id result){
                                                              successBlock();
                                                          }
                                                          failure:failureBlock];
}

#pragma mark - etc

-(NSString *)storedPushDeviceID {
    NSArray *array = [self storedPushDeviceString];
    return array[0];
}
-(NSString *)storedPushUserUUID {
    NSArray *array = [self storedPushDeviceString];
    if (array.count == 1)  return nil;
    
    return array[1];
}

-(NSArray *)storedPushDeviceString {
    NSString *deviceString = [[NSUserDefaults standardUserDefaults] objectForKey:PUSH_DEVICE_ID];
    return [deviceString componentsSeparatedByString:PUSH_DELIMETER];
}

-(void)storedPushDeviceInfo:(NSString *)deviceID{
    NSString *user = @"";
    BaasioUser *currentUser = [BaasioUser currentUser];    
    if (currentUser != nil)
        user = currentUser.uuid;

    NSString *pushDeviceInfo = [NSString stringWithFormat:@"%@%@%@", deviceID, PUSH_DELIMETER, user];

    [[NSUserDefaults standardUserDefaults] setObject:pushDeviceInfo forKey:PUSH_DEVICE_ID];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end