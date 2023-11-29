//
//  FWDrawingConfigViewModel.m
//  VCSSDK_Example
//
//  Created by SailorGa on 2020/8/4.
//  Copyright © 2020 SailorGa. All rights reserved.
//

#import "FWDrawingConfigViewModel.h"

@interface FWDrawingConfigViewModel()

@end

@implementation FWDrawingConfigViewModel

#pragma mark - 初始化ViewModel
- (instancetype)init {
    
    if (self = [super init]) {
        _loading = NO;
        _drawingSubject = [RACSubject subject];
    }
    return self;
}

#pragma mark - 开启电子白板事件
/// 开启电子白板事件
/// @param state 共享类型
- (void)openDrawingClick:(FWShareState)state {
    
    if (kStringIsEmpty(self.addressText)) {
        self.promptText = @"请输入服务地址";
        return;
    }
    if (kStringIsEmpty(self.portText)) {
        self.promptText = @"请输入服务端口";
        return;
    }
    if (kStringIsEmpty(self.roomText)) {
        self.promptText = @"请输入房间ID";
        return;
    }
    if (kStringIsEmpty(self.userText)) {
        self.promptText = @"请输入用户ID";
        return;
    }
    self.promptText = @"开启白板成功";
    self.state = state;
    [self.drawingSubject sendNext:nil];
}

@end
