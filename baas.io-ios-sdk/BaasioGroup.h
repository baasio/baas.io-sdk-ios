//
//  BaasioGroup.h
//  baas.io-ios-sdk
//
//  Created by cetauri on 12. 12. 11..
//  Copyright (c) 2012년 kth. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaasioUser.h"

/**
 A baas.io Framework Group Object.
*/
@interface BaasioGroup : BaasioEntity
/**
 create group
 @param group group name
*/
- (void)setGroupName:(NSString*)group;
/**
 setUserName
 @param user user name
*/
- (void)setUserName:(NSString*)user;

/**
 get
 
 @param uuid uuid
 @param error error
 */
+ (BaasioGroup *)get:(NSString *)uuid
               error:(NSError **)error;
/**
 get asynchronously
 
 @param uuid uuid
 @param successBlock successBlock
 @param failureBlock failureBlock
 */
+ (BaasioRequest*)getInBackground:(NSString *)uuid
                     successBlock:(void (^)(BaasioGroup *entity))successBlock
                     failureBlock:(void (^)(NSError *error))failureBlock;

/**
 save
 @param error error
*/
- (BaasioGroup *)save:(NSError **)error;
/**
 create asynchronously
 @param successBlock successBlock
 @param failureBlock failureBlock
*/
- (BaasioRequest*)saveInBackground:(void (^)(BaasioGroup *group))successBlock
                      failureBlock:(void (^)(NSError *error))failureBlock;

/**
 update
 @param error error
 */
- (BaasioGroup *)update:(NSError **)error;

/**
 update asynchronously
 @param successBlock successBlock
 @param failureBlock failureBlock
 */
- (BaasioRequest*)updateInBackground:(void (^)(BaasioGroup *group))successBlock
                        failureBlock:(void (^)(NSError *error))failureBlock;

//XXX : join, withdraw
/**
 add
 @param error error
 */
- (void)add:(NSError **)error;
/**
 add asynchronously
 @param successBlock successBlock
 @param failureBlock failureBlock
 */
- (BaasioRequest*)addInBackground:(void (^)(BaasioGroup *group))successBlock
                        failureBlock:(void (^)(NSError *error))failureBlock;
/**
 remove
 @param error error
 */
- (void)remove:(NSError **)error;
/**
 remove asynchronously
 @param successBlock successBlock
 @param failureBlock failureBlock
 */
- (BaasioRequest*)removeInBackground:(void (^)(void))successBlock
                        failureBlock:(void (^)(NSError *error))failureBlock;


#pragma mark - for super document

/**
 delete
 @param error error
 */
- (void)delete:(NSError **)error;

/**
 delete asynchronously
 @param successBlock successBlock
 @param failureBlock failureBlock
 */
- (BaasioRequest*)deleteInBackground:(void (^)(void))successBlock
                        failureBlock:(void (^)(NSError *error))failureBlock;

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
 dictionary
 */
- (NSDictionary *)dictionary;
@end
