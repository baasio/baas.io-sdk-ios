//
//  BaasioNetworkManager.m
//  baas.io-ios-sdk
//
//  Created by cetauri on 12. 12. 12..
//  Copyright (c) 2012년 kth. All rights reserved.
//

#import "BaasioNetworkManager.h"
#import "AFNetworking.h"
#import "JSONKit.h"
#import "Baasio+Private.h"
#import "NetworkActivityIndicatorManager.h"


@implementation BaasioNetworkManager

+(BaasioNetworkManager *)sharedInstance
{
    static BaasioNetworkManager  *_manager = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        _manager = [[BaasioNetworkManager alloc] init];
    });
    return _manager;
}

- (id)connectWithHTTPSync:(NSString *)path
               withMethod:(NSString *)httpMethod
                   params:(NSDictionary *)params
                    error:(NSError **)error
{
    __block id response = nil;
    __block BOOL isFinish = false;
    __block NSError *blockError = nil;
    
    BaasioRequest *request = [self connectWithHTTP:path
               withMethod:httpMethod
                   params:params
                  success:^(id result){
                      response = result;
                      isFinish = true;
                  }
                  failure:^(NSError *error){
                      blockError = error;
                      isFinish = true;
                  }];
    
    [request waitUntilFinished];
    
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

- (BaasioRequest*) connectWithHTTP:(NSString*)path
                      withMethod:(NSString*)httpMethod
                        params:(NSDictionary*)params
                         success:(void (^)(id result))successBlock
                         failure:(void (^)(NSError *error))failureBlock {
    
    
    NSDictionary *parameters;
    if ([httpMethod isEqualToString:@"GET"] ||[httpMethod isEqualToString:@"DELETE"]) {
        parameters = params;
    }
    AFHTTPClient *httpClient = [AFHTTPClient clientWithBaseURL:[[Baasio sharedInstance] getAPIURL]];
    NSMutableURLRequest *request = [httpClient requestWithMethod:httpMethod path:path parameters:parameters];
    request = [[Baasio sharedInstance] setAuthorization:request];

    if ([httpMethod isEqualToString:@"POST"] || [httpMethod isEqualToString:@"PUT"]) {
        NSError *error;
        NSData *data = [params JSONDataWithOptions:JKSerializeOptionNone error:&error];
        if (error != nil) {
            failureBlock(error);
            return nil;
        }
        request.HTTPBody = data;
    }
    
    void (^failure)(NSURLRequest *, NSHTTPURLResponse *, NSError *, id) = [self failure:failureBlock];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON){
                                                                                            [[NetworkActivityIndicatorManager sharedInstance] hide];
                                                                                            successBlock(JSON);
                                                                                        }
                                                                                        failure:failure];
    [operation start];
    [[NetworkActivityIndicatorManager sharedInstance] show];
    return (BaasioRequest*)operation;

}


- (BaasioRequest *)multipartFormRequest:(NSString *)path
                             withMethod:(NSString *)httpMethod
                               withBody:(NSData *)bodyData
                                 params:(NSDictionary *)params
                               filename:(NSString *)filename
                            contentType:(NSString *)contentType
                           successBlock:(void (^)(BaasioFile* file))successBlock
                           failureBlock:(void (^)(NSError *))failureBlock
                          progressBlock:(void (^)(float progress))progressBlock
{
    NSURL *url = [[Baasio sharedInstance] getAPIURL];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    NSMutableURLRequest *request = [httpClient multipartFormRequestWithMethod:httpMethod
                                                                         path:path
                                                                   parameters:nil
                                                    constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
                                                        NSMutableDictionary *mutableParams = [NSMutableDictionary dictionaryWithDictionary:params];
                                                        if (bodyData != nil){
                                                            NSString *_contentType = contentType;
                                                            if (_contentType == nil || [_contentType isEqualToString:@""]) {
                                                                _contentType = [self mimeTypeForFileAtPath:filename];
                                                                [mutableParams setObject:_contentType forKey:@"content-type"];
                                                            }
                                                            
                                                            [formData appendPartWithFileData:bodyData
                                                                                        name:@"file"
                                                                                    fileName:filename
                                                                                    mimeType:_contentType];
                                                        }
                                                        
                                                        if (bodyData != nil){
                                                            
                                                            NSError *error;
                                                            NSData *data = [mutableParams JSONDataWithOptions:JKSerializeOptionNone error:&error];
                                                            
                                                            [formData appendPartWithFileData:data
                                                                                        name:@"entity"
                                                                                    fileName:@"entity"
                                                                                    mimeType:@"application/json"];
                                                        }


                                                    }];
    
    request = [[Baasio sharedInstance] setAuthorization:request];


    void (^failure)(NSURLRequest *, NSHTTPURLResponse *, NSError *, id) = [[BaasioNetworkManager sharedInstance] failure:failureBlock];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON){
                                                                                            [[NetworkActivityIndicatorManager sharedInstance] hide];
                                                                                            
                                                                                            NSDictionary *dictionary = JSON[@"entities"][0];

                                                                                            BaasioFile *_file = [[BaasioFile alloc]init];
                                                                                            [_file set:dictionary];
                                                                                            
                                                                                            successBlock(_file);
                                                                                        }
                                                                                        failure:failure];

    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        float progress = totalBytesWritten / totalBytesExpectedToWrite;
        progressBlock(progress);
    }];

    [operation start];
    [[NetworkActivityIndicatorManager sharedInstance]show];
    return (BaasioRequest*)operation;
}


#pragma mark - API response method
- (void (^)(NSURLRequest *, NSHTTPURLResponse *, NSError *, id))failure:(void (^)(NSError *))failureBlock {
    
    
    void (^failure)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON){
        
        [[NetworkActivityIndicatorManager sharedInstance] hide];
        
        NSError *e = [self extractNormalError:error JSON:JSON];

        if ([_delegate respondsToSelector:@selector(hook:)]){
            [_delegate hook:e];
        }
        failureBlock(e);
    };
    return failure;
}

- (NSError *)extractNormalError:(NSError *)error JSON:(id)JSON{

    if (JSON == nil){
        NSString *debugDescription = error.userInfo[@"NSDebugDescription"];
        if (debugDescription != nil) {
            NSMutableDictionary* details = [NSMutableDictionary dictionary];
            [details setValue:debugDescription forKey:NSLocalizedDescriptionKey];

            NSError *e = [NSError errorWithDomain:error.domain code:error.code userInfo:details];
            return e;
        }
        return error;
    }

    NSString *message = JSON[@"error_description"];
    NSMutableDictionary* details = [NSMutableDictionary dictionary];
    [details setValue:message forKey:NSLocalizedDescriptionKey];
    
    int error_code = [JSON[@"error_code"] intValue];
    
    NSError *e = [NSError errorWithDomain:@"BassioError" code:error_code userInfo:details];
    e.uuid = JSON[@"error_uuid"];
    return e;
}

#pragma mark - etc

- (NSString*) mimeTypeForFileAtPath: (NSString *) path {
    // Borrowed from http://stackoverflow.com/questions/5996797/determine-mime-type-of-nsdata-loaded-from-a-file
    // itself, derived from  http://stackoverflow.com/questions/2439020/wheres-the-iphone-mime-type-database
    CFStringRef UTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef)[path pathExtension], NULL);
    CFStringRef mimeType = UTTypeCopyPreferredTagWithClass (UTI, kUTTagClassMIMEType);
    CFRelease(UTI);
    if (!mimeType) {
        return @"application/octet-stream";
    }
    return (NSString *)CFBridgingRelease(mimeType);
}


@end
