//
//  FWServeConfigViewModel.m
//  VCSSDK_Example
//
//  Created by SailorGa on 2020/4/29.
//  Copyright © 2020 SailorGa. All rights reserved.
//

#import "FWServeConfigViewModel.h"

@interface FWServeConfigViewModel()

@end

@implementation FWServeConfigViewModel

#pragma mark - 初始化ViewModel
- (instancetype)init {
    
    if (self = [super init]) {
        _saveServeAddrSubject = [RACSubject subject];
        _loading = NO;
    }
    return self;
}

#pragma mark - 保存服务器地址
- (void)saveServeAddr {
    
    if (kStringIsEmpty(self.serveAddrText)) {
        self.promptText = @"服务器地址不能为空";
        return;
    }
    /// 存储当前服务器地址
    [kSGUserDefaults setObject:self.serveAddrText forKey:DATADEFAULTAPIKEY];
    self.promptText = @"服务器地址保存成功";
    [self.saveServeAddrSubject sendNext:nil];
}

@end
