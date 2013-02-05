//
// Created by cetauri on 12. 11. 19..
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "Baasio.h"
#import "Baasio+Private.h"
@implementation Baasio {
    NSString *_token;
    BaasioUser *_currentUser;
}

+ (id)sharedInstance
{
  static dispatch_once_t pred;
  static id _instance = nil;
  dispatch_once(&pred, ^{
    _instance = [[self alloc] init]; // or some other init method
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
@end

@implementation Baasio(Private)

- (void)setToken:(NSString*)token{
    _token = token;
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

@end