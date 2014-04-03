//
// Created by cetauri on 12. 11. 19..
//
// To change the template use AppCode | Preferences | File Templates.
//

#import "BaasioUser.h"
#import "Baasio.h"
#import "Baasio+Private.h"
#import "BaasioNetworkManager.h"
#import "BaasioValidator.h"
@implementation BaasioUser 
-(id) init
{
    self = [super init];
    if (self){
        self.entityName = @"users";
    }
    return self;
}
+ (BaasioUser *)user
{
    return [[BaasioUser alloc] init];
}

+ (BaasioUser *)currentUser {
    BaasioUser *user =  [[Baasio sharedInstance]currentUser];
    return user;
}

- (BaasioUser *)update:(NSError **)error
{
    BaasioEntity *entity = [super update:error];
    BaasioUser *user = [[BaasioUser alloc]init];
    [user set:entity.dictionary];
    return user;
}


- (BaasioRequest*)updateInBackground:(void (^)(BaasioUser *group))successBlock
                        failureBlock:(void (^)(NSError *error))failureBlock
{
    return [super updateInBackground:^(BaasioEntity *entity){
                            BaasioUser *user = [[BaasioUser alloc]init];
                            [user set:entity.dictionary];
                            successBlock(user);
                        }
                        failureBlock:failureBlock];
}

+ (void)signOut {
    [[Baasio sharedInstance] setCurrentUser:nil];
    [[Baasio sharedInstance] setToken:nil];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:nil forKey:@"access_token"];
    [userDefaults setObject:nil forKey:@"login_user"];
    [userDefaults synchronize];
}

- (void)unsubscribe:(NSError**)error
{
    
    NSString *path = [@"users/" stringByAppendingString:[BaasioUser currentUser].uuid];
    [[BaasioNetworkManager sharedInstance] connectWithHTTPSync:path withMethod:@"DELETE" params:nil error:error];
    [BaasioUser signOut];
    return;
}

- (BaasioRequest*)unsubscribeInBackground:(void (^)(void))successBlock
                             failureBlock:(void (^)(NSError *error))failureBlock
{
    NSString *path = [@"users/" stringByAppendingString:[BaasioUser currentUser].uuid];
    return [[BaasioNetworkManager sharedInstance] connectWithHTTP:path
                                                    withMethod:@"DELETE"
                                                        params:nil
                                                       success:^(id result){
                                                           [BaasioUser signOut];
                                                           successBlock();
                                                        }
                                                       failure:failureBlock];
}

+ (void)signIn:(NSString *)username
      password:(NSString *)password
         error:(NSError**)error
{
    NSDictionary *params = @{
                                @"grant_type" : @"password",
                                @"username" : username,
                                @"password" : password
                            };

    id result = [[BaasioNetworkManager sharedInstance] connectWithHTTPSync:@"token"
                                                                withMethod:@"POST"
                                                                    params:params
                                                                     error:error];

    [self saveLoginInfomation:result];
    
    
    return;
}

+ (BaasioRequest*)signInBackground:(NSString *)username
                          password:(NSString *)password
                      successBlock:(void (^)(void))successBlock
                      failureBlock:(void (^)(NSError *error))failureBlock
{
    NSDictionary *params = @{
                                @"grant_type" : @"password",
                                @"username" : username,
                                @"password" : password
                            };
    return [[BaasioNetworkManager sharedInstance] connectWithHTTP:@"token"
                                                    withMethod:@"POST"
                                                        params:params
                                                       success:^(id result){
                                                           [self saveLoginInfomation:result];

                                                           successBlock();
                                                       }
                                                       failure:failureBlock];
}

+ (void)saveLoginInfomation:(id)result {
    NSDictionary *response = (NSDictionary *)result;
    Baasio *baasio = [Baasio sharedInstance];
    NSString *access_token = response[@"access_token"];
    [baasio setToken:access_token];

    NSDictionary *userReponse = response[@"user"];
    BaasioUser *loginUser = [BaasioUser user];
    [loginUser set:userReponse];
    [baasio setCurrentUser:loginUser];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:access_token forKey:@"access_token"];
    [userDefaults setObject:userReponse forKey:@"login_user"];
    [userDefaults synchronize];
}

+ (void)signUp:(NSString *)username
      password:(NSString *)password
          name:(NSString *)name
         email:(NSString *)email
         error:(NSError**)error
{
    NSDictionary *params = @{
                                @"name":name,
                                @"password":password,
                                @"username":username,
                                @"email":email
                            };

    [[BaasioNetworkManager sharedInstance] connectWithHTTPSync:@"users" withMethod:@"POST" params:params error:error];
}

+ (BaasioRequest*)signUpInBackground:(NSString *)username
                            password:(NSString *)password
                                name:(NSString *)name
                               email:(NSString *)email
                        successBlock:(void (^)(void))successBlock
                        failureBlock:(void (^)(NSError *error))failureBlock
{
    NSDictionary *params = @{
                                @"name":name,
                                @"password":password,
                                @"username":username,
                                @"email":email
                            };

    return [[BaasioNetworkManager sharedInstance] connectWithHTTP:@"users"
                                                    withMethod:@"POST"
                                                        params:params
                                                       success:^(id result){
                                                           successBlock();
                                                       }
                                                       failure:failureBlock];
}

-(void)signUp:(NSError **)error{
    NSArray *validateKeys = @[@"username", @"password", @"email", @"name"];
    NSError *e = [BaasioValidator parameterValidation:self.dictionary validateKeys:validateKeys selector:_cmd];
    if (e != nil){
        *error = e;
        return ;
    }
    [[BaasioNetworkManager sharedInstance] connectWithHTTPSync:@"users" withMethod:@"POST" params:self.dictionary error:error];
}

