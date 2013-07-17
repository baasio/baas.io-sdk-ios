//
// Created by cetauri on 12. 11. 19..
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "BaasioRequest.h"

/**
 A baas.io Framework File Object.
*/
@interface BaasioEntity : NSObject

@property(strong) NSString *entityName;
@property(strong) NSString *uuid;
@property(readonly, strong, getter = created) NSDate *created;
@property(readonly, strong, getter = modified) NSDate *modified;
@property(readonly, strong, getter = type) NSString *type;

/**
 Entity set
 @param entity Entity
 */
-(void)set:(NSDictionary *)entity;

/**
 create entity
 @param entityName Entity name
 */
+ (BaasioEntity *)entitytWithName:(NSString *)entityName;

/**
 Entity save
 @param error error
*/
- (BaasioEntity *)save:(NSError **)error;

/**
 Entity save asynchronously
 @param successBlock successBlock
 @param failureBlock failureBlock
 */
- (BaasioRequest*)saveInBackground:(void (^)(BaasioEntity *entity))successBlock
            failureBlock:(void (^)(NSError *error))failureBlock;

/**
 Entity update
 @param error error
 */
- (BaasioEntity *)update:(NSError **)error;

/**
 Entity update asynchronously
 @param successBlock successBlock
 @param failureBlock failureBlock
 */
- (BaasioRequest*)updateInBackground:(void (^)(id entity))successBlock
              failureBlock:(void (^)(NSError *error))failureBlock;

/**
 Entity delete
 @param error error
 */
- (void)delete:(NSError **)error;

/**
 Entity delete asynchronously
 @param successBlock successBlock
 @param failureBlock failureBlock
 */
- (BaasioRequest*)deleteInBackground:(void (^)(void))successBlock
              failureBlock:(void (^)(NSError *error))failureBlock;


#pragma mark - relation
/**
 Entity connect
 @param entity entity
 @param relationship relationship 이름
 @param error error
 */
- (void) connect:(BaasioEntity *)entity
    relationship:(NSString*)relationship
           error:(NSError **)error;
/**
 Entity connect asynchronously
 @param entity entity
 @param relationship relationship 이름
 @param successBlock successBlock
 @param failureBlock failureBlock
 */
- (BaasioRequest*)connectInBackground:(BaasioEntity *)entity
                         relationship:(NSString*)relationship
                         successBlock:(void (^)(void))successBlock
                         failureBlock:(void (^)(NSError *error))failureBlock;
/**
 Entity disconnect
 @param entity entity
 @param relationship relationship 이름
 @param error error
 */
- (void) disconnect:(BaasioEntity *)entity
    relationship:(NSString*)relationship
           error:(NSError **)error;

/**
 Entity disconnect asynchronously
 @param entity entity
 @param relationship relationship 이름
 @param successBlock successBlock
 @param failureBlock failureBlock
 */
- (BaasioRequest*)disconnectInBackground:(BaasioEntity *)entity
                            relationship:(NSString*)relationship
                            successBlock:(void (^)(void))successBlock
                            failureBlock:(void (^)(NSError *error))failureBlock;

#pragma mark - Data
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

#pragma mark - Entity
/**
 Entity get
 @param entityName Entity name
 @param uuid uuid
 @param error error
 */
+ (BaasioEntity *)get:(NSString *)entityName
                 uuid:(NSString *)uuid
                error:(NSError **)error;
/**
 Entity get asynchronously
 @param entityName Entity name
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
 Returns a string that represents the contents of the dictionary, formatted as a property list.
 */
- (NSString *)description;


#pragma mark - etc
/**
 Entity dictionary
 */
- (NSDictionary *)dictionary;
@end