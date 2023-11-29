//
//  FWCameraView.h
//  VCSSDK_Example
//
//  Created by SailorGa on 2020/5/17.
//  Copyright © 2020 SailorGa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <VCSSDK/VCSSDK.h>

NS_ASSUME_NONNULL_BEGIN

@interface FWCameraView : UIView

/// 本地采集预览窗口
@property (nonatomic, strong) RTYUVPlayer *player;

#pragma mark - 我的视频发生变化处理
/// 我的视频发生变化处理
/// @param videoState 视频状态
- (void)stepVideoState:(BOOL)videoState;

#pragma mark - 我的音频发生变化处理
/// 我的音频发生变化处理
/// @param audioState 音频状态
- (void)stepAudioState:(BOOL)audioState;

#pragma mark 设置当前音频分贝
/// 设置当前音频分贝
/// @param volume 分贝值
- (void)playAudioWithVolume:(float)volume;

#pragma mark 播放画面缩放
/// 播放画面缩放
/// @param scale 缩放比例
- (void)playerViewZoomWithScale:(float)scale;

#pragma mark - 播放画面直接缩放
/// 播放画面直接缩放
/// @param point 位置坐标
- (void)playerViewDirectZoom;

#pragma mark 播放画面拖动
/// 播放画面拖动
/// @param offsetX X轴坐标系的偏移值
/// @param offsetY Y轴坐标系的偏移值
- (void)playerViewMoveWithOffsetX:(float)offsetX offsetY:(float)offsetY;

@end

NS_ASSUME_NONNULL_END
