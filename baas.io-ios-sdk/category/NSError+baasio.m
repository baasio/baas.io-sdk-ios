//
//  NSError+baasio.m
//  NSError
//
//  Created by cetauri on 13. 1. 22..
//  Copyright (c) 2013년 Baas.io. All rights reserved.
//

#import "NSError+baasio.h"
NSInteger const UNKNOWN_ERROR = -100;

NSInteger const BAD_REQUEST_ERROR = 100;

NSInteger const RESOURCE_NOT_FOUND_ERROR = 101;

NSInteger const MISSING_REQUIRED_PROPERTY_ERROR = 102;

NSInteger const INVALID_PRECONDITION_ERROR = 103;

NSInteger const NOT_IMPLEMENTED_ERROR = 190;

NSInteger const AUTH_ERROR = 200;

NSInteger const INVALID_USERNAME_OR_PASSWORD_ERROR = 201;

NSInteger const UNAUTHORIZED_ERROR = 202;

NSInteger const BAD_TOKEN_ERROR = 210;

NSInteger const EXPIRED_TOKEN_ERROR = 211;

NSInteger const PUSH_APPLICATION_NOT_ACTIVATED_ERROR = 600;

NSInteger const PUSH_ERROR = 620;

NSInteger const RESOURCE_ALREADY_EXIST_ERROR = 911;

NSInteger const PRESERVED_RESOURCE_ERROR = 912;

NSInteger const DUPLICATED_UNIQUE_PROPERTY_ERROR = 913;

NSInteger const QUERY_PARSE_ERROR = 915;


@implementation NSError (Baasio)
-(void)setUuid:(NSString *)uuid{
    _uuid = uuid;
}

- (NSString *)uuid{
    return _uuid;
}
@end
