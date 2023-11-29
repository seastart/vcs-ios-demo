//
//  FWServeConfigViewModel.h
//  VCSSDK_Example
//
//  Created by SailorGa on 2020/4/29.
//  Copyright © 2020 SailorGa. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FWServeConfigViewModel : NSObject

/// 关联Class
@property (nonatomic, assign) Class viewClass;
/// 是否在加载状态
@property (nonatomic, assign) BOOL loading;

/// 提示
@property (copy, nonatomic) NSString *promptText;
/// 服务器地址
@property (copy, nonatomic) NSString *serveAddrText;

/// 保存服务器地址请求订阅
@property (nonatomic, strong, readonly) RACSubject *saveServeAddrSubject;

/// 保存服务器地址
- (void)saveServeAddr;

@end

NS_ASSUME_NONNULL_END
