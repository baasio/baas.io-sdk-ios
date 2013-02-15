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
 Collection용 Query 생성
 @param name name
 */
+ (BaasioQuery *)queryWithCollection:(NSString *)name;

/**
 Group용 Query 생성
 
 @param name name
 */
+ (BaasioQuery *)queryWithGroup:(NSString *)name;

/**
 Relationship용 Query 생성

 @param name name
 */
+ (BaasioQuery *)queryWithRelationship:(NSString *)name;

/**
 가져올 property
 
 예) 이름, uuid => [query setProjectionIn:@"name, uuid"];
 @param projectionIn projectionIn
 */
-(void)setProjectionIn:(NSString *)projectionIn;

/**
 where 조건 추가
 @param wheres wheres 조건
 */
-(void)setWheres:(NSString *)wheres;

/**
 정렬
 @param key key
 @param order BaasioQuerySortOrderASC or BaasioQuerySortOrderDESC
 */
-(void)setOrderBy:(NSString *)key order:(BaasioQuerySortOrder)order;

/**
 limit
 @param limit 결과를 가져올 갯수(default : 10개)
 */
-(void)setLimit: (int)limit;

/**
 cursor
 */
-(NSString *)cursor;

/**
 cursor
 @param cursor cursor
 */
-(void)setCursor:(NSString *)cursor;


/**
 reset cursor
 */
-(void)setResetCursor;

/**
 hasMoreEntities
 다음 결과 존재 여부
 */
-(BOOL)hasMoreEntities;

/**
 description
 */
-(NSString *)description;

/**
 다음 결과
 @param error error
 */
-(NSArray *)next:(NSError**)error;

/**
 다음 결과 asynchronously
 @param successBlock successBlock
 @param failureBlock failureBlock
 */
-(BaasioRequest *)nextInBackground:(void (^)(NSArray *objects))successBlock
                      failureBlock:(void (^)(NSError *error))failureBlock;
/**
 이전 결과
 @param error error
 */
-(NSArray *)prev:(NSError**)error;

/**
 이전 결과 asynchronously
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
