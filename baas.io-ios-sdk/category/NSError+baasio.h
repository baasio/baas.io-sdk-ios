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
 */
- (NSString *)uuid;

@end
