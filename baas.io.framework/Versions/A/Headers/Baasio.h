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
 @param baasioID baas.io ID
 @param applicationName Application ID
 */
+ (void)setApplicationInfo:(NSString *)baasioID applicationName:(NSString *)applicationName;
/**
 setApplicationInfo
 @param apiURL API Host
 @param baasioID baas.io ID
 @param applicationName Application IDe
 */
+ (void)setApplicationInfo:(NSString *)apiURL baasioID:(NSString *)baasioID applicationName:(NSString *)applicationName;

/**
 현재 SDK가 바라보는 API URL 정보
 */
- (NSURL *)getAPIURL;

/**
 로그인 유무 체크
 */
- (BOOL)hasToken;
@end


