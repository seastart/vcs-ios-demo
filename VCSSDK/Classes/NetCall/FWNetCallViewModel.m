//
//  FWNetCallViewModel.m
//  VCSSDK_Example
//
//  Created by SailorGa on 2020/8/24.
//  Copyright © 2020 SailorGa. All rights reserved.
//

#import "FWNetCallViewModel.h"

@interface FWNetCallViewModel()

@end

@implementation FWNetCallViewModel

#pragma mark - 初始化ViewModel

- (instancetype)init {
    
    if (self = [super init]) {
        _loading = NO;
    }
    return self;
}

@end
