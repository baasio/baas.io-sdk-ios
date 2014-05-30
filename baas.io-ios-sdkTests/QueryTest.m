//
// Created by cetauri on 12. 11. 26..
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "QueryTest.h"
#import "BaasioQuery.h"
#import "Baasio.h"
#import "BaasioEntity.h"
#import "UnitTestConstant.h"
@implementation QueryTest {
    BOOL exitRunLoop;
}
- (void)setUp
{
    [super setUp];
    exitRunLoop = NO;
    
    [Baasio setApplicationInfo:TEST_APPLICATION_ID applicationName:TEST_BAASIO_ID];
    [[Baasio sharedInstance]isDebugMode:YES];
    
    
    NSURL *URL = [NSURL URLWithString:@"https://api.baas.io"];
    [NSURLRequest.class performSelector:NSSelectorFromString(@"setAllowsAnyHTTPSCertificate:forHost:")
                             withObject:NSNull.null  // Just need to pass non-nil here to appear as a BOOL YES, using the NSNull.null singleton is pretty safe
                             withObject:[URL host]];
}

- (void)tearDown
{
    // Tear-down code here.
    [super tearDown];
}

- (void)test_1_QueryBuild{
    BaasioQuery *query = [BaasioQuery queryWithCollection:@"tests"];
    [query setLimit:10];
    [query setProjectionIn:@"name, title"];
    [query setOrderBy:@"name" order:BaasioQuerySortOrderASC];
    [query setWheres:@"name = 1"];

    NSLog(@"description : %@", query.description);
}
- (void)test_2_QueryPreNextTest{
    

    BaasioQuery *query = [BaasioQuery queryWithCollection:@"tests"];
//    [query setCursor:@"cursor"];
    [query setLimit:3];
    
    [query queryInBackground:^(NSArray *array) {
                XCTAssertTrue(array.count == 3, @"count is not equals.", nil);
        
                XCTAssertTrue([[array objectAtIndex:0][@"count"] intValue] == 0, @"wrong.", nil);
                NSLog(@"array : %@", array.description);

                [query nextInBackground:^(NSArray *array) {
                    XCTAssertTrue(array.count == 3, @"count is not equals.", nil);
                    
                    XCTAssertTrue([[array objectAtIndex:0][@"count"] intValue] == 3, @"wrong.", nil);
                    NSLog(@"array : %@", array.description);

                    [query nextInBackground:^(NSArray *array) {
                        XCTAssertTrue(array.count == 3, @"count is not equals.", nil);
                        XCTAssertTrue([[array objectAtIndex:0][@"count"] intValue] == 6, @"wrong.", nil);
                        NSLog(@"array : %@", array.description);
                        [query nextInBackground:^(NSArray *array) {
                                XCTAssertTrue(array.count == 3, @"count is not equals.", nil);
                            
                            XCTAssertTrue([[array objectAtIndex:0][@"count"] intValue] == 9, @"wrong.", nil);
                                NSLog(@"array : %@", array.description);
                                [query prevInBackground:^(NSArray *array) {
                                    XCTAssertTrue(array.count == 3, @"count is not equals.", nil);
                                    XCTAssertTrue([[array objectAtIndex:0][@"count"] intValue] == 6, @"wrong.", nil);
                                    NSLog(@"array : %@", array.description);
                                    [query prevInBackground:^(NSArray *array) {
                                        XCTAssertTrue(array.count == 3, @"count is not equals.", nil);
                                        XCTAssertTrue([[array objectAtIndex:0][@"count"] intValue] == 3, @"wrong.", nil);
                                        NSLog(@"array : %@", array.description);
                                        exitRunLoop = YES;
                                        
                                    }
                                   failureBlock:^(NSError *error) {
                                       NSLog(@"fail : %@", error.localizedDescription);
                                       XCTFail(@"Test Fail in %@ : %@", NSStringFromSelector(_cmd), error.localizedDescription);
                                       exitRunLoop = YES;
                                   }];
                                    
                                }
                                   failureBlock:^(NSError *error) {
                                       NSLog(@"fail : %@", error.localizedDescription);
                                       XCTFail(@"Test Fail in %@ : %@", NSStringFromSelector(_cmd), error.localizedDescription);
                                       exitRunLoop = YES;
                                   }];

                            }
                           failureBlock:^(NSError *error) {
                               NSLog(@"fail : %@", error.localizedDescription);
                               XCTFail(@"Test Fail in %@ : %@", NSStringFromSelector(_cmd), error.localizedDescription);
                               exitRunLoop = YES;
                           }];

                    }
                   failureBlock:^(NSError *error) {
                       NSLog(@"fail : %@", error.localizedDescription);
                       XCTFail(@"Test Fail in %@ : %@", NSStringFromSelector(_cmd), error.localizedDescription);
                       exitRunLoop = YES;
                   }];


                }
                   failureBlock:^(NSError *error) {
                       NSLog(@"fail : %@", error.localizedDescription);
                       XCTFail(@"Test Fail in %@ : %@", NSStringFromSelector(_cmd), error.localizedDescription);
                       exitRunLoop = YES;
                   }];
                 }
               failureBlock:^(NSError *error) {
                   NSLog(@"fail : %@", error.localizedDescription);
                   XCTFail(@"Test Fail in %@ : %@", NSStringFromSelector(_cmd), error.localizedDescription);
                   exitRunLoop = YES;
               }];
    
    
    [self runTestLoop];

}
- (void)test_3_relationQuery{
    BaasioQuery *query = [BaasioQuery queryWithRelationship:@"master"
                                                   withUUID:@"fd0c96dc-8573-11e2-9f13-06fd000000c2"
                                               withRelation:@"following"];
    [query queryInBackground:^(NSArray *array) {
        NSLog(@"array : %@", array.description);
        exitRunLoop = YES;
    } failureBlock:^(NSError *error) {
        NSLog(@"fail : %@", error.localizedDescription);
        exitRunLoop = YES;
    }];
    [self runTestLoop];
    NSLog(@"description : %@", query.description);
    
}

