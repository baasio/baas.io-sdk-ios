//
// Created by cetauri on 13. 4. 2..
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "SimpleNetworkManager.h"
#import "AFNetworking.h"
#import "JSONKit.h"
#import "NetworkActivityIndicatorManager.h"

@implementation SimpleNetworkManager {

}


+(SimpleNetworkManager *)sharedInstance
{
    static SimpleNetworkManager  *_manager = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        _manager = [[SimpleNetworkManager alloc] init];
    });
    return _manager;
}
- (NSString*)connectWithHTTPSync:(NSString *)path
                         withMethod:(NSString *)httpMethod
                             params:(NSDictionary *)params
                       headerFields:(NSDictionary *)headerFields
                              error:(NSError **)error
{
    __block id response = nil;
    __block BOOL isFinish = false;
    __block NSError *blockError = nil;

    NSOperation *operation = [self connectWithHTTP:path
                                        withMethod:httpMethod
                                            params:params
                                      headerFields:headerFields
                                           success:^(id result) {
                                               response = result;
                                               isFinish = true;
                                           }
                                           failure:^(NSError *error) {
                                               blockError = error;
                                               isFinish = true;
                                           }];

    [operation waitUntilFinished];

#ifndef UNIT_TEST
    while(!isFinish){
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.5]];
    }
#endif

     if (error != nil) {
         *error = blockError;
     }
    return response;
}

- (NSOperation*)connectWithHTTP:(NSString *)path
                     withMethod:(NSString *)httpMethod
                         params:(NSDictionary *)params
                   headerFields:(NSDictionary *)headerFields
                        success:(void (^)(NSString *response))successBlock
                        failure:(void (^)(NSError *error))failureBlock {

    NSDictionary *parameters;
    if ([httpMethod isEqualToString:@"GET"] ||[httpMethod isEqualToString:@"DELETE"]) {
        parameters = params;
    }
    AFHTTPClient *httpClient = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:path]];
    NSMutableURLRequest *request = [httpClient requestWithMethod:httpMethod path:path parameters:parameters];
    
    if (headerFields != nil) {
        [request setAllHTTPHeaderFields:headerFields];
    }

    if ([httpMethod isEqualToString:@"POST"] || [httpMethod isEqualToString:@"PUT"]) {
        NSError *error;
        NSData *data = [params JSONDataWithOptions:JKSerializeOptionNone error:&error];
        if (error != nil) {
            failureBlock(error);
            return nil;
        }
        request.HTTPBody = data;
    }

    AFHTTPRequestOperation *operation =[httpClient HTTPRequestOperationWithRequest:request
                                        success:^(AFHTTPRequestOperation *operation, id responseObject){                                            
                                            [[NetworkActivityIndicatorManager sharedInstance] hide];
                                            successBlock(operation.responseString);
                                            
                                        }
                                        failure:^(AFHTTPRequestOperation *operation, NSError *error){
                                            [[NetworkActivityIndicatorManager sharedInstance] hide];
                                            
                                            failureBlock(operation.error);
                                        }];
    [[NetworkActivityIndicatorManager sharedInstance] show];
    [operation start];
    return (NSOperation *)operation;

}

@end