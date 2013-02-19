//
//  UIImageView+Baasio.m
//  baas.io-ios-sdk
//
//  Created by cetauri on 13. 2. 19..
//  Copyright (c) 2013년 kth. All rights reserved.
//

#import "UIImageView+Baasio.h"
#import "UIImageView+AFNetworking.h"
@implementation UIImageView (Baasio)
- (void)imageWithURL:(NSURL *)url{
    [self setImageWithURL:url];
}

- (void)imageWithURL:(NSURL *)url
       placeholderImage:(UIImage *)placeholderImage{
    [self setImageWithURL:url
         placeholderImage:placeholderImage];
}

- (void)imageWithURLRequest:(NSURLRequest *)urlRequest
              placeholderImage:(UIImage *)placeholderImage
                       success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image))success
                       failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error))failure{
    [self setImageWithURLRequest:urlRequest
                placeholderImage:placeholderImage
                         success:success
                         failure:failure];
}

- (void)cancelImageRequest{
    [self cancelImageRequestOperation];
}

@end
