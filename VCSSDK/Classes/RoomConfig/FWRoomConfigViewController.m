//
//  FWRoomConfigViewController.m
//  VCSSDK_Example
//
//  Created by SailorGa on 2020/4/27.
//  Copyright © 2020 SailorGa. All rights reserved.
//

#import "FWRoomConfigViewController.h"
#import "FWRoomGestureViewController.h"
#import "FWRoomViewController.h"
#import "FWRoomConfigViewModel.h"
#import <VCSSDK/VCSMessage.h>
#import <VCSSDK/VCSLogin.h>
#import "FWPackageBridge.h"

/// 呼叫接收主题
#define FWReceiveTopic [NSString stringWithFormat:@"vcs/%@", [VCSLoginManager sharedManager].token]
/// 呼叫发送主题
#define FWPublishTopic [NSString stringWithFormat:@"vcs/reg/%@/%@", [VCSLoginManager sharedManager].serverId, [VCSLoginManager sharedManager].token]

@interface FWRoomConfigViewController ()

/// 房间号码
@property (weak, nonatomic) IBOutlet UITextField *roomNumberTextField;
/// AGC
@property (weak, nonatomic) IBOutlet UITextField *agcTextField;
/// AEC
@property (weak, nonatomic) IBOutlet UITextField *aecTextField;
/// 音频采样率
@property (weak, nonatomic) IBOutlet UITextField *sampeTextField;
/// 帧率
@property (weak, nonatomic) IBOutlet UITextField *fpsTextField;
/// 码率
@property (weak, nonatomic) IBOutlet UITextField *vbirateTextField;
/// 调试地址
@property (weak, nonatomic) IBOutlet UITextField *debugAddrTextField;

/// 远程调试开关
@property (weak, nonatomic) IBOutlet UIButton *debugSwitch;
/// 硬件编码开关
@property (weak, nonatomic) IBOutlet UIButton *hardwareSwitch;
/// 自己视频开关
@property (weak, nonatomic) IBOutlet UIButton *thisVideoSwitch;
/// 自己音频开关
@property (weak, nonatomic) IBOutlet UIButton *thisAudioSwitch;
/// 他人视频开关
@property (weak, nonatomic) IBOutlet UIButton *otherVideoSwitch;
/// 他人音频开关
@property (weak, nonatomic) IBOutlet UIButton *otherAudioSwitch;
/// 码率自适应开关
@property (weak, nonatomic) IBOutlet UIButton *bitRateAdaptationSwitch;
/// 延时自适应开关
@property (weak, nonatomic) IBOutlet UIButton *delayAdaptationSwitch;
/// 播放声音开关
@property (weak, nonatomic) IBOutlet UIButton *speakerAudioSwitch;

/// 提示信息
@property (weak, nonatomic) IBOutlet UILabel *promptLabel;
/// 当前ip地址
@property (weak, nonatomic) IBOutlet UILabel *ipAddrLable;

/// 开始会议按钮
@property (weak, nonatomic) IBOutlet UIButton *startMeetingButton;

/// 顶部工具按钮
@property (strong, nonatomic) UIBarButtonItem *audioEncodeSwitchItem;

/// ViewModel
@property (strong, nonatomic) FWRoomConfigViewModel *viewModel;

/// 心跳计时器
@property (nonatomic, strong) VCSTimerBridge *keepAliveTimer;

@end

@implementation FWRoomConfigViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /// 初始化UI
    [self buildView];
}

#pragma mark - 懒加载顶部HeaderView
- (UIBarButtonItem *)audioEncodeSwitchItem {
    
    if (!_audioEncodeSwitchItem) {
        _audioEncodeSwitchItem = [[UIBarButtonItem alloc] initWithTitle:@"AAC编码" style:UIBarButtonItemStylePlain target:self action:@selector(audioEncodeSwitchClick:)];
    }
    return _audioEncodeSwitchItem;
}

#pragma mark - 初始化UI
- (void)buildView {
    
    /// 设置默认数据
    /// self.roomNumberTextField.text = @"908014411";
    self.roomNumberTextField.text = @"954051420";
    self.agcTextField.text = @"10000";
    self.aecTextField.text = @"12";
    self.sampeTextField.text = @"48000";
    self.fpsTextField.text = @"25";
    self.vbirateTextField.text = @"1500*1024";
    
    /// 设置title
    self.navigationItem.title = @"入会配置";
    /// 音频编码切换按钮添加到NavigationItem中
    self.navigationItem.rightBarButtonItem = self.audioEncodeSwitchItem;
    
    /// 设置当前IP地址
    self.ipAddrLable.text = [NSString stringWithFormat:@"IP地址：%@",[[FWIPAddressBridge sharedManager] currentIpAddress]];
    
    /// 初始化ViewModel
    self.viewModel = [[FWRoomConfigViewModel alloc] init];
    /// ViewModel关联Class
    self.viewModel.viewClass = [self class];
    /// ViewModel关联登录信息
    self.viewModel.loginModel = self.loginModel;
    
    /// 绑定动态响应信号
    [self bindSignal];
    /// 调试通讯组件
    /// [self debugMessageModule];
}

#pragma mark - 绑定信号
- (void)bindSignal {
    
    @weakify(self);
    
    /// 绑定提示信息
    RAC(self.promptLabel, text) = RACObserve(self.viewModel, promptText);
    
    /// 绑定远程调试开关按钮状态
    RAC(self.debugSwitch, selected) = RACObserve(self.viewModel, isDebug);
    
    /// 绑定硬件编码开关按钮状态
    RAC(self.hardwareSwitch, selected) = RACObserve(self.viewModel, isHardware);
    
    /// 绑定自己视频开关按钮状态
    RAC(self.thisVideoSwitch, selected) = RACObserve(self.viewModel, isThisVideo);
    
    /// 绑定自己音频开关按钮状态
    RAC(self.thisAudioSwitch, selected) = RACObserve(self.viewModel, isThisAudio);
    
    /// 绑定他人视频开关按钮状态
    RAC(self.otherVideoSwitch, selected) = RACObserve(self.viewModel, isOtherVideo);
    
    /// 绑定他人音频开关按钮状态
    RAC(self.otherAudioSwitch, selected) = RACObserve(self.viewModel, isOtherAudio);
    
    /// 绑定码率自适应开关按钮状态
    RAC(self.bitRateAdaptationSwitch, selected) = RACObserve(self.viewModel, isBitRateAdaptation);
    
    /// 绑定延时自适应开关按钮状态
    RAC(self.delayAdaptationSwitch, selected) = RACObserve(self.viewModel, isDelayAdaptation);
    
    /// 绑定播放声音开关按钮状态
    RAC(self.speakerAudioSwitch, selected) = RACObserve(self.viewModel, isOpenSpeaker);
    
    /// 监听房间号码变化
    [self.roomNumberTextField.rac_textSignal subscribeNext:^(NSString * _Nullable text) {
        @strongify(self);
        self.viewModel.roomNumberText = text;
    }];
    
    /// 监听AGC变化
    [self.agcTextField.rac_textSignal subscribeNext:^(NSString * _Nullable text) {
        @strongify(self);
        self.viewModel.agcText = text;
    }];
    
    /// 监听AEC变化
    [self.aecTextField.rac_textSignal subscribeNext:^(NSString * _Nullable text) {
        @strongify(self);
        self.viewModel.aecText = text;
    }];
    
    /// 监听音频采样率变化
    [self.sampeTextField.rac_textSignal subscribeNext:^(NSString * _Nullable text) {
        @strongify(self);
        self.viewModel.sampeText = text;
    }];
    
    /// 监听帧率变化
    [self.fpsTextField.rac_textSignal subscribeNext:^(NSString * _Nullable text) {
        @strongify(self);
        self.viewModel.fpsText = text;
    }];
    
    /// 监听码率变化
    [self.vbirateTextField.rac_textSignal subscribeNext:^(NSString * _Nullable text) {
        @strongify(self);
        self.viewModel.vbirateText = text;
    }];
        
    /// 监听调试地址变化
    [self.debugAddrTextField.rac_textSignal subscribeNext:^(NSString * _Nullable text) {
        @strongify(self);
        self.viewModel.debugAddrText = text;
    }];
    
    /// 绑定远程调试开关按钮事件
    [[self.debugSwitch rac_signalForControlEvents :UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        self.viewModel.isDebug = !self.viewModel.isDebug;
    }];
    
    /// 绑定硬件编码开关按钮事件
    [[self.hardwareSwitch rac_signalForControlEvents :UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        self.viewModel.isHardware = !self.viewModel.isHardware;
    }];
    
    /// 绑定自己视频开关按钮事件
    [[self.thisVideoSwitch rac_signalForControlEvents :UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        self.viewModel.isThisVideo = !self.viewModel.isThisVideo;
    }];
    
    /// 绑定自己音频开关按钮事件
    [[self.thisAudioSwitch rac_signalForControlEvents :UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        self.viewModel.isThisAudio = !self.viewModel.isThisAudio;
    }];
    
    /// 绑定他人视频开关按钮事件
    [[self.otherVideoSwitch rac_signalForControlEvents :UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        self.viewModel.isOtherVideo = !self.viewModel.isOtherVideo;
    }];
    
    /// 绑定他人音频开关按钮事件
    [[self.otherAudioSwitch rac_signalForControlEvents :UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        self.viewModel.isOtherAudio = !self.viewModel.isOtherAudio;
    }];
    
    /// 绑定码率自适应开关按钮事件
    [[self.bitRateAdaptationSwitch rac_signalForControlEvents :UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        self.viewModel.isBitRateAdaptation = !self.viewModel.isBitRateAdaptation;
    }];
    
    /// 绑定延时自适应开关按钮事件
    [[self.delayAdaptationSwitch rac_signalForControlEvents :UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        self.viewModel.isDelayAdaptation = !self.viewModel.isDelayAdaptation;
    }];
    
    /// 绑定播放声音开关按钮事件
    [[self.speakerAudioSwitch rac_signalForControlEvents :UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        self.viewModel.isOpenSpeaker = !self.viewModel.isOpenSpeaker;
    }];
    
    /// 绑定开始会议按钮事件
    [[self.startMeetingButton rac_signalForControlEvents :UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        /// 开始会议事件处理
        [self.viewModel startMeeting];
    }];
    
    /// 进入房间请求订阅
    [self.viewModel.enterRoomSubject subscribeNext:^(id _Nullable meetingParam) {
        @strongify(self);
        /// 进入房间成功
        [self enterRoomSucceed:meetingParam];
    }];
}

#pragma mark - 登录成功处理
- (void)enterRoomSucceed:(VCSMeetingParam *)meetingParam {
    
    /// 跳转会议页面
    FWRoomViewController *roomVC = [[FWRoomViewController alloc] init];
    roomVC.meetingParam = self.viewModel.meetingParam;
    roomVC.enterRoomModel = self.viewModel.enterRoomModel;
    roomVC.loginModel = self.viewModel.loginModel;
    [self.navigationController pushViewController:roomVC animated:YES];
    
//    /// 跳转会议页面
//    FWRoomGestureViewController *roomVC = [[FWRoomGestureViewController alloc] init];
//    roomVC.meetingParam = self.viewModel.meetingParam;
//    roomVC.enterRoomModel = self.viewModel.enterRoomModel;
//    roomVC.loginModel = self.viewModel.loginModel;
//    [self.navigationController pushViewController:roomVC animated:YES];
}

#pragma mark - 音频编码模式切换事件
- (void)audioEncodeSwitchClick:(UIBarButtonItem *)sender {
    
    /// 修改viewModel音频编码模式
    self.viewModel.isAudioEncodeAac = !self.viewModel.isAudioEncodeAac;
    /// 修改按钮显示标题
    [sender setTitle:self.viewModel.isAudioEncodeAac ? @"AAC编码" : @"OPUS编码"];
}


#pragma mark - ------------ 通讯组件使用示例 ------------
#pragma mark 调试通讯组件
/// 调试通讯组件
- (void)debugMessageModule {
    
    WeakSelf();
    /// 取消订阅主题
    [[VCSMessageManager sharedInstance] unsubscribeMessageWithTopic:FWReceiveTopic resultBlock:^(NSError * _Nonnull error) {
        /// 添加连接状态改变监听
        [weakSelf appendChangeState];
        /// 订阅主题
        [weakSelf subscribeTopic];
        /// 启动心跳
        [weakSelf onHeartBeat];
    }];
}

#pragma mark 添加连接状态改变监听
/// 添加连接状态改变监听
- (void)appendChangeState {
    
    WeakSelf();
    /// 设置连接状态回调
    [[VCSMessageManager sharedInstance] setChangeStateBlock:^(SGMQTTSessionManagerState state) {
        SGLOG(@"调试日志 连接状态变化回调 state = %d", state);
        /// 重连成功时，需要重新订阅主题
        if (state == SGMQTTSessionManagerStateConnected) {
            /// 调试通讯组件
            [weakSelf debugMessageModule];
        }
    }];
}

#pragma mark 订阅主题
/// 订阅主题
- (void)subscribeTopic {
    
    WeakSelf();
    /// 订阅主题
    [[VCSMessageManager sharedInstance] subscribeMessageWithTopic:FWReceiveTopic qosLevel:SGMQTTQosLevelExactlyOnce resultBlock:^(NSError * _Nonnull error) {
        if (error) {
            /// 订阅主题失败(尝试再次订阅接收主题)
            [weakSelf subscribeTopic];
        } else {
            /// 订阅主题成功(开启发送心跳消息)
            [weakSelf sendHeartBeat];
        }
    } receiveDataBlock:^(NSData * _Nonnull data, NSString * _Nonnull topic) {
        /// 接收到消息
        [weakSelf serveReceiveData:data topic:topic];
    }];
}

#pragma mark 接收到消息
/// 接收到消息
/// @param data 消息体
/// @param topic 订阅主题
/// @param retained 保留字段
- (void)serveReceiveData:(NSData *)data topic:(NSString *)topic {
    
    /// 解析指定主题消息
    if (![topic isEqualToString:FWReceiveTopic]) {
        return;
    }
    
    /// type 可参照会议中 PacketType 声明使用
    /// command 可参照会议中 Command 声明使用
    /// result 可参照会议中 Result 声明使用
    [FWPackageBridge receiveSocketData:data resultBlock:^(int type, int command, int result, NSData * _Nonnull data) {
        SGLOG(@"调试日志 接收到服务端消息 topic = %@", topic);
    }];
}

#pragma mark 启动心跳
/// 启动心跳
- (void)onHeartBeat {
    
    /// 销毁计时器
    [self closeInternal];
    
    WeakSelf();
    /// 10秒钟发送一次心跳
    self.keepAliveTimer = [VCSTimerBridge scheduledTimerWithTimeInterval:10.0 inmilli:NO repeats:YES queue:dispatch_get_main_queue() block:^{
        /// 发送心跳消息
        [weakSelf sendHeartBeat];
    }];
}

#pragma mark 发送心跳消息
/// 发送心跳消息
- (void)sendHeartBeat {
    
    /// 构建心跳消息数据
    NSData *heartData = [FWPackageBridge sendHeartBeatWithToken:[VCSLoginManager sharedManager].token accountId:self.loginModel.data.account.id];
    /// 发送数据消息
    [self publishWithData:heartData topic:FWPublishTopic];
}

#pragma mark 发送数据消息
/// 发送数据消息
/// - Parameters:
///   - data: 消息体
///   - topic: 目标主题
- (void)publishWithData:(NSData *)data topic:(NSString *)topic {
    
    /// 发送数据
    [[VCSMessageManager sharedInstance] publishMessageWithTopic:topic qosLevel:SGMQTTQosLevelExactlyOnce data:data resultBlock:^(NSError * _Nonnull error) {
        if (error) {
            SGLOG(@"调试日志 客户端消息发送失败 error = %@", error);
        } else {
            SGLOG(@"调试日志 客户端消息发送成功");
        }
    }];
}

#pragma mark 销毁计时器
/// 销毁计时器
- (void)closeInternal {
    
    /// 关闭心跳计时器
    if (self.keepAliveTimer) {
        /// 释放计时器
        [self.keepAliveTimer invalidate];
        /// 置空计时器
        self.keepAliveTimer = nil;
    }
}


#pragma mark - 资源释放
- (void)dealloc {
    
    /// 取消订阅主题
    [[VCSMessageManager sharedInstance] unsubscribeMessageWithTopic:FWReceiveTopic resultBlock:nil];
    /// 销毁计时器
    [self closeInternal];
    /// 调试日志
    SGLOG(@"++++++++++++释放资源：%@", kStringFromClass(self));
}

@end
