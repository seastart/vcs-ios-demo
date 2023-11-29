//
//  VCSDrawingWidget.h
//  Draw
//
//  Created by seastart on 2020/7/31.
//  Copyright © 2020 seastart. All rights reserved.
//

#import "VCSDrawingBoard.h"
#import "VCSDrawDataModel.h"
#import "VCSEwbClient.h"
#import "VCSDrawNetwork.h"

NS_ASSUME_NONNULL_BEGIN

/// 画板事件回调
typedef void(^VCSDrawingWidgetEventBlock)(CGPoint point, EWBDrawType event);

@interface VCSDrawingWidget : VCSDrawingBoard
{
    // 本地适量数据生成器
    drawing::PainterPathModel drawDataModel;
}

// 数据模型
- (drawing::PainterPathModel&)getDataModel;

// 绘制网络数据包
- (void)onPacket:(NSData*)data command:(short)command;

#pragma mark - 画板事件回调
/// 画板事件回调
@property (copy, nonatomic) VCSDrawingWidgetEventBlock eventBlock;

/// 画板事件回调
/// @param eventBlock 画板事件回调
- (void)eventBlock:(VCSDrawingWidgetEventBlock)eventBlock;

@end

NS_ASSUME_NONNULL_END