-(void)test_2_QueryCursorTest{
    BaasioQuery *query = [BaasioQuery queryWithCollection:@"foos"];
    [query queryInBackground:^(NSArray *objects) {
//        NSLog(@"objects : %@", objects.description);
//        NSLog(@"cursor check : %d", [query hasMoreEntities]);
        
//        [query queryInBackground:^(NSArray *objects) {
//            NSLog(@"objects : %@", objects.description);
//            NSLog(@"cursor check : %d", [query hasMoreEntities]);
//            exitRunLoop = YES;
//        } failureBlock:^(NSError *error) {
//            NSLog(@"error : %@", error.description);
//            exitRunLoop = YES;
//        }];
        
        [query nextInBackground:^(NSArray *objects) {
            NSLog(@"objects : %@", objects.description);
            NSLog(@"cursor check : %d", [query hasMoreEntities]);
            [query prevInBackground:^(NSArray *objects) {
                NSLog(@"objects : %@", objects.description);
                NSLog(@"cursor check : %d", [query hasMoreEntities]);
                exitRunLoop = YES;

            } failureBlock:^(NSError *error) {
                NSLog(@"error : %@", error.description);
                exitRunLoop = YES;
            }];
        } failureBlock:^(NSError *error) {
            NSLog(@"error : %@", error.description);
            exitRunLoop = YES;
        }];
        
        
//        [query nextInBackground:^(NSArray *objects) {
//            NSLog(@"objects : %@", objects.description);
//            NSLog(@"cursor check : %d", [query hasMoreEntities]);
//            
//            [query nextInBackground:^(NSArray *objects) {
//                NSLog(@"objects : %@", objects.description);
//                NSLog(@"cursor check : %d", [query hasMoreEntities]);
//                [query prevInBackground:^(NSArray *objects) {
//                    NSLog(@"objects : %@", objects.description);
//                    NSLog(@"cursor check : %d", [query hasMoreEntities]);
//                    exitRunLoop = YES;
//                } failureBlock:^(NSError *error) {
//                    NSLog(@"error : %@", error.description);
//                    exitRunLoop = YES;
//                }];
//            } failureBlock:^(NSError *error) {
//                NSLog(@"error : %@", error.description);
//                exitRunLoop = YES;
//            }];
//        
//        
//        } failureBlock:^(NSError *error) {
//            NSLog(@"error : %@", error.description);
//            exitRunLoop = YES;
//        }];
        
    } failureBlock:^(NSError *error) {
        NSLog(@"error : %@", error.description);
        exitRunLoop = YES;
    }];
    [self runTestLoop];
}


- (void)test_3_QueryPreNextTest_Sync{
    NSError *error = nil;
    
    BaasioQuery *query = [BaasioQuery queryWithCollection:@"tests"];
    [query query:&error];
    for (int i = 0; i < 15; i++) {
        
        NSArray *array = [query next:&error];
        NSLog(@"array : %i", array.count);
        if (error != nil) {
            NSLog(@"error.localizedDescription : %@", error.localizedDescription);
        }
        
    }
    
    for (int i = 0; i < 15; i++) {
        
        NSArray *array = [query prev:&error];
        NSLog(@"array : %i", array.count);
        if (error != nil) {
            NSLog(@"error.localizedDescription : %@", error.localizedDescription);
        }
        
    }
}


- (void)runTestLoop{
    while (!exitRunLoop){
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.5]];
    }
}
@end