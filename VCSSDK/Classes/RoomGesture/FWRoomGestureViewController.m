//
//  FWRoomGestureViewController.m
//  VCSSDK_Example
//
//  Created by SailorGa on 2021/1/25.
//  Copyright © 2021 SailorGa. All rights reserved.
//

#import "FWRoomGestureViewController.h"

API_AVAILABLE(ios(12.0))
@interface FWRoomGestureViewController ()<VCSMeetingManagerProtocol, VCSMeetingManagerCameraProtocol>

@property (weak, nonatomic) IBOutlet RTYUVPlayer *cameraView;
@property (weak, nonatomic) IBOutlet UIView *minePlayerView;
@property (weak, nonatomic) IBOutlet UIView *otherPlayerView;
/// 开启/关闭自己的音频
@property (weak, nonatomic) IBOutlet UIButton *selfAudioSwitchButton;
/// 屏幕共享按钮
@property (weak, nonatomic) IBOutlet UIButton *screenSharedButton;
/// 退出会议室
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;
/// 云端屏幕录制窗口
@property (strong, nonatomic) RTYUVPlayer *minePlayer;
/// 其它视频流窗口
@property (strong, nonatomic) RTYUVPlayer *otherPlayer;

/// BroadcastPickerView
@property (strong, nonatomic) RPSystemBroadcastPickerView *broadcastPickerView;

/// 当前分享者帐号SDKNO
@property (assign, nonatomic) int sharingSdkno;
/// 标记会议室当前是否有共享屏幕
@property (assign, nonatomic) BOOL isSharingScreen;

/// 其他人SDKNO
@property (assign, nonatomic) int otherSdkno;

@end

@implementation FWRoomGestureViewController

- (void)viewDidLoad {

    [super viewDidLoad];
    
    /// 初始化UI
    [self buildView];
}

#pragma mark - 页面出现前
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
    /// 限制锁屏
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    /// 禁止侧滑返回功能
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

#pragma mark - 页面即将消失
- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setHidden:NO];
    /// 取消限制锁屏
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    /// 恢复侧滑返回功能
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

#pragma mark - 懒加载实例播放
- (RTYUVPlayer *)minePlayer {
    
    if (!_minePlayer) {
        _minePlayer = [[RTYUVPlayer alloc] initWithFrame:self.minePlayerView.bounds];
        [_minePlayer openViewZoomAndMove:YES];
        [_minePlayer customDisplayCtrl:YES];
    }
    return _minePlayer;
}

- (RTYUVPlayer *)otherPlayer {
    
    if (!_otherPlayer) {
        _otherPlayer = [[RTYUVPlayer alloc] initWithFrame:self.otherPlayerView.bounds];
    }
    return _otherPlayer;
}

#pragma mark - 懒加载屏幕录制
- (RPSystemBroadcastPickerView *)broadcastPickerView API_AVAILABLE(ios(12.0)) {
    
    if (!_broadcastPickerView) {
        _broadcastPickerView = [[RPSystemBroadcastPickerView alloc] init];
        _broadcastPickerView.preferredExtension = @"cn.seastart.vcsdemo.replayBroadcastUpload";
        _broadcastPickerView.showsMicrophoneButton = NO;
        _broadcastPickerView.hidden = YES;
    }
    return _broadcastPickerView;
}

#pragma mark - 初始化UI
- (void)buildView {
    
    /// 初始化SDK
    BOOL isSucceed = [[VCSMeetingManager sharedManager] initMediaSessionWithMeetingParam:self.meetingParam isNoPickAudio:NO delegate:self];
    if (isSucceed) {
        /// 设置采集窗口代理
        [VCSMeetingManager sharedManager].cameraDelegate = self;
        /// 视图添加相机采集
        [[VCSMeetingManager sharedManager] onLocalDisplayViewReady:self.cameraView];
        /// 实例播放器
        [self.minePlayerView insertSubview:self.minePlayer atIndex:0];
        [self.otherPlayerView insertSubview:self.otherPlayer atIndex:0];
    } else {
        SGLOG(@"++++++++++互动服务器连接失败可再次做重连操作");
        /// 不需要重连直接调用退出
        [self dismiss];
    }
    /// 开启录屏服务端
    [[VCSMeetingManager sharedManager] startScreenRecordWithAppGroup:VCSAPPGROUP];
    
    /// 绑定动态响应信号
    [self bindSignal];
    /// 为房间手势界面添加手势
    [self appendRecognizer];
    /// 默认设置本地预览小窗口旋转角度和镜像
    [self stepPreviewRotate];
}

