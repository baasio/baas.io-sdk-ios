//
//  BaasioNetworkManager.h
//  baas.io-ios-sdk
//
//  Created by cetauri on 12. 12. 12..
//  Copyright (c) 2012년 kth. All rights reserved.
//

#import "BaasioRequest.h"
#import "BaasioFile.h"

@protocol BassioErrorDelegate <NSObject>;
@required
-(void)hook:(NSError *)error;
@end


@interface BaasioNetworkManager : NSObject

@property (nonatomic,assign) id <BassioErrorDelegate> delegate;

/**
 sharedInstance
 */
+ (BaasioNetworkManager *)sharedInstance;

/**
 HTTP connect
 @param path path
 @param httpMethod http method (ex : GET, POST, PUT, DELETE)
 @param params http paramters
 @param error error
 */
- (id)connectWithHTTPSync:(NSString *)path
               withMethod:(NSString *)httpMethod
                   params:(NSDictionary *)params
                    error:(NSError **)error;


/**
 HTTP connect asynchronously
 @param path path
 @param method http method (ex : GET, POST, PUT, DELETE)
 @param params http paramters
 @param successBlock successBlock
 @param failureBlock failureBlock
 */
- (BaasioRequest*) connectWithHTTP:(NSString*)path
                        withMethod:(NSString*)httpMethod
                            params:(NSDictionary*)params
                           success:(void (^)(id result))successBlock
                           failure:(void (^)(NSError *error))failureBlock;
/**
 multipart/form-data HTTP request asynchronously

 @param path path
 @param method http method (ex : GET, POST, PUT, DELETE)
 @param data binary data
 @param params http paramters
 @param filename File Name
 @param contentType Content-Type
 @param successBlock successBlock
 @param failureBlock failureBlock
 @param progressBlock progressBlock
 */
- (BaasioRequest *)multipartFormRequest:(NSString *)path
                             withMethod:(NSString *)httpMethod
                               withBody:(NSData *)data
                                 params:(NSDictionary *)params
                               filename:(NSString *)filename
                            contentType:(NSString *)contentType
                           successBlock:(void (^)(BaasioFile* file))successBlock
                           failureBlock:(void (^)(NSError *))failureBlock
                          progressBlock:(void (^)(float progress))progressBlock;

#pragma mark - API response method
- (void (^)(NSURLRequest *, NSHTTPURLResponse *, NSError *, id))failure:(void (^)(NSError *))failureBlock;

@end
