baas.io-sdk-ios
===============

baas.io SDK for iOS


## Install

```
# git clone git://github.com/baasio/baas.io-sdk-ios.git
# cd baas.io-sdk-ios
# ./submodule_setup.sh
```

## Usage
See [this](https://github.com/baasio/baas.io-sdk-ios/wiki/Getting-Started#Install).

## How To Get Started
* [Download SDK](https://github.com/baasio/baas.io-sdk-ios/archive/master.zip)
* Read Document
 * [SDK Guide](https://github.com/baasio/baas.io-sdk-ios/wiki/SDK-Guide)
 * [Getting Started](https://github.com/baasio/baas.io-sdk-ios/wiki/Getting-Started)
 * [SDK Reference](https://baas.io/docs/ko/ios/reference/)


## Release history

### v0.8.1.8
* iOS 64bit 지원
* submodule jsonkit 제거

### v0.8.1.7
* Push 예약 발송시 예약 되지 않던 문제

### v0.8.1.6
* Query prev, next 호출 시 NSError 처리가 안되는 문제
* 첫 페이지 호출 시 cursor 가 clean 되지 않았던 현상
* 10개 이하 Entitis에서 앱 죽는 문제

### v0.8.1.5
* Query prev, next 호출 시 NSError 처리가 안되는 문제
* Push User 발송 시 앱 죽는 문제

### v0.8.1.4
* SimpleNetworkManager 버그 수정


### v0.8.1.3
* BAAS-43 Push SDK 사용성 개선
* BAAS-58 회원 가입 시 추가 정보를 넣을 수 있게 함
* BAAS-59 추가적인 library 없이도 network api를 쓸 수 있는 기능을 제공
* BAAS-60 UIImageView에 비동기 이미지 로딩 기능 제공

* BAAS-61 에러코드 재 정리
* BAAS-376 디버그 모드 추가
* BAAS-64 최신 버젼이 릴리즈 되면 자동으로 알림
* BAAS-377 Push on/off 기능 구현

* 기타
 * 커서 관련 함수명 변경
 * 버그 수정
 * 암호 변경/리셋 기능 구현


### v0.8.1.1
* User Token 관련 에러 처리

### v0.8.1
* 라이브러리 Header 파일 업데이트

## License
This is available under the MIT license. See the LICENSE file for more info.

Namely, It's totally free. :)
