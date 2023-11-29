//
//  FWNetCallViewModel.h
//  VCSSDK_Example
//
//  Created by SailorGa on 2020/8/24.
//  Copyright © 2020 SailorGa. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FWNetCallViewModel : NSObject

/// 关联Class
@property (nonatomic, assign) Class viewClass;
/// 是否在加载状态
@property (nonatomic, assign) BOOL loading;

/// 房间ID
@property (copy, nonatomic) NSString *roomText;
/// 用户ID
@property (copy, nonatomic) NSString *userText;
/// 提示
@property (copy, nonatomic) NSString *promptText;

@end

NS_ASSUME_NONNULL_END
