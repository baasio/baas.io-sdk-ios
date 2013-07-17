//
//  BaasioValidator.m
//  baas.io-ios-sdk
//
//  Created by cetauri on 13. 6. 10..
//  Copyright (c) 2013년 kth. All rights reserved.
//

#import "BaasioValidator.h"
#import "NSError+baasio.h"
@implementation BaasioValidator
#pragma mark - API Parameter Validation method
+ (NSError *)parameterValidation:(NSDictionary *)dictionary
                    validateKeys:(NSArray *)validateKeys
                        selector:(SEL)selector {
    NSArray *allKeys = [dictionary allKeys];
    
    for (int i = 0; i < validateKeys.count; i++) {
        NSString *key = validateKeys[i];
        if (![allKeys containsObject:validateKeys[i]]){
            NSString *message = [NSString stringWithFormat:@"The '%@' method requires a property named '%@'", NSStringFromSelector(selector), key];
            NSMutableDictionary* details = [NSMutableDictionary dictionary];
            [details setValue:message forKey:NSLocalizedDescriptionKey];
            NSError *e = [NSError errorWithDomain:@"BassioError" code:MISSING_REQUIRED_PROPERTY_ERROR userInfo:details];
            return e;
        }
    }
    return nil;
}
@end
