//
//  BaasioMessage.m
//  baas.io-ios-sdk
//
//  Created by cetauri on 12. 12. 6..
//  Copyright (c) 2012년 kth. All rights reserved.
//

#import "BaasioMessage.h"


@implementation BaasioMessage {
    NSMutableDictionary *_payload;
}

-(id) init
{
    self = [super init];
    if (self){
        _payload = [NSMutableDictionary dictionary];
        _target = @"all";
        _badge = 1;
        _platform = @"I,G";
        _memo = @"iOS SDK";
    }
    return self;
}

- (NSDictionary *)payload
{
    
    NSMutableDictionary *payload = _payload;
    
    [payload setValue:[NSString stringWithFormat:@"%d",(int)_badge] forKey:@"badge"];
    [payload setValue:_sound forKey:@"sound"];
    [payload setValue:_alert forKey:@"alert"];

    
    return payload;
}

- (NSString *)reserveDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmm"];
    
    return [dateFormatter stringFromDate:[[NSCalendar currentCalendar] dateFromComponents:_reserve]];
}

- (NSDictionary *)dictionary
{
    
    NSDictionary *dictionary = @{
        @"target": _target,
        @"payload": [self payload],
        @"platform": _platform,
        @"memo": _memo
    };
    
    NSMutableDictionary *_mictionary = [NSMutableDictionary dictionaryWithDictionary:dictionary];
    if (_to != nil && _to.count != 0) {
        NSString *toList = _to.description;
        toList = [toList stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        toList = [toList stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        toList = [toList substringWithRange:NSMakeRange(1, [toList length]-2)];
        [_mictionary setObject:toList forKey:@"to"];
    }
    
    if (_reserve != nil) {
        [_mictionary setObject:[self reserveDate] forKey:@"reserve"];
    }
    
    return _mictionary;
}




NSString *path = @"pushes";
- (void)addPayload:(NSString*)value forKey:(NSString*)key
{
    [_payload setValue:value forKey:key];
}
@end
