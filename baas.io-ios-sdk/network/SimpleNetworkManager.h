//
// Created by cetauri on 13. 4. 2..
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>


/**
 Simple Network Manager Class
 */
@interface SimpleNetworkManager : NSObject

+ (SimpleNetworkManager *)sharedInstance;

/**
 HTTP connect
 @param path path
 @param httpMethod http method (ex : GET, POST, PUT, DELETE)
 @param params http paramters
 @param headerFields http header fields
 @param error error
 */
- (NSString*)connectWithHTTPSync:(NSString *)path
                      withMethod:(NSString *)httpMethod
                          params:(NSDictionary *)params
                    headerFields:(NSDictionary *)headerFields
                           error:(NSError **)error;


/**
 HTTP connect asynchronously
 @param path path
 @param httpMethod http method (ex : GET, POST, PUT, DELETE)
 @param params http paramters
 @param headerFields http header fields
 @param successBlock successBlock
 @param failureBlock failureBlock
 */
- (NSOperation*)connectWithHTTP:(NSString *)path
                     withMethod:(NSString *)httpMethod
                         params:(NSDictionary *)params
                   headerFields:(NSDictionary *)headerFields
                        success:(void (^)(NSString *response))successBlock
                        failure:(void (^)(NSError *error))failureBlock;

@end