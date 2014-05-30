//
//  HelprTest.m
//  baas.io-ios-sdk
//
//  Created by cetauri on 12. 12. 20..
//  Copyright (c) 2012년 kth. All rights reserved.
//

#import "HelprTest.h"
#import "BaasioHelp.h"
#import "BaasioUser.h"
#import "UnitTestConstant.h"
@implementation HelprTest {
    BOOL exitRunLoop;
}


- (void)setUp
{
    [super setUp];
    [Baasio setApplicationInfo:TEST_APPLICATION_ID applicationName:TEST_BAASIO_ID];
}

- (void)tearDown
{
    // Tear-down code here.
    [super tearDown];
}

- (void)test_1_helpList
{
    BaasioHelp *helpdesk = [[BaasioHelp alloc]init];
    [helpdesk searchHelpsInBackground:@""
          successBlock:^(NSArray *array) {
              NSLog(@"array : %@", array.description);
              exitRunLoop = YES;

          }
          failureBlock:^(NSError *error) {
              NSLog(@"fail : %@", error.localizedDescription);
              XCTFail(@"Test Fail in %@ : %@", NSStringFromSelector(_cmd), error.localizedDescription);
              exitRunLoop = YES;
          }];
    
    [self runTestLoop];
}

- (void)test_2_helpDetail
{
    BaasioHelp *helpdesk = [[BaasioHelp alloc]init];
    [helpdesk getHelpDetailInBackground:@"cf334051-2dee-47ef-b787-2d7f5a889db0"
             successBlock:^(NSDictionary *dictionary) {
                 NSLog(@"dictionary : %@", dictionary);
                 exitRunLoop = YES;
             }
             failureBlock:^(NSError *error) {
                 NSLog(@"fail : %@", error.localizedDescription);
                 XCTFail(@"Test Fail in %@ : %@", NSStringFromSelector(_cmd), error.localizedDescription);
                 exitRunLoop = YES;
             }];
    
    [self runTestLoop];
}




//- (void)test_3_sendQuestion
//{
//
//    [BaasioUser signInBackground:@"helpdesk"
//                        password:@"helpdesk"
//                    successBlock:^(void){
//
//        BaasioHelp *helpdesk = [[BaasioHelp alloc]init];
//        
//        [helpdesk sendQuestionInBackground:@"email@email.com"
//                                   content:@"내용입니다 내용입니다.2"
//                              successBlock:^(void) {
//                                  exitRunLoop = YES;
//                              }
//                              failureBlock:^(NSError *error) {
//                                  NSLog(@"fail : %@", error.localizedDescription);
//                                  STFail(@"Test Fail in %@ : %@", NSStringFromSelector(_cmd), error.localizedDescription);
//                                  exitRunLoop = YES;
//                              }];
//    }
//      failureBlock:^(NSError *error){
//           NSLog(@"fail : %@", error.localizedDescription);
//           STFail(@"Test Fail in %@ : %@", NSStringFromSelector(_cmd), error.localizedDescription);
//           exitRunLoop = YES;
//      }];
//
//    
//    [self runTestLoop];
//}


- (void)runTestLoop{
    while (!exitRunLoop){
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.5]];
    }
}

@end
