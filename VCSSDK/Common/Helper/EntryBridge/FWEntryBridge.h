//
//  FWEntryBridge.h
//  VCSSDK_Example
//
//  Created by SailorGa on 2025/8/25.
//  Copyright © 2025 SailorGa. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FWEntryBridge : NSObject

/// 初始化方法
+ (FWEntryBridge *)sharedManager;

/// 获取当前窗口
- (UIWindow *)getCurrentWindow;

/// 部分基础设置
- (void)setupDefault;

/// 设置窗口根视图
- (void)setWindowRootView;

@end

NS_ASSUME_NONNULL_END
