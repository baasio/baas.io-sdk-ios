//
//  NetworkActivityIndicatorManager.m
//  baas.io-ios-sdk
//
//  Created by cetauri on 13. 1. 8..
//  Copyright (c) 2013년 kth. All rights reserved.
//
#import "NetworkActivityIndicatorManager.h"

@implementation NetworkActivityIndicatorManager

+(NetworkActivityIndicatorManager *)sharedInstance
{
    static NetworkActivityIndicatorManager  *_manager = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        _manager = [[NetworkActivityIndicatorManager alloc] init];
    });
    return _manager;
}

- (id)init
{
    self = [super init];
    if (self) {
        lock = [[NSObject alloc] init];
        application = [UIApplication sharedApplication];
    }
    
    return self;
}

- (void)show
{
    @synchronized(lock){
        count++;
        application.networkActivityIndicatorVisible = YES;
    }
}

- (void)hide
{
    @synchronized(lock){
        if (count <= 1) {
            count = 0;
        } else {
            count -= 1;
            return;
        }
        application.networkActivityIndicatorVisible = NO;
    }
}

- (void)forceShow;
{
    @synchronized(lock){
        count = 0;
        [self show];
    }
}

- (void)forceHide
{
    @synchronized(lock){
        count = 0;
        [self hide];
    }
}

@end
