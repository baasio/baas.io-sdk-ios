//
// Created by cetauri on 13. 4. 2..
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "SimpleNetworkManagerTest.h"
#import "SimpleNetworkManager.h"
@implementation SimpleNetworkManagerTest {
    BOOL exitRunLoop;
}
//-(void)test_sync{
//    
//    NSError *e;
//    NSString *response = [[SimpleNetworkManager sharedInstance]connectWithHTTPSync:@"https://api.baas.io/cetauri/sandbox/users/cetauri/resetpw"
//                                                                        withMethod:@"GET"
//                                                                            params:nil
//                                                                      headerFields:nil
//                                                                             error:&e];
//    NSLog(@"error : %@", e);
//    NSLog(@"response : %@", response);
//    
//}
//
//-(void)test_async{
//    exitRunLoop = false;
//    [[SimpleNetworkManager sharedInstance]connectWithHTTP:@"https://api.baas.io/cetau23ri/sandbox/users/cetauri/resetpw"
//                                               withMethod:@"GET"
//                                                   params:nil
//                                             headerFields:nil
//                                                  success:^(NSString *response) {
//                                                      NSLog(@"success : %@", response);
//                                                      exitRunLoop = true;
//                                                  }
//                                                  failure:^(NSError *error) {
//                                                      NSLog(@"error : %@", error.localizedDescription);
//                                                      exitRunLoop = true;
//                                                  }];
//    [self runTestLoop];
//
//}

-(void)test_sync_post{
    NSDictionary *dic = @{@"key" : @"value2"};
    NSError *e;
    NSString *response = [[SimpleNetworkManager sharedInstance]connectWithHTTPSync:@"https://api.baas.io/cetauri/sandbox/sample"
                                                                        withMethod:@"POST"
                                                                            params:dic
                                                                      headerFields:nil
                                                                             error:&e];
    NSLog(@"error : %@", e.description);
    NSLog(@"response : %@", response);
    
}

-(void)test_sync_get{
    NSDictionary *dic = @{@"filter" : @"key%3D'value'"};
    NSError *e;
    NSString *response = [[SimpleNetworkManager sharedInstance]connectWithHTTPSync:@"https://api.baas.io/cetauri/sandbox/sample"
                                                                        withMethod:@"GET"
                                                                            params:dic
                                                                      headerFields:nil
                                                                             error:&e];
    NSLog(@"error : %@", e.description);
    NSLog(@"response : %@", response);
    
}

- (void)runTestLoop{
    while (!exitRunLoop){
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.5]];
    }
}

@end