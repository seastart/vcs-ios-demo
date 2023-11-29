//
//  FWKeychain.h
//  VCSSDK_Example
//
//  Created by SailorGa on 2023/11/29.
//  Copyright © 2023 SailorGa. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - VCSSDK Appid
FOUNDATION_EXTERN NSString *__nonnull const VCSSDKAPPID;
#pragma mark - VCSSDK AppKey
FOUNDATION_EXTERN NSString *__nonnull const VCSSDKAPPKEY;
#pragma mark - VCSSDK Signature
FOUNDATION_EXTERN NSString *__nonnull const VCSSDKSIGNATURE;

@interface FWKeychain : NSObject

@end

NS_ASSUME_NONNULL_END