- (BaasioRequest*)signUpInBackground:(void (^)(void))successBlock
                        failureBlock:(void (^)(NSError *error))failureBlock
{
    NSArray *validateKeys = @[@"username", @"password", @"email", @"name"];
    NSError *e = [BaasioValidator parameterValidation:self.dictionary validateKeys:validateKeys selector:_cmd];
    if (e != nil){
        failureBlock(e);
        return nil;
    }
    return [[BaasioNetworkManager sharedInstance] connectWithHTTP:@"users"
                                                       withMethod:@"POST"
                                                           params:self.dictionary
                                                          success:^(id result){
                                                              successBlock();
                                                          }
                                                          failure:failureBlock];
}

+ (void)changePassword:(NSString *)oldPassword
           newPassword:(NSString *)newPassword
                 error:(NSError**)error
{
    NSDictionary *params = @{
                             @"oldpassword" : oldPassword,
                             @"newpassword" : newPassword
                             };
    
    BaasioUser *baasioUser = [BaasioUser currentUser];
    if(baasioUser==nil){
        *error = [self emptyUserError];
        return;
    }
    
    NSString *path = [NSString stringWithFormat:@"users/%@/password",baasioUser.uuid];
    [[BaasioNetworkManager sharedInstance] connectWithHTTPSync:path
                                                    withMethod:@"POST"
                                                        params:params
                                                         error:error];
}

+ (BaasioRequest*)changePasswordInBackground:(NSString *)oldPassword
                                 newPassword:(NSString *)newPassword
                                successBlock:(void (^)(void))successBlock
                                failureBlock:(void (^)(NSError *error))failureBlock
{
    NSDictionary *params = @{
                             @"oldpassword":oldPassword,
                             @"newpassword":newPassword,
                             };
    
    BaasioUser *baasioUser = [BaasioUser currentUser];
    if(baasioUser==nil){
        failureBlock([self emptyUserError]);
        return nil;
    }
    
    NSString *path = [NSString stringWithFormat:@"users/%@/password",baasioUser.uuid];
    return [[BaasioNetworkManager sharedInstance] connectWithHTTP:path
                                                       withMethod:@"POST"
                                                           params:params
                                                          success:^(id result){
                                                              successBlock();
                                                          }
                                                          failure:failureBlock];
}

+ (void)resetPassword:(NSString *)username
                error:(NSError**)error
{
    NSString *path = [NSString stringWithFormat:@"users/%@/resetpw",username];
    [[BaasioNetworkManager sharedInstance] connectWithHTTPSync:path
                                                    withMethod:@"POST"
                                                        params:nil
                                                         error:error];
    
}

+ (BaasioRequest*)resetPasswordInBackground:(NSString *)username
                               successBlock:(void (^)(void))successBlock
                               failureBlock:(void (^)(NSError *error))failureBlock
{
    NSString *path = [NSString stringWithFormat:@"users/%@/resetpw",username];
    return [[BaasioNetworkManager sharedInstance] connectWithHTTP:path
                                                       withMethod:@"POST"
                                                           params:nil
                                                          success:^(id result){
                                                              successBlock();
                                                          }
                                                          failure:failureBlock];
}

+ (NSError*)emptyUserError{
    NSString *message = @"The baasioUser was empty. Please login in first.";
    NSMutableDictionary* details = [NSMutableDictionary dictionary];
    [details setValue:message forKey:NSLocalizedDescriptionKey];
    
    return[NSError errorWithDomain:@"BassioError" code:BAD_TOKEN_ERROR userInfo:details];
}

+ (void)signUpViaFacebook:(NSString *)accessToken
                    error:(NSError**)error
{
    NSDictionary *params = @{
                                @"fb_access_token" : accessToken
                            };

    NSString *path = @"auth/facebook";
    id result = [[BaasioNetworkManager sharedInstance] connectWithHTTPSync:path
                                                                withMethod:@"GET"
                                                                    params:params
                                                                     error:error];
    [self saveLoginInfomation:result];
}

+ (BaasioRequest*)signUpViaFacebookInBackground:(NSString *)accessToken
                                   successBlock:(void (^)(void))successBlock
                                   failureBlock:(void (^)(NSError *error))failureBlock
{
    NSDictionary *params = @{
                                @"fb_access_token" : accessToken
                            };

    NSString *path = @"auth/facebook";
    return [[BaasioNetworkManager sharedInstance] connectWithHTTP:path
                                                    withMethod:@"GET"
                                                        params:params
                                                       success:^(id result){
                                                           [self saveLoginInfomation:result];
                                                           successBlock();
                                                       }
                                                       failure:failureBlock];
}


+ (void)signInViaFacebook:(NSString *)accessToken
                    error:(NSError**)error
{
    [self signUpViaFacebook:accessToken error:error];
}

+ (BaasioRequest*)signInViaFacebookInBackground:(NSString *)accessToken
                                   successBlock:(void (^)(void))successBlock
                                   failureBlock:(void (^)(NSError *error))failureBlock
{
    return [self signUpViaFacebookInBackground:accessToken
                                  successBlock:successBlock
                                  failureBlock:failureBlock];
}


#pragma mark - etc
-(NSString*)username{
    return [self objectForKey:@"username"];
}

-(void)setUsername:(NSString*)username{
    [self setObject:username forKey:@"username"];
}
@end