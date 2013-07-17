//
//  NSError+baasio.h
//  NSError
//
//  Created by cetauri on 13. 1. 22..
//  Copyright (c) 2013년 Baas.io. All rights reserved.
//

#import <Foundation/Foundation.h>


/// 잘못된 요청입니다. 각 API 별 Request 형식을 참고해서 다시 요청하시기 바랍니다.
extern NSInteger const BAD_REQUEST_ERROR;

/// 요청받은 리소스가 서버에 존재하지 않습니다.
extern NSInteger const RESOURCE_NOT_FOUND_ERROR;

/// 전송된 데이터(entity)에 반드시 필요한 속성이 누락되었습니다. 요청 형식을 다시 확인해주세요.
extern NSInteger const MISSING_REQUIRED_PROPERTY_ERROR;

/// 해당 Request 를 처리하기 위한 위한 선행 작업이 이루어지지 않았습니다.
extern NSInteger const INVALID_PRECONDITION_ERROR;

/// 추후 공개를 위해 예약된 기능들에 대해 접근했을때 발생합니다.
extern NSInteger const NOT_IMPLEMENTED_ERROR;

/// 인증 또는 권한과 관련된 문제가 발생했습니다.
extern NSInteger const AUTH_ERROR;

/// 잘못된 id이거나 password 입니다.
extern NSInteger const INVALID_USERNAME_OR_PASSWORD_ERROR;

/// 접근 권한이 없습니다.
extern NSInteger const UNAUTHORIZED_ERROR;

/// 인증 토큰에 문제가 있습니다.
extern NSInteger const BAD_TOKEN_ERROR;

/// 만료된 인증 토큰입니다.
extern NSInteger const EXPIRED_TOKEN_ERROR;

/// Push 기능이 활성화 되어 있지 않습니다.
extern NSInteger const PUSH_APPLICATION_NOT_ACTIVATED_ERROR;

/// Push 관련 에러가 발생했습니다.
extern NSInteger const PUSH_ERROR;

/// 이미 존재하는 리소스입니다.
extern NSInteger const RESOURCE_ALREADY_EXIST_ERROR;

/// 예약된 리소스 이름입니다.
extern NSInteger const PRESERVED_RESOURCE_ERROR;

/// 유일해야하는 속성을 중복해서 가질 수 없습니다.
extern NSInteger const DUPLICATED_UNIQUE_PROPERTY_ERROR;

/// 잘못된 쿼리입니다.
extern NSInteger const QUERY_PARSE_ERROR;

/// 알수 없는 에러입니다.
extern NSInteger const UNKNOWN_ERROR;

/**
 The category of NSError for baas.io.
 baas.io의 에러 코드를 확장하여 uuid를 받을 수 있다.
*/
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
