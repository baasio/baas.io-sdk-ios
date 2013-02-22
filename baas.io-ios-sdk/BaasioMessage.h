//
//  BaasioMessage.h
//  baas.io-ios-sdk
//
//  Created by cetauri on 12. 12. 6..
//  Copyright (c) 2012년 kth. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 A bass.io Framework Message Object for Push.
*/
@interface BaasioMessage : NSObject

/**
 */
@property(nonatomic, assign) NSString *target;
/**
 */
@property(nonatomic, assign) int badge;
/**
 */
@property(nonatomic, assign) NSString *sound;
/**
 */
@property(nonatomic, assign) NSString *alert;

/**
 */
@property(nonatomic, assign) NSString *platform;
/**
 */
@property(nonatomic, assign) NSString *memo;
/**
 */
@property(strong) NSDateComponents *reserve;
/**
 */
@property(nonatomic, assign) NSArray *to;

/**
 Adds a given key-value pair to the dictionary.
 @param value value
 @param key key
 */
- (void)addPayload:(NSString*)value forKey:(NSString*)key;

/**
 Entity dictionary
 */
- (NSDictionary *)dictionary;
@end


