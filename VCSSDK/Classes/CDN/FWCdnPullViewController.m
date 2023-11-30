//
//  FWCdnPullViewController.m
//  VCSSDK_Example
//
//  Created by SailorGa on 2023/10/10.
//  Copyright © 2023 SailorGa. All rights reserved.
//

#import "FWCdnPullViewController.h"
#import <VCSSDK/VCSSDK.h>

@interface FWCdnPullViewController () <VCSWebRTCManagerDelegate>

/// 播放器父组件
@property (weak, nonatomic) IBOutlet UIView *remoteVideoView0;
@property (weak, nonatomic) IBOutlet UIView *remoteVideoView1;
/// 播放器窗口
@property (nonatomic, strong) RTYUVPlayer *playerView0;
@property (nonatomic, strong) RTYUVPlayer *playerView1;

/// 音频开关按钮
@property (weak, nonatomic) IBOutlet UIButton *enabledAudioButton;
/// 订阅远端流按钮
@property (weak, nonatomic) IBOutlet UIButton *subscribeStreamButton;
/// 取消订阅远端流按钮
@property (weak, nonatomic) IBOutlet UIButton *unSubscribeStreamButton;

/// 订阅远端流计数
@property (assign, nonatomic) NSInteger count;

@end

@implementation FWCdnPullViewController

#pragma mark - 懒加载播放器实例
- (RTYUVPlayer *)playerView0 {
    
    if (!_playerView0) {
        _playerView0 = [[RTYUVPlayer alloc] initWithFrame:self.remoteVideoView0.bounds];
        _playerView0.backgroundColor = RGBOF(0x696969);
    }
    return _playerView0;
}

#pragma mark - 懒加载播放器实例
- (RTYUVPlayer *)playerView1 {
    
    if (!_playerView1) {
        _playerView1 = [[RTYUVPlayer alloc] initWithFrame:self.remoteVideoView1.bounds];
        _playerView1.backgroundColor = RGBOF(0x696969);
    }
    return _playerView1;
}

#pragma mark - 页面加载
- (void)viewDidLoad {
    
    [super viewDidLoad];
    /// 初始化UI
    [self buildView];
}

#pragma mark - 页面重新绘制
- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    /// 重置播放器实例布局
    self.playerView0.frame = self.remoteVideoView0.bounds;
    self.playerView1.frame = self.remoteVideoView1.bounds;
    /// 不全屏显示需要计算坐标位置
    [self.playerView0 SetLayoutReset:YES];
    [self.playerView1 SetLayoutReset:YES];
}

#pragma mark - 初始化UI
- (void)buildView {
    
    /// 设置标题
    self.navigationItem.title = NSLocalizedString(@"CDN 拉流", nil);
    /// 加载播放器窗口
    [self.remoteVideoView0 addSubview:self.playerView0];
    [self.remoteVideoView1 addSubview:self.playerView1];
    /// 重置计数
    self.count = -1;
    /// 绑定动态响应信号
    [self bindSignal];
    /// 初始化CDN拉流
    [self initializeWebRTC];
}

#pragma mark - 绑定信号
- (void)bindSignal {
    
    @weakify(self);
    
    /// 绑定音频开关按钮事件
    [[self.enabledAudioButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        /// 声明按钮选中状态
        BOOL selected = !self.enabledAudioButton.selected;
        /// 变更按钮选中状态
        self.enabledAudioButton.selected = selected;
        /// 设置音频是否播放
        [[VCSWebRTCManager sharedManager] enabledAudio:!selected];
    }];
    
    /// 绑定订阅远端流按钮事件
    [[self.subscribeStreamButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        /// 订阅远端流操作
        [self onSubscribeStream];
    }];
    
    /// 绑定取消订阅远端流按钮事件
    [[self.unSubscribeStreamButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        /// 订阅远端流操作
        [self onUnSubscribeStream];
    }];
}

#pragma mark - 初始化CDN拉流
- (void)initializeWebRTC {
    
    /// 创建入会参数
    VCSMeetingParam *meetingParam = [[VCSMeetingParam alloc] init];
    /// 设置服务地址
    meetingParam.domain = @"https://ws-webrtc-pull-dev.srtc.live";
    /// 加入房间
    [[VCSWebRTCManager sharedManager] enterRoomWithMeetingParam:meetingParam roomNo:@"50505050" delegate:self];
}

#pragma mark - 订阅远端流操作
- (void)onSubscribeStream {
    
    if (self.count >= 1) {
        /// 限制最大订阅两路远端流到窗口
        return;
    }
    /// 累计计数
    self.count++;
    
    /// 声明用户标识
    NSString *userId = @"video0";
    /// 根据计数确认用户标识以及渲染窗口
    if (self.count == 0) {
        userId = @"video0";
    } else if (self.count == 1) {
        userId = @"video1";
    }
    /// 订阅远端用户的视频流
    [[VCSWebRTCManager sharedManager] subscribeRemoteVideo:userId trackId:0 subscribe:YES];
}

#pragma mark - 取消订阅远端流操作
- (void)onUnSubscribeStream {
    
    if (self.count <= -1) {
        /// 限制最大订阅两路远端流到窗口
        return;
    }
    
    /// 声明用户标识
    NSString *userId = @"video0";
    /// 根据计数确认用户标识
    if (self.count == 1) {
        userId = @"video1";
    } else if (self.count == 0) {
        userId = @"video0";
    }
    /// 订阅远端用户的视频流
    [[VCSWebRTCManager sharedManager] subscribeRemoteVideo:userId trackId:0 subscribe:NO];
    
    /// 累减计数
    self.count--;
}

#pragma mark - ------- VCSWebRTCManagerDelegate代理实现 -------
#pragma mark 远端视频数据回调
/// 远端视频数据回调
/// - Parameters:
///   - userId: 用户标识
///   - trackId: 轨道号
///   - type: 视频存储格式(0 - I420 , 1 - NV12, 2 - NV21)
///   - rotation: 视频方向
///   - width: 视频宽度
///   - height: 视频高度
///   - yData: 像素数据
///   - uData: 像素数据
///   - vData: 像素数据
- (void)roomRemoteStreamWithUserId:(NSString *)userId trackId:(int)trackId type:(int)type rotation:(RTCVideoRotation)rotation width:(int)width height:(int)height yData:(void *)yData uData:(void *)uData vData:(void *)vData {
    
    /// 将视频数据送入渲染器
    if ([userId isEqualToString:@"video0"]) {
        [self.playerView0 displayYUVData:trackId type:type lable:VIDEO_CAMERA_0 width:width height:height yData:yData uData:uData vData:vData];
    } else if ([userId isEqualToString:@"video1"]) {
        [self.playerView1 displayYUVData:trackId type:type lable:VIDEO_CAMERA_0 width:width height:height yData:yData uData:uData vData:vData];
    }
    /// 释放数据
    if (yData) {
        free(yData);
    }
    if (uData){
        free(uData);
    }
    if (vData) {
        free(vData);
    }
}

#pragma mark - 资源释放
- (void)dealloc {
    
    /// 离开房间
    [[VCSWebRTCManager sharedManager] exitRoom];
    /// 日志输出
    SGLOG(@"释放资源：%@", kStringFromClass(self));
}

@end
