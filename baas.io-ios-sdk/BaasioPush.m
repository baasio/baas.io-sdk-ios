//
// Created by cetauri on 12. 11. 26..
//
// To change the template use AppCode | Preferences | File Templates.
//

#import "BaasioPush.h"
#import "BaasioNetworkManager.h"
#import "BaasioQuery.h"
@interface BaasioPush(hidden)
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
    if (deviceID == nil) return;

    NSString *path = [@"devices/" stringByAppendingString:deviceID];

    [[BaasioNetworkManager sharedInstance] connectWithHTTPSync:path
                                                    withMethod:@"DELETE"
                                                        params:nil
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

    NSString *path = [@"devices/" stringByAppendingString:deviceID];

    [[BaasioNetworkManager sharedInstance] connectWithHTTP:path
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
    
    //기존에 등록한 적이 있는가?
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:PUSH_DEVICE_ID]);
    
    NSLog(@"기기를 등록한 적이 있는가 검사");
    
    if ([[NSUserDefaults standardUserDefaults]objectForKey:PUSH_DEVICE_ID]){
        
        NSLog(@"기기를 등록한 적 있음");
        
        //혹시 토큰이 바뀌었나?
        
        NSLog(@"토큰이 바뀌었나 검사");
        
        if(![deviceID isEqualToString:[[[[NSUserDefaults standardUserDefaults]objectForKey:PUSH_DEVICE_ID] componentsSeparatedByString:@"\b"]objectAtIndex:1]]){
            
            // 바뀌었다면 PUT을 해줌
            
            NSLog(@"토큰이 바뀌었음");
            
            NSDictionary *params = [[NSDictionary alloc]init];
            params = @{
                           @"token" : deviceID,
                           @"tags" : tags
                       };
            
            NSString *path = [@"devices/" stringByAppendingFormat:@"%@",[[[[NSUserDefaults standardUserDefaults]objectForKey:PUSH_DEVICE_ID] componentsSeparatedByString:@"\b"]objectAtIndex:1]];
            return [[BaasioNetworkManager sharedInstance] connectWithHTTP:path
                                                        withMethod:@"PUT"
                                                            params:params
                                                           success:^(id result) {
                                                               NSLog(@"과거 토큰에서 바뀐 토큰으로 변경완료.");
                                                               
                                                               NSMutableArray *push_Device_Info = [NSMutableArray array];
                                                               if([BaasioUser currentUser]) [push_Device_Info addObject:[[BaasioUser currentUser]objectForKey:@"uuid"]];
                                                               else [push_Device_Info addObject:@" "];
                                                               [push_Device_Info addObject:deviceID];
                                                               [[NSUserDefaults standardUserDefaults] setObject:[[push_Device_Info valueForKey:@"description"] componentsJoinedByString:@"\b"] forKey:PUSH_DEVICE_ID];
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
            
            if([[[BaasioUser currentUser]objectForKey:@"uuid"] isEqualToString:[[[[NSUserDefaults standardUserDefaults]objectForKey:PUSH_DEVICE_ID] componentsSeparatedByString:@"\b"]objectAtIndex:0]]){
                
                NSLog(@"같은 유저가 로그인하여 끝냄");
                
                return nil;
            }else{
                
                NSLog(@"다른 유저가 로그인하여 PUT진행");
                
                NSDictionary *params = [[NSDictionary alloc]init];
                params = @{
                           @"tags" : tags
                           };
                
                NSString *path = [@"devices/" stringByAppendingFormat:@"%@",[[[[NSUserDefaults standardUserDefaults]objectForKey:PUSH_DEVICE_ID] componentsSeparatedByString:@"\b"]objectAtIndex:1]];
                return [[BaasioNetworkManager sharedInstance] connectWithHTTP:path
                                                                   withMethod:@"PUT"
                                                                       params:params
                                                                      success:^(id result) {
                                                                          NSLog(@"유저 변경완료.");
                                                                          
                                                                          NSMutableArray *push_Device_Info = [NSMutableArray array];
                                                                          [push_Device_Info addObject:[[BaasioUser currentUser]objectForKey:@"uuid"]];
                                                                          [push_Device_Info addObject:deviceID];
                                                    
                                                                          [[NSUserDefaults standardUserDefaults] setObject:[[push_Device_Info valueForKey:@"description"] componentsJoinedByString:@"\b"] forKey:PUSH_DEVICE_ID];
                                                                          [[NSUserDefaults standardUserDefaults] synchronize];
                                                                          successBlock();
                                                                      }failure:^(NSError *error){
                                                                          NSLog(@"유저 변경실패.");
                                                                          failureBlock(error);
                                                                      }];
            }
            
            
            
        }
        
        //기기에 등록한 적이 있지만 토큰이 바뀌지 않았고 로그인 되어있지 않다면 여기서 멈춤.
        
        NSLog(@"로그인 되어있는 상태가 아님");
        
        return nil;
    }

    NSLog(@"기기를 등록한 적 없음");
    
    //어서와 Push등록은 처음이지?
    
    NSDictionary *params = [[NSDictionary alloc]init];
    params = @{
               @"token" : deviceID,
               @"platform" : @"I",
               @"tags" : tags
               };
    
    NSString *path = @"devices";
    return [[BaasioNetworkManager sharedInstance] connectWithHTTP:path
                                                withMethod:@"POST"
                                                    params:params
                                                   success:^(id result){
                                                       NSMutableArray *push_Device_Info = [NSMutableArray array];
                                                       if([BaasioUser currentUser]) [push_Device_Info addObject:[[BaasioUser currentUser]objectForKey:@"uuid"]];
                                                       else [push_Device_Info addObject:@" "];
                                                       [push_Device_Info addObject:deviceID];
                                                       [[NSUserDefaults standardUserDefaults] setObject:[[push_Device_Info valueForKey:@"description"] componentsJoinedByString:@"\b"] forKey:PUSH_DEVICE_ID];
                                                       [[NSUserDefaults standardUserDefaults] synchronize];
                                                       successBlock();
                                                   }
                                                   failure:^(NSError *error) {
                                                       if (error.code == 913) {   //error code = DUPLICATED_UNIQUE_PROPERTY_ERROR.
                                                           
                                                           NSLog(@"Device가 등록되어 있어서 PUT함");
                                                           
                                                           [[BaasioNetworkManager sharedInstance] connectWithHTTP:[path stringByAppendingFormat:@"/%@",deviceID]
                                                                                                       withMethod:@"PUT"
                                                                                                           params:params
                                                                                                          success:^(id result) {
                                                                                                              
                                                                                                              NSLog(@"기기 등록 성공");
                                                                                                              
                                                                                                              NSMutableArray *push_Device_Info = [NSMutableArray array];
                                                                                                              if([BaasioUser currentUser]) [push_Device_Info addObject:[[BaasioUser currentUser]objectForKey:@"uuid"]];
                                                                                                              else [push_Device_Info addObject:@" "];
                                                                                                              [push_Device_Info addObject:deviceID];
                                                                                                              [[NSUserDefaults standardUserDefaults] setObject:[[push_Device_Info valueForKey:@"description"] componentsJoinedByString:@"\b"] forKey:PUSH_DEVICE_ID];
                                                                                                              [[NSUserDefaults standardUserDefaults] synchronize];
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
    NSString *deviceID = [[NSUserDefaults standardUserDefaults]objectForKey:PUSH_DEVICE_ID];
    if (deviceID == nil)    return;
    
    NSString *path = [@"devices/" stringByAppendingString:deviceID];
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
    NSString *deviceID = [[NSUserDefaults standardUserDefaults]objectForKey:PUSH_DEVICE_ID];
    if (deviceID == nil)    {
        successBlock();
        return nil;
    }
    
    NSString *path = [@"devices/" stringByAppendingString:deviceID];
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
    NSString *deviceID = [[NSUserDefaults standardUserDefaults]objectForKey:PUSH_DEVICE_ID];
    if (deviceID == nil)    return;
    
    NSString *path = [@"devices/" stringByAppendingString:deviceID];
    
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
    NSString *deviceID = [[NSUserDefaults standardUserDefaults]objectForKey:PUSH_DEVICE_ID];
    if (deviceID == nil)    {
        successBlock();
        return nil;
    }
    
    NSString *path = [@"devices/" stringByAppendingString:deviceID];
    
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
    NSString *deviceID = [[NSUserDefaults standardUserDefaults]objectForKey:PUSH_DEVICE_ID];
    if (deviceID == nil)    return;
    
    NSString *path = [@"devices/" stringByAppendingString:deviceID];
    
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
    NSString *deviceID = [[NSUserDefaults standardUserDefaults]objectForKey:PUSH_DEVICE_ID];
    if (deviceID == nil)    {
        successBlock();
        return nil;
    }
    
    NSString *path = [@"devices/" stringByAppendingString:deviceID];
    
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