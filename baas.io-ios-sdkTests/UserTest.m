//
// Created by cetauri on 12. 11. 19..
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "UserTest.h"
#import "Baasio.h"
#import "BaasioUser.h"
#import "UnitTestConstant.h"

@implementation UserTest {
    BOOL exitRunLoop;
}

- (void)setUp
{
    [super setUp];
    exitRunLoop = NO;

    [Baasio setApplicationInfo:TEST_APPLICATION_ID applicationName:TEST_BAASIO_ID];
}

- (void)tearDown
{
    // Tear-down code here.

    [super tearDown];
}

//- (void)test_sync_1_SignUp
//{
//    NSError *error = nil;
//    [BaasioUser signUp:@"cetauri"
//              password:@"cetauri"
//                  name:@"권오상"
//                 email:@"cetauri@gmail.com"
//                 error:&error];
//    NSLog(@"response : ---------------------- %@", error.localizedDescription );
//}
//
//- (void)test_sync_2_SignIn
//{
//    NSError *error = nil;
//    [BaasioUser signIn:@"user10" password:@"user10" error:&error];
//    if (!error) {
//        //성공
//        NSLog(@"Success");
//    } else {
//        //실패
//        NSLog(@"Error: %@", error.localizedDescription);
//    }
//}
//
//- (void)test_sync_3_unsubscribe
//{
//
//
//    BaasioUser *user = [BaasioUser currentUser];
//    user.username = @"cetauri";
//    [user updateInBackground:^(BaasioUser *user) {
//                   	    NSLog(@"success.");
//                    }
//                    failureBlock:^(NSError *error) {
//                    	NSLog(@"error : %@", error.localizedDescription);
//                    }];
//
//}

//- (void)test_sync_4_changePassword
//{
//    NSError *error = nil;
//    [BaasioUser changePassword:@"user11"
//                   newPassword:@"user10"
//                         error:&error];
//    NSLog(@"response : ---------------------- %@", error.localizedDescription );
//}

- (void)test_sync_5_ResetPassword
{
    NSError *error = nil;
    [BaasioUser resetPassword:@"user1"
                        error:&error];
    NSLog(@"response : ----------------------\n%@\n\n", error.localizedDescription );
}

//- (void)test_1_SignUp
//{
//
//
//    [BaasioUser signUpInBackground:@"My ID"
//                          password:@"My Password"
//                              name:@"My name"
//                             email:@"email@baas.io"
//                      successBlock:^(void) {
//                          NSLog(@"success");
//                      }
//                      failureBlock:^(NSError *error) {
//                          NSLog(@"fail : %@", error.localizedDescription);
//                      }];
//}
//
//- (void)test_2_SignIn
//{
//    [BaasioUser signInBackground:@"user10"
//                  password:@"user10"
//              successBlock:^(void) {
//                    NSLog(@"success");
//                    exitRunLoop = YES;
//              }
//              failureBlock:^(NSError *error) {
//                    NSLog(@"fail : %@", error.localizedDescription);
//                    STFail(@"Test Faiil in %@ : %@", NSStringFromSelector(_cmd), error.localizedDescription);
//                    exitRunLoop = YES;
//              }];
//    [self runTestLoop];
//}

//- (void)test_3_ChangePassword
//{
//    BaasioUser *user = [[BaasioUser alloc]init];
//    [user changePasswordInBackground:@"user10"
//                         newPassword:@"user11"
//                        successBlock:^{
//                                  NSLog(@"success");
//                                  exitRunLoop = YES;
//                        }
//                        failureBlock:^(NSError *error) {
//                                  NSLog(@"fail : %@", error.localizedDescription);
//                                  exitRunLoop = YES;
//                        }];
//    [self runTestLoop];
//}

//- (void)test_4_ResetPassword
//{
//    [BaasioUser resetPasswordInBackground:@"user1"
//                             successBlock:^{
//                                 NSLog(@"success");
//                                 exitRunLoop = YES;
//                             }failureBlock:^(NSError *error) {
//                                 NSLog(@"fail : %@", error.localizedDescription);
//                                 exitRunLoop = YES;
//                             }];
//    [self runTestLoop];
//}
//
//- (void)test_9_unsubscribe
//{
//    BaasioUser *user = [BaasioUser user];
//    [user unsubscribeInBackground:^(void) {
//                            NSLog(@"success");
//                      }
//                      failureBlock:^(NSError *error) {
//                          NSLog(@"fail : %@", error.localizedDescription);
//                      }];
//    [self runTestLoop];
//}


- (void)runTestLoop{
    while (!exitRunLoop){
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.5]];
    }
}


- (void)runTestLoopSync{
    NSLog(@"runTestLoopSync");
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:3]];

}
@end