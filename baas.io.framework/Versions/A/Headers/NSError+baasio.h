//
//  NSError+baasio.h
//  NSError
//
//  Created by cetauri on 13. 1. 22..
//  Copyright (c) 2013년 Baas.io. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 The category of NSError for baas.io.
 baas.io의 에러 코드를 확장하여 uuid를 받을 수 있다.
*/
NSString *_uuid;
@interface NSError (Baasio)
/**
 setUuid
 @param uuid uuid
 */
-(void)setUuid:(NSString *)uuid;

/**
 uuid
 @return uuid
 */
- (NSString *)uuid;

@end
