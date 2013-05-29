//
// Created by cetauri on 12. 11. 26..
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "PushTest.h"
#import "BaasioPush.h"
#import "Baasio.h"
#import "BaasioEntity.h"
#import "UnitTestConstant.h"

@implementation PushTest {
    BOOL exitRunLoop;
}
- (void)setUp
{
    [super setUp];
    exitRunLoop = NO;
    
    [Baasio setApplicationInfo:TEST_APPLICATION_ID applicationName:TEST_BAASIO_ID];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.

    [super tearDown];
}

- (void)testToken{
    NSArray *tags = @[@"1",@"2"];
    NSString *token = @"123456789012345678901234567890";
    
    //register
    [[BaasioPush alloc] didRegisterForRemoteNotifications:[token dataUsingEncoding:NSUTF8StringEncoding]
                                                     tags:tags
                                             successBlock:^(void){
                                                 exitRunLoop = YES;
                                             }
                                             failureBlock:^(NSError *error){
                                                NSLog(@"fail : %@", error.localizedDescription);
                                                STFail(@"Test Fail in %@ : %@", NSStringFromSelector(_cmd), error.localizedDescription);
                                                exitRunLoop = YES;
                                             }];

    [self runTestLoop];
    exitRunLoop = NO;

    
    //tag update
    tags = @[@"3",@"4"];
    [[BaasioPush alloc]tagUpdateInBackground:tags
                                successBlock:^(void){
                                    exitRunLoop = YES;
                                    [BaasioEntity getInBackground:@"devices"
                                                                                    uuid:token
                                                                            successBlock:^(BaasioEntity *entity){
                                                                                NSLog(@"entity.description : %@", entity.description);
                                                                                exitRunLoop = YES;
                                                                            }
                                                                            failureBlock:^(NSError *error){
                                                                                NSLog(@"fail : %@", error.localizedDescription);
                                                                                STFail(@"Test Fail in %@ : %@", NSStringFromSelector(_cmd), error.localizedDescription);
                                                                                exitRunLoop = YES;
                                                                            }];
//                                    entity 
                                }
                                failureBlock:^(NSError *error){
                                    NSLog(@"fail : %@", error.localizedDescription);
                                    STFail(@"Test Fail in %@ : %@", NSStringFromSelector(_cmd), error.localizedDescription);
                                    exitRunLoop = YES;
                                }];
    [self runTestLoop];
    exitRunLoop = NO;

    
    //unregister
    [[BaasioPush alloc] unregisterForRemoteNotifications:^(void){
                                                exitRunLoop = YES;
                                            }
                                            failureBlock:^(NSError *error){
                                                NSLog(@"fail : %@", error.localizedDescription);
                                                STFail(@"Test Fail in %@ : %@", NSStringFromSelector(_cmd), error.localizedDescription);

                                                exitRunLoop = YES;
                                            }];

    [self runTestLoop];
}

///**
// Push 발송
// @param message Push 환경 설정 객체
// @param error error
// */
//- (void)sendPush:(BaasioMessage *)message
//           error:(NSError**)error;
//
///**
// Push 발송 asynchronously
// @param message Push 환경 설정 객체
// @param successBlock successBlock
// @param failureBlock failureBlock
// */
//- (BaasioRequest*)sendPushInBackground:(BaasioMessage *)message
//                          successBlock:(void (^)(void))successBlock
//                          failureBlock:(void (^)(NSError *error))failureBlock;
//
///**
// APNS에 디바이스 등록
//
// 앱 시작나 로그인 후에 디바이스 등록이 필요한 시점에 호출하 된다.
// @param types types
// */
//- (void)registerForRemoteNotificationTypes:(UIRemoteNotificationType)types;
//
///**
// APNS에 디바이스 해제
//
// 앱 로그아웃 시에 호출해주면 된다.
// */
//- (void)unregisterForRemoteNotifications:(void (^)(void))successBlock
//                            failureBlock:(void (^)(NSError *error))failureBlock;
//
///**
// 디바이스 등록
//
// baas.io에 디바이스 Token 전달 asynchronously
// @param deviceToken deviceToken
// @param tags tags
// @param successBlock successBlock
// @param failureBlock failureBlock
// */
//- (BaasioRequest*)didRegisterForRemoteNotifications:(NSData *)deviceToken
//                                               tags:(NSArray *)tags
//                                       successBlock:(void (^)(void))successBlock
//                                       failureBlock:(void (^)(NSError *error))failureBlock;
//
///**
// Push tag 수정하기
// @param tags tags
// @param error error
// */
//- (void)tagUpdate:(NSArray *)tags
//            error:(NSError**)error;
//
///**
// Push tag 수정하기 asynchronously
// @param tags tags
// @param successBlock successBlock
// @param failureBlock failureBlock
// */
//- (BaasioRequest*)tagUpdateInBackground:(NSArray *)tags
//                           successBlock:(void (^)(void))successBlock
//                           failureBlock:(void (^)(NSError *error))failureBlock;
//
///**
// Push 켜기
// 서버에서 push 발송을 하지 않도록 설정되어 있다면 push를 발송하도록 상태를 변경합니다.
// @param error error
// */
//- (void)pushOn:(NSError**)error;
//
///**
// Push 켜기 asynchronously
//
// 서버에서 push 발송을 하지 않도록 설정되어 있다면 push를 발송하도록 상태를 변경합니다.
// @param successBlock successBlock
// @param failureBlock failureBlock
// */
//- (BaasioRequest*)pushOnInBackground:(void (^)(void))successBlock
//                        failureBlock:(void (^)(NSError *error))failureBlock;
//
///**
// Push 끄기
//
// 서버에서 push 발송을 하지 않도록 합니다. 설정에서 push on/off 기능이 있다면 이것을 사용하세요.
// @param error error
// */
//- (void)pushOff:(NSError**)error;
//
///**
// Push 끄기 asynchronously
//
// 서버에서 push 발송을 하지 않도록 합니다. 설정에서 push on/off 기능이 있다면 이것을 사용하세요.
// @param successBlock successBlock
// @param failureBlock failureBlock
// */
//- (BaasioRequest*)pushOffInBackground:(void (^)(void))successBlock
//                         failureBlock:(void (^)(NSError *error))failureBlock;
//



