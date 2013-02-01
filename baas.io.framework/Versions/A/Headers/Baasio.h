//
// Created by cetauri on 12. 11. 19..
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>


/**
 A bass.io Framework File Object.
 */
@interface Baasio : NSObject
@property(nonatomic, strong) NSString *apiURL;
@property(nonatomic, strong) NSString *applicationName;
@property(nonatomic, strong) NSString *baasioID;

/**
 sharedInstance
 */
+ (id)sharedInstance;
/**
 setApplicationInfo
 @param baasioID baasioID
 @param applicationName applicationName
 */
+ (void)setApplicationInfo:(NSString *)baasioID applicationName:(NSString *)applicationName;
/**
 setApplicationInfo
 @param apiURL apiURL
 @param baasioID baasioID
 @param applicationName applicationName
 */
+ (void)setApplicationInfo:(NSString *)apiURL baasioID:(NSString *)baasioID applicationName:(NSString *)applicationName;

/**
 getAPIURL
 */
- (NSURL *)getAPIURL;

/**
 hasToken
 */
- (BOOL)hasToken;
@end


