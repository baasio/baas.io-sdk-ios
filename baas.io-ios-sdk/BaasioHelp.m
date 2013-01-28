//
//  BaasioHelp.m
//  baas.io-ios-sdk
//
//  Created by cetauri on 12. 12. 20..
//  Copyright (c) 2012년 kth. All rights reserved.
//

#import "BaasioHelp.h"
#import "BaasioNetworkManager.h"
@implementation BaasioHelp

- (BaasioRequest*)getHelpsInBackground:(void (^)(NSArray *array))successBlock
                             failureBlock:(void (^)(NSError *error))failureBlock
{

    return [self searchHelpsInBackground:@"" successBlock:successBlock failureBlock:failureBlock];
}

- (BaasioRequest*)searchHelpsInBackground:(NSString *)keyword
                             successBlock:(void (^)(NSArray *array))successBlock
                             failureBlock:(void (^)(NSError *error))failureBlock
{

    NSDictionary *param = @{@"keyword": keyword};
    
    return [[BaasioNetworkManager sharedInstance] connectWithHTTP:@"help/helps"
                                                           withMethod:@"GET"
                                                               params:param
                                                              success:^(id result){
                                                                  NSDictionary *response = (NSDictionary *)result;
                                                                  NSLog(@"response : %@", response);
                                                                  NSArray *objects = [NSArray arrayWithArray:response[@"entities"]];
                                                                  successBlock(objects);
                                                              }
                                                              failure:failureBlock];

}

- (BaasioRequest*)getHelpDetailInBackground:(NSString *)uuid
                               successBlock:(void (^)(NSDictionary *dictionary))successBlock
                               failureBlock:(void (^)(NSError *error))failureBlock{
    
    NSString *path = [@"help/helps/" stringByAppendingString:uuid];
    
    return [[BaasioNetworkManager sharedInstance] connectWithHTTP:path
                                                       withMethod:@"GET"
                                                           params:nil
                                                          success:^(id result){
                                                              NSDictionary *response = (NSDictionary *)result;
                                                              NSLog(@"response : %@", response);
                                                              NSArray *objects = [NSArray arrayWithArray:response[@"entities"]];
                                                              successBlock(objects[0]);
                                                          }
                                                          failure:failureBlock];
}

- (BaasioRequest*)sendQuestionInBackground:(NSString *)email
                                   content:(NSString *)content
                              successBlock:(void (^)(void))successBlock
                              failureBlock:(void (^)(NSError *error))failureBlock
{

    NSDictionary *param = @{
        @"email" : email,
        @"content" : content,
        @"temporary_answer" : @"temporary_answer",  //
        @"classification_id" : @"classification_id",//
        @"satisfaction_level_id" : @"satisfaction_level_id",//
        @"status_id" : @"status_id",//
        @"device_info" : @"device_info",//
        @"official" : @"official",//
        @"publicaccessable" : @"publicaccessable",//
        @"app_info" : @"app_info",//
        @"os_info" : @"os_info",//
        @"platform" : @"platform",//
        @"vote" : @"1",
        @"tags" : @""
    };
    NSString *path = @"help/questions";
    return [[BaasioNetworkManager sharedInstance] connectWithHTTP:path
                                                       withMethod:@"POST"
                                                           params:param
                                                          success:^(id result){
                                                              NSDictionary *response = (NSDictionary *)result;
                                                              NSLog(@"response : %@", response);
                                                              successBlock();
                                                          }
                                                          failure:failureBlock];
}


@end
