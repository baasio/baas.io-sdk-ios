//
//  NSError+baasio.m
//  NSError
//
//  Created by cetauri on 13. 1. 22..
//  Copyright (c) 2013년 Baas.io. All rights reserved.
//

#import "NSError+baasio.h"

@implementation NSError (Baasio)
-(void)setUuid:(NSString *)uuid{
    _uuid = uuid;
}

- (NSString *)uuid{
    return _uuid;
}
@end
