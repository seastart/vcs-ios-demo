//
//  FWNetworkViewModel.m
//  VCSSDK_Example
//
//  Created by SailorGa on 2021/11/1.
//  Copyright © 2021 SailorGa. All rights reserved.
//

#import "FWNetworkViewModel.h"

@interface FWNetworkViewModel()

@end

@implementation FWNetworkViewModel

#pragma mark - 初始化ViewModel
- (instancetype)init {
    
    if (self = [super init]) {
        _detectionSubject = [RACSubject subject];
        _loading = NO;
        
        _streamHostText = @"103.78.228.91";
        _streamPortText = @"8006";
        
        _streamIdText = @"12340001";
        
        _upSpeedText = @"2000";
        _downSpeedText = @"2000";
        _timeText = @"30";
        
        _promptText = @"提示信息";
    }
    return self;
}

#pragma mark - 开启网络检测
/// 开启网络检测
- (void)startNetworkDetection {
    
    if (kStringIsEmpty(self.streamHostText)) {
        self.promptText = @"请输入服务地址";
        return;
    }
    if (kStringIsEmpty(self.streamPortText)) {
        self.promptText = @"请输入服务端口";
        return;
    }
    if (kStringIsEmpty(self.streamIdText)) {
        self.promptText = @"请输入用户编号";
        return;
    }
    if (kStringIsEmpty(self.upSpeedText)) {
        self.promptText = @"请输入上行码率";
        return;
    }
    if (kStringIsEmpty(self.downSpeedText)) {
        self.promptText = @"请输入下行码率";
        return;
    }
    if (kStringIsEmpty(self.timeText)) {
        self.promptText = @"请输入测试时间";
        return;
    }
    [self.detectionSubject sendNext:nil];
}

@end
