//
// Created by cetauri on 12. 11. 26..
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "BaasioFile.h"
#import "AFNetworking.h"
#import "BaasioNetworkManager.h"
#import "Baasio+Private.h"
#import "NetworkActivityIndicatorManager.h"
#import "JSONKit.h"

@implementation BaasioFile {

}
-(id) init
{
    self = [super init];
    if (self){
        self.entityName = @"files";
    }
    return self;
}

#pragma mark - file

- (BaasioRequest*)fileDownloadInBackground:(NSString *)downloadPath
                              successBlock:(void (^)(NSString *))successBlock
                              failureBlock:(void (^)(NSError *))failureBlock
                             progressBlock:(void (^)(float progress))progressBlock
{
    NSURL *url = [[Baasio sharedInstance] getAPIURL];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];

    NSString *path = [self.entityName stringByAppendingFormat:@"/%@/data", self.uuid];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET" path:path parameters:nil];
    request = [[Baasio sharedInstance] setAuthorization:request];

    void (^failure)(NSURLRequest *, NSHTTPURLResponse *, NSError *, id) = [[BaasioNetworkManager sharedInstance] failure:failureBlock];

    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON){
                                                                                            [[NetworkActivityIndicatorManager sharedInstance]hide];
                                                                                            successBlock(downloadPath);
                                                                                        }
                                                                                        failure:failure];
    operation.outputStream = [NSOutputStream outputStreamToFileAtPath:downloadPath append:NO];
    [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead){
        float progress = (float)totalBytesRead / totalBytesExpectedToRead;
        progressBlock(progress);
    }];
    [operation start];
    [[NetworkActivityIndicatorManager sharedInstance]show];
    return (BaasioRequest*)operation;
}

- (BaasioRequest*)fileUploadInBackground:(void (^)(BaasioFile *file))successBlock
                            failureBlock:(void (^)(NSError *))failureBlock
                           progressBlock:(void (^)(float progress))progressBlock
{
    return [[BaasioNetworkManager sharedInstance] multipartFormRequest:self.entityName
                                                           withMethod:@"POST"
                                                             withBody:_data
                                                               params:self.dictionary
                                                             filename:self.filename
                                                          contentType:self.contentType
                                                         successBlock:^(BaasioFile *file) {
                                                             successBlock(file);
                                                         }
                                                         failureBlock:failureBlock
                                                        progressBlock:progressBlock];
}

- (BaasioRequest*)fileUpdateInBackground:(void (^)(BaasioFile *file))successBlock
                            failureBlock:(void (^)(NSError *))failureBlock
                           progressBlock:(void (^)(float progress))progressBlock
{
    
    NSString *path = [self.entityName stringByAppendingFormat:@"/%@", self.uuid];
    return [[BaasioNetworkManager sharedInstance] multipartFormRequest:path
                                                            withMethod:@"PUT"
                                                              withBody:_data
                                                                params:self.dictionary
                                                              filename:self.filename
                                                           contentType:self.contentType
                                                          successBlock:^(BaasioFile *file) {
                                                              successBlock(file);
                                                          }
                                                          failureBlock:failureBlock
                                                         progressBlock:progressBlock];
}

#pragma mark - super
- (BaasioRequest*)getInBackground:(void (^)(BaasioFile *file))successBlock
                     failureBlock:(void (^)(NSError *))failureBlock
{
    return [BaasioFile getInBackground:self.entityName
                                  uuid:self.uuid
                          successBlock:^(BaasioEntity *entity) {
                              BaasioFile *_file = [[BaasioFile alloc] init];
                              [_file set:entity.dictionary];
                              successBlock(_file);
                          }
                          failureBlock:failureBlock];
}

- (BaasioRequest*)updateInBackground:(void (^)(BaasioFile *file))successBlock
                        failureBlock:(void (^)(NSError *error))failureBlock
{
    return [super updateInBackground:^(BaasioEntity *entity){
                            BaasioFile *_file = [[BaasioFile alloc]init];
                            [_file set:entity.dictionary];
                            successBlock(_file);
                        }
                        failureBlock:failureBlock];
}

- (void) connect:(BaasioEntity *)entity
    relationship:(NSString*)relationship
           error:(NSError **)error{
    
    [NSException raise:@"BaasioUnsupportedException" format:@"Don't connect in Baasiofile."];
}

- (BaasioRequest*)connectInBackground:(BaasioEntity *)entity
                         relationship:(NSString*)relationship
                         successBlock:(void (^)(void))successBlock
                         failureBlock:(void (^)(NSError *error))failureBlock{
    [NSException raise:@"BaasioUnsupportedException" format:@"Don't connect in Baasiofile."];
    return nil;
}


#pragma mark - entity
- (void)setContentType:(NSString *)contentType{
    [super setObject:contentType forKey:@"content-type"];
}

- (NSString*)contentType{
    return [super objectForKey:@"content-type"];
}

- (void)setFilename:(NSString *)filename{
    [super setObject:filename forKey:@"filename"];
}

- (NSString*)filename{
    return [super objectForKey:@"filename"];
}


@end