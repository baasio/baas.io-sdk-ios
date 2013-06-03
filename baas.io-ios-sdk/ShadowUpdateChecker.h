//
// Created by cetauri on 13. 6. 3..
//
// To change the template use AppCode | Preferences | File Templates.
//

#define GITHUB_TAGS_LIST @"https://api.github.com/repos/baasio/baas.io-sdk-ios/tags"

#import <Foundation/Foundation.h>


@interface ShadowUpdateChecker : NSObject
- (NSString *)currentSDKVersion;
- (NSString *)latestVersion;

- (void)check;
@end