//
//  FWLoginViewModel.m
//  VCSSDK_Example
//
//  Created by SailorGa on 2020/4/28.
//  Copyright © 2020 SailorGa. All rights reserved.
//

#import "FWLoginViewModel.h"
#import "FWAppDelegate.h"
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
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.accountText forKey:@"loginname"];
    [params setValue:[[FWToolHelper sharedManager] HmacSha1:HmacSha1Key data:[NSString stringWithFormat:@"%@%@",self.accountText, self.passwordText]] forKey:@"password"];
    [params setValue:@(3) forKey:@"dev_type"];
    [params setValue:DeviceUUID forKey:@"device_id"];
    [[FWNetworkBridge sharedManager] POST:FWUserLoginInterfacePart params:params className:@"FWLoginModel" result:^(BOOL isSuccess, id _Nullable result, NSString * _Nullable errorMsg) {
        self.loading = NO;
        if (isSuccess && result) {
            self.promptText = @"登录成功";
            self.loginModel = (FWLoginModel *)result;
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
