//
//  NetworkActivityIndicatorManager.h
//  baas.io-ios-sdk
//
//  Created by cetauri on 13. 1. 8..
//  Copyright (c) 2013년 kth. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface NetworkActivityIndicatorManager : NSObject {
    int count;
    NSObject *lock;
    UIApplication *application;
}

+ (NetworkActivityIndicatorManager*) sharedInstance;

- (void)show;
- (void)hide;


- (void)forceShow;
- (void)forceHide;
@end
