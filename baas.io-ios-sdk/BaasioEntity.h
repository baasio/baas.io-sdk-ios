//
// Created by cetauri on 12. 11. 19..
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "BaasioRequest.h"

/**
 A bass.io Framework File Object.
*/
@interface BaasioEntity : NSObject

@property(strong) NSString *entityName;
@property(strong) NSString *uuid;
@property(readonly, strong, getter = created) NSDate *created;
@property(readonly, strong, getter = modified) NSDate *modified;
@property(readonly, strong, getter = type) NSString *type;

/**
 set
 @param entity entity
 */
-(void)set:(NSDictionary *)entity;

/**
 entitytWithName
 @param entityName entityName
 */
+ (BaasioEntity *)entitytWithName:(NSString *)entityName;

 /**
 save
 @param error error
*/
- (BaasioEntity *)save:(NSError **)error;

/**
 save asynchronously
 @param successBlock successBlock
 @param failureBlock failureBlock
 */
- (BaasioRequest*)saveInBackground:(void (^)(BaasioEntity *entity))successBlock
            failureBlock:(void (^)(NSError *error))failureBlock;

/**
 update
 @param error error
 */
- (BaasioEntity *)update:(NSError **)error;

/**
 update asynchronously
 @param successBlock successBlock
 @param failureBlock failureBlock
 */
- (BaasioRequest*)updateInBackground:(void (^)(id entity))successBlock
              failureBlock:(void (^)(NSError *error))failureBlock;

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


#pragma mark - relation
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

#pragma mark - Data
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

#pragma mark - Entity
/**
 get
 @param entityName entityName
 @param uuid uuid
 @param error error
 */
+ (BaasioEntity *)get:(NSString *)entityName
                 uuid:(NSString *)uuid
                error:(NSError **)error;
/**
 get asynchronously
 @param entityName entityName
 @param uuid uuid
 @param successBlock successBlock
 @param failureBlock failureBlock
 */
+ (BaasioRequest*)getInBackground:(NSString *)entityName
                             uuid:(NSString *)uuid
                     successBlock:(void (^)(BaasioEntity *entity))successBlock
                     failureBlock:(void (^)(NSError *error))failureBlock;

#pragma mark - super
/**
 description
 */
- (NSString *)description;


#pragma mark - etc
/**
 dictionary
 */
- (NSDictionary *)dictionary;
@end