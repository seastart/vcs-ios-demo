//
//  FWLoginViewModel.m
//  VCSSDK_Example
//
//  Created by SailorGa on 2020/4/28.
//  Copyright © 2020 SailorGa. All rights reserved.
//

#import "FWLoginViewModel.h"
#import "FWAppDelegate.h"
#import <VCSSDK/VCSSDK.h>
#import <VCSSDK/VCSLogin.h>

@interface FWLoginViewModel()

@end

@implementation FWLoginViewModel

#pragma mark - 初始化ViewModel
- (instancetype)init {
    
    if (self = [super init]) {
        _loginSubject = [RACSubject subject];
        _loginModel = [[FWLoginModel alloc] init];
        _loading = NO;
    }
    return self;
}

#pragma mark - 登录
/// 登录
/// @param state 用户操作类型
- (void)commitLoginWithState:(FWUserOperateState)state {
    
    if (kStringIsEmpty(self.accountText)) {
        self.promptText = @"请输入账号";
        return;
    }
    if (kStringIsEmpty(self.passwordText)) {
        self.promptText = @"请输入密码";
        return;
    }
    self.loading = YES;
    self.promptText = @"登录中...";
    
    /// 创建配置参数
    VCSLoginConfig *loginConfig = [[VCSLoginConfig alloc] init];
    /// 服务器地址
    loginConfig.domainUrl = [kSGUserDefaults objectForKey:DATADEFAULTAPIKEY];
    /// AppID
    loginConfig.appId = VCSSDKAPPID;
    /// AppKey
    loginConfig.appKey = VCSSDKAPPKEY;
    /// 账号登录
    loginConfig.isTourist = NO;
    /// 登录账号
    loginConfig.loginname = self.accountText;
    /// 登录密码
    loginConfig.password = self.passwordText;
    /// 通过配置初始化组件
    [[VCSMeetingManager sharedManager] initializeWithConfig:loginConfig resultBlock:^(BOOL result, id  _Nullable data, NSString * _Nullable errorMsg) {
        self.loading = NO;
        if (result && data) {
            self.promptText = @"登录成功";
            /// 转换成登录数据模型
            self.loginModel = [[FWLoginModel alloc] initWithDictionary:data];
            /// 设置userToken
            [[FWNetworkBridge sharedManager] setUserToken:self.loginModel.data.token];
            /// 登录VCSSDK
            [[VCSLoginManager sharedManager] login:self.loginModel.data.token meetingHost:self.loginModel.data.reg.mqtt_address meetingPort:self.loginModel.data.reg.mqtt_port serverId:self.loginModel.data.reg.server_id timeoutInterval:20 resultBlock:^(NSError * _Nullable error) {
                [self.loginSubject sendNext:@(state)];
            }];
        } else {
            self.promptText = errorMsg;
        }
    }];
}

@end
