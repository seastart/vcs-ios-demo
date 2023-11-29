//
//  FWCameraView.m
//  VCSSDK_Example
//
//  Created by SailorGa on 2020/5/17.
//  Copyright © 2020 SailorGa. All rights reserved.
//

#import "FWCameraView.h"

@interface FWCameraView()

/// 内容
@property (strong, nonatomic) UIView *contentView;
/// 视频关闭显示
@property (weak, nonatomic) IBOutlet UIImageView *videoImageView;
/// 视频关闭提示
@property (weak, nonatomic) IBOutlet UILabel *videoCloseLabel;
/// 音频状态显示
@property (weak, nonatomic) IBOutlet UIImageView *audioImageView;
/// 音量柱
@property (weak, nonatomic) IBOutlet UIProgressView *audioProgressView;

@end

@implementation FWCameraView

#pragma mark - 初始化方法
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil].firstObject;
        self.contentView.frame = self.bounds;
        [self addSubview:self.contentView];
        /// 配置属性
        [self stepConfig];
    }
    return self;
}

#pragma mark - 懒加载实例播放
- (RTYUVPlayer *)player {
    
    if (!_player) {
        _player = [[RTYUVPlayer alloc] initWithFrame:self.bounds];
        _player.backgroundColor = [UIColor clearColor];
        [_player openViewZoomAndMove:YES];
    }
    return _player;
}

#pragma mark - 页面重新绘制
- (void)layoutSubviews {
    
    [super layoutSubviews];
    /// 设置播放组件frame
    self.player.frame = self.bounds;
    /// 不全屏显示需要计算坐标位置
    [self.player SetLayoutReset:YES];
}

#pragma mark - 配置属性
- (void)stepConfig {
    
    /// 加载预览播放器
    [self insertSubview:self.player atIndex:0];
}

#pragma mark - 我的视频发生变化处理
/// 我的视频发生变化处理
/// @param videoState 视频状态
- (void)stepVideoState:(BOOL)videoState {
    
    self.videoImageView.hidden = self.videoCloseLabel.hidden = videoState;
}

#pragma mark - 我的音频发生变化处理
/// 我的音频发生变化处理
/// @param audioState 音频状态
- (void)stepAudioState:(BOOL)audioState {
    
    self.audioImageView.hidden = audioState;
}

#pragma mark 设置当前音频分贝
/// 设置当前音频分贝
/// @param volume 分贝值
- (void)playAudioWithVolume:(float)volume {
    
    SGLOG(@"+++++++设置的分贝值为 = %f", volume);
    /// 设置音量柱数值
    [self.audioProgressView setProgress:volume animated:YES];
}

#pragma mark 播放画面缩放
/// 播放画面缩放
/// @param scale 缩放比例
- (void)playerViewZoomWithScale:(float)scale {
    
    /// 当前为共享状态(缩放视图)
    [self.player zoom:scale];
}

#pragma mark - 播放画面直接缩放
/// 播放画面直接缩放
/// @param point 位置坐标
- (void)playerViewDirectZoom {
    
    float scale = [self.player getCurrentScale];
    if (scale <= 1.0) {
        [self.player directZoom:1.5];
    } else {
        [self.player directZoom:1.0];
    }
}

#pragma mark 播放画面拖动
/// 播放画面拖动
/// @param offsetX X轴坐标系的偏移值
/// @param offsetY Y轴坐标系的偏移值
- (void)playerViewMoveWithOffsetX:(float)offsetX offsetY:(float)offsetY {
    
    /// 当前为共享状态(拖动视图)
    [self.player move:offsetX dy:offsetY];
}

#pragma mark - 释放资源
- (void)dealloc {
    
    /// 释放RTYUVPlayer资源
    [self.player ReleasePlay];
    SGLOG(@"++++++++++++释放资源：%@", kStringFromClass(self));
}

@end
