//
// Created by cetauri on 13. 6. 3..
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "ShadowUpdateChecker.h"
#import "SimpleNetworkManager.h"

@implementation ShadowUpdateChecker {
    BOOL exitRunLoop;
}

- (NSString *)latestVersion{

    [[SimpleNetworkManager sharedInstance] connectWithHTTP:GITHUB_TAGS_LIST
                                                withMethod:@"GET"
                                                    params:nil
                                              headerFields:nil
                                                   success:^(NSString *response) {
                                                       exitRunLoop = true;
                                                       NSLog(@"response : %@", response);
                                                       return response;
                                                   }
                                                   failure:^(NSError *error){
                                                       exitRunLoop = true;
                                                       NSLog(@"error : %@", error.localizedDescription);
                                                       return nil;
                                                   }];

    [self runTestLoop];
}

- (void)runTestLoop{
    while (!exitRunLoop){
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.5]];
    }
}
@end