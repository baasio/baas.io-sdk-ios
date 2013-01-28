//
//  Baasio+Private.h
//  baas.io-ios-sdk
//
//  Created by cetauri on 12. 12. 3..
//  Copyright (c) 2012년 kth. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaasioUser.h"
#import "Baasio.h"

@interface Baasio(Private)
- (BaasioUser*)currentUser;
- (void)setCurrentUser:(BaasioUser*)currentUser;

- (void)setToken:(NSString*)token;

- (NSMutableURLRequest *)setAuthorization:(NSMutableURLRequest *)request;
@end