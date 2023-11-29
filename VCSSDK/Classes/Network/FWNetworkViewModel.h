//
//  FWNetworkViewModel.h
//  VCSSDK_Example
//
//  Created by SailorGa on 2021/11/1.
//  Copyright © 2021 SailorGa. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FWNetworkViewModel : NSObject

/// 关联Class
@property (nonatomic, assign) Class viewClass;
/// 是否在加载状态
@property (nonatomic, assign) BOOL loading;

/// 服务地址
@property (copy, nonatomic) NSString *streamHostText;
/// 服务端口
@property (copy, nonatomic) NSString *streamPortText;
/// 用户编号
@property (copy, nonatomic) NSString *streamIdText;
/// 上行码率
@property (copy, nonatomic) NSString *upSpeedText;
/// 下行码率
@property (copy, nonatomic) NSString *downSpeedText;
/// 测试时间
@property (copy, nonatomic) NSString *timeText;
/// 提示信息
@property (copy, nonatomic) NSString *promptText;

/// 网络检测订阅
@property (nonatomic, strong, readonly) RACSubject *detectionSubject;

#pragma mark - 开启网络检测
/// 开启网络检测
- (void)startNetworkDetection;

@end

NS_ASSUME_NONNULL_END
