//
// Created by cetauri on 13. 6. 3..
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "ShadowUpdateChecker.h"
#import "SimpleNetworkManager.h"
#import "BaasioVersion.h"
#import "JSONKit.h"
#import "Baasio.h"
#import "Baasio+Private.h"
@implementation ShadowUpdateChecker {

}

- (void)check {

    dispatch_async( dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0 ), ^(void){
        if (![[Baasio sharedInstance] isDebugMode]){
             return;
        }

        [NSThread sleepForTimeInterval:1];

        NSError *error;
        NSString *latestVersion = [self latestVersion:&error];
        NSString *currentVersion = [self currentSDKVersion];

        if (error != nil){
            NSLog(@"Fail to get new version : %@", error.localizedDescription);
            return;
        }

        if (![latestVersion isEqualToString:currentVersion]) {
           for (int i = 0; i < 50; i++) {
//               NSLog(@"★☆★☆ The new Baas.io SDK Release. see this link https://github.com/baasio/baas.io-sdk-ios (current : %@, new : %@) ★☆★☆", currentVersion, latestVersion);
               printf("★☆★☆ The new Baas.io SDK Release. see this link https://github.com/baasio/baas.io-sdk-ios (current : %s, new : %s) ★☆★☆\n", [currentVersion UTF8String], [latestVersion UTF8String]);
           }
        }
   });
}

- (NSString *)currentSDKVersion{
    return BAASIO_SDK_VERSION_STRING;
}

- (NSString *)latestVersion:(NSError **)error {
    NSString *response = [[SimpleNetworkManager sharedInstance] connectWithHTTPSync:GITHUB_TAGS_LIST
                                                                     withMethod:@"GET"
                                                                         params:nil
                                                                   headerFields:nil
                                                                          error:error];

    NSArray *array = [response objectFromJSONString];
    NSDictionary *dictionary = [array objectAtIndex:0];
    return [dictionary objectForKey:@"name"];
}

@end