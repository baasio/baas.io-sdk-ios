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
 A baas.io Framework Query Object.
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
 
 @param entityName entityName
 @param uuid uuid
 @param relationName relationName
 */
+ (BaasioQuery *)queryWithRelationship:(NSString *)entityName
                              withUUID:(NSString *)uuid
                          withRelation:(NSString*)relationName;

/**
 가져올 property
 
 예) 이름, uuid => [query setProjectionIn:@"name, uuid"];
 @param projectionIn projectionIn
 */
-(void)setProjectionIn:(NSString *)projectionIn;

/**
 where 조건
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
 페이징 초기화 
 */
-(void)clearCursor;

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
