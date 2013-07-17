//
//  BaasioValidator.h
//  baas.io-ios-sdk
//
//  Created by cetauri on 13. 6. 10..
//  Copyright (c) 2013년 kth. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaasioValidator : NSObject
+ (NSError *)parameterValidation:(NSDictionary *)dictionary
                    validateKeys:(NSArray *)validateKeys
                        selector:(SEL)selector;
@end