#pragma mark - 绑定信号
- (void)bindSignal {
    
    @weakify(self);
    
    /// 绑定开启或关闭自己的视频按钮事件
    [[self.selfAudioSwitchButton rac_signalForControlEvents :UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        control.selected = !control.selected;
        if (control.selected) {
            /// 不发送自己的视频
            [[VCSMeetingManager sharedManager] enableSendVideo:DeviceState_DsClosed];
            [FWToastBridge showToastAction:NSLocalizedString(@"已关闭视频", nil)];
        } else {
            /// 发送自己的音频
            [[VCSMeetingManager sharedManager] enableSendVideo:DeviceState_DsActive];
            [FWToastBridge showToastAction:NSLocalizedString(@"已开启视频", nil)];
        }
    }];
    
    /// 退出会议按钮事件
    [[self.logoutButton rac_signalForControlEvents :UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        [self dismiss];
    }];
    
    /// 屏幕共享按钮事件
    [[self.screenSharedButton rac_signalForControlEvents :UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        /// 共享屏幕事件
        [self sharingScreenClick];
    }];
}

#pragma mark - 共享屏幕事件
- (void)sharingScreenClick {
    
    /// 弹出BroadcastPicker
    [self showBroadcastPicker];
}

#pragma mark - 弹出BroadcastPicker
- (void)showBroadcastPicker {
    
    /// 将事件传递给RPSystemBroadcastPickerView开启录制按钮
    for (UIView *view in self.broadcastPickerView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            [(UIButton *)view sendActionsForControlEvents:UIControlEventTouchDown | UIControlEventTouchUpInside];
        }
    }
}

#pragma mark - 为房间手势界面添加手势
- (void)appendRecognizer {
    
    /// 添加手势拖动
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGestureRecognizer:)];
    [self.view addGestureRecognizer:panGesture];
    
    /// 添加手势缩放
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchGestureRecognizer:)];
    [self.view addGestureRecognizer:pinchGesture];
}

#pragma mark - 拖动手势处理
- (void)handlePanGestureRecognizer:(UIPanGestureRecognizer *)sender {
    
    /// 该方法返回在横坐标上、纵坐标上拖动了多少像素
    CGPoint point = [sender translationInView:self.view];
    /// 播放画面拖动
    [self.minePlayer move:point.x dy:-point.y];
    /// 拖动起来一直是在递增，所以每次都要重置为0
    [sender setTranslation:CGPointZero inView:self.view];
}

#pragma mark - 缩放手势处理
- (void)handlePinchGestureRecognizer:(UIPinchGestureRecognizer *)sender {
    
    /// 播放画面缩放
    [self.minePlayer zoom:sender.scale];
    /// 每次捏合动作完毕之后，让此捏合值复原，使得它每次都是从100%开始缩放
    sender.scale = 1.0;
}

#pragma mark - ------- VCSMeetingManagerCameraProtocol的代理方法 -------
#pragma mark 摄像头采集视频数据回调
/// 摄像头采集视频数据回调
/// @param pixelbuffer 视频采集数据
- (void)captureCameraDataWithCVPixleBuffer:(CVPixelBufferRef)pixelbuffer {
    
    /// 显示 CVPixelBufferRef数据
    /// [self.player displayCVPixleBuffer:pixelbuffer];
}

#pragma mark - ------- VCSMeetingManagerProtocol的代理方法 -------
#pragma mark 会议室参会人流媒体数据回调(可根据不同linkId显示/处理窗口)
/// 会议室参会人流媒体数据回调(可根据不同linkId显示/处理窗口)
/// @param linkId 视频链路ID
/// @param track 视频轨道(0~7)八个轨道
/// @param type 视频存储格式(0 - I420 , 1 - NV12, 2 - NV21)
/// @param lable 视频角度
/// @param width 宽/高
/// @param height 宽/高
/// @param yData 流媒体像素数据
/// @param uData 流媒体像素数据
/// @param vData 流媒体像素数据
- (void)roomParticipantCameraDataWithLinkId:(int)linkId track:(int)track type:(int)type lable:(int)lable width:(int)width height:(int)height yData:(void *)yData uData:(void *)uData vData:(void *)vData {
    
    if (self.sharingSdkno == linkId) {
        /// 屏幕录制画面
        [self.minePlayer displayYUVData:track type:type lable:lable width:width height:height yData:yData uData:uData vData:vData];
    } else {
        /// 视频流画面
        [self.otherPlayer displayYUVData:track type:type lable:lable width:width height:height yData:yData uData:uData vData:vData];
    }
}

