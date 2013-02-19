//
// Created by cetauri on 12. 11. 19..
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "BaasioEntity.h"
#import "BaasioRequest.h"

/**
 A bass.io Framework User Object.
*/
@interface BaasioUser : BaasioEntity
@property(strong) NSString *username;

/**
 user 생성 
 */
+ (BaasioUser *)user;

/**
 currentUser
 */
+ (BaasioUser *)currentUser;


/**
 user update
 @param error error
 */
- (BaasioUser *)update:(NSError **)error;

/**
 user update asynchronously
 @param successBlock successBlock
 @param failureBlock failureBlock
 */
- (BaasioRequest*)updateInBackground:(void (^)(BaasioUser *group))successBlock
                        failureBlock:(void (^)(NSError *error))failureBlock;


/**
 로그아웃
 */
+ (void)signOut;


/**
 로그인

 @param username username
 @param password password
 @param error error
 */
+ (void)signIn:(NSString *)username
      password:(NSString *)password
         error:(NSError**)error;

/**
 로그인 asynchronously

 @param username username
 @param password password
 @param successBlock successBlock
 @param failureBlock failureBlock
 */
+ (BaasioRequest*)signInBackground:(NSString *)username
                          password:(NSString *)password
                      successBlock:(void (^)(void))successBlock
                      failureBlock:(void (^)(NSError *error))failureBlock;

/**
 회원가입

 @param username username
 @param password password
 @param name name
 @param email email
 @param error error
 */
+ (void)signUp:(NSString *)username
      password:(NSString *)password
          name:(NSString *)name
         email:(NSString *)email
         error:(NSError**)error;

/**
 회원가입 asynchronously

 @param username username
 @param password password
 @param name name
 @param email email
 @param successBlock successBlock
 @param failureBlock failureBlock
 */
+ (BaasioRequest*)signUpInBackground:(NSString *)username
                            password:(NSString *)password
                                name:(NSString *)name
                               email:(NSString *)email
                        successBlock:(void (^)(void))successBlock
                        failureBlock:(void (^)(NSError *error))failureBlock;

/**
 탈퇴

 @param error error
 */
- (void)unsubscribe:(NSError**)error;

/**
 탈퇴 asynchronously

 @param successBlock successBlock
 @param failureBlock failureBlock
 */
- (BaasioRequest*)unsubscribeInBackground:(void (^)(void))successBlock
                   failureBlock:(void (^)(NSError *error))failureBlock;


/**
 Facebook 통한 회원가입

 @param accessToken accessToken
 @param error error
 */
+ (void)signUpViaFacebook:(NSString *)accessToken
                    error:(NSError**)error;

/**
 Facebook 통한 회원가입 asynchronously

 @param accessToken accessToken
 @param successBlock successBlock
 @param failureBlock failureBlock
 */
+ (BaasioRequest*)signUpViaFacebookInBackground:(NSString *)accessToken
                                   successBlock:(void (^)(void))successBlock
                                   failureBlock:(void (^)(NSError *error))failureBlock;

/**
 Facebook 통한 로그인

 @param accessToken accessToken
 @param error error
 */
+ (void)signInViaFacebook:(NSString *)accessToken
                    error:(NSError**)error;

/**
 Facebook 통한 로그인 asynchronously

 @param accessToken accessToken
 @param successBlock successBlock
 @param failureBlock failureBlock
 */
+ (BaasioRequest*)signInViaFacebookInBackground:(NSString *)accessToken
                                   successBlock:(void (^)(void))successBlock
                                   failureBlock:(void (^)(NSError *error))failureBlock;


#pragma mark - for super document
/**
 user set
 @param entity entity
 */
-(void)set:(NSDictionary *)entity;

/**
 user connect
 @param entity entity
 @param relationship relationship
 @param error error
 */
- (void) connect:(BaasioEntity *)entity
    relationship:(NSString*)relationship
           error:(NSError **)error;
/**
 user connect asynchronously
 @param entity entity
 @param relationship relationship
 @param successBlock successBlock
 @param failureBlock failureBlock
 */
- (BaasioRequest*)connectInBackground:(BaasioEntity *)entity
                         relationship:(NSString*)relationship
                         successBlock:(void (^)(void))successBlock
                         failureBlock:(void (^)(NSError *error))failureBlock;
/**
 user disconnect
 @param entity entity
 @param relationship relationship
 @param error error
 */
- (void) disconnect:(BaasioEntity *)entity
       relationship:(NSString*)relationship
              error:(NSError **)error;

/**
 user disconnect asynchronously
 @param entity entity
 @param relationship relationship
 @param successBlock successBlock
 @param failureBlock failureBlock
 */
- (BaasioRequest*)disconnectInBackground:(BaasioEntity *)entity
                            relationship:(NSString*)relationship
                            successBlock:(void (^)(void))successBlock
                            failureBlock:(void (^)(NSError *error))failureBlock;

/**
 Returns the value associated with a given key.
 @param key key
 */
- (NSString *)objectForKey:(NSString *)key;
/**
 Adds a given key-value pair to the dictionary.
 @param value value
 @param key key
 */
- (void)setObject:(id)value forKey:(NSString *)key;


/**
 Returns a string that represents the contents of the dictionary, formatted as a property list.
 */
- (NSString *)description;

/**
 Entity dictionary
 */
- (NSDictionary *)dictionary;
@end
