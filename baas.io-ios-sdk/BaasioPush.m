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
    
    
    NSMutableString *deviceID = [NSMutableString string];
    const unsigned char* ptr = (const unsigned char*) [deviceToken bytes];
    for(int i = 0 ; i < 32 ; i++)
    {
        [deviceID appendFormat:@"%02x", ptr[i]];
    }
    
    //기존에 등록한 적이 있는가?
    NSLog(@"기기를 등록한 적이 있는가 검사");
    
    if ([[NSUserDefaults standardUserDefaults]objectForKey:PUSH_DEVICE_ID]){
        
        NSLog(@"기기를 등록한 적 있음");
        
        //혹시 토큰이 바뀌었나?
        
        NSLog(@"토큰이 바뀌었나 검사");
        
        if(![deviceID isEqualToString:[[NSUserDefaults standardUserDefaults]objectForKey:PUSH_DEVICE_ID]]){
            
            // 바뀌었다면 PUT을 해줌
            
            NSLog(@"토큰이 바뀌었음");
            
            NSDictionary *params = [[NSDictionary alloc]init];
            if([BaasioUser currentUser]){
                if(tags){
                    params = @{
                               @"platform" : @"I",
                               @"token" : deviceID,
                               @"tags" : tags,
                               @"username" : [[BaasioUser currentUser]objectForKey:@"username"]
                               };
                }else{
                    params = @{
                               @"platform" : @"I",
                               @"token" : deviceID,
                               @"username" : [[BaasioUser currentUser]objectForKey:@"username"]
                               };
                }
            }else{
                if(tags){
                    params = @{
                               @"platform" : @"I",
                               @"token" : deviceID,
                               @"tags" : tags
                               };
                }else{
                    params = @{
                               @"platform" : @"I",
                               @"token" : deviceID
                               };
                }
            }
            
            
            
            NSString *path = [@"devices/" stringByAppendingFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:PUSH_DEVICE_ID]];
            return [[BaasioNetworkManager sharedInstance] connectWithHTTP:path
                                                        withMethod:@"PUT"
                                                            params:params
                                                           success:^(id result) {
                                                               NSLog(@"과거 토큰에서 바뀐 토큰으로 변경완료.");
                                                               [[NSUserDefaults standardUserDefaults] setObject:deviceID forKey:PUSH_DEVICE_ID];
                                                               [[NSUserDefaults standardUserDefaults] synchronize];
                                                               successBlock();
                                                           }failure:^(NSError *error){
                                                               NSLog(@"과거 토큰에서 바뀐 토큰으로 변경실패.");
                                                               failureBlock(error);
                                                           }];
        }
        
        NSLog(@"토큰이 바뀌지 않음");
        
        //혹시 로그인한 유저가 기존 디바이스정보의 유저와 바뀌었나 (또는 기존 디바이스정보에 유저정보가 없나)?
        
        NSLog(@"로그인이 된 상태인지 검사");
        
        if([BaasioUser currentUser]){
            
            NSLog(@"로그인 되어있음");
            
            NSLog(@"다른 유저가 로그인했는지 검사");
            
            BaasioQuery *query = [BaasioQuery queryWithCollection:@"devices"];
            [query setWheres:[NSString stringWithFormat:@"token = '%@'", deviceID]];
            return [query queryInBackground:^(NSArray *objects) {
                if(![[[BaasioUser currentUser]objectForKey:@"username"] isEqualToString:objects[0][@"username"]]){
                    
                    NSLog(@"다른 유저가 로그인함.");
                    
                    // 바뀌었다면 PUT을 해줌
                    
                    NSDictionary *params = [[NSDictionary alloc]init];
                    if([BaasioUser currentUser]){
                        if(tags){
                            params = @{
                                       @"platform" : @"I",
                                       @"token" : deviceID,
                                       @"tags" : tags,
                                       @"username" : [[BaasioUser currentUser]objectForKey:@"username"]
                                       };
                        }else{
                            params = @{
                                       @"platform" : @"I",
                                       @"token" : deviceID,
                                       @"username" : [[BaasioUser currentUser]objectForKey:@"username"]
                                       };
                        }
                    }else{
                        if(tags){
                            params = @{
                                       @"platform" : @"I",
                                       @"token" : deviceID,
                                       @"tags" : tags
                                       };
                        }else{
                            params = @{
                                       @"platform" : @"I",
                                       @"token" : deviceID
                                       };
                        }
                    }
                    
                    NSString *path = [@"devices/" stringByAppendingFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:PUSH_DEVICE_ID]];
                    [[BaasioNetworkManager sharedInstance] connectWithHTTP:path
                                                                       withMethod:@"PUT"
                                                                           params:params
                                                                          success:^(id result) {
                                                                              NSLog(@"유저정보 업데이트 완료.");
                                                                              [[NSUserDefaults standardUserDefaults] setObject:deviceID forKey:PUSH_DEVICE_ID];
                                                                              [[NSUserDefaults standardUserDefaults] synchronize];
                                                                              successBlock();
                                                                          }failure:^(NSError *error){
                                                                              NSLog(@"유저정보 업데이트 실패.");
                                                                              failureBlock(error);
                                                                          }];
                    
                    
                }else{
                    
                   NSLog(@"같은 유저가 로그인함.");
                    
                }
            }failureBlock:^(NSError *error) {
                NSLog(@"디바이스 정보 불러오기 실패");
                failureBlock(error);
            }];
        }
        
        //기기에 등록한 적이 있지만 토큰이 바뀌지 않았고 로그인 되어있지 않다면 여기서 멈춤.
        
        NSLog(@"로그인 되어있는 상태가 아님");

        return nil;
    }
    
    NSLog(@"기기를 등록한 적 없음");
    
    //어서와 Push등록은 처음이지?
    //먼저 baas.io 서버에 붕 떠있는 device token이 존재한다면 먼저 삭제. (앱을 그냥 삭제하고 다시 푸시등록 할 경우를 대비)
    
    BaasioQuery *query = [BaasioQuery queryWithCollection:@"devices"];
    [query setWheres:[NSString stringWithFormat:@"token = '%@'", deviceID]];
    return [query queryInBackground:^(NSArray *response){
        if (response.count == 0) {
            NSDictionary *params = [[NSDictionary alloc]init];
            if([BaasioUser currentUser]){
                if(tags){
                    params = @{
                               @"platform" : @"I",
                               @"token" : deviceID,
                               @"tags" : tags,
                               @"username" : [[BaasioUser currentUser]objectForKey:@"username"]
                               };
                }else{
                    params = @{
                               @"platform" : @"I",
                               @"token" : deviceID,
                               @"username" : [[BaasioUser currentUser]objectForKey:@"username"]
                               };
                }
            }else{
                if(tags){
                    params = @{
                               @"platform" : @"I",
                               @"token" : deviceID,
                               @"tags" : tags
                               };
                }else{
                    params = @{
                               @"platform" : @"I",
                               @"token" : deviceID
                               };
                }
            }
            
            NSString *path = @"devices";
            [[BaasioNetworkManager sharedInstance] connectWithHTTP:path
                                                               withMethod:@"POST"
                                                                   params:params
                                                                  success:^(id result){
                                                                      [[NSUserDefaults standardUserDefaults] setObject:deviceID forKey:PUSH_DEVICE_ID];
                                                                      [[NSUserDefaults standardUserDefaults] synchronize];
                                                                      successBlock();
                                                                  }
                                                                  failure:^(NSError *error) {
                                                                      if (error.code == 911) {   ///////////error code = already exists.
                                                                          [[BaasioNetworkManager sharedInstance] connectWithHTTP:[path stringByAppendingFormat:@"/%@",deviceID]
                                                                                                                      withMethod:@"PUT"
                                                                                                                          params:params
                                                                                                                         success:^(id result) {
                                                                                                                             
                                                                                                                             NSLog(@"기기 등록 성공");
                                                                                                                             
                                                                                                                             [[NSUserDefaults standardUserDefaults] setObject:deviceID forKey:PUSH_DEVICE_ID];
                                                                                                                             [[NSUserDefaults standardUserDefaults] synchronize];
                                                                                                                             successBlock();
                                                                                                                         }
                                                                                                                         failure:failureBlock];
                                                                      }else{
                                                                          failureBlock(error);
                                                                      }
                                                                  }];
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
                                                           NSLog(@"baas.io 서버에 붕떠있는 device가 있어서 삭제를 먼저함");
                                                           NSDictionary *params = [[NSDictionary alloc]init];
                                                           if([BaasioUser currentUser]){
                                                               if(tags){
                                                                   params = @{
                                                                              @"platform" : @"I",
                                                                              @"token" : deviceID,
                                                                              @"tags" : tags,
                                                                              @"username" : [[BaasioUser currentUser]objectForKey:@"username"]
                                                                              };
                                                               }else{
                                                                   params = @{
                                                                              @"platform" : @"I",
                                                                              @"token" : deviceID,
                                                                              @"username" : [[BaasioUser currentUser]objectForKey:@"username"]
                                                                              };
                                                               }
                                                           }else{
                                                               if(tags){
                                                                   params = @{
                                                                              @"platform" : @"I",
                                                                              @"token" : deviceID,
                                                                              @"tags" : tags
                                                                              };
                                                               }else{
                                                                   params = @{
                                                                              @"platform" : @"I",
                                                                              @"token" : deviceID
                                                                              };
                                                               }
                                                           }
                                                           
                                                           NSString *path = @"devices";
                                                           [[BaasioNetworkManager sharedInstance] connectWithHTTP:path
                                                                                                              withMethod:@"POST"
                                                                                                                  params:params
                                                                                                                 success:^(id result){
                                                                                                                     [[NSUserDefaults standardUserDefaults] setObject:deviceID forKey:PUSH_DEVICE_ID];
                                                                                                                     [[NSUserDefaults standardUserDefaults] synchronize];
                                                                                                                     successBlock();
                                                                                                                 }
                                                                                                                 failure:^(NSError *error) {
                                                                                                                     if (error.code == 911) {   ///////////error code = already exists.
                                                                                                                         [[BaasioNetworkManager sharedInstance] connectWithHTTP:[path stringByAppendingFormat:@"/%@",deviceID]
                                                                                                                                                                     withMethod:@"PUT"
                                                                                                                                                                         params:params
                                                                                                                                                                        success:^(id result) {
                                                                                                                                                                            
                                                                                                                                                                            NSLog(@"기기 등록 성공");
                                                                                                                                                                            
                                                                                                                                                                            [[NSUserDefaults standardUserDefaults] setObject:deviceID forKey:PUSH_DEVICE_ID];
                                                                                                                                                                            [[NSUserDefaults standardUserDefaults] synchronize];
                                                                                                                                                                            successBlock();
                                                                                                                                                                        }
                                                                                                                                                                        failure:failureBlock];
                                                                                                                     }else{
                                                                                                                         failureBlock(error);
                                                                                                                     }
                                                                                                                 }];
                                                       }
                                                       failure:^(NSError *error){
                                                           
                                                       }];
    }
                       failureBlock:^(NSError *error) {
                           
                       }];
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