//
// Created by cetauri on 12. 11. 19..
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "EntityTest.h"
#import "BaasioEntity.h"
#import "BaasioQuery.h"
#import "Baasio.h"
#import "BaasioFile.h"
#import "UnitTestConstant.h"

static NSString *uuid;

@implementation EntityTest {
    BOOL exitRunLoop;
}
- (void)setUp
{
//    [super setUp];
    exitRunLoop = NO;
    
    [Baasio setApplicationInfo:TEST_APPLICATION_ID applicationName:TEST_BAASIO_ID];
    
    uuid = [[NSUserDefaults standardUserDefaults]objectForKey:@"entity.uuid"];
    NSLog(@"uuid : %@", uuid);
}


- (void)tearDown
{
    // Tear-down code here.
    [super tearDown];
}


- (void)test_1_EntitySave
{
    BaasioEntity *entity = [BaasioEntity entitytWithName:@"GameScore"];
    [entity setObject:[NSNumber numberWithInt:1337] forKey:@"score"];
    [entity setObject:@"Sean Plott" forKey:@"playerName"];
    [entity setObject:[NSNumber numberWithBool:NO] forKey:@"cheatMode"];
    [entity saveInBackground:^(BaasioEntity *entity) {
                    uuid = entity.uuid;
        
                    [[NSUserDefaults standardUserDefaults] setObject:entity.uuid forKey:@"entity.uuid"];
                    [[NSUserDefaults standardUserDefaults]synchronize];
                    exitRunLoop = YES;
                }
                failureBlock:^(NSError *error) {
                    NSLog(@"fail : %@", error.localizedDescription);
                    XCTFail(@"Test Fail in %@ : %@", NSStringFromSelector(_cmd), error.localizedDescription);
                    exitRunLoop = YES;
                }];
    
    [self runTestLoop];
}


- (void)test_3_EntityUpdate
{
    
    BaasioEntity *entity = [BaasioEntity entitytWithName:@"GameScore"];
    entity.uuid = uuid;
    [entity setObject:@"30" forKey:@"duration"];

    [entity updateInBackground:^(BaasioEntity *entity) {
                                    exitRunLoop = YES;
                                }
                  failureBlock:^(NSError *error) {
                                    NSLog(@"fail : %@", error.localizedDescription);
                                    XCTFail(@"Test Fail in %@ : %@", NSStringFromSelector(_cmd), error.localizedDescription);
                                    exitRunLoop = YES;
                                }];
    [self runTestLoop];
}

- (void)test_4_EntityInfo
{
    NSLog(@"_entity : %@", uuid);
    [BaasioEntity getInBackground:@"GameScore"
                             uuid:uuid
                     successBlock:^(BaasioEntity *entity) {
                         NSLog(@"entity : %@", entity.description);
                         exitRunLoop = YES;
                     }
                     failureBlock:^(NSError *error) {
                         NSLog(@"fail : %@", error.localizedDescription);
                         XCTFail(@"Test Fail in %@ : %@", NSStringFromSelector(_cmd), error.localizedDescription);
                         exitRunLoop = YES;
                     }];

    [self runTestLoop];
}
- (void)test_5_EntityDelete
{
    NSLog(@"_entity : %@", uuid);
    BaasioEntity *entity = [BaasioEntity entitytWithName:@"GameScore"];
    entity.uuid = uuid;
    [entity deleteInBackground:^(void) {
                                    exitRunLoop = YES;
                                }
                                failureBlock:^(NSError *error) {
                                  NSLog(@"fail : %@", error.localizedDescription);
                                  XCTFail(@"Test Fail in %@ : %@", NSStringFromSelector(_cmd), error.localizedDescription);
                                  exitRunLoop = YES;
                              }];
    
    [self runTestLoop];
    
}

//- (void)test_6_EntitySave
//{
//    BaasioFile *file = [[BaasioFile alloc]init];
//    file.filename = @"1.txt";
//    file.data = [@"Working at Parse is great!" dataUsingEncoding:NSUTF8StringEncoding];
//    [file fileUploadInBackground:^(BaasioFile *file){
//        
//        NSLog(@"file.description : %@", file.description);
//        BaasioEntity *entity = [BaasioEntity entitytWithName:@"GameScore"];
//        [entity setObject:[NSNumber numberWithInt:1337] forKey:@"score"];
//        [entity setObject:@"Sean Plott" forKey:@"playerName"];
//        [entity setObject:[NSNumber numberWithBool:NO] forKey:@"cheatMode"];
//        [entity setObject:file forKey:@"file"];
//        [entity saveInBackground:^(BaasioEntity *entity) {
//                                    
//                                    uuid = entity.uuid;
//                                    exitRunLoop = YES;
//                                }
//                                failureBlock:^(NSError *error) {
//                                    NSLog(@"fail : %@", error.localizedDescription);
//                                    STFail(@"Test Fail in %@ : %@", NSStringFromSelector(_cmd), error.localizedDescription);
//                                    exitRunLoop = YES;
//                                }];
//                    
//                    exitRunLoop = YES;
//                }
//                failureBlock:^(NSError *error){
//                    exitRunLoop = YES;
//                }
//               progressBlock:^(float progress){
//                   NSLog(@"progress  :%f", progress);
//               }];
//    
//    
//    [self runTestLoop];
//}
//
//- (void)test_7_EntityDelete{
//    [self test_5_EntityDelete];
//}

- (void)runTestLoop{
    while (!exitRunLoop){
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.5]];
    }
}
@end