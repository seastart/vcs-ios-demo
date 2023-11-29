//
//  FWRegisterViewModel.m
//  VCSSDK_Example
//
//  Created by SailorGa on 2020/4/28.
//  Copyright © 2020 SailorGa. All rights reserved.
//

#import "FWRegisterViewModel.h"

@interface FWRegisterViewModel()

@end

@implementation FWRegisterViewModel

#pragma mark - 初始化ViewModel
- (instancetype)init {
    
    if (self = [super init]) {
        _registerSubject = [RACSubject subject];
        _resetCodeSubject = [RACSubject subject];
        _loading = NO;
    }
    return self;
}

#pragma mark - 获取验证码
- (void)getMobileCode {
    
    if (kStringIsEmpty(self.mobileText)) {
        self.promptText = @"请输入手机号码";
        return;
    }
    self.loading = YES;
    self.promptText = @"正在发送验证码...";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@(self.state) forKey:@"used_for"];
    [params setValue:self.mobileText forKey:@"mobile"];
    [params setValue:self.mobileText forKey:@"account_name"];
    [[FWNetworkBridge sharedManager] POST:FWUserCodeInfofacePart params:params className:@"FWBaseModel" result:^(BOOL isSuccess, id _Nullable result, NSString * _Nullable errorMsg) {
        self.loading = NO;
        if (isSuccess && result) {
            self.promptText = @"验证码发送成功,请注意查收";
            [self.mobileCodeSubject sendNext:nil];
        } else {
            self.promptText = errorMsg;
        }
    }];
}

#pragma mark - 提交按钮处理
- (void)submitClick {
    
    if (self.state == FWUserCodeStateRegister) {
        /// 注册账号
        [self registerAccount];
    } else {
        /// 重置密码
        [self resetPassword];
    }
}

#pragma mark - 注册账号
- (void)registerAccount {
    
    if (kStringIsEmpty(self.mobileText)) {
        self.promptText = @"请输入手机号码";
        return;
    }
    if (kStringIsEmpty(self.codeText)) {
        self.promptText = @"请输入短信验证码";
        return;
    }
    if (kStringIsEmpty(self.passwordText)) {
        self.promptText = @"请输入密码";
        return;
    }
    self.loading = YES;
    self.promptText = @"正在注册账号...";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.mobileText forKey:@"name"];
    [params setValue:self.mobileText forKey:@"mobile"];
    [params setValue:self.mobileText forKey:@"nickname"];
    [params setValue:self.codeText forKey:@"vcode"];
    [params setValue:[[FWToolHelper sharedManager] HmacSha1:HmacSha1Key data:[NSString stringWithFormat:@"%@%@",self.mobileText, self.passwordText]] forKey:@"password"];
    [params setValue:@(3) forKey:@"dev_type"];
    [params setValue:DeviceUUID forKey:@"device_id"];
    [[FWNetworkBridge sharedManager] POST:FWUserRegisterInfofacePart params:params className:@"FWLoginModel" result:^(BOOL isSuccess, id _Nullable result, NSString * _Nullable errorMsg) {
        self.loading = NO;
        if (isSuccess && result) {
            self.promptText = @"注册成功";
            self.loginModel = (FWLoginModel *)result;
            [self.registerSubject sendNext:nil];
        } else {
            self.promptText = errorMsg;
        }
    }];
}

#pragma mark - 重置密码
- (void)resetPassword {
    
    if (kStringIsEmpty(self.mobileText)) {
        self.promptText = @"请输入手机号码";
        return;
    }
    if (kStringIsEmpty(self.codeText)) {
        self.promptText = @"请输入短信验证码";
        return;
    }
    if (kStringIsEmpty(self.passwordText)) {
        self.promptText = @"请输入密码";
        return;
    }
    self.loading = YES;
    self.promptText = @"正在重置密码...";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.mobileText forKey:@"name"];
    [params setValue:self.codeText forKey:@"vcode"];
    [params setValue:[[FWToolHelper sharedManager] HmacSha1:HmacSha1Key data:[NSString stringWithFormat:@"%@%@",self.mobileText, self.passwordText]] forKey:@"new_password"];
    [[FWNetworkBridge sharedManager] POST:FWUserResetPasswordInfofacePart params:params className:@"FWBaseModel" result:^(BOOL isSuccess, id  _Nullable result, NSString * _Nullable errorMsg) {
        self.loading = NO;
        if (isSuccess && result) {
            self.promptText = @"重置密码成功";
            [self.resetCodeSubject sendNext:nil];
        } else {
            self.promptText = errorMsg;
        }
    }];
}

@end
