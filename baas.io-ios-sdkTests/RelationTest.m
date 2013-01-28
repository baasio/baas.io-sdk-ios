//
//  RelationTest.m
//  baas.io-ios-sdk
//
//  Created by cetauri on 12. 12. 16..
//  Copyright (c) 2012년 kth. All rights reserved.
//

#import "RelationTest.h"
#import "BaasioEntity.h"
#import "BaasioQuery.h"
#import "Baasio.h"
#import "UnitTestConstant.h"
@implementation RelationTest{
    BOOL exitRunLoop;
    NSString *relationship;
}
//static NSString *uuid;


- (void)setUp
{
    //    [super setUp];
    [Baasio setApplicationInfo:TEST_APPLICATION_ID applicationName:TEST_BAASIO_ID];
    // Set-up code here.
    
    relationship = @"relationship";
}

- (void)tearDown
{
    // Tear-down code here.
    [super tearDown];
}
- (void)test_1_createConnect{

    BaasioEntity *entity = [BaasioEntity entitytWithName:@"user"];
    entity.uuid = @"2f0768f4-44cf-11e2-9c36-06ebb80000ba";
    
    BaasioEntity *entity2 = [BaasioEntity entitytWithName:@"gamescore"];
    entity2.uuid = @"1f09ce74-44e2-11e2-9c36-06ebb80000ba";

   [entity connectInBackground:entity2
                  relationship:relationship
                  successBlock:^(void){

                        exitRunLoop = true;
                        
                    }
                  failureBlock:^(NSError *error){
                      NSLog(@"fail : %@", error.localizedDescription);
                      STFail(@"Test Fail in %@ : %@", NSStringFromSelector(_cmd), error.localizedDescription);
                      
                      exitRunLoop = true;
                  }];

    
    BaasioEntity *entity3 = [BaasioEntity entitytWithName:@"user"];
    entity3.uuid = @"2f0768f4-44cf-11e2-9c36-06ebb80000ba";
    [entity connectInBackground:entity3
                   relationship:relationship
                   successBlock:^(void){
                       
                       exitRunLoop = true;
                       
                   }
                   failureBlock:^(NSError *error){
                       NSLog(@"fail : %@", error.localizedDescription);
                       STFail(@"Test Fail in %@ : %@", NSStringFromSelector(_cmd), error.localizedDescription);
                       
                       exitRunLoop = true;
                   }];

    
    [self runTestLoop];
}


//- (void)test_2_selectConnect{
//    BaasioQuery *query = [BaasioQuery queryWithRelationship:relationship];
//    
//    [query queryInBackground:^(NSArray *array){
//                    NSLog(@"array : %i", array.count);
//                    exitRunLoop = true;
//              }
//              failureBlock:^(NSError *error){
//                  NSLog(@"fail : %@", error.localizedDescription);
//                  STFail(@"Test Fail in %@ : %@", NSStringFromSelector(_cmd), error.localizedDescription);
//                  
//                  exitRunLoop = true;
//              }];
//}

- (void)test_3_deleteConnect{
    //    NSLog(@"_entity : %@", uuid);
    
    BaasioEntity *entity = [BaasioEntity entitytWithName:@"user"];
    entity.uuid = @"2f0768f4-44cf-11e2-9c36-06ebb80000ba";
    
    BaasioEntity *entity2 = [BaasioEntity entitytWithName:@"gamescore"];
    entity2.uuid = @"1f09ce74-44e2-11e2-9c36-06ebb80000ba";
    
    [entity disconnectInBackground:entity2
                   relationship:relationship
                   successBlock:^(void){
                       
                       exitRunLoop = true;
                       
                   }
                   failureBlock:^(NSError *error){
                       NSLog(@"fail : %@", error.localizedDescription);
                       STFail(@"Test Fail in %@ : %@", NSStringFromSelector(_cmd), error.localizedDescription);
                       
                       exitRunLoop = true;
                   }];
    
    
    
    [self runTestLoop];
}

- (void)runTestLoop{
    while (!exitRunLoop){
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.5]];
    }
}
@end
