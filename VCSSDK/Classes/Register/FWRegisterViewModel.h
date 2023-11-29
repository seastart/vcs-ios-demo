//
//  FWRegisterViewModel.h
//  VCSSDK_Example
//
//  Created by SailorGa on 2020/4/28.
//  Copyright © 2020 SailorGa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FWLoginModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FWRegisterViewModel : NSObject

/// 关联Class
@property (nonatomic, assign) Class viewClass;
/// 是否在加载状态
@property (nonatomic, assign) BOOL loading;
/// 模块类型(注册/重置密码)
@property (nonatomic, assign) FWUserCodeState state;

/// 手机号码
@property (copy, nonatomic) NSString *mobileText;
/// 验证码
@property (copy, nonatomic) NSString *codeText;
/// 密码
@property (copy, nonatomic) NSString *passwordText;

/// 提示
@property (copy, nonatomic) NSString *promptText;

/// 获取验证码请求订阅
@property (nonatomic, strong, readonly) RACSubject *mobileCodeSubject;
/// 注册请求订阅
@property (nonatomic, strong, readonly) RACSubject *registerSubject;
/// 重置密码请求订阅
@property (nonatomic, strong, readonly) RACSubject *resetCodeSubject;

/// 注册返回的登录信息
@property (nonatomic, strong) FWLoginModel *loginModel;

/// 获取验证码
- (void)getMobileCode;

/// 提交按钮处理
- (void)submitClick;

@end

NS_ASSUME_NONNULL_END
