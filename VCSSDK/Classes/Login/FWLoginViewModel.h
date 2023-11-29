//
//  FWLoginViewModel.h
//  VCSSDK_Example
//
//  Created by SailorGa on 2020/4/28.
//  Copyright © 2020 SailorGa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FWLoginModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FWLoginViewModel : NSObject

/// 关联Class
@property (nonatomic, assign) Class viewClass;
/// 是否在加载状态
@property (nonatomic, assign) BOOL loading;

/// 账号
@property (copy, nonatomic) NSString *accountText;
/// 密码
@property (copy, nonatomic) NSString *passwordText;
/// 提示
@property (copy, nonatomic) NSString *promptText;

/// 登录请求订阅
@property (nonatomic, strong, readonly) RACSubject *loginSubject;

/// 登录信息
@property (nonatomic, strong) FWLoginModel *loginModel;

/// 登录
/// @param state 用户操作类型
- (void)commitLoginWithState:(FWUserOperateState)state;

@end

NS_ASSUME_NONNULL_END
