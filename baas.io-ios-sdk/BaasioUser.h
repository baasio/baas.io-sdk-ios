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
 user
 */
+ (BaasioUser *)user;

/**
 currentUser
 */
+ (BaasioUser *)currentUser;


/**
 update
 @param error error
 */
- (BaasioUser *)update:(NSError **)error;

/**
 update asynchronously
 @param successBlock successBlock
 @param failureBlock failureBlock
 */
- (BaasioRequest*)updateInBackground:(void (^)(BaasioUser *group))successBlock
                        failureBlock:(void (^)(NSError *error))failureBlock;


/**
 signOut
 */
+ (void)signOut;


/**
 signIn

 @param username username
 @param password password
 @param error error
 */
+ (void)signIn:(NSString *)username
      password:(NSString *)password
         error:(NSError**)error;

/**
 sign asynchronously

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
 signUp

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
 signUp asynchronously

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
 unsubscribe

 @param error error
 */
- (void)unsubscribe:(NSError**)error;

/**
 unsubscribe asynchronously

 @param successBlock successBlock
 @param failureBlock failureBlock
 */
- (BaasioRequest*)unsubscribeInBackground:(void (^)(void))successBlock
                   failureBlock:(void (^)(NSError *error))failureBlock;


/**
 signUp via Facebook

 @param accessToken accessToken
 @param error error
 */
+ (void)signUpViaFacebook:(NSString *)accessToken
                    error:(NSError**)error;

/**
 signUp via Facebook asynchronously

 @param accessToken accessToken
 @param successBlock successBlock
 @param failureBlock failureBlock
 */
+ (BaasioRequest*)signUpViaFacebookInBackground:(NSString *)accessToken
                                   successBlock:(void (^)(void))successBlock
                                   failureBlock:(void (^)(NSError *error))failureBlock;

/**
 signIn via Facebook

 @param accessToken accessToken
 @param error error
 */
+ (void)signInViaFacebook:(NSString *)accessToken
                    error:(NSError**)error;

/**
 signIn via Facebook asynchronously

 @param accessToken accessToken
 @param successBlock successBlock
 @param failureBlock failureBlock
 */
+ (BaasioRequest*)signInViaFacebookInBackground:(NSString *)accessToken
                                   successBlock:(void (^)(void))successBlock
                                   failureBlock:(void (^)(NSError *error))failureBlock;


#pragma mark - for super document
/**
 set
 @param entity entity
 */
-(void)set:(NSDictionary *)entity;

/**
 connect
 @param entity entity
 @param relationship relationship
 @param error error
 */
- (void) connect:(BaasioEntity *)entity
    relationship:(NSString*)relationship
           error:(NSError **)error;
/**
 connect asynchronously
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
 disconnect
 @param entity entity
 @param relationship relationship
 @param error error
 */
- (void) disconnect:(BaasioEntity *)entity
       relationship:(NSString*)relationship
              error:(NSError **)error;

/**
 disconnect asynchronously
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
 objectForKey
 @param key key
 */
- (NSString *)objectForKey:(NSString *)key;
/**
 setObject
 @param value value
 @param key key
 */
- (void)setObject:(id)value forKey:(NSString *)key;


/**
 description
 */
- (NSString *)description;

/**
 dictionary
 */
- (NSDictionary *)dictionary;
@end
