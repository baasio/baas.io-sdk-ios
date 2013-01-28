//
// Created by cetauri on 12. 11. 26..
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "FileTest.h"
#import "BaasioFile.h"
#import "Baasio.h"
#import "UnitTestConstant.h"

@implementation FileTest {
    BOOL exitRunLoop;
}

- (void)setUp
{
//    [super setUp];
    
    [Baasio setApplicationInfo:TEST_APPLICATION_ID applicationName:TEST_BAASIO_ID];

    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    [super tearDown];
}
static NSString *uuid;

- (void)test_1_Upload{
    NSData *data = [@"Baas.io is great! " dataUsingEncoding:NSUTF8StringEncoding];
    BaasioFile *file = [[BaasioFile alloc] init];
    file.data = data;
    file.filename = @"김상열7.txt";
    file.contentType = @"application/json";
    [file setObject:@"cetauri" forKey:@"nickname"];
    [file setObject:@"권오상" forKey:@"realname"];

    [file fileUploadInBackground:^(BaasioFile *file) {
            NSLog(@"success : %@", file.uuid);
            uuid = file.uuid;
            [[NSUserDefaults standardUserDefaults] setObject:file.uuid forKey:@"file.uuid"];
            exitRunLoop = YES;
        }
        failureBlock:^(NSError *error) {
            NSLog(@"error : %@", error.localizedDescription);
            NSLog(@"uuid : %@", error.uuid);

            STFail(@"Test Faiil in %@ : %@", NSStringFromSelector(_cmd), error.localizedDescription);
            exitRunLoop = YES;
        }
        progressBlock:^(float progress) {
           NSLog(@"progress : %f", progress);
        }];

    [self runTestLoop];
}

- (void)test_2_Get{

    NSString *uuid = [[NSUserDefaults standardUserDefaults]objectForKey:@"file.uuid"];

    BaasioFile *file = [[BaasioFile alloc] init];
    file.uuid = uuid;
    [file getInBackground:^(BaasioFile *file) {
                         NSLog(@"success : %@", file.description);
                         exitRunLoop = YES;
                     }
                     failureBlock:^(NSError *error) {
                         NSLog(@"error : %@", error.localizedDescription);
                         STFail(@"Test Faiil in %@ : %@", NSStringFromSelector(_cmd), error.localizedDescription);
                         exitRunLoop = YES;
                     }];

    [self runTestLoop];
}


- (void)test_3_Download{

    NSString *uuid = [[NSUserDefaults standardUserDefaults]objectForKey:@"file.uuid"];

    NSString *path = [NSString stringWithFormat:@"%@/1.txt", NSTemporaryDirectory()];
    BaasioFile *file = [[BaasioFile alloc] init];
    file.uuid = uuid;
    [file fileDownloadInBackground:path
          successBlock:^(NSString *downloadPath) {
              NSLog(@"success : %@", downloadPath);
              // 파일 읽기.
              NSString *entireFileInString = [NSString stringWithContentsOfFile:downloadPath encoding:NSStringEncodingConversionAllowLossy error:nil];
              // 라인별로 읽기.
              NSArray *lines = [entireFileInString componentsSeparatedByString:@"\n"];
              // 테스트.
              for (NSString *line in lines) {
                  NSLog(@"%@",[NSString stringWithFormat:@"line: %@", line]);
              }

              exitRunLoop = YES;
         }
         failureBlock:^(NSError *error) {
             NSLog(@"error : %@", error.localizedDescription);

             STFail(@"Test Faiil in %@ : %@", NSStringFromSelector(_cmd), error.localizedDescription);
             exitRunLoop = YES;
         }
         progressBlock:^(float progress){
             NSLog(@"progress : %f", progress);
         } ];
    
    [self runTestLoop];
}

- (void)test_5_update{
    NSString *uuid = [[NSUserDefaults standardUserDefaults] objectForKey:@"file.uuid"];
    
    BaasioFile *file = [[BaasioFile alloc] init];
    file.uuid = uuid;
    [file setObject:@"권오상" forKey:@"cetauri"];
    [file setObject:@"짐승" forKey:@"realname"];
    [file updateInBackground:^(BaasioFile *entity){
            NSLog(@"success : %@, %@", entity.description, entity.filename);

            exitRunLoop = YES;
        }
        failureBlock:^(NSError *error) {
            NSLog(@"error : %@", error.localizedDescription);

            STFail(@"Test Faiil in %@ : %@", NSStringFromSelector(_cmd), error.localizedDescription);
            exitRunLoop = YES;
        }];
    
    [self runTestLoop];
}

- (void)test_6_updateFile{
    
    NSString *uuid = [[NSUserDefaults standardUserDefaults] objectForKey:@"file.uuid"];
    
    BaasioFile *file = [[BaasioFile alloc] init];
    file.uuid = uuid;
    file.data = [@"Updated Baas.io is great!" dataUsingEncoding:NSUTF8StringEncoding];
    
    file.filename = @"1.txt";
    [file setObject:@"Kwon oh sang" forKey:@"cetauri"];
    [file fileUpdateInBackground:^(BaasioFile *entity){
                NSLog(@"success : %@", entity.description);

                exitRunLoop = YES;
            }
            failureBlock:^(NSError *error) {
                NSLog(@"error : %@", error.localizedDescription);

                STFail(@"Test Faiil in %@ : %@", NSStringFromSelector(_cmd), error.localizedDescription);
                exitRunLoop = YES;
            }

            progressBlock:^(float progress){
               NSLog(@"progress : %f", progress);
            }];
    
    [self runTestLoop];
}

- (void)test_7_updateFile{
    [self test_3_Download];
}
- (void)test_9_Delete{

    NSString *uuid = [[NSUserDefaults standardUserDefaults]objectForKey:@"file.uuid"];

    BaasioFile *file = [[BaasioFile alloc] init];
    file.uuid = uuid;
    [file deleteInBackground:^(void) {
                    NSLog(@"Delete success.");
                    exitRunLoop = YES;
                }
                failureBlock:^(NSError *error) {
                    NSLog(@"error : %@", error.localizedDescription);
                    STFail(@"Test Faiil in %@ : %@", NSStringFromSelector(_cmd), error.localizedDescription);
                    exitRunLoop = YES;
                }];

    [self runTestLoop];
}


- (void)runTestLoop{
//    while (!exitRunLoop){
//        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.5]];
//    }
}
@end