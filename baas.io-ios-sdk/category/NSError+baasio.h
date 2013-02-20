//
//  NSError+baasio.h
//  NSError
//
//  Created by cetauri on 13. 1. 22..
//  Copyright (c) 2013년 Baas.io. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
* 잘못된 요청입니다. 각 API 별 Request 형식을 참고해서 다시 요청하시기 바랍니다.
*/
#define BAD_REQUEST_ERROR	100

/**
* 요청받은 리소스가 서버에 존재하지 않습니다.
*/
#define RESOURCE_NOT_FOUND_ERROR	101

/**
* 전송된 데이터(entity)에 반드시 필요한 속성이 누락되었습니다. 요청 형식을 다시 확인해주세요.
*/
#define MISSING_REQUIRED_PROPERTY_ERROR	102

/**
* 해당 Request 를 처리하기 위한 위한 선행 작업이 이루어지지 않았습니다.
*/
#define INVALID_PRECONDITION_ERROR	103

/**
* 추후 공개를 위해 예약된 기능들에 대해 접근했을때 발생합니다.
*/
#define NOT_IMPLEMENTED_ERROR	190

/**
* 인증 또는 권한과 관련된 문제가 발생했습니다.
*/
#define AUTH_ERROR	200

/**
* 잘못된 id이거나 password 입니다.
*/
#define INVALID_USERNAME_OR_PASSWORD_ERROR	201

/**
* 접근 권한이 없습니다.
*/
#define UNAUTHORIZED_ERROR  202

/**
* 인증 토큰에 문제가 있습니다.
*/
#define BAD_TOKEN_ERROR 210

/**
* 만료된 인증 토큰입니다.
*/
#define EXPIRED_TOKEN_ERROR	211

/**
* Push 기능이 활성화 되어 있지 않습니다.
*/
#define PUSH_APPLICATION_NOT_ACTIVATED_ERROR    600

/**
* Push 관련 에러가 발생했습니다.
*/
#define PUSH_ERROR	620

/**
* 이미 존재하는 리소스입니다.
*/
#define RESOURCE_ALREADY_EXIST_ERROR    911

/**
* 예약된 리소스 이름입니다.
*/
#define PRESERVED_RESOURCE_ERROR	912

/**
* 유일해야하는 속성을 중복해서 가질 수 없습니다.
*/
#define DUPLICATED_UNIQUE_PROPERTY_ERROR	913

/**
* 잘못된 쿼리입니다.
*/
#define QUERY_PARSE_ERROR	915

/**
* 알수 없는 에러입니다.
*/
#define UNKNOWN_ERROR	-100

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