#pragma mark 录屏状态码回调
/// 录屏状态码回调
/// @param status 状态码(0-停止，1-开始，-1-连接失败)
- (void)pushScreenStreamProcessStatus:(int)status {
    
    switch (status) {
        case -1:
            SGLOG(@"++++++++++录屏连接失败");
            break;
        case 0:
            SGLOG(@"++++++++++录屏停止");
            /// 关闭共享屏幕
            [[VCSMeetingManager sharedManager] sendRoomStopSharing];
            break;
        case 1:
            SGLOG(@"++++++++++录屏开始");
            [[VCSMeetingManager sharedManager] sendRoomStartToShareWithSharingType:SharingType_StDesktop sharingPicURL:nil sharingRelativePicURL:nil];
            break;
        default:
            break;
    }
}

#pragma mark 成员进入会议室通知
/// 成员进入会议室通知
/// @param notify 通知信息
/// @param error 错误信息
- (void)onListenEnterWithNotify:(EnterNotify *)notify error:(NSError *)error {
    
    if (self.sharingSdkno > 0) {
        return;
    }
    /// 成员进入房间
    self.sharingSdkno = notify.account.streamId;
}

#pragma mark 会议室状态通知
/// 会议室状态通知
/// @param notify 通知信息
/// @param error 错误信息
- (void)onListenRoomStateWithNotify:(RoomNotify *)notify error:(NSError *)error {
    
    if (notify.room.sharingType == SharingType_StDesktop) {
        
        if (self.isSharingScreen) {
            /// 已经处理共享屏幕消息
            return;
        }
        /// 切换该流的轨道播放屏幕录制码流
        [[VCSMeetingManager sharedManager] setStreamTrackWithClientId:self.sharingSdkno mark:[notify.room.sharingStreamId intValue] isSync:YES];
        /// 标记当前会议室内在共享屏幕
        self.isSharingScreen = YES;
    } else {
        
        if (self.isSharingScreen) {
            /// 切换该流的轨道播放屏幕录制码流
            [[VCSMeetingManager sharedManager] setStreamTrackWithClientId:self.sharingSdkno mark:1 isSync:NO];
        }
        /// 标记当前会议室内未在共享屏幕
        self.isSharingScreen = NO;
    }
}

#pragma mark - 更新本地预览小窗口旋转角度和镜像
/// 更新本地预览小窗口旋转角度和镜像
- (void)stepPreviewRotate {
    
    if ([[VCSMeetingManager sharedManager] getCurrenCamera] == 0) {
        /// 前置采集
        [self.minePlayer setViewflip:YES flipY:NO];
    } else {
        /// 后置采集
        [self.minePlayer setViewflip:NO flipY:NO];
    }
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    /// 更新本地预览小窗口旋转角度
    switch (orientation) {
        case UIInterfaceOrientationUnknown:
        case UIInterfaceOrientationPortrait:
            [self.minePlayer setViewRotate:270];
            break;
        case UIInterfaceOrientationPortraitUpsideDown:
            [self.minePlayer setViewRotate:90];
            break;
        case UIInterfaceOrientationLandscapeLeft: {
            if ([[VCSMeetingManager sharedManager] getCurrenCamera] == 0) {
                /// 前置采集
                [self.minePlayer setViewRotate:0];
            } else {
                /// 后置采集
                [self.minePlayer setViewRotate:180];
            }
        }
            break;
        case UIInterfaceOrientationLandscapeRight: {
            if ([[VCSMeetingManager sharedManager] getCurrenCamera] == 0) {
                /// 前置采集
                [self.minePlayer setViewRotate:180];
            } else {
                /// 后置采集
                [self.minePlayer setViewRotate:0];
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark - 退出(离开此页面)
- (void)dismiss {
    
    @weakify(self);
    
    /// 销毁释放会议资源
    [[VCSMeetingManager sharedManager] destroy:YES finishBlock:^{
        @strongify(self);
        /// 返回上级目录
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

@end
