//
//  FWIPAddressBridge.h
//  VCSSDK_Example
//
//  Created by SailorGa on 2020/4/29.
//  Copyright © 2020 SailorGa. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FWIPAddressBridge : NSObject

/// 初始化方法
+ (FWIPAddressBridge *)sharedManager;

/// 获取具体的IP地址
- (NSString *)currentIpAddress;

/// 获取IP地址的详细信息
- (void)currentIPAdressDetailInfo;

@end

NS_ASSUME_NONNULL_END
