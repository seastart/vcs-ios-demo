//
//  FWCastingViewModel.m
//  VCSSDK_Example
//
//  Created by SailorGa on 2023/5/23.
//  Copyright © 2023 SailorGa. All rights reserved.
//

#import "FWCastingViewModel.h"

@interface FWCastingViewModel()

@end

@implementation FWCastingViewModel

#pragma mark - 初始化ViewModel
- (instancetype)init {
    
    if (self = [super init]) {
        _toastSubject = [RACSubject subject];
        _buildSubject = [RACSubject subject];
        _domainText = @"192.168.7.245";
        _usernameText = DeviceName;
        _enableAudio = YES;
        _loading = NO;
    }
    return self;
}

#pragma mark - 构建投屏配置
/// 构建投屏配置
- (void)buildMediaConfig {
    
    if (kStringIsEmpty(self.domainText)) {
        [self.toastSubject sendNext:NSLocalizedString(@"请输入投屏地址", nil)];
        return;
    }
    
    if (kStringIsEmpty(self.usernameText)) {
        [self.toastSubject sendNext:NSLocalizedString(@"请输入用户名称", nil)];
        return;
    }
    
    /// 创建配置参数
    VCSCastingMediaConfig *mediaConfig = [[VCSCastingMediaConfig alloc] init];
    mediaConfig.domain = self.domainText;
    mediaConfig.username = self.usernameText;
    mediaConfig.enableEncrypt = YES;
    mediaConfig.enableSaveVideo = YES;
    mediaConfig.enableSaveAudio = YES;
    
    /// 回调构建完成
    [self.buildSubject sendNext:mediaConfig];
}


@end
