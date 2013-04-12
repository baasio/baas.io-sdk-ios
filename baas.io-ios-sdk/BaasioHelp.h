//
//  BaasioHelp.h
//  baas.io-ios-sdk
//
//  Created by cetauri on 12. 12. 20..
//  Copyright (c) 2012년 kth. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Baasio.h"
#import "BaasioRequest.h"

/**
 A baas.io Framework Help Object.
*/
@interface BaasioHelp : NSObject
/**
 asynchronously 도움말 보기
 @param successBlock successBlock
 @param failureBlock failureBlock
 */
- (BaasioRequest*)getHelpsInBackground:(void (^)(NSArray *array))successBlock
                           failureBlock:(void (^)(NSError *error))failureBlock;


/**
 asynchronously 도움말 상세보기
 @param uuid uuid
 @param successBlock successBlock
 @param failureBlock failureBlock
*/
- (BaasioRequest*)getHelpDetailInBackground:(NSString *)uuid
                               successBlock:(void (^)(NSDictionary *dictionary))successBlock
                               failureBlock:(void (^)(NSError *error))failureBlock;

/**
 asynchronously 도움말 검색
 @param keyword 검색어
 @param successBlock successBlock
 @param failureBlock failureBlock
*/
- (BaasioRequest*)searchHelpsInBackground:(NSString *)keyword
                             successBlock:(void (^)(NSArray *array))successBlock
                             failureBlock:(void (^)(NSError *error))failureBlock;

/**
 asynchronously 문의 하기
 @param email email
 @param content 문의내용
 @param successBlock successBlock
 @param failureBlock failureBlock
*/

- (BaasioRequest*)sendQuestionInBackground:(NSString *)email
                                   content:(NSString *)content
                              successBlock:(void (^)(void))successBlock
                              failureBlock:(void (^)(NSError *error))failureBlock;
@end
