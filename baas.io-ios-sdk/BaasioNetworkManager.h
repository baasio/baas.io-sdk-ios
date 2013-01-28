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

+ (BaasioNetworkManager *)sharedInstance;


- (id)connectWithHTTPSync:(NSString *)path
               withMethod:(NSString *)method
                   params:(NSDictionary *)params
                    error:(NSError **)error;

- (BaasioRequest*) connectWithHTTP:(NSString*)path
                        withMethod:(NSString*)httpMethod
                            params:(NSDictionary*)params
                           success:(void (^)(id result))successBlock
                           failure:(void (^)(NSError *error))failureBlock;

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
