//
//  FWCastingViewModel.h
//  VCSSDK_Example
//
//  Created by SailorGa on 2023/5/23.
//  Copyright © 2023 SailorGa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <VCSSDK/VCSCastingManager.h>

NS_ASSUME_NONNULL_BEGIN

@interface FWCastingViewModel : NSObject

/// 关联Class
@property (nonatomic, assign) Class viewClass;
/// 是否在加载状态
@property (nonatomic, assign) BOOL loading;

/// 投屏地址
@property (copy, nonatomic) NSString *domainText;
/// 用户名称
@property (copy, nonatomic) NSString *usernameText;
/// 音频启用状态
@property (assign, nonatomic) BOOL enableAudio;

/// 提示框订阅
@property (nonatomic, strong, readonly) RACSubject *toastSubject;
/// 构建订阅
@property (nonatomic, strong, readonly) RACSubject *buildSubject;

/// 构建投屏配置
- (void)buildMediaConfig;

@end

NS_ASSUME_NONNULL_END