//- (void)test_1_RegisterDevice{
//    BaasioPush *push = [[BaasioPush alloc] init];
//    [push registerInBackground:@"0a328b4155e0d423fef64bf949fce997411acc845c0fcb20bb5e33fd8e9944fe"
//                          tags:@[@"man",@"adult"]
//                  successBlock:^(void) {
//                      exitRunLoop = YES;
//                  }
//                  failureBlock:^(NSError *error) {
//                      NSLog(@"fail : %@", error.localizedDescription);
//                      STFail(@"Test Fail in %@ : %@", NSStringFromSelector(_cmd), error.localizedDescription);
//                      exitRunLoop = YES;
//                  }];
//    [self runTestLoop];
//}
//
//
//
//- (void)test_2_sendPush{
//    BaasioPush *push = [[BaasioPush alloc] init];
//    BaasioMessage *config = [[BaasioMessage alloc]init];
//    
//    NSDateComponents *reserve = [[NSDateComponents alloc]init];
//    reserve.year = 2012;
//    reserve.month = 12;
//    reserve.day = 7;
//    reserve.hour = 4;
//    reserve.minute = 55;
//    
//    config.alert = [NSString stringWithFormat:@"%@ %@", [NSDate date],@"테스트 dea28251-4041-11e2-a05c-02003a570010"];
//    config.badge = 2;
//    //    config.reserve = reserve;
//    config.to = [NSMutableArray arrayWithObject:@"man"];
//    
//    [push sendPushInBackground:config
//                  successBlock:^(void) {
//                      exitRunLoop = YES;
//                  }
//                  failureBlock:^(NSError *error) {
//                      NSLog(@"fail : %@", error.localizedDescription);
//                      STFail(@"Test Fail in %@ : %@", NSStringFromSelector(_cmd), error.localizedDescription);
//                      exitRunLoop = YES;
//                  }];
//    [self runTestLoop];
//}
//
//- (void)test_3_updatePush{
//    BaasioPush *push = [[BaasioPush alloc] init];
//    [push pushOn:@[@"a", @"b"] error:nil];
//}
//
//- (void)test_4_UnregisterDevice{
//
//    BaasioPush *push = [[BaasioPush alloc] init];
//    [push unregisterInBackground:^(void) {
//                      exitRunLoop = YES;
//                  }
//                  failureBlock:^(NSError *error) {
//                      NSLog(@"fail : %@", error.localizedDescription);
//                      STFail(@"Test Fail in %@ : %@", NSStringFromSelector(_cmd), error.localizedDescription);
//                      exitRunLoop = YES;
//                  }];
//    [self runTestLoop];
//}
//- (void)test_5_tagUpdate{
//    BaasioPush *push = [[BaasioPush alloc] init];
//    NSError *errors;
//    [push pushTagUpdate:@[@"tttt"]
//                  error:&errors];
//    NSLog(@"%@",errors);
//}
//
//- (void)test_6_tagUpdateInBackground{
//    BaasioPush *push = [[BaasioPush alloc] init];
//    [push pushTagUpdateInBackground:@[@"tttt"]
//                       successBlock:^{
//                           NSLog(@"success");
//                           exitRunLoop = YES;
//                       }
//                       failureBlock:^(NSError *error) {
//                           NSLog(@"fail:%@",error);
//                           exitRunLoop = YES;
//                       }];
//    [self runTestLoop];
//}


- (void)runTestLoop{
    while (!exitRunLoop){
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.5]];
    }
}
@end