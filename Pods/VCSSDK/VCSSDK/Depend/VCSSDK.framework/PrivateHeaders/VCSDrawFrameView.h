//
//  VCSDrawFrameView.h
//  Draw
//
//  Created by seastart on 2020/7/31.
//  Copyright © 2020 seastart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VCSDrawingWidget.h"
#import "VCSCommons.h"

NS_ASSUME_NONNULL_BEGIN

/// 超时状态回调(连接状态)
typedef void(^VCSDrawFrameViewTimeoutBlock)(VCSDrawConnectState state);

/// 画板事件回调
typedef void(^VCSDrawFrameViewEventBlock)(CGPoint point, EWBDrawType event);

/// 重置画布宽高比例回调
typedef void(^VCSDrawFrameViewResetBlock)(NSString * __nullable imageUrl);

@interface VCSDrawFrameView : UIView

#pragma mark - 超时状态回调(连接状态)
/// 超时状态回调(连接状态)
@property (copy, nonatomic) VCSDrawFrameViewTimeoutBlock timeoutBlock;

/// 超时状态回调(连接状态)
/// @param timeoutBlock 超时状态回调(连接状态)
- (void)timeoutBlock:(VCSDrawFrameViewTimeoutBlock)timeoutBlock;

#pragma mark - 画板事件回调
/// 画板事件回调
@property (copy, nonatomic) VCSDrawingWidgetEventBlock eventBlock;

/// 画板事件回调
/// @param eventBlock 画板事件回调
- (void)eventBlock:(VCSDrawingWidgetEventBlock)eventBlock;

#pragma mark - 重置画布宽高比例回调
/// 重置画布宽高比例回调
@property (copy, nonatomic) VCSDrawFrameViewResetBlock resetBlock;

/// 重置画布宽高比例回调
/// @param resetBlock 重置画布宽高比例回调
- (void)resetBlock:(VCSDrawFrameViewResetBlock)resetBlock;

@property (nonatomic, strong) UIImageView* backImageView;
@property (nonatomic, strong) VCSDrawingWidget* contentView;

- (drawing::PainterPathModel&)getDataModel;

// 连接服务器
- (void)connect:(OpenModel&)model;

/// 更换本地画布宽高比例
/// @param ratio 宽高比例
- (void)changeLocalDrawBackWithRatio:(float)ratio;

/// 更换服务端画布宽高比例
/// @param ratio 宽高比例
/// @param imageUrl 图片地址
- (void)changeServeDrawWithRatio:(float)ratio imageUrl:(nullable NSString *)imageUrl;

/// 清空本地画布
- (void)clearLocalContent;

// 清除
- (void)clear;

@end

NS_ASSUME_NONNULL_END
