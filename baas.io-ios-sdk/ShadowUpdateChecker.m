//
// Created by cetauri on 13. 6. 3..
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "ShadowUpdateChecker.h"
#import "SimpleNetworkManager.h"
#import "JSONKit.h"
@implementation ShadowUpdateChecker {

}

- (void)check {

    dispatch_async( dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0 ), ^(void){

        //TODO 주기 설정
           NSString *currentVersion = [self currentSDKVersion];
           NSString *latestVersion = [self latestVersion];

           if (true) {
               for (int i = 0; i < 20; i++) {
                   NSLog(@"The New Baas.io SDK Release, Please Update. (current : %@, new : %@)", currentVersion, latestVersion);
               }
           }
       });
}

- (NSString *)currentSDKVersion{
    return @"1.1.1";
}

- (NSString *)latestVersion{
    __block  NSString *name = nil;
    __block BOOL isFinish = false;
    NSOperation *operation = [[SimpleNetworkManager sharedInstance] connectWithHTTP:GITHUB_TAGS_LIST
                                                withMethod:@"GET"
                                                    params:nil
                                              headerFields:nil
                                                   success:^(NSString *response) {
                                                       isFinish = true;
                                                       
                                                       NSArray *array = [response objectFromJSONString];
                                                       NSDictionary *dictionary = [array objectAtIndex:0];
                                                       name = [dictionary objectForKey:@"name"];
                                                   }
                                                   failure:^(NSError *error){
                                                       isFinish = true;
                                                       NSLog(@"error : %@", error.localizedDescription);
                                                   }];
    [operation waitUntilFinished];

#ifndef UNIT_TEST
    while(!isFinish){
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.5]];
    }
#endif

    return name;
}

@end