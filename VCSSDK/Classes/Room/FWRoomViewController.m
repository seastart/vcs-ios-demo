//
//  FWRoomViewController.m
//  VCSSDK_Example
//
//  Created by SailorGa on 2020/4/27.
//  Copyright © 2020 SailorGa. All rights reserved.
//

#import "FWRoomViewController.h"
#import "TZImagePickerController.h"
#import "FWAppDelegate.h"
#import "FWPlayerView.h"
#import "FWWhiteBoardView.h"
#import "FWRoomViewModel.h"
#import "FWBeautyModel.h"
#import <AVKit/AVKit.h>
#import <UserNotifications/UserNotifications.h>
#import <VCSSDK/VCSBeauty.h>
#import <VCSSDK/VCSLogin.h>
#import "FWFilterView.h"

API_AVAILABLE(ios(12.0))
@interface FWRoomViewController ()<VCSMeetingManagerProtocol, AVRoutePickerViewDelegate, FWFilterViewDelegate>

/// 视频窗口
@property (weak, nonatomic) IBOutlet UIView *cameraPlayerView;

/// 电子白板窗口
@property (nonatomic, strong) FWWhiteBoardView *whiteBoardView;

/// CPU占用率&&内存使用情况
@property (weak, nonatomic) IBOutlet UILabel *performanceStatusLabel;
/// 当前网络状况
@property (weak, nonatomic) IBOutlet UIImageView *netLevelImageView;

/// 标题
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
/// 退出会议室
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;
/// 网络检测
@property (weak, nonatomic) IBOutlet UIButton *networkDetectionButton;
/// 发送聊天消息
@property (weak, nonatomic) IBOutlet UIButton *sendChatButton;
/// 开启电子白板
@property (weak, nonatomic) IBOutlet UIButton *openBoardButton;
/// 开启图片分享
@property (weak, nonatomic) IBOutlet UIButton *openSharingPictureButton;
/// 屏幕共享按钮
@property (weak, nonatomic) IBOutlet UIButton *screenSharedButton;
/// 画中画按钮
@property (weak, nonatomic) IBOutlet UIButton *pipButton;
/// 房间视频状态
@property (weak, nonatomic) IBOutlet UIButton *roomVideoStateButton;
/// 房间音频状态
@property (weak, nonatomic) IBOutlet UIButton *roomAudioStateButton;
/// 摄像头转换
@property (weak, nonatomic) IBOutlet UIButton *cameraSwitchButton;
/// 开启/关闭闪光灯
@property (weak, nonatomic) IBOutlet UIButton *flashlightButton;
/// 开启/关闭自己的音频
@property (weak, nonatomic) IBOutlet UIButton *selfAudioSwitchButton;
/// 开启/关闭自己的视频
@property (weak, nonatomic) IBOutlet UIButton *selfVideoSwitchButton;
/// 接收/不接受所有人的视频
@property (weak, nonatomic) IBOutlet UIButton *allVideoSwitchButton;
/// 接收/不接受所有人的音频
@property (weak, nonatomic) IBOutlet UIButton *allAudioSwitchButton;
/// 切换音频输出设备
@property (weak, nonatomic) IBOutlet UIButton *outputAudioButton;
/// 举手操作
@property (weak, nonatomic) IBOutlet UIButton *raiseHandButton;
/// 会议室锁定按钮
@property (weak, nonatomic) IBOutlet UIButton *lockedRoomButton;
/// 语音模式开关
@property (weak, nonatomic) IBOutlet UIButton *audioModeButton;
/// 房间静音类型按钮
@property (weak, nonatomic) IBOutlet UIButton *roomMuteTypeButton;
/// 更改自己的昵称按钮
@property (weak, nonatomic) IBOutlet UIButton *changeNicknameButton;

/// 美颜按钮
@property (weak, nonatomic) IBOutlet UIButton *beautyButton;
/// 美颜视图
@property (weak, nonatomic) IBOutlet UIView *beautyView;
/// 关闭弹窗按钮
@property (weak, nonatomic) IBOutlet UIButton *closeItemButton;
/// 美肤按钮
@property (weak, nonatomic) IBOutlet UIButton *beautyItemButton;
/// 滤镜按钮
@property (weak, nonatomic) IBOutlet UIButton *filterItemButton;

/// 美颜与非美颜对比
@property (weak, nonatomic) IBOutlet UIButton *beautyContrastButton;

/// 滤镜视图
@property (weak, nonatomic) IBOutlet FWFilterView *filterView;
/// 选中的滤镜
@property (nonatomic, strong) FWBeautyModel *seletedParam;

/// 美肤视图
@property (weak, nonatomic) IBOutlet UIView *beautyItemView;
/// 美白
@property (weak, nonatomic) IBOutlet UISlider *whiteSlider;
/// 红润
@property (weak, nonatomic) IBOutlet UISlider *redSlider;
/// 磨皮
@property (weak, nonatomic) IBOutlet UISlider *blurSlider;
/// 锐化
@property (weak, nonatomic) IBOutlet UISlider *sharpenSlider;

/// 当前版本信息
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;
/// 当前用户流媒体上传状态
@property (weak, nonatomic) IBOutlet UILabel *selfUploadStateLabel;
/// 其它与会人员流媒体上传状态
@property (weak, nonatomic) IBOutlet UILabel *otherUploadStateLabel;
/// 当前讲话人员音频数据信息
@property (weak, nonatomic) IBOutlet UILabel *audioSpeakingStatusLabel;

/// 当前共享功能的用户
@property (nonatomic, strong) NSString *sharingAccountId;
/// 当前共享屏幕的码流ID
@property (nonatomic, strong) NSString *sharingStreamId;
/// 当前分享者帐号SDKNO
@property (nonatomic, strong) NSString *sharingSdkno;
/// 标记会议室当前是否有共享白板
@property (assign, nonatomic) BOOL isSharingWhiteBoard;
/// 标记会议室当前是否有共享图片
@property (assign, nonatomic) BOOL isSharingPicture;
/// 标记会议室当前是否有共享屏幕
@property (assign, nonatomic) BOOL isSharingScreen;

/// 标记房间视频状态
@property (assign, nonatomic) DeviceState videoState;
/// 标记房间音频状态
@property (assign, nonatomic) DeviceState audioState;

/// BroadcastPickerView
@property (strong, nonatomic) RPSystemBroadcastPickerView *broadcastPickerView;
/// AVRoutePickerView
@property (nonatomic, strong) AVRoutePickerView *routePickerView;

/// 房间内成员 自定义保存管理
@property (nonatomic, strong) NSMutableArray *roomDataArray;
/// 视频采集以及播放小窗口
@property (nonatomic, strong) FWPlayerView *playerView;

/// 标记是否横屏
@property (nonatomic, assign) BOOL isHorizontalScreen;
/// 自己的录屏状态(YES-正在录屏 NO-未在录屏)
@property (nonatomic, assign) BOOL screenStatus;

/// 限制一次只处理一个人的举手操作
@property (nonatomic, assign) BOOL isRaiseHand;

/// ViewModel
@property (strong, nonatomic) FWRoomViewModel *viewModel;
/// 用户重连标志
@property (nonatomic, assign) BOOL isReconnect;
/// 当前音频输出路由
@property (nonatomic, assign) VCSAudioRoute audioRoute;

/// 网络监测配置
@property (nonatomic, strong) VCSNetworkConfig *networkConfig;

/// 标识回到前台时是否需要恢复视频
@property (nonatomic, assign) BOOL isNeedResumeVideo;

@end

@implementation FWRoomViewController

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

#pragma mark - 页面加载完成
- (void)viewDidAppear:(BOOL)animated {
    
    /// 开启并监听屏幕方向变化
    [self beginDeviceOrientationChange];
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

#pragma mark - 横竖屏切换
- (void)orientationToPortrait:(UIInterfaceOrientation)orientation {
    
    SEL selector = NSSelectorFromString(@"setOrientation:");
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
    [invocation setSelector:selector];
    [invocation setTarget:[UIDevice currentDevice]];
    UIInterfaceOrientation val = orientation;
    [invocation setArgument:&val atIndex:2];
    [invocation invoke];
}

#pragma mark - 懒加载视频采集以及播放小窗口
- (FWPlayerView *)playerView {

    if (!_playerView) {
        _playerView = [[FWPlayerView alloc] initSGWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    }
    return _playerView;
}

#pragma mark - 懒加载房间电子白板窗口
/// 懒加载房间电子白板窗口
- (FWWhiteBoardView *)whiteBoardView {
    
    if (!_whiteBoardView) {
        _whiteBoardView = [[FWWhiteBoardView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        WeakSelf();
        /// 退出会议
        [_whiteBoardView logoutClickBlock:^{
            [weakSelf dismiss];
        }];
    }
    return _whiteBoardView;
}

#pragma mark - 懒加载房间内成员
- (NSMutableArray *)roomDataArray {
    
    if (!_roomDataArray) {
        _roomDataArray = [NSMutableArray array];
    }
    return _roomDataArray;
}

#pragma mark - 懒加载屏幕录制
- (RPSystemBroadcastPickerView *)broadcastPickerView API_AVAILABLE(ios(12.0)){
    
    if (!_broadcastPickerView) {
        _broadcastPickerView = [[RPSystemBroadcastPickerView alloc] init];
        _broadcastPickerView.preferredExtension = @"cn.seastart.vcsdemo.replayBroadcastUpload";
        _broadcastPickerView.showsMicrophoneButton = NO;
        _broadcastPickerView.hidden = YES;
    }
    return _broadcastPickerView;
}

#pragma mark - 懒加载音频路由选择
- (AVRoutePickerView *)routePickerView API_AVAILABLE(ios(11.0)) {
    
    if (!_routePickerView) {
        _routePickerView = [[AVRoutePickerView alloc] init];
        _routePickerView.delegate = self;
        _routePickerView.hidden = YES;
    }
    return _routePickerView;
}

#pragma mark - 懒加载网络监测配置
/// 懒加载网络监测配置
- (VCSNetworkConfig *)networkConfig {
    
    if (!_networkConfig) {
        _networkConfig = [[VCSNetworkConfig alloc] init];
        _networkConfig.upSpeed = 2000;
        _networkConfig.downSpeed = 2000;
        _networkConfig.duration = 10;
        _networkConfig.deviceId = DeviceUUID;
    }
    return _networkConfig;
}

#pragma mark - 初始化UI
- (void)buildView {
    
    /// 设置默认房间音视频状态为开启
    self.videoState = self.audioState = DeviceState_DsActive;
    /// 设置默认自己音频开关
    self.selfAudioSwitchButton.selected = !self.meetingParam.isOpenAudio;
    /// 设置默认自己视频开关
    self.selfVideoSwitchButton.selected = !self.meetingParam.isOpenVideo;
    /// 默认没有屏幕共享
    self.isSharingScreen = NO;
    /// 默认没有举手操作
    self.isRaiseHand = NO;
    /// 设置ViewModel
    [self setupViewModel];
    /// 绑定动态响应信号
    [self bindSignal];
    
    /// 当前当前用户昵称&sdkno
    self.titleLabel.text = [NSString stringWithFormat:@"%@(%ld)",self.loginModel.data.account.nickname, (long)self.loginModel.data.account.room.sdk_no];
    /// 初始化SDK
    BOOL isSucceed = [[VCSMeetingManager sharedManager] initMediaSessionWithMeetingParam:self.meetingParam isNoPickAudio:NO delegate:self];
    /// 当前SDK版本
    self.versionLabel.text = [NSString stringWithFormat:@"%@ 当前房间sdk no = %ld",[[VCSMeetingManager sharedManager] getVersionInfo], (long)self.enterRoomModel.data.sdk_no];
    /// 测试提前设置用户轨道
    /// [[VCSMeetingManager sharedManager] setStreamTrackWithClientId:20000660 mark:2 isSync:NO];
    if (isSucceed) {
        /// 初始化SDK成功(添加视频采集画面并开始推流)
        [self.cameraPlayerView addSubview:self.playerView];
        /// 设置网络延时抖动档位(重传档位)
        [[VCSMeetingManager sharedManager] setNetworkDelayShakeWithState:VCSNetworkDelayShakeStateMedium];
    } else {
        SGLOG(@"++++++++++互动服务器连接失败可再次做重连操作");
        /// 不需要重连直接调用退出
        [self dismiss];
    }
    /// 开启录屏服务端
    [[VCSMeetingManager sharedManager] startScreenRecordWithAppGroup:VCSAPPGROUP];
    /// 获取音频路由列表
    /// [[VCSMeetingManager sharedManager] getAvailableAudioRoutes];
    
    /// 默认设置横屏
    self.isHorizontalScreen = [VCSMeetingManager sharedManager].meetingParam.isHorizontalScreen;
    
    /// 加载房间电子白板窗口
    [self.view addSubview:self.whiteBoardView];
    /// 默认隐藏房间电子白板窗口
    [self.whiteBoardView hiddenView];
    /// 消息回调处理
    [self resultBlockAction];
    
    /// 添加画面手势
    /// [self appendRecognizer];
    
    /// 设置Slider
    [self setupSlider];
    /// 设置滤镜
    [self setupFilter];
    
    /// 监听音频输出设备改变
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(outputDeviceChanged:) name:AVAudioSessionRouteChangeNotification object:[AVAudioSession sharedInstance]];
    
    /// 绑定监听通知
    [self bindNotification];
}

#pragma mark - 绑定监听通知
- (void)bindNotification {
    
    /// 应用程序进入前台并处于活动状态
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    /// 应用程序从活动状态进入非活动状态
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
}

#pragma mark - 应用程序进入前台并处于活动状态
/// 应用程序进入前台并处于活动状态
- (void)appDidBecomeActive:(NSNotification *)notification {
    
    /// 如果回到前台时需要恢复视频
    if (self.isNeedResumeVideo) {
        /// 当前视频为关闭状态
        if ([VCSMeetingManager sharedManager].account.videoState == DeviceState_DsClosed) {
            /// 开启自己的视频
            [[VCSMeetingManager sharedManager] enableSendVideo:DeviceState_DsActive];
        }
        /// 标记回到前台时不需要恢复视频
        self.isNeedResumeVideo = NO;
    }
}

#pragma mark - 应用程序从活动状态进入非活动状态
/// 应用程序从活动状态进入非活动状态
- (void)appWillResignActive:(NSNotification *)notification {
    
    /// 当前视频为开启状态
    if ([VCSMeetingManager sharedManager].account.videoState == DeviceState_DsActive) {
        /// 关闭自己的视频
        [[VCSMeetingManager sharedManager] enableSendVideo:DeviceState_DsClosed];
        /// 标记回到前台时需要恢复视频
        self.isNeedResumeVideo = YES;
    }
}

#pragma mark - 为房间手势界面添加手势
- (void)appendRecognizer {
    
    /// 添加手势单击
    UITapGestureRecognizer *singleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGestureRecognizer:)];
    singleTapGesture.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:singleTapGesture];
    
    /// 添加手势双击
    UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTapGestureRecognizer:)];
    doubleTapGesture.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:doubleTapGesture];
    
    /// 添加手势拖动
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGestureRecognizer:)];
    [self.view addGestureRecognizer:panGesture];
    
    /// 添加手势缩放
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchGestureRecognizer:)];
    [self.view addGestureRecognizer:pinchGesture];
    
    /// 双击手势识别失败之后才执行前面单击手势
    [singleTapGesture requireGestureRecognizerToFail:doubleTapGesture];
}

#pragma mark - 单击手势处理
- (void)handleSingleTapGestureRecognizer:(UITapGestureRecognizer *)sender {
    
    SGLOG(@"+++++++++++单击手势处理 numberOfTapsRequired=%lu", (unsigned long)sender.numberOfTouches);
    self.logoutButton.hidden = self.networkDetectionButton.hidden = self.sendChatButton.hidden = self.openBoardButton.hidden = self.openSharingPictureButton.hidden = self.screenSharedButton.hidden = self.cameraSwitchButton.hidden = self.flashlightButton.hidden = self.selfAudioSwitchButton.hidden = self.selfVideoSwitchButton.hidden = self.allVideoSwitchButton.hidden = self.allAudioSwitchButton.hidden = self.pipButton.hidden = self.outputAudioButton.hidden = self.roomVideoStateButton.hidden = self.roomAudioStateButton.hidden = self.raiseHandButton.hidden = self.lockedRoomButton.hidden = self.audioModeButton.hidden = self.roomMuteTypeButton.hidden = self.beautyButton.hidden = self.changeNicknameButton.hidden = !self.logoutButton.hidden;
}

#pragma mark - 双击手势处理
- (void)handleDoubleTapGestureRecognizer:(UITapGestureRecognizer *)sender {
    
    SGLOG(@"+++++++++++双击手势处理 numberOfTapsRequired=%lu", (unsigned long)sender.numberOfTouches);
    /// CGPoint point = [sender locationInView:self.view];
    /// 播放画面直接缩放
    [self.playerView playerViewDirectZoom];
}

#pragma mark - 拖动手势处理
- (void)handlePanGestureRecognizer:(UIPanGestureRecognizer *)sender {
    
    /// 该方法返回在横坐标上、纵坐标上拖动了多少像素
    CGPoint point = [sender translationInView:self.view];
    SGLOG(@"+++++++++++拖动手势处理 偏移量 offsetX=%f offsetY=%f ", point.x, -point.y);
    /// 播放画面拖动
    [self.playerView playerViewMoveWithOffsetX:point.x offsetY:-point.y];
    /// 拖动起来一直是在递增，所以每次都要重置为0
    [sender setTranslation:CGPointZero inView:self.view];
}

#pragma mark - 缩放手势处理
- (void)handlePinchGestureRecognizer:(UIPinchGestureRecognizer *)sender {
    
    /// 缩放的倍数
    CGFloat scale = sender.scale;
    SGLOG(@"+++++++++++缩放手势处理 scale=%f", scale);
    /// 播放画面缩放
    [self.playerView playerViewZoomWithScale:scale];
    /// 每次捏合动作完毕之后，让此捏合值复原，使得它每次都是从100%开始缩放
    sender.scale = 1.0;
}

#pragma mark - 开启并监听屏幕方向变化
- (void)beginDeviceOrientationChange {
    
    /// 监听屏幕方向变化设备旋转的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleStatusBarOrientationChange:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
}

#pragma mark - 设置ViewModel
- (void)setupViewModel {
    
    /// 初始化ViewModel
    self.viewModel = [[FWRoomViewModel alloc] init];
    /// ViewModel关联Class
    self.viewModel.viewClass = [self class];
    /// ViewModel关联进入房间信息
    self.viewModel.enterRoomModel = self.enterRoomModel;
}

#pragma mark - 设置滤镜
/// 设置滤镜
- (void)setupFilter {
    
    /// 设置代理
    self.filterView.mDelegate = self;
    /// 设置滤镜列表
    self.filterView.filters = [self getFilterData];
    
    /// 初始化默认滤镜
    self.seletedParam = [[FWBeautyModel alloc] init];
    self.seletedParam.titleKey = @"origin";
    self.seletedParam.title = @"无";
    self.seletedParam.value = 0.4;
    
    /// 设置默认滤镜
    [self.filterView setDefaultFilter:self.seletedParam];
}

#pragma mark - 开启滤镜
/// 开启滤镜
- (void)filterViewDidSelectedFilter:(FWBeautyModel *)param {
    
    /// 保存设置的滤镜
    self.seletedParam = param;
    /// 切换滤镜
    [VCSBeautyManager sharedManager].filterName = self.seletedParam.titleKey;
}

#pragma mark - 设置Slider
/// 设置Slider
- (void)setupSlider {
    
    /// 设置初始值
    self.whiteSlider.value = [VCSBeautyManager sharedManager].whiteLevel;
    self.whiteSlider.continuous = YES;
    self.redSlider.value = [VCSBeautyManager sharedManager].redLevel;
    self.redSlider.continuous = YES;
    self.blurSlider.value = [VCSBeautyManager sharedManager].blurLevel;
    self.blurSlider.continuous = YES;
    self.sharpenSlider.value = [VCSBeautyManager sharedManager].sharpen;
    self.sharpenSlider.continuous = YES;
    /// 针对值变化添加响应方法
    [self.whiteSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.redSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.blurSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.sharpenSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
}

#pragma mark - Slider值变化添加响应方法
/// Slider值变化添加响应方法
/// @param slider UISlider对象
- (void)sliderValueChanged:(UISlider *)slider {
    
    /// 获取变化的值
    float value = slider.value;
    SGLOG(@"++++++++++++Slider值变化添加响应方法 = %f", value);
    switch (slider.tag) {
        case 10000:
            /// 美白
            [VCSBeautyManager sharedManager].whiteLevel = value;
            break;
        case 10001:
            /// 红润
            [VCSBeautyManager sharedManager].redLevel = value;
            break;
        case 10002:
            /// 磨皮
            [VCSBeautyManager sharedManager].blurLevel = value;;
            break;
        case 10003:
            /// 锐化
            [VCSBeautyManager sharedManager].sharpen = value;
            break;
        default:
            break;
    }
}

#pragma mark - 绑定信号
- (void)bindSignal {
    
    @weakify(self);
    
    /// 监听订阅加载状态
    [RACObserve(self.viewModel, loading) subscribeNext:^(NSNumber * _Nullable value) {
        if(value.boolValue) {
            [FWToastBridge showToastAction];
        } else {
            [FWToastBridge hiddenToastAction];
        }
    }];
    
    /// 提示框订阅
    [self.viewModel.toastSubject subscribeNext:^(id _Nullable message) {
        if (!kStringIsEmpty(message)) {
            [FWToastBridge showToastAction:message];
        }
    }];
    
    /// 进入房间请求订阅
    [self.viewModel.enterRoomSubject subscribeNext:^(id _Nullable text) {
        @strongify(self);
        /// 重连进入房间成功
        [[VCSMeetingManager sharedManager] restartMeetingWithMeetingHost:self.enterRoomModel.data.meeting_host meetingPort:(int)self.enterRoomModel.data.meeting_port streamHost:self.enterRoomModel.data.stream_host streamPort:(int)self.enterRoomModel.data.stream_port session:self.enterRoomModel.data.session];
    }];
    
    /// 上传图片成功订阅
    [self.viewModel.uploadFilesSubject subscribeNext:^(id _Nullable imageUrl) {
        /// 开始分享(包括：白板、图片、桌面)
        /// [[VCSMeetingManager sharedManager] sendRoomStartToShareWithSharingType:SharingType_StPicture sharingPicURL:@"http://crazy.image.alimmdn.com/iSaior/14878273006128.png"];
        [[VCSMeetingManager sharedManager] sendRoomStartToShareWithSharingType:SharingType_StPicture sharingPicURL:imageUrl sharingRelativePicURL:imageUrl];
    }];
    
    /// 退出会议按钮事件
    [[self.logoutButton rac_signalForControlEvents :UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        [self dismiss];
    }];
    
    /// 网络检测
    [[self.networkDetectionButton rac_signalForControlEvents :UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        /// 开启网络检测
        [[VCSMeetingManager sharedManager] startNetworkDetectionWithConfig:self.networkConfig];
    }];
    
    /// 发送聊天消息按钮事件
    [[self.sendChatButton rac_signalForControlEvents :UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        [self sendChatMessage];
    }];
    
    /// 开启电子白板按钮事件
    [[self.openBoardButton rac_signalForControlEvents :UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        if (self.isSharingScreen) {
            [FWToastBridge showToastAction:@"当前在共享屏幕，请稍后再试"];
            return;
        }
        if (self.isSharingWhiteBoard) {
            [FWToastBridge showToastAction:@"当前在共享电子白板，请稍后再试"];
            return;
        }
        if (self.isSharingPicture) {
            [FWToastBridge showToastAction:@"当前在共享图片，请稍后再试"];
            return;
        }
        /// 开始分享(包括：白板、图片、桌面)
        [[VCSMeetingManager sharedManager] sendRoomStartToShareWithSharingType:SharingType_StWhiteBoard sharingPicURL:nil sharingRelativePicURL:nil];
    }];
    
    /// 开启图片分享按钮事件
    [[self.openSharingPictureButton rac_signalForControlEvents :UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        [self showImagePicker];
    }];
    
    /// 屏幕共享按钮事件
    [[self.screenSharedButton rac_signalForControlEvents :UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        /// 共享屏幕事件
        [self sharingScreenClick];
    }];
    
    /// 画中画按钮事件
    [[self.pipButton rac_signalForControlEvents :UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        self.pipButton.selected = !self.pipButton.selected;
        self.playerView.scrollView.hidden = self.pipButton.selected;
    }];
    
    /// 房间视频状态按钮事件
    [[self.roomVideoStateButton rac_signalForControlEvents :UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        [[VCSMeetingManager sharedManager] sendKostCtrlRoomVideoWithVideoState:self.roomVideoStateButton.selected ? DeviceState_DsActive : DeviceState_DsDisabled];
    }];
    
    /// 房间音频状态按钮事件
    [[self.roomAudioStateButton rac_signalForControlEvents :UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        [[VCSMeetingManager sharedManager] sendKostCtrlRoomAudioWithAudioState:self.roomAudioStateButton.selected ? DeviceState_DsActive : DeviceState_DsDisabled];
    }];
    
    /// 摄像头转换按钮事件
    [[self.cameraSwitchButton rac_signalForControlEvents :UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        /// 摄像头前置后置
        dispatch_async(dispatch_get_main_queue(), ^{
            self.cameraSwitchButton.selected = !self.cameraSwitchButton.selected;
            [[VCSMeetingManager sharedManager] switchCamera];
        });
    }];
    
    /// 开启/关闭闪光灯按钮事件
    [[self.flashlightButton rac_signalForControlEvents :UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        /// 闪光灯是否开启
        dispatch_async(dispatch_get_main_queue(), ^{
            self.flashlightButton.selected = !self.flashlightButton.selected;
            [[VCSMeetingManager sharedManager] flashlightCamera:self.flashlightButton.selected];
        });
    }];
    
    /// 开启/关闭自己的音频按钮事件
    [[self.selfAudioSwitchButton rac_signalForControlEvents :UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([VCSMeetingManager sharedManager].account.audioState == DeviceState_DsDisabled) {
                /// 被主持人禁用(主持人禁用状态自己不能控制)
                return;
            } else {
                self.selfAudioSwitchButton.selected = !self.selfAudioSwitchButton.selected;
                if (self.selfAudioSwitchButton.selected) {
                    /// 不发送自己的音频
                    [[VCSMeetingManager sharedManager] enableSendAudio:DeviceState_DsClosed];
                } else {
                    /// 发送自己的音频
                    [[VCSMeetingManager sharedManager] enableSendAudio:DeviceState_DsActive];
                }
                /// 音频状态变化处理
                [self.playerView stepAudioState:!self.selfAudioSwitchButton.selected];
            }
        });
    }];
    
    /// 开启/关闭自己的视频按钮事件
    [[self.selfVideoSwitchButton rac_signalForControlEvents :UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([VCSMeetingManager sharedManager].account.videoState == DeviceState_DsDisabled) {
                /// 被主持人禁用(主持人禁用状态自己不能控制)
                return;
            } else {
                if (self.screenStatus) {
                    /// 当前自己在共享屏幕直接返回
                    return;
                }
                self.selfVideoSwitchButton.selected = !self.selfVideoSwitchButton.selected;
                if (self.selfVideoSwitchButton.selected) {
                    /// 不发送自己的音频
                    [[VCSMeetingManager sharedManager] enableSendVideo:DeviceState_DsClosed];
                } else {
                    /// 发送自己的音频
                    [[VCSMeetingManager sharedManager] enableSendVideo:DeviceState_DsActive];
                }
                /// 视频状态变化处理
                [self.playerView stepVideoState:!self.selfVideoSwitchButton.selected];
            }
        });
    }];
    
    /// 接收/不接受所有人的视频按钮事件
    [[self.allVideoSwitchButton rac_signalForControlEvents :UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.isSharingScreen) {
                /// 有人在共享屏幕直接返回
                return;
            }
            self.allVideoSwitchButton.selected = !self.allVideoSwitchButton.selected;
            if (self.allVideoSwitchButton.selected) {
                [[VCSMeetingManager sharedManager] enableRecvVideoWithClientId:0 besidesId:nil enabled:NO];
            } else {
                [[VCSMeetingManager sharedManager] enableRecvVideoWithClientId:0 besidesId:nil enabled:YES];
            }
        });
    }];
    
    /// 接收/不接受所有人的音频按钮事件
    [[self.allAudioSwitchButton rac_signalForControlEvents :UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            self.allAudioSwitchButton.selected = !self.allAudioSwitchButton.selected;
            if (self.allAudioSwitchButton.selected) {
                [[VCSMeetingManager sharedManager] setSpeakerSwitch:NO];
                /// [[VCSMeetingManager sharedManager] enableRecvAudioWithClientId:0 enabled:NO];
            } else {
                [[VCSMeetingManager sharedManager] setSpeakerSwitch:YES];
                /// [[VCSMeetingManager sharedManager] enableRecvAudioWithClientId:0 enabled:YES];
            }
        });
    }];
    
    /// 切换音频输出设备
    [[self.outputAudioButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            switch (self.audioRoute) {
                case VCSAudioRouteSpeaker:
                    /// 切换成听筒模式
                    [[VCSMeetingManager sharedManager] setAudioRoute:VCSAudioRouteReceiver];
                    break;
                case VCSAudioRouteReceiver:
                    /// 切换成扬声器模式
                    [[VCSMeetingManager sharedManager] setAudioRoute:VCSAudioRouteSpeaker];
                    break;
                case VCSAudioRouteHeadphone:
                case VCSAudioRouteBluetooth:
                    /// 弹出RoutePickerView
                    [self showRoutePickerView];
                    break;
                default:
                    break;
            }
        });
    }];
    
    /// 举手操作按钮事件
    [[self.raiseHandButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        /// @strongify(self);
        /// 发送举手操作消息
        [[VCSMeetingManager sharedManager] sendRaiseHandWithHus:HandUpStatus_HusLiftTheBan];
    }];
    
    /// 锁定会议室按钮事件
    [[self.lockedRoomButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        /// 锁定房间
        [self.viewModel lockedRoomWithLocked:!control.selected];
    }];
    
    /// 语音模式按钮事件
    [[self.audioModeButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        self.audioModeButton.selected = !self.audioModeButton.selected;
        /// 开启/关闭语音模式
        [[VCSMeetingManager sharedManager] enableAudioMode:self.audioModeButton.selected];
    }];
    
    /// 房间静音类型按钮事件
    [[self.roomMuteTypeButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        /// 选择房间静音类型事件
        [self showRoomMuteTypePicker];
    }];
    
    /// 更改自己的昵称按钮事件
    [[self.changeNicknameButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        /// 更改自己的昵称对话框
        [self sendRoomNicknameAlert];
    }];
    
    /// 房间美颜按钮事件
    [[self.beautyButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        self.beautyView.hidden = !self.beautyView.hidden;
    }];
    
    /// 关闭美颜弹窗按钮事件
    [[self.closeItemButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        self.beautyItemView.hidden = NO;
        self.filterView.hidden = YES;
        self.beautyView.hidden = YES;
    }];
    
    /// 美肤美型按钮事件
    [[self.beautyItemButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        self.beautyItemView.hidden = NO;
        self.filterView.hidden = YES;
    }];
    
    /// 美颜滤镜按钮事件
    [[self.filterItemButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        self.beautyItemView.hidden = YES;
        self.filterView.hidden = NO;
    }];
    
    /// 美颜与非美颜对比按钮(按下)事件
    [[self.beautyContrastButton rac_signalForControlEvents:UIControlEventTouchDown] subscribeNext:^(__kindof UIControl * _Nullable control) {
        /// @strongify(self);
        [[VCSBeautyManager sharedManager] onBeautySwitch:NO];
    }];
    
    /// 美颜与非美颜对比按钮(抬起)事件
    [[self.beautyContrastButton rac_signalForControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        /// @strongify(self);
        [[VCSBeautyManager sharedManager] onBeautySwitch:YES];
    }];
}

#pragma mark - 设置自己的会议昵称对话框
- (void)sendRoomNicknameAlert {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"更改本次会议当前账号的昵称" preferredStyle:UIAlertControllerStyleAlert];
    /// 在对话框中添加输入框
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入新昵称";
        textField.text = @"测试更改昵称";
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
    }];
    UIAlertAction *ensureAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {
        /// 设置房间成员扩展信息
        /// [[VCSMeetingManager sharedManager] sendRoomMemberExtendWithTargetId:nil extendInfo:@"变更后的扩展信息" selves:YES];
        /// 获取新昵称
        NSString *nickname = [[alert textFields] firstObject].text;
        /// 设置房间成员昵称
        [[VCSMeetingManager sharedManager] sendRoomMemberNicknameWithTargetId:nil nickname:nickname selves:YES];
    }];
    [alert addAction:cancelAction];
    [alert addAction:ensureAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - 选择房间静音类型事件
- (void)showRoomMuteTypePicker {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"请选择房间静音类型", nil) message:nil preferredStyle:isPhone ? UIAlertControllerStyleActionSheet : UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
    }];
    UIAlertAction *disabledAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"静音状态为关闭", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [[VCSMeetingManager sharedManager] sendRoomMuteWithState:MuteState_MuteDisabled];
    }];
    UIAlertAction *activeAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"静音状态为开启", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [[VCSMeetingManager sharedManager] sendRoomMuteWithState:MuteState_MuteActive];
    }];
    UIAlertAction *moreAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"超过6人自动开启静音", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [[VCSMeetingManager sharedManager] sendRoomMuteWithState:MuteState_MuteMore];
    }];
    [alert addAction:cancelAction];
    [alert addAction:disabledAction];
    [alert addAction:activeAction];
    [alert addAction:moreAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - 弹出RoutePickerView
- (void)showRoutePickerView {
    
    /// 将事件传递给RoutePickerView开启音频路由
    for (UIView *view in self.routePickerView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            [(UIButton *)view sendActionsForControlEvents:UIControlEventTouchUpInside];
        }
    }
}

#pragma mark - 退出(离开此页面)
- (void)dismiss {
    
    @weakify(self);
    
    /// 销毁释放会议资源
    [[VCSMeetingManager sharedManager] destroy:YES finishBlock:^{
        @strongify(self);
        /// 登出MQTT
        /// [[VCSLoginManager sharedManager] logout];
        /// 返回上级目录
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

#pragma mark - 共享屏幕事件
- (void)sharingScreenClick {
    
    if (self.isSharingPicture) {
        [FWToastBridge showToastAction:@"当前在共享图片，请稍后再试"];
        return;
    }
    if (self.isSharingWhiteBoard) {
        [FWToastBridge showToastAction:@"当前在共享电子白板，请稍后再试"];
        return;
    }
    if (!self.isSharingScreen) {
        /// 当前没有人共享屏幕(可以申请开启共享屏幕)
        /// 弹出BroadcastPicker
        [self showBroadcastPicker];
    } else {
        /// 当前有人在屏幕图片
        /// 限制只有主持人和共享屏幕所有者才能操作共享屏幕开关
        if (!kStringIsEmpty(self.sharingAccountId) && ![self.sharingAccountId isEqualToString:[VCSMeetingManager sharedManager].meetingParam.accountId]) {
            [FWToastBridge showToastAction:@"当前有参会人共享屏幕，您没有权限完成此操作"];
            return;
        }
        /// 弹出BroadcastPicker
        [self showBroadcastPicker];
    }
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

#pragma mark - 设备方向改变的处理
- (void)handleStatusBarOrientationChange:(NSNotification *)notification {
    
    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    switch (interfaceOrientation) {
        case UIInterfaceOrientationUnknown:
            SGLOG(@"++++++++++++未知方向");
            break;
        case UIInterfaceOrientationPortrait:
            SGLOG(@"++++++++++++屏幕直立");
            [self changeScreenOrientationPortrait:interfaceOrientation];
            break;
        case UIInterfaceOrientationPortraitUpsideDown:
            SGLOG(@"++++++++++++屏幕直立，上下顛倒");
            [self changeScreenOrientationPortrait:interfaceOrientation];
            break;
        case UIInterfaceOrientationLandscapeLeft:
            SGLOG(@"++++++++++++屏幕向左横置");
            [self changeScreenOrientationLandscape:interfaceOrientation];
            break;
        case UIInterfaceOrientationLandscapeRight:
            SGLOG(@"++++++++++++屏幕向右橫置");
            [self changeScreenOrientationLandscape:interfaceOrientation];
            break;
        default:
            break;
    }
}

#pragma mark - 设置屏幕方向为竖屏
- (void)changeScreenOrientationPortrait:(UIInterfaceOrientation)orientation {
    
    self.isHorizontalScreen = NO;
    /// 竖屏切换
    [[VCSMeetingManager sharedManager] changeScreenOrientation:(UIDeviceOrientation)orientation previewSize:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT) isHorizontalScreen:NO];
    [self.playerView changeScreenOrientation:NO];
    [self.whiteBoardView changeScreenOrientation:NO];
}

#pragma mark - 设置屏幕方向为横屏
- (void)changeScreenOrientationLandscape:(UIInterfaceOrientation)orientation {
    
    self.isHorizontalScreen = YES;
    /// 横屏切换
    [[VCSMeetingManager sharedManager] changeScreenOrientation:(UIDeviceOrientation)orientation previewSize:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT) isHorizontalScreen:YES];
    [self.playerView changeScreenOrientation:YES];
    [self.whiteBoardView changeScreenOrientation:YES];
}

#pragma mark - 选取本地相册资源
- (void)showImagePicker {
    
    if (self.isSharingScreen) {
        [FWToastBridge showToastAction:@"当前在共享屏幕，请稍后再试"];
        return;
    }
    if (self.isSharingWhiteBoard) {
        [FWToastBridge showToastAction:@"当前在共享电子白板，请稍后再试"];
        return;
    }
    if (self.isSharingPicture) {
        [FWToastBridge showToastAction:@"当前在共享图片，请稍后再试"];
        return;
    }
    TZImagePickerController *imagePickerVC = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:nil];
    /// 禁止选视频
    imagePickerVC.allowPickingVideo = NO;
    WeakSelf();
    [imagePickerVC setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        /// 上传多媒体素材
        [weakSelf uploadMediaResource:photos];
    }];
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

#pragma mark - 上传多媒体素材
- (void)uploadMediaResource:(NSArray<UIImage *> *)photos {
    
    SGLOG(@"++++++++++++上传多媒体素材");
    /// 上传图片到服务器
    [self.viewModel roomtempUploadFilesToken:photos.firstObject];
}

#pragma mark - ------- AVRoutePickerViewDelegate的代理方法 -------
#pragma mark AirPlay界面弹出时回调
- (void)routePickerViewWillBeginPresentingRoutes:(AVRoutePickerView *)routePickerView API_AVAILABLE(ios(11.0)) {
    
    SGLOG(@"++++++++++++Airplay视图弹出");
}

#pragma mark AirPlay界面结束时回调
- (void)routePickerViewDidEndPresentingRoutes:(AVRoutePickerView *)routePickerView API_AVAILABLE(ios(11.0)) {
    
    SGLOG(@"++++++++++++Airplay视图弹回");
}

#pragma mark - 监听音频输出设备改变
- (void)outputDeviceChanged:(NSNotification *)notification {
    
    /// 如果业务层需要可以再这里做相关监听以及UI处理
}

#pragma mark - ------- VCSMeetingManagerProtocol的代理方法 -------
#pragma mark 开启网络检测
/// 开启网络检测
- (void)roomNetworkManagerDidBegined {
    
    [FWToastBridge showToastAction:@"网络检测已开启"];
}

#pragma mark 完成网络检测
/// 完成网络检测
/// @param uploadModel 上行网络状况
/// @param downModel 下行网络状况
/// @param connectModel 网络连接状况
- (void)roomNetworkManagerDidFinshedWithUploadModel:(nullable VCSNetworkModel *)uploadModel downModel:(nullable VCSNetworkModel *)downModel connectModel:(VCSNetworkConnectModel *)connectModel {
    
    [FWToastBridge showToastAction:@"网络检测已完成"];
}

#pragma mark 流媒体连接结果回调
/// 流媒体连接结果回调
/// @param succeed 连接是否成功，YES-成功 NO-失败
- (void)roomStreamMediaDidConnectFinish:(BOOL)succeed {
    
    SGLOG(@"%@", succeed ? @"流媒体连接成功" : @"流媒体连接失败");
}

#pragma mark 流媒体重连结果回调
/// 流媒体重连结果回调
/// @param succeed 重连是否成功，YES-成功 NO-失败
- (void)roomStreamMediaDidReconnectFinish:(BOOL)succeed {
    
    SGLOG(@"%@", succeed ? @"流媒体连接闪断重连成功" : @"流媒体连接闪断了，正在尝试重连...");
}

#pragma mark 码率自适应状态(当前发送端码率变化回调)
/// 码率自适应状态(当前发送端码率变化回调)
/// @param state 当前发送端码率变化状态
- (void)roomSenderXbitrateChangeWithStreamState:(VCSXbitrateSendState)state {
    
    switch (state) {
        case VCSXbitrateSendStateStart:
            SGLOG(@"++++++++++++当前发送端码率自适应：开始工作");
            break;
        case VCSXbitrateSendStateNormal:
            SGLOG(@"++++++++++++当前发送端码率自适应：码流恢复最初设置");
            break;
        case VCSXbitrateSendStateHalf:
            SGLOG(@"++++++++++++当前发送端码率自适应：码率变为原来的一半");
            break;
        case VCSXbitrateSendStateQuarter:
            SGLOG(@"++++++++++++当前发送端码率自适应：码率变为原来的四分之一");
            break;
        case VCSXbitrateSendStateVeryBad:
            SGLOG(@"++++++++++++当前发送端码率自适应：当前网络环境及其差劲情况");
            break;
        default:
            break;
    }
}

#pragma mark 会议室流媒体码率自适应状态(接收网络状态回调)
/// 会议室流媒体码率自适应状态(接收网络状态回调)
/// @param linkId 链路ID(SDKNO&streamID)
/// @param lrlState 端到端链路状态
/// @param lrdState 下行链路状态
- (void)roomXbitrateChangeStateWithLinkId:(NSString *)linkId lrlState:(VCSXbitrateInceptState)lrlState lrdState:(VCSXbitrateInceptState)lrdState {
    
    SGLOG(@"+++++会议室流媒体码率自适应状态(接收网络状态回调) linkId = %@ lrlState = %ld lrdState = %ld", linkId, (long)lrlState, (long)lrdState);
    switch (lrlState) {
        case VCSXbitrateInceptStateNormal:
            /// 关闭该流的音频优先策略
            [[VCSMeetingManager sharedManager] setAudioPriorityWithClientId:[linkId intValue] enable:NO];
            break;
        case VCSXbitrateInceptStatePoor:
            break;
        case VCSXbitrateInceptStateBad:
        case VCSXbitrateInceptStateVeryBad:
        case VCSXbitrateInceptStateLose:
            /// 开启该流的音频优先策略
            [[VCSMeetingManager sharedManager] setAudioPriorityWithClientId:[linkId intValue] enable:YES];
            break;
        default:
            break;
    }
}

#pragma mark 会议室当前用户上传流媒体状态回调
/// 会议室当前用户上传流媒体状态回调
/// @param ptr 底层防止溢出字段
/// @param streamData 流媒体信息(delay : 上传延迟时间 speed : 上传发送速度 status : -1上传出错 >=0正常 buffer : 上传缓冲包0-4正常 overflow : 上传缓冲包0-4正常 loss_r = "0.00"; 当前上传丢包率 loss_c  = "0.00"; 经过补偿的最终上传丢包率)
/// {
///    uploadinfo =     (
///                {
///            buffer = 0; 上传缓冲包0-4正常
///            delay = 0; 上传延迟时间
///            overflow = 0; 上传缓冲包0-4正常
///            speed = 0kps; 上传发送速度
///            status = "-2"; -1上传出错 >=0正常
///            loss_r = "0.00"; 当前上传丢包率
///            loss_c  = "0.00"; 经过补偿的最终上传丢包率
///        }
///    );
/// }
- (void)roomCurrentStreamStatusWithPtr:(NSString *)ptr streamData:(NSDictionary *)streamData {
    
    SGLOG(@"+++++自己上传流媒体相关的信息回调\n%@", streamData);
    self.selfUploadStateLabel.text = [NSString stringWithFormat:@"当前用户流媒体上传状态：%@", [[FWToolHelper sharedManager] convertToJsonData:streamData]];
    /// 设置信号强度
    NSString *imageUrl = @"icon_meeting_room_player_mobile_signal_1";
    switch ([VCSMeetingManager sharedManager].account.netLevel) {
        case NetLevel_NlGood:
            imageUrl = @"icon_meeting_room_player_mobile_signal_1";
            break;
        case NetLevel_NlNormal:
            imageUrl = @"icon_meeting_room_player_mobile_signal_2";
            break;
        case NetLevel_NlLow:
            imageUrl = @"icon_meeting_room_player_mobile_signal_3";
            break;
        case NetLevel_NlBad:
        case NetLevel_NlLost:
            imageUrl = @"icon_meeting_room_player_mobile_signal_4";
            break;
        default:
            break;
    }
    [self.netLevelImageView setImage:kGetImage(imageUrl)];
}

#pragma mark 会议室其它与会人员上传流媒体状态回调
/// 会议室其它与会人员上传流媒体状态回调
/// @param ptr 底层防止溢出字段
/// @param streamData 流媒体信息
/// {
///     "recvinfo": [
///          {
///              "linkid": 12340001,  对方sdkno
///              "recv": 4127，接收包信息
///              "comp": 13,  补偿 高 网络不稳定
///              "losf": 0,   丢失包信息  高 就是网络差
///              "lrl": 6.8,  短时端到端丢包率（对方手机到你手机）
///              "lrd": 8.9,   短时下行丢包率（服务器到你）
///              "audio": 600,   接收音频包信息
///          }
///      ]
///  }
- (void)roomParticipantStreamStatusWithPtr:(NSString *)ptr streamData:(NSDictionary *)streamData {
    
    SGLOG(@"+++++与会人员上传流媒体相关的信息回调\n%@", streamData);
    self.otherUploadStateLabel.text = [NSString stringWithFormat:@"其它与会人员流媒体上传状态：%@", [[FWToolHelper sharedManager] convertToJsonData:streamData]];
}

#pragma mark 会议室视频进入和退出流媒体输出信息回调
/// 会议室视频进入和退出流媒体输出信息回调
/// @param lparam 宽/高
/// @param wparam 宽/高
/// @param ptr 底层防止溢出字段
- (void)roomStreamDataWithLparam:(int)lparam wparam:(int)wparam ptr:(NSString *)ptr {
    
    SGLOG(@"++++++会议室视频进入和退出流媒体输出信息回调 ptr == %@ lparam = %.2d wparam = %.2d", ptr, lparam, wparam);
}

#pragma mark 会议室参会人流媒体数据回调(可根据不同linkId显示/处理窗口)
/// 会议室参会人流媒体数据回调(可根据不同linkId显示/处理窗口)
/// @param linkId 视频链路ID
/// @param stamp 时间戳
/// @param track 视频轨道
/// @param type 视频存储格式(0 - I420 , 1 - NV12, 2 - NV21)
/// @param lable 视频角度
/// @param width 宽/高
/// @param height 宽/高
/// @param yData 流媒体像素数据
/// @param uData 流媒体像素数据
/// @param vData 流媒体像素数据
- (void)roomParticipantCameraDataWithLinkId:(int)linkId stamp:(int)stamp track:(int)track type:(int)type lable:(int)lable width:(int)width height:(int)height yData:(void *)yData uData:(void *)uData vData:(void *)vData {
    
    /// SGLOG(@"+++++++++++参会人流媒体回调 linkId = %d, stamp = %d, lable = %d, width = %d, height = %d", linkId, stamp, lable, width, height);
    /// 用于播放用户的特定画面
    [self.playerView playCallbackFrameWithLinkId:linkId stamp:stamp track:track type:type lable:lable width:width height:height yData:yData uData:uData vData:vData];
}

#pragma mark 当前服务器是否允许本人发言回调
/// 当前服务器是否允许本人发言回调
/// @param state 是否允许发言
- (void)roomServiceSpeechWithState:(BOOL)state {
    
    SGLOG(@"++++++++++%@", state ? @"当前服务器允许你发言" : @"当前服务器不允许你发言");
}

#pragma mark 音频路由变更回调
/// 音频路由变更回调
/// @param route 音频路由
/// @param routeName 音频路由名称
/// @param previousRoute 变更前的音频路由
/// @param previousRouteName 变更前的音频路由名称
- (void)onAudioRouteChanged:(VCSAudioRoute)route routeName:(NSString *)routeName previousRoute:(VCSAudioRoute)previousRoute previousRouteName:(NSString *)previousRouteName {
    
    SGLOG(@"++++++++音频输出端口变更回调 route = %ld, previousRoute = %ld", route, previousRoute);
    /// 记录当前音频输出路由
    self.audioRoute = route;
    dispatch_async(dispatch_get_main_queue(), ^{
        switch (route) {
            case VCSAudioRouteSpeaker:
                /// 扬声器(免提模式)
                [self.outputAudioButton setTitle:@" 当前为免提模式 " forState:UIControlStateNormal];
                break;
            case VCSAudioRouteReceiver:
                /// 听筒(听筒模式)
                [self.outputAudioButton setTitle:@" 当前为听筒模式 " forState:UIControlStateNormal];
                break;
            case VCSAudioRouteHeadphone:
                /// 有线耳机设备(有线耳机模式)
                [self.outputAudioButton setTitle:@" 当前为耳机模式 " forState:UIControlStateNormal];
                break;
            case VCSAudioRouteBluetooth:
                /// 蓝牙设备(蓝牙模式)
                [self.outputAudioButton setTitle:@" 当前为蓝牙模式 " forState:UIControlStateNormal];
                break;
            default:
                break;
        }
    });
}

#pragma mark 当前应用CPU占用率内存使用情况回调
/// 当前应用CPU占用率内存使用情况回调
/// @param memory 内存使用
/// @param cpuUsage CPU占有率
- (void)roomAppPerformanceWithMemory:(double)memory cpuUsage:(double)cpuUsage {
    
    NSString *performanceStr = [NSString stringWithFormat:@"CPU: %.2f%@ Memory: %.2f MB ", cpuUsage, @"%", memory];
    self.performanceStatusLabel.text = performanceStr;
    SGLOG(@"++++++++++当前应用CPU占用率内存使用情况 = %@", performanceStr);
}

#pragma mark 当前讲话人员音频数据信息回调
/// 当前讲话人员音频数据信息回调
/// @param audioArray 讲话人员音频数据列表
/// {
///    streamId = 20000016; 链接ID(即：sdkno)
///    power = 6766; 功率
///    db = "-99"; 分贝值
/// }
- (void)roomAudioSpeakingStatusWithAudioArray:(nullable NSMutableArray *)audioArray {
    
    /// 会议时成员音频变化更新
    [self.playerView playAudioWithAudioArray:audioArray];
    self.audioSpeakingStatusLabel.text = [NSString stringWithFormat:@"当前讲话人员音频数据信息：%@", [audioArray componentsJoinedByString:@","]];
    SGLOG(@"++++++++++当前讲话人员音频数据信息 = %@", audioArray);
}

#pragma mark 下行网络丢包档位变化回调
/// 下行网络丢包档位变化回调
/// @param state 下行丢包档位
- (void)roomDownstreamLevelChangeWithState:(VCSDownLevelState)state {
    
    SGLOG(@"++++++++++下行丢包档位变化，当前档位 = %ld", (long)state);
}

#pragma mark 短时平均下行丢包率回调
/// 短时平均下行丢包率回调
/// @param average 平均下行丢包率
- (void)roomDownstreamLossWithAverage:(CGFloat)average {
    
    SGLOG(@"++++++++++短时平均下行丢包率，当前平均丢包率 = %.2lf", average);
}

#pragma mark 语音模式状态变更回调
/// 语音模式状态变更回调
/// @param audioMode 语音模式状态(YES-开启 NO-关闭)
- (void)roomAudioModeChangeWithAudioMode:(BOOL)audioMode {
    
    SGLOG(@"++++++++++语音模式状态变更回调 = %@", audioMode ? @"开启" : @"关闭");
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
            /// 标记未在录屏
            self.screenStatus = NO;
            /// 关闭共享屏幕
            [[VCSMeetingManager sharedManager] sendRoomStopSharing];
            break;
        case 1:
            SGLOG(@"++++++++++录屏开始");
            /// 标记正在录屏
            self.screenStatus = YES;
            [[VCSMeetingManager sharedManager] sendRoomStartToShareWithSharingType:SharingType_StDesktop sharingPicURL:nil sharingRelativePicURL:nil];
            break;
        default:
            break;
    }
}

#pragma mark 互动服务闪断重连成功回调
/// 互动服务闪断重连成功回调
- (BOOL)roomReconnectedSucceed {
    
    SGLOG(@"++++++++++互动服务闪断重连成功回调");
    
    return YES;
}

#pragma mark 互动服务连接失败(进入房间失败)
/// 互动服务连接失败(进入房间失败)
/// @param command cmd指令
/// @param result 结果
- (void)roomListenRoomEnterFailedCommand:(Command)command result:(Result)result {
    
    SGLOG(@"++++++++++互动服务连接失败(进入房间失败)");
    if (self.isReconnect) {
        return;
    }
    self.isReconnect = YES;
    WeakSelf();
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您已掉线是否重连?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"退出" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
        weakSelf.isReconnect = NO;
        [weakSelf dismiss];
    }];
    UIAlertAction *ensureAction = [UIAlertAction actionWithTitle:@"重连" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        weakSelf.isReconnect = NO;
        [weakSelf.viewModel reconnectionMeeting];
    }];
    [alert addAction:cancelAction];
    [alert addAction:ensureAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark 会议室状态通知
/// 会议室状态通知
/// @param notify 通知信息
/// @param error 错误信息
- (void)onListenRoomStateWithNotify:(RoomNotify *)notify error:(NSError *)error {
    
    SGLOG(@"++++++会议室状态通知 Notify == %@ error = %@", notify, error);
    SGLOG(@"++++++会议室锁定状态 = %@", notify.room.locked ? @"锁定" : @"解锁");
    if (self.lockedRoomButton.selected != notify.room.locked) {
        /// 设置会议室锁定按钮状态
        self.lockedRoomButton.selected = notify.room.locked;
    }
    
    NSString *roomModeTypeStr = @" 静音状态为关闭 ";
    if (notify.room.mute == MuteState_MuteDisabled) {
        roomModeTypeStr = @" 静音状态为关闭 ";
    } else if (notify.room.mute == MuteState_MuteActive) {
        roomModeTypeStr = @" 静音状态为开启 ";
    } else if (notify.room.mute == MuteState_MuteMore) {
        roomModeTypeStr = @" 超过6人自动开启静音 ";
    }
    [self.roomMuteTypeButton setTitle:roomModeTypeStr forState:UIControlStateNormal];
    
    if (notify.room.vstate != self.videoState) {
        /// 判断全局视频状态和本地的全局视频状态
        self.videoState = notify.room.vstate;
        if (self.videoState == DeviceState_DsActive) {
            /// 视频状态为开启
            self.roomVideoStateButton.selected = NO;
            [FWToastBridge showToastAction:@"视频状态变更为开启"];
        } else {
            /// 视频状态为关闭或禁用
            self.roomVideoStateButton.selected = YES;
            [FWToastBridge showToastAction:@"视频状态变更为关闭或禁用"];
        }
    }
    if (notify.room.astate != self.audioState) {
        /// 判断全局音频状态和本地的全局音频状态
        self.audioState = notify.room.astate;
        if (self.audioState == DeviceState_DsActive) {
            /// 音频状态为开启
            self.roomAudioStateButton.selected = NO;
            [FWToastBridge showToastAction:@"音频状态变更为开启"];
        } else {
            /// 音频状态为关闭或禁用
            self.roomAudioStateButton.selected = YES;
            [FWToastBridge showToastAction:@"音频状态变更为关闭或禁用"];
        }
    }
    /// 判断电子白板控制开关
    if (notify.room.sharingType == SharingType_StWhiteBoard) {
        if ([self.whiteBoardView getShowState]) {
            /// 当前白板显示状态并且接收到的指令也是显示
            return;
        }
        /// 记录当前共享的用户
        self.sharingAccountId = notify.room.sharingAccId;
        /// 读写权限
        BOOL isPrivileges = NO;
        if ([self.sharingAccountId isEqualToString:self.loginModel.data.account.id]) {
            isPrivileges = YES;
        }
        if ([VCSMeetingManager sharedManager].account.role != ConferenceRole_CrMember) {
            isPrivileges = YES;
        }
        /// 开启电子白板
        [self.whiteBoardView showView:self.enterRoomModel.data.wb_host userId:self.loginModel.data.account.id meetingId:self.enterRoomModel.data.room.no privileges:isPrivileges imageUrl:nil image:nil];
        /// 标记当前会议室内在共享电子白板
        self.isSharingWhiteBoard = YES;
    } else if (notify.room.sharingType == SharingType_StDesktop) {
        if (self.isSharingScreen) {
            /// 已经处理共享屏幕消息
            return;
        }
        /// 记录当前共享的用户
        self.sharingAccountId = notify.room.sharingAccId;
        /// 记录当前共享的码流ID
        self.sharingStreamId = notify.room.sharingStreamId;
        /// 记录当前分享者帐号SDKNO
        self.sharingSdkno = notify.room.sharingSdkno;
        /// 当前有人在共享屏幕
        [self.playerView sharingDesktop:self.sharingSdkno isSharing:YES];
        /// 切换该流的轨道播放屏幕录制码流
        [[VCSMeetingManager sharedManager] setStreamTrackWithClientId:[self.sharingSdkno intValue] mark:[self.sharingStreamId intValue] isSync:YES];
        /// 标记当前会议室内在共享屏幕
        self.isSharingScreen = YES;
    } else if (notify.room.sharingType == SharingType_StPicture) {
        if ([self.whiteBoardView getShowState]) {
            /// 当前白板显示状态并且接收到的指令也是显示
            return;
        }
        /// 记录当前共享的用户
        self.sharingAccountId = notify.room.sharingAccId;
        /// 读写权限
        BOOL isPrivileges = NO;
        if ([self.sharingAccountId isEqualToString:self.loginModel.data.account.id]) {
            isPrivileges = YES;
        }
        if ([VCSMeetingManager sharedManager].account.role != ConferenceRole_CrMember) {
            isPrivileges = YES;
        }
        
        /// 显示加载框
        [FWToastBridge showToastAction];
        /// 首先下载图片
        [[FWNetworkBridge sharedManager] downloadImageWithImageUrl:notify.room.sharingPicURL finishBlock:^(UIImage * _Nullable image) {
            if (!image) {
                /// 图片下载失败，丢弃该指令
                return;
            }
            /// 开启电子白板(图片共享)
            [self.whiteBoardView showView:self.enterRoomModel.data.wb_host userId:self.loginModel.data.account.id meetingId:self.enterRoomModel.data.room.no privileges:isPrivileges imageUrl:notify.room.sharingPicURL image:image];
            /// 隐藏加载框
            [FWToastBridge hiddenToastAction];
        }];
        /// 标记当前会议室内在共享图片
        self.isSharingPicture = YES;
    } else {
        if (self.isSharingScreen) {
            /// 切换该流的轨道播放屏幕录制码流
            [[VCSMeetingManager sharedManager] setStreamTrackWithClientId:[self.sharingSdkno intValue] mark:1 isSync:YES];
        }
        if ([self.whiteBoardView getShowState]) {
            /// 当前白板显示状态并且接收到的指令也是关闭
            [self.whiteBoardView hiddenView];
        }
        /// 当前共享屏幕关闭
        [self.playerView sharingDesktop:self.sharingSdkno isSharing:NO];
        /// 结束时分享者帐号SDKNO
        self.sharingSdkno = nil;
        /// 结束时共享屏幕的码流ID
        self.sharingStreamId = nil;
        /// 结束时当前共享的用户置空
        self.sharingAccountId = nil;
        /// 标记当前会议室内未在共享电子白板
        self.isSharingWhiteBoard = NO;
        /// 标记当前会议室内未在共享图片
        self.isSharingPicture = NO;
        /// 标记当前会议室内未在共享屏幕
        self.isSharingScreen = NO;
    }
}

#pragma mark 成员状态通知
/// 成员状态通知
/// @param notify 通知信息
/// @param error 错误信息
- (void)onListenAccountStateWithNotify:(AccountNotify *)notify error:(NSError *)error {
    
    [self.playerView playStateWithAccount:notify.account];
    SGLOG(@"++++++成员状态通 Notify == %@ error = %@", notify, error);
    /// 维护成员信息
    @synchronized (self.roomDataArray) {
        for (Account *item in self.roomDataArray) {
            if ([item.id_p isEqualToString:notify.account.id_p]) {
                /// 房间内找到该成员
                item.streamsArray = notify.account.streamsArray;
                break;
            }
        }
    }
    /// 举手提示处理
    if (notify.account.hus == HandUpStatus_HusLiftTheBan) {
        /// 解除禁言请求
        [self raiseHandClick:notify.account];
    }
}

#pragma mark 被踢出房间通知
/// 被踢出房间通知
/// @param notify 通知信息
/// @param error 错误信息
- (void)onListenKickoutWithNotify:(KickoutNotify *)notify error:(NSError *)error {
    
    /// 收到被踢通知主动退出会议室
    [FWToastBridge showToastAction:@"您已经被主持人踢出会议室"];
    [self dismiss];
    SGLOG(@"++++++被踢通知 Notify == %@ error = %@", notify, error);
}

#pragma mark 成员进入会议室通知
/// 成员进入会议室通知
/// @param notify 通知信息
/// @param error 错误信息
- (void)onListenEnterWithNotify:(EnterNotify *)notify error:(NSError *)error {
    
    /// 成员进入房间
    [self serverNotifyEnterWithAccount:notify.account];
    [self.playerView playEnterWithAccount:notify.account];
    SGLOG(@"++++++成员进入通知 Notify == %@ error = %@", notify, error);
}

#pragma mark 成员退出会议室通知
/// 成员退出会议室通知
/// @param notify 通知信息
/// @param error 错误信息
- (void)onListenExitWithNotify:(ExitNotify *)notify error:(NSError *)error {
    
    /// 成员退出通知
    [self serverNotifyLeaveWithAccount:notify.account];
    [self.playerView playLeaveWithAccount:notify.account];
    SGLOG(@"++++++成员退出通知 Notify == %@ error = %@", notify, error);
}

#pragma mark 会议开始通知
/// 会议开始通知
/// @param notify 通知信息
/// @param error 错误信息
- (void)onListenRoomBeginWithNotify:(RoomBeginNotify *)notify error:(NSError *)error {
    
    SGLOG(@"++++++会议开始通知 Notify == %@ error = %@", notify, error);
}

#pragma mark 会议结束通知
/// 会议结束通知
/// @param notify 通知信息
/// @param error 错误信息
- (void)onListenRoomEndedWithNotify:(RoomEndedNotify *)notify error:(NSError *)error {
    
    SGLOG(@"++++++会议结束通知 Notify == %@ error = %@", notify, error);
}

#pragma mark 我的状态变化通知
/// 我的状态变化通知
/// @param notify 通知信息
/// @param error 错误信息
/// @param firstNotify 是否为首次状态通知
- (void)onListenMyAccountWithNotify:(MyAccountNotify *)notify error:(NSError *)error firstNotify:(BOOL)firstNotify {
    
    SGLOG(@"++++++我的状态变化通知 Message == %@ error = %@ firstNotify = %d", notify, error, firstNotify);
    /// 自己的音频状态控制
    if (notify.account.hasAudioState) {
        if (notify.account.audioState == DeviceState_DsActive) {
            /// 音频正常状态 自己可操作 1不发送 0发送
            [[VCSMeetingManager sharedManager] enableSendAudio:DeviceState_DsActive];
            /// 设置我的音频为开启状态
            [self.playerView stepAudioState:YES];
        } else {
            /// 音频被主持人关闭 自己不可打开 自己关闭 1不发送 0发送
            [[VCSMeetingManager sharedManager] enableSendAudio:DeviceState_DsClosed];
            /// 设置我的音频为关闭状态
            [self.playerView stepAudioState:NO];
        }
    }
    
    /// 自己的视频状态控制
    if (notify.account.hasVideoState) {
        /// 当前自己在共享屏幕直接返回
        if (self.screenStatus) {
            return;
        }
        if (notify.account.videoState == DeviceState_DsActive) {
            /// 视频正常状态 自己可操作 1不发送 0发送
            [[VCSMeetingManager sharedManager] enableSendVideo:DeviceState_DsActive];
            /// 设置我的视频为开启状态
            [self.playerView stepVideoState:YES];
        } else {
            /// 视频被主持人关闭 自己不可打开 自己关闭 1不发送 0发送
            [[VCSMeetingManager sharedManager] enableSendVideo:DeviceState_DsClosed];
            /// 设置我的视频为关闭状态
            [self.playerView stepVideoState:NO];
        }
    }
}

#pragma mark 码流变化通知
/// 码流变化通知
/// @param notify 通知信息
/// @param error 错误信息
- (void)onListenStreamChangedWithNotify:(StreamNotify *)notify error:(NSError *)error {
    
    SGLOG(@"++++++码流变化通知 Notify == %@ error = %@", notify, error);
    @synchronized (self.roomDataArray) {
        if (notify.operation == Operation_OperationAdd) {
            /// 新增
            for (Account *item in self.roomDataArray) {
                if ([item.id_p isEqualToString:notify.accountId]) {
                    [item.streamsArray addObject:notify.stream];
                    break;
                }
            }
        } else if (notify.operation == Operation_OperationRemove) {
            /// 移除
            for (Account *item in self.roomDataArray) {
                if ([item.id_p isEqualToString:notify.accountId]) {
                    [item.streamsArray removeObject:notify.stream];
                    break;
                }
            }
        }
    }
}

#pragma mark 透传消息通知
/// 透传消息通知
/// @param notify 通知信息
/// @param error 错误信息
- (void)onListenPassthroughWithNotify:(PassthroughNotify *)notify error:(NSError *)error {
    
    SGLOG(@"++++++透传消息通知 Notify == %@ error = %@", notify, error);
}

#pragma mark 主持人操作码流通知
/// 主持人操作码流通知
/// @param notify 通知信息
/// @param error 错误信息
- (void)onListenHostCtrlStreamWithNotify:(HostCtrlStreamNotify *)notify error:(NSError *)error {
    
    SGLOG(@"++++++主持人操作码流通知 Notify == %@ error = %@", notify, error);
}

#pragma mark 聊天消息通知
/// 聊天消息通知
/// @param notify 通知信息
/// @param error 错误信息
- (void)onListenChatWithNotify:(ChatNotify *)notify error:(NSError *)error {
    
    SGLOG(@"++++++聊天消息通知 Notify == %@ error = %@", notify, error);
    [FWToastBridge showToast:[NSString stringWithFormat:@"%@：%@", notify.accountName, notify.message] location:@"bottom" showTime:1.5];
}

#pragma mark 举手发言的处理通知
/// 举手发言的处理通知
/// @param notify 通知信息
/// @param error 错误信息
- (void)onListenRoomRaiseHandWithNotify:(HandUpNotify *)notify error:(NSError *)error {
    
    SGLOG(@"++++++举手发言的处理通知 Notify == %@ error = %@", notify, error);
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"成员举手反馈" message:[NSString stringWithFormat:@"您的举手已被主持人%@", notify.result == 0 ? @"同意" : @"拒绝"] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
    }];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark 收回主持人通知
/// 收回主持人通知
/// @param notify 通知信息
/// @param error 错误信息
- (void)onListenRoomRecoveryHostWithNotify:(RoomRecoveryHostNotify *)notify error:(NSError *)error {
    
    SGLOG(@"++++++收回主持人通知 Notify == %@ error = %@", notify, error);
}

#pragma mark 转移主持人通知
/// 转移主持人通知
/// @param notify 通知信息
/// @param error 错误信息
- (void)onListenRoomMoveHostWithNotify:(RoomMoveHostNotify *)notify error:(NSError *)error {
    
    SGLOG(@"++++++转移主持人通知 Notify == %@ error = %@", notify, error);
}

#pragma mark 设置联席主持人通知
/// 设置联席主持人通知
/// @param notify 通知信息
/// @param error 错误信息
- (void)onListenRoomUnionHostWithNotify:(RoomUnionHostNotify *)notify error:(NSError *)error {
    
    SGLOG(@"++++++设置联席主持人通知 Notify == %@ error = %@", notify, error);
}

#pragma mark 接收聊天通知
/// 接收聊天通知
/// @param notify 通知信息
/// @param error 错误信息
- (void)onListenRoomChatEventWithNotify:(XChatEvent *)notify error:(NSError *)error {
    
    SGLOG(@"++++++接收聊天通知 Notify == %@ error = %@", notify, error);
    /// 弹出通知框
    [self sendLocalNotificationToHostAppWithTitle:@"会控聊天通知" msg:notify.message.content userInfo:nil];
}

#pragma mark 事件命令透传通知
/// 事件命令透传通知
/// @param command 消息指令
/// @param content 消息内容
- (void)onListenRoomEventWithCommand:(VCSCommandEventState)command content:(NSString *)content {
    
    SGLOG(@"事件命令透传通知-会控服务 Command = %ld content = %@", command, content);
}

#pragma mark - 处理成员举手操作
/// 处理成员举手操作
/// @param account 成员信息
- (void)raiseHandClick:(Account *)account {
    
    if (self.isRaiseHand) {
        /// 当前在处理举手操作，丢弃指令
        return;
    }
    WeakSelf();
    self.isRaiseHand = YES;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"成员举手提示" message:[NSString stringWithFormat:@"成员=%@,昵称=%@,发起了举手", account.name, account.nickname] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"同意" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
        [[VCSMeetingManager sharedManager] hostDisposeRoomRaiseHandWithTargetId:account.id_p hus:account.hus result:YES isAudience:NO];
        weakSelf.isRaiseHand = NO;
    }];
    UIAlertAction *ensureAction = [UIAlertAction actionWithTitle:@"不同意" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [[VCSMeetingManager sharedManager] hostDisposeRoomRaiseHandWithTargetId:account.id_p hus:account.hus result:NO isAudience:YES];
        weakSelf.isRaiseHand = NO;
    }];
    [alert addAction:cancelAction];
    [alert addAction:ensureAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - 收到进入房间、退出房间、踢人等人员变动通知时人员管理方法
#pragma mark 进入房间的成员进行管理
- (void)serverNotifyEnterWithAccount:(Account *)account {
    
    /// 默认此成员不存在
    BOOL isMember = NO;
    for (Account *item in self.roomDataArray) {
        if ([item.id_p isEqualToString:account.id_p]) {
            /// 已经存在了 不需要再添加
            isMember = YES; /** 已经存在了 不需要再添加 */
            break;
        }
    }
    if (!isMember) {
        /// 不存在的用户 需要进行添加
        [self.roomDataArray addObject:account];
    }
}

#pragma mark 退出房间的成员进行管理
- (void)serverNotifyLeaveWithAccount:(Account *)account {
    
    for (Account *item in self.roomDataArray) {
        if ([item.id_p isEqualToString:account.id_p]) {
            /// 房间内 还存在这个成员 删除
            [self.roomDataArray removeObject:item];
            break;
        }
    }
}

#pragma mark 当主持人踢人时对成员进行管理
- (void)serverNotifyKickoutWithAccountId:(NSString *)accountId {
    
    /// accountId=互动服务ID不能用错
    for (Account *item in self.roomDataArray) {
        if ([accountId isEqualToString:item.id_p]) {
            [self.roomDataArray removeObject:item];
            /// 有人离开房间
            [self.playerView playLeaveWithAccount:item];
            break;
        }
    }
}

#pragma mark - 发送聊天消息(测试使用，消息文本为"你也好")
- (void)sendChatMessage {
    
    /// 向所有人发送"你也好"
    [[VCSMeetingManager sharedManager] sendTextChatWithMessage:@"你也好" targetId:nil type:MessageType_MtText];
}

#pragma mark - 消息回调处理
- (void)resultBlockAction {
    
    WeakSelf();
    /// 流媒体采集回调(外部去根据流媒体ID 找到相对应的数据源 切换大小图 isMaxPlayer=YES大图 No小图)
    /// @param serverId 流媒体ID
    /// @param isMaxPlayer 切换大小图(YES-大图，NO-小图)
    self.playerView.resultBlock = ^(NSString * _Nullable serverId, BOOL isMaxPlayer) {

        dispatch_async(dispatch_get_main_queue(), ^{
            SGLOG(@"++++++流媒体采集回调 ServerID == %@, isMaxPlayer = %d", serverId, isMaxPlayer);
            @synchronized (weakSelf.roomDataArray) {
                for (Account *account in weakSelf.roomDataArray) {
                    NSString *streamId = [NSString stringWithFormat:@"%d", account.streamId];
                    if ([streamId isEqualToString:serverId]) {
                        /// 如果是同一个人 切换对应大小码流 如果不存在大码流 直接默认小码流
                        /// 默认不存在主码流
                        BOOL isMaxStream = NO;
                        /// 默认不存在录屏码流
                        BOOL isScreenStream = NO;
                        for (Stream *stream in account.streamsArray) {
                            if (stream.channelType == ChannelType_CtScreen) {
                                /// 存在录屏码流
                                [[VCSMeetingManager sharedManager] setStreamTrackWithClientId:[serverId intValue] mark:stream.id_p isSync:NO];
                                isScreenStream = YES;
                                break;
                            }
                        }
                        if (isScreenStream) {
                            [[VCSMeetingManager sharedManager] setStreamTrackWithClientId:[serverId intValue] mark:4 isSync:NO];
                        } else {
                            for (Stream *stream in account.streamsArray) {
                                if (stream.type == StreamType_StreamMain) {
                                    /// 存在主码流
                                    isMaxStream = YES;
                                    break;
                                }
                            }
                            if (isMaxPlayer && isMaxStream) {
                                /// 大图并且存在主码流
                                /// 此处需要兼容各个平台 自己根据平台类型做判断 测试大码流2适用移动端 */
                                [[VCSMeetingManager sharedManager] setStreamTrackWithClientId:[serverId intValue] mark:2 isSync:YES];
                            } else {
                                [[VCSMeetingManager sharedManager] setStreamTrackWithClientId:[serverId intValue] mark:1 isSync:YES];
                            }
                        }
                        break;
                    }
                }
            }
        });
    };
}

#pragma mark - 发送本地推送
- (void)sendLocalNotificationToHostAppWithTitle:(NSString *)title msg:(NSString *)msg userInfo:(NSDictionary *)userInfo {
    
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title = [NSString localizedUserNotificationStringForKey:title arguments:nil];
    content.body = [NSString localizedUserNotificationStringForKey:msg arguments:nil];
    content.sound = [UNNotificationSound defaultSound];
    content.userInfo = userInfo;
    
    /// 在设定时间后推送本地推送
    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:0.1f repeats:NO];
    
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"VCSDEMO" content:content trigger:trigger];
    
    /// 添加推送成功后的处理
    [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
    }];
}

#pragma mark - 获取所有滤镜
/// 获取所有滤镜
- (NSArray <FWBeautyModel *> *)getFilterData {
    
    NSArray *beautyFiltersDataSource = @[@"origin",
                                         
                                         @"bailiang1",@"bailiang2",@"bailiang3",@"bailiang4",@"bailiang5",@"bailiang6",@"bailiang7",
                                         
                                         @"fennen1",@"fennen2",@"fennen3",@"fennen4",@"fennen5",@"fennen6",
                                         
                                         @"lengsediao1",@"lengsediao2",@"lengsediao3",@"lengsediao4",@"lengsediao5",@"lengsediao6",@"lengsediao7",@"lengsediao8",@"lengsediao11",
                                         
                                         @"nuansediao1",@"nuansediao2",
                                         
                                         @"gexing1",@"gexing2",@"gexing3",@"gexing4",@"gexing5",@"gexing6",@"gexing7",@"gexing10",@"gexing11",
                                         
                                         @"heibai1",@"heibai2",@"heibai3",@"heibai4"
    ];
    
    NSDictionary *filtersCHName = @{@"origin":@"原图",
                                    
                                    @"bailiang1":@"白亮1",@"bailiang2":@"白亮2",@"bailiang3":@"白亮3",@"bailiang4":@"白亮4",@"bailiang5":@"白亮5",@"bailiang6":@"白亮6",@"bailiang7":@"白亮7",
                                    
                                    @"fennen1":@"粉嫩1",@"fennen2":@"粉嫩2",@"fennen3":@"粉嫩3",@"fennen4":@"粉嫩4",@"fennen5":@"粉嫩5",@"fennen6":@"粉嫩6",
                                    
                                    @"lengsediao1":@"冷色调1",@"lengsediao2":@"冷色调2",@"lengsediao3":@"冷色调3",@"lengsediao4":@"冷色调4",@"lengsediao5":@"冷色调5",@"lengsediao6":@"冷色调6",@"lengsediao7":@"冷色调7",@"lengsediao8":@"冷色调8",@"lengsediao9":@"冷色调9",@"lengsediao10":@"冷色调10",@"lengsediao11":@"冷色调11",
                                    
                                    @"nuansediao1":@"暖色调1",@"nuansediao2":@"暖色调2",@"nuansediao3":@"暖色调3",
                                    
                                    @"gexing1":@"个性1",@"gexing2":@"个性2",@"gexing3":@"个性3",@"gexing4":@"个性4",@"gexing5":@"个性5",@"gexing6":@"个性6",@"gexing7":@"个性7",@"gexing8":@"个性8",@"gexing9":@"个性9",@"gexing10":@"个性10",@"gexing11":@"个性11",
                                    
                                    @"heibai1":@"黑白1",@"heibai2":@"黑白2",@"heibai3":@"黑白3",@"heibai4":@"黑白4",@"heibai5":@"黑白5",
    };
    NSMutableArray *filters = [NSMutableArray array];
    
    for (NSString *str in beautyFiltersDataSource) {
        FWBeautyModel *model = [[FWBeautyModel alloc] init];
        /// 视频处理类型(滤镜)
        model.type = FWBeautyDefineFilter;
        model.titleKey = str;
        model.title = [filtersCHName valueForKey:str];
        model.value = 0.4;
        model.ratio = 1.0;
        [filters addObject:model];
    }
    
    return [NSArray arrayWithArray:filters];
}

#pragma mark - 资源释放
- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    SGLOG(@"++++++++++++释放资源：%@", kStringFromClass(self));
}

@end
