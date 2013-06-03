//
//  ShadowUpdateCheckerTest.m
//  baas.io-ios-sdk
//
//  Created by cetauri on 13. 6. 3..
//  Copyright (c) 2013년 kth. All rights reserved.
//

#import "ShadowUpdateCheckerTest.h"
#import "ShadowUpdateChecker.h"
@implementation ShadowUpdateCheckerTest

- (void)setUp
{
}

- (void)tearDown
{
    // Tear-down code here.
    [super tearDown];
}

-(void)testGetLatestVersion
{
    ShadowUpdateChecker *checker = [[ShadowUpdateChecker alloc]init];
    NSString *version = [checker latestVersion];
    NSLog(@"version : %@", version);
}
@end
