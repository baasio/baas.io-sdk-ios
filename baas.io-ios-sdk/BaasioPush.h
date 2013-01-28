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
 sendPush
 @param message message
 @param error error
 */
- (void)sendPush:(BaasioMessage *)message
           error:(NSError**)error;

/**
 sendPush asynchronously
 @param config config
 @param successBlock successBlock
 @param failureBlock failureBlock
 */
- (BaasioRequest*)sendPushInBackground:(BaasioMessage *)config
                          successBlock:(void (^)(void))successBlock
                          failureBlock:(void (^)(NSError *error))failureBlock;
/**
 unregister
 @param error error
 */
- (void)unregister:(NSError**)error;

/**
 unregister asynchronously
 @param successBlock successBlock
 @param failureBlock failureBlock
 */
- (BaasioRequest*)unregisterInBackground:(void (^)(void))successBlock
                            failureBlock:(void (^)(NSError *error))failureBlock;

/**
 register
 @param deviceID deviceID
 @param tags tags
 @param error error
 */
- (void)register:(NSString *)deviceID
            tags:(NSArray *)tags
           error:(NSError**)error;
/**
 register asynchronously
 @param deviceID deviceID
 @param tags tags
 @param successBlock successBlock
 @param failureBlock failureBlock
 */
- (BaasioRequest*)registerInBackground:(NSString *)deviceID
                                  tags:(NSArray *)tags
                          successBlock:(void (^)(void))successBlock
                          failureBlock:(void (^)(NSError *error))failureBlock;
@end