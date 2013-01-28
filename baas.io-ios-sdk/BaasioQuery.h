//
// Created by cetauri on 12. 11. 19..
//
// To change the template use AppCode | Preferences | File Templates.
//

typedef enum {
    BaasioQuerySortOrderASC,
    BaasioQuerySortOrderDESC
} BaasioQuerySortOrder;

#import "BaasioGroup.h"

/**
 A bass.io Framework Query Object.
*/
@interface BaasioQuery : NSObject
/**
 queryWithCollection
 @param name name
 */
+ (BaasioQuery *)queryWithCollection:(NSString *)name;

/**
 queryWithGroup
 @param name name
 */
+ (BaasioQuery *)queryWithGroup:(NSString *)name;

/**
 queryWithRelationship
 @param name name
 */
+ (BaasioQuery *)queryWithRelationship:(NSString *)name;

/**
 projectionIn
 @param projectionIn projectionIn
 */
-(void)projectionIn:(NSString *)projectionIn;

/**
 setWheres
 @param wheres wheres
 */
-(void)setWheres:(NSString *)wheres;

/**
 setOrderBy
 @param key key
 @param order order
 */
-(void)setOrderBy:(NSString *)key order:(BaasioQuerySortOrder)order;

/**
 setLimit
 @param limit limit
 */
-(void)setLimit: (int)limit;

/**
 cursor
 */
-(NSString *)cursor;

/**
 setCursor
 @param cursor cursor
 */
-(void)setCursor:(NSString *)cursor;


/**
 setResetCursor
 */
-(void)setResetCursor;

/**
 hasMoreEntities
 */
-(BOOL)hasMoreEntities;

/**
 description
 */
-(NSString *)description;

/**
 next
 @param error error
 */
-(NSArray *)next:(NSError**)error;

/**
 next asynchronously
 @param successBlock successBlock
 @param failureBlock failureBlock
 */
-(BaasioRequest *)nextInBackground:(void (^)(NSArray *objects))successBlock
                       failureBlock:(void (^)(NSError *error))failureBlock;
/**
 prev
 @param error error
 */
-(NSArray *)prev:(NSError**)error;

/**
 prev asynchronously
 @param successBlock successBlock
 @param failureBlock failureBlock
 */
-(BaasioRequest *)prevInBackground:(void (^)(NSArray *objects))successBlock
                       failureBlock:(void (^)(NSError *error))failureBlock;

/**
 query
 @param error error
 */
-(NSArray *)query:(NSError**)error;

/**
 query asynchronously
 @param successBlock successBlock
 @param failureBlock failureBlock
 */
-(BaasioRequest *)queryInBackground:(void (^)(NSArray *objects))successBlock
                failureBlock:(void (^)(NSError *error))failureBlock;
@end
