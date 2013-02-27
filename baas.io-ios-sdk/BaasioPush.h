//
// Created by cetauri on 12. 11. 26..
//
// To change the template use AppCode | Preferences | File Templates.
//

#define PUSH_DEVICE_ID @"PUSH_DEVICE_ID_BAASIO_SDK"
#import <Foundation/Foundation.h>
#import "BaasioMessage.h"
#import "BaasioRequest.h"

/**
 A bass.io Framework Push Object.
*/
@interface BaasioPush : NSObject

/**
 Push 발송
 @param message Push 환경 설정 객체
 @param error error
 */
- (void)sendPush:(BaasioMessage *)message
           error:(NSError**)error;

/**
 Push 발송 asynchronously
 @param message Push 환경 설정 객체
 @param successBlock successBlock
 @param failureBlock failureBlock
 */
- (BaasioRequest*)sendPushInBackground:(BaasioMessage *)message
                          successBlock:(void (^)(void))successBlock
                          failureBlock:(void (^)(NSError *error))failureBlock;
/**
 디바이스 삭제
 @param error error
 */
- (void)unregister:(NSError**)error;

/**
 디바이스 삭제 asynchronously
 @param successBlock successBlock
 @param failureBlock failureBlock
 */
- (BaasioRequest*)unregisterInBackground:(void (^)(void))successBlock
                            failureBlock:(void (^)(NSError *error))failureBlock;

/**
 디바이스 등록
 @param deviceID device ID
 @param tags tags
 @param error error
 */
- (void)register:(NSString *)deviceID
            tags:(NSArray *)tags
           error:(NSError**)error;
/**
 디바이스 등록 asynchronously
 @param deviceID device ID
 @param tags tags
 @param successBlock successBlock
 @param failureBlock failureBlock
 */
- (BaasioRequest*)registerInBackground:(NSString *)deviceID
                                  tags:(NSArray *)tags
                          successBlock:(void (^)(void))successBlock
                          failureBlock:(void (^)(NSError *error))failureBlock;



/**
 Push 켜기
 @param error error
 */
- (void)pushOn:(NSError**)error;

/**
 pushOnInBackground
 @param successBlock successBlock
 @param failureBlock failureBlock
 */
- (BaasioRequest*)pushOnInBackground:(void (^)(void))successBlock
                        failureBlock:(void (^)(NSError *error))failureBlock;

/**
 Push 끄기
 @param error error
 */
- (void)pushOff:(NSError**)error;
/**
 pushOffInBackground
 @param successBlock successBlock
 @param failureBlock failureBlock
 */
- (BaasioRequest*)pushOffInBackground:(void (^)(void))successBlock
                         failureBlock:(void (^)(NSError *error))failureBlock;


@end