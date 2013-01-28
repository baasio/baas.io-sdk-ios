//
// Created by cetauri on 12. 11. 26..
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "PushTest.h"
#import "BaasioPush.h"
#import "Baasio.h"
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

- (void)test_1_RegisterDevice{
    BaasioPush *push = [[BaasioPush alloc] init];
    [push registerInBackground:@"0a328b4155e0d423fef64bf949fce997411acc845c0fcb20bb5e33fd8e9944fa"
                          tags:@[@"man",@"adult"]
                  successBlock:^(void) {
                      exitRunLoop = YES;
                  }
                  failureBlock:^(NSError *error) {
                      NSLog(@"fail : %@", error.localizedDescription);
                      STFail(@"Test Fail in %@ : %@", NSStringFromSelector(_cmd), error.localizedDescription);
                      exitRunLoop = YES;
                  }];
    [self runTestLoop];
}

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
//    config.alert = @"권오상 dea28251-4041-11e2-a05c-02003a570010";
//    config.badge = 2;
////    config.reserve = reserve;
//    config.to = [NSMutableArray arrayWithObject:@"f5df22f9-547e-11e2-b5a4-06ebb80000ba"];
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

- (void)test_3_UnregisterDevice{

    BaasioPush *push = [[BaasioPush alloc] init];
    [push unregisterInBackground:^(void) {
                      exitRunLoop = YES;
                  }
                  failureBlock:^(NSError *error) {
                      NSLog(@"fail : %@", error.localizedDescription);
                      STFail(@"Test Fail in %@ : %@", NSStringFromSelector(_cmd), error.localizedDescription);
                      exitRunLoop = YES;
                  }];
    [self runTestLoop];
}

- (void)runTestLoop{
    while (!exitRunLoop){
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.5]];
    }
}
@end