//
//  FWDrawingConfigViewModel.h
//  VCSSDK_Example
//
//  Created by SailorGa on 2020/8/4.
//  Copyright © 2020 SailorGa. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FWDrawingConfigViewModel : NSObject

/// 关联Class
@property (nonatomic, assign) Class viewClass;
/// 是否在加载状态
@property (nonatomic, assign) BOOL loading;
/// 共享类型
@property (nonatomic, assign) FWShareState state;

/// 电子白板服务器地址
@property (copy, nonatomic) NSString *addressText;
/// 电子白板服务器端口
@property (copy, nonatomic) NSString *portText;
/// 房间ID
@property (copy, nonatomic) NSString *roomText;
/// 用户ID
@property (copy, nonatomic) NSString *userText;
/// 提示
@property (copy, nonatomic) NSString *promptText;

/// 开启电子白板成功
@property (nonatomic, strong, readonly) RACSubject *drawingSubject;

/// 开启电子白板事件
/// @param state 共享类型
- (void)openDrawingClick:(FWShareState)state;

@end

NS_ASSUME_NONNULL_END
