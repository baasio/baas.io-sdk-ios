//
// Created by cetauri on 12. 11. 19..
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "Baasio.h"
#import "Baasio+Private.h"
#import "ShadowUpdateChecker.h"

bool _isDebugMode;

@implementation Baasio {
//    NSString *_token;
    BaasioUser *_currentUser;

}

+ (id)sharedInstance
{
  static dispatch_once_t pred;
  static id _instance = nil;
  dispatch_once(&pred, ^{
    _instance = [[self alloc] init]; // or some other init method
    _isDebugMode = false;

    [[[ShadowUpdateChecker alloc] init] check];

});
  return _instance;
}

+ (void)setApplicationInfo:(NSString *)baasioID applicationName:(NSString *)applicationName
{
    NSString *apiURL = @"https://api.baas.io";
    [Baasio setApplicationInfo:apiURL baasioID:baasioID applicationName:applicationName];
}

+ (void)setApplicationInfo:(NSString *)apiURL baasioID:(NSString *)baasioID applicationName:(NSString *)applicationName
{
    Baasio *baasio = [Baasio sharedInstance];
    baasio.apiURL = apiURL;
    baasio.baasioID = baasioID;
    baasio.applicationName = applicationName;
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *savedToken = [userDefaults objectForKey:@"access_token"];
    NSDictionary *savedUser = [userDefaults objectForKey:@"login_user"];
    if (savedToken != nil && savedUser != nil) {
        baasio.token = savedToken;
        
        BaasioUser *loginUser = [BaasioUser user];
        [loginUser set:savedUser];
        [baasio setCurrentUser:loginUser];
    }
}

- (NSURL *)getAPIURL{
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@", _apiURL, _baasioID, _applicationName];
    return [NSURL URLWithString:url];
}

- (BOOL)hasToken {
    if (_token == nil || [_token isEqualToString:@""] ){
        return false;
    }
    
    return true;
}

- (void)isDebugMode:(BOOL)flag{
    _isDebugMode = flag;
}
@end

@implementation Baasio(Private)

- (NSString *)getToken{
    return _token;
}

#pragma mark - API Authorization method
- (NSMutableURLRequest *)setAuthorization:(NSMutableURLRequest *)request{
    if (_token != nil) {
        [request addValue:[@"Bearer " stringByAppendingString:_token] forHTTPHeaderField:@"Authorization"];
    }

    return request;
}

- (BaasioUser*)currentUser{
    return _currentUser;
}

- (void)setCurrentUser:(BaasioUser*)currentUser{
    _currentUser = currentUser;
}

- (BOOL)isDebugMode{
    return _isDebugMode;
}

@end