//
//  FWMQTTClientViewController.m
//  VCSSDK_Example
//
//  Created by SailorGa on 2021/3/15.
//  Copyright © 2021 SailorGa. All rights reserved.
//

#import "FWMQTTClientViewController.h"
#import "FWMQTTClientViewModel.h"
#import "FWMQTTClientBridge.h"
#import <UserNotifications/UserNotifications.h>
#import <SDWebImage/SDWebImage-umbrella.h>
#import "TZImagePickerController.h"
#import <VCSSDK/VCSAudio.h>

@interface FWMQTTClientViewController ()<VCSAudioManagerProtocol>

/// 房间ID
@property (weak, nonatomic) IBOutlet UITextField *roomTextField;
/// 用户ID
@property (weak, nonatomic) IBOutlet UITextField *userTextField;
/// 提示信息
@property (weak, nonatomic) IBOutlet UILabel *promptLabel;
/// 发起邀请
@property (weak, nonatomic) IBOutlet UIButton *inviteConfirmButton;
/// 上报通话状态
@property (weak, nonatomic) IBOutlet UIButton *callStatusButton;
/// 发起呼叫
@property (weak, nonatomic) IBOutlet UIButton *callButton;
/// 取消呼叫
@property (weak, nonatomic) IBOutlet UIButton *callCancelButton;

/// 发送文本消息
@property (weak, nonatomic) IBOutlet UIButton *publishTextButton;
/// 发送图片消息
@property (weak, nonatomic) IBOutlet UIButton *publishImageButton;
/// 发送语音消息
@property (weak, nonatomic) IBOutlet UIButton *publishVoiceButton;
/// 录制音量显示组件
@property (weak, nonatomic) IBOutlet UIView *recorderView;
/// 录制音量显示图片
@property (weak, nonatomic) IBOutlet UIImageView *recorderImageView;

/// 接收到的图片
@property (weak, nonatomic) IBOutlet UIImageView *receiveImageView;

/// 返回按钮
@property (strong, nonatomic) UIBarButtonItem *gobackItem;

/// 呼叫用户状态结构
@property (strong, nonatomic) WaitingAccount *selfAccount;
/// 呼叫用户状态结构
@property (strong, nonatomic) WaitingAccount *waitingAccount;
/// 呼叫列表
@property (strong, nonatomic) NSMutableArray *callDataArray;

/// 录音文件路径
@property (nonatomic, strong) NSString *filePath;

/// ViewModel
@property (strong, nonatomic) FWMQTTClientViewModel *viewModel;

@end

@implementation FWMQTTClientViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    /// 初始化UI
    [self buildView];
}

#pragma mark - 懒加载返回按钮
- (UIBarButtonItem *)gobackItem {
    
    if (!_gobackItem) {
        _gobackItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"icon_common_goback"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(gobackItemClick)];
    }
    return _gobackItem;
}

#pragma mark - 懒加载呼叫用户状态结构
- (WaitingAccount *)waitingAccount {
    
    if (!_waitingAccount) {
        _waitingAccount = [[WaitingAccount alloc] init];
        _waitingAccount.callId = [[FWToolHelper sharedManager] getUniqueIdentifier];
        /// 15606946786 - b2a04ab737cd4ea98e8088254ff05066
        /// 15606946788 - bfc5d971f0a1452c8a3935e521a2d550
        /// 15606946788 - fdf64b937faf4f5f9e41a34a39510d76
        _waitingAccount.id_p = @"fdf64b937faf4f5f9e41a34a39510d76";
        _waitingAccount.name = @"15606946788";
        _waitingAccount.nickname = @"15606946788";
        _waitingAccount.portrait = @"http://crazy.image.alimmdn.com/iSaior/14878273006128.png";
        _waitingAccount.roomNo = self.viewModel.roomText;
        _waitingAccount.status = InviteStatus_Waiting;
        _waitingAccount.callType = 3;
        _waitingAccount.roomPwd = @"abc@12345";
    }
    return _waitingAccount;
}

#pragma mark - 懒加载呼叫用户状态结构
- (WaitingAccount *)selfAccount {
    
    if (!_selfAccount) {
        _selfAccount = [[WaitingAccount alloc] init];
        _selfAccount.callId = [[FWToolHelper sharedManager] getUniqueIdentifier];
        /// 15606946786 - b2a04ab737cd4ea98e8088254ff05066
        /// 15606946788 - bfc5d971f0a1452c8a3935e521a2d550
        /// 15606946788 - 60165d81b9df4b5194e9acb97183ee3c
        _selfAccount.id_p = self.loginModel.data.account.id;
        _selfAccount.name = self.loginModel.data.account.name;
        _selfAccount.nickname = self.loginModel.data.account.nickname;
        _selfAccount.portrait = @"http://crazy.image.alimmdn.com/iSaior/14878273006128.png";
        _selfAccount.roomNo = self.viewModel.roomText;
        _selfAccount.status = InviteStatus_Waiting;
        _selfAccount.callType = 3;
        _selfAccount.roomPwd = @"abc@12345";
    }
    return _selfAccount;
}

#pragma mark - 懒加载房间内成员
- (NSMutableArray *)callDataArray {
    
    if (!_callDataArray) {
        _callDataArray = [[NSMutableArray alloc] init];
        [_callDataArray addObject:self.waitingAccount];
    }
    return _callDataArray;
}

#pragma mark - 初始化UI
- (void)buildView {
    
    /// 连接呼叫服务
    [[FWMQTTClientBridge sharedManager] startNetCallWithLoginModel:self.loginModel];
    
    /// 设置title
    self.navigationItem.title = @"MQTT呼叫服务";
    
    /// 设置默认数据
    self.roomTextField.text = @"915606946786";
    self.userTextField.text = self.loginModel.data.account.mobile;
    
    /// 获取录音文件保存路径
    self.filePath = [VCSAudioFileBridge audioDefaultFilePath:nil];
    
    /// 初始化ViewModel
    self.viewModel = [[FWMQTTClientViewModel alloc] init];
    /// ViewModel关联Class
    self.viewModel.viewClass = [self class];
    
    /// 设置左侧操作按钮
    [self setupLeftBarItems];
    /// 绑定动态响应信号
    [self bindSignal];
    /// 监听呼叫服务广播回调
    [self onListenNetCall];
}

#pragma mark - 设置左侧操作按钮
- (void)setupLeftBarItems {
    
    /// 添加到NavigationItem
    self.navigationItem.leftBarButtonItem = self.gobackItem;
}

#pragma mark - 退出事件
/// 退出事件
- (void)gobackItemClick {
    
    /// 停止并释放录音服务
    [[VCSAudioManager sharedManager] destroy];
    /// 停止并释放呼叫服务
    [[FWMQTTClientBridge sharedManager] stop];
    /// 退出页面
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 绑定信号
- (void)bindSignal {
    
    @weakify(self);
    
    /// 绑定提示信息
    RAC(self.promptLabel, text) = RACObserve(self.viewModel, promptText);
    
    /// 房间ID
    [self.roomTextField.rac_textSignal subscribeNext:^(NSString * _Nullable text) {
        @strongify(self);
        self.viewModel.roomText = text;
    }];
    
    /// 用户ID
    [self.userTextField.rac_textSignal subscribeNext:^(NSString * _Nullable text) {
        @strongify(self);
        self.viewModel.userText = text;
    }];
    
    /// 上传请求订阅
    [self.viewModel.uploadSubject subscribeNext:^(NSNumber * _Nullable value) {
        @strongify(self);
        /// 上传成功处理消息发送
        switch (value.integerValue) {
            case FWUserUploadFileStatePicture:
                /// 发送图片消息
                [self publishImageClick:self.viewModel.uploadModel.data.url];
                break;
            case FWUserUploadFileStateAudio:
                /// 发送语音消息
                [self publishAudioClick:self.viewModel.uploadModel.data.url];
                break;
            default:
                break;
        }
    }];
    
    /// 绑定发起邀请按钮事件
    [[self.inviteConfirmButton rac_signalForControlEvents :UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        /// 发起邀请
        [[FWMQTTClientBridge sharedManager] inviteWithRoomNo:self.viewModel.roomText targetId:self.viewModel.userText];
    }];
    
    /// 绑定上报自己的通话状态按钮事件
    [[self.callStatusButton rac_signalForControlEvents :UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        /// 构建成员信息
        WaitingAccount *account = [[WaitingAccount alloc] init];
        account.id_p = self.loginModel.data.account.id;
        account.name = @"Sailor";
        account.nickname = @"SailorGa";
        account.portrait = @"http://crazy.image.alimmdn.com/iSaior/14878273006128.png";
        account.roomNo = self.viewModel.roomText;
        account.status = InviteStatus_Waiting;
        account.callType = 3;
        account.roomPwd = @"abc@12345";
        /// 更新帐户信息
        [[FWMQTTClientBridge sharedManager] updateWaitingAccountInfo:account];
    }];
    
    /// 绑定发起呼叫按钮事件
    [[self.callButton rac_signalForControlEvents :UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        for (WaitingAccount *account in self.callDataArray) {
            account.status = InviteStatus_Waiting;
        }
        /// 发起呼叫
        [[FWMQTTClientBridge sharedManager] callWithAccountsArray:self.callDataArray currentMember:self.selfAccount roomNo:self.viewModel.roomText restart:YES role:ConferenceRole_CrMember];
    }];
    
    /// 绑定取消呼叫按钮事件
    [[self.callCancelButton rac_signalForControlEvents :UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        for (WaitingAccount *account in self.callDataArray) {
            account.status = InviteStatus_Canceled;
        }
        /// 取消呼叫
        [[FWMQTTClientBridge sharedManager] callCancelNewWithAccountsArray:self.callDataArray roomNo:self.viewModel.roomText];
    }];
    
    /// 绑定发送文本消息按钮事件
    [[self.publishTextButton rac_signalForControlEvents :UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        /// 发送文本消息
        [self publishTextClick];
    }];
    
    /// 绑定发送图片消息按钮事件
    [[self.publishImageButton rac_signalForControlEvents :UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        /// 图片选择器
        [self showImagePicker];
    }];
    
    /// 绑定发送语音消息按钮事件(按下事件)
    [[self.publishVoiceButton rac_signalForControlEvents :UIControlEventTouchDown] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        /// 开启录制
        [self startRecording];
    }];
    
    /// 绑定发送语音消息按钮事件(抬起事件)
    [[self.publishVoiceButton rac_signalForControlEvents :UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        /// 停止录制
        [self stopRecording];
    }];
    
    /// 绑定发送语音消息按钮事件(拖动事件)
    [[self.publishVoiceButton rac_signalForControlEvents :UIControlEventTouchDragExit] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        /// 停止录制
        [self stopRecording];
    }];
}

#pragma mark - 图片选择器
/// 图片选择器
- (void)showImagePicker {
    
    TZImagePickerController *imagePickerVC = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:nil];
    /// 禁止选视频
    imagePickerVC.allowPickingVideo = NO;
    [imagePickerVC setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        /// 上传图片
        [self.viewModel uploadFileWithFileData:UIImageJPEGRepresentation(photos.firstObject, 0.5) state:FWUserUploadFileStatePicture];
    }];
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

#pragma mark - 发送文本消息
/// 发送文本消息
- (void)publishTextClick {
    
    /// 你好
    [[FWMQTTClientBridge sharedManager] sendTextWithMessage:@"你好呀" receiverID:self.loginModel.data.account.id];
}

#pragma mark - 发送图片消息
/// 发送图片消息
/// @param imagePath 图片地址
- (void)publishImageClick:(NSString *)imagePath {
    
    /// @"http://crazy.image.alimmdn.com/iSaior/14878273006128.png"
    [[FWMQTTClientBridge sharedManager] sendImageWithImagePath:imagePath receiverID:self.loginModel.data.account.id];
}

#pragma mark - 发送语音消息
/// 发送语音消息
/// @param audioPath 音频地址
- (void)publishAudioClick:(NSString *)audioPath {
    
    /// @"http://download.lingyongqian.cn//music//ForElise.mp3"
    [[FWMQTTClientBridge sharedManager] sendAudioWithAudioPath:audioPath receiverID:self.loginModel.data.account.id];
}

#pragma mark - 开启录制
/// 开启录制
- (void)startRecording {
    
    if (kStringIsEmpty(self.filePath)) {
        [FWToastBridge showToastAction:@"录制文件地址为空"];
        return;
    }
    /// 设置录制代理
    [VCSAudioManager sharedManager].audioRecorder.delegate = self;
    /// 设置监测录音音量
    [VCSAudioManager sharedManager].audioRecorder.monitorVolume = YES;
    /// 录音限制时长设置为0(不限制时长)
    [VCSAudioManager sharedManager].audioRecorder.totalTime = 0;
    /// 开启录制
    [[VCSAudioManager sharedManager].audioRecorder recorderStartWithFilePath:self.filePath complete:^(BOOL isFailed) {
        if (isFailed) {
            [FWToastBridge showToastAction:@"音频文件地址无效，录制失败"];
        }
    }];
}

#pragma mark - 停止录制
/// 停止录制
- (void)stopRecording {
    
    if (kStringIsEmpty(self.filePath)) {
        [FWToastBridge showToastAction:@"录制文件地址为空"];
        return;
    }
    /// 停止录制
    [[VCSAudioManager sharedManager].audioRecorder recorderStop];
}

#pragma mark - 请求录制音频信息
/// 请求录制音频信息
- (void)requestRecorderAudio {
    
    /// 设置Session为AVAudioSessionCategoryPlayback用于播放
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    /// 获取音频信息
    [VCSAudioFileBridge audioGetFileAudioInfoWithFilePath:self.filePath result:^(NSString * _Nullable fileName, long long fileSize, NSTimeInterval fileTime, NSString * _Nullable filePath, NSData * _Nullable audioData) {
        /// 输出日志
        SGLOG(@"++++++++++++录制文件路径 = %@, 录制文件大小 = %lld, 录制录音时长 = %.2fs", fileName, fileSize, fileTime);
        /// 上传音频
        [self.viewModel uploadFileWithFileData:audioData state:FWUserUploadFileStateAudio];
    }];
}

#pragma mark - 监听呼叫服务广播回调
- (void)onListenNetCall {
    
    WeakSelf();
    
    /// 呼叫服务邀请入会通知回调
    [[FWMQTTClientBridge sharedManager] inviteBlock:^(InviteNotification * _Nonnull notify) {
        SGLOG(@"++++++++++++邀请入会通知 = %@", notify);
        [weakSelf sendLocalNotificationToHostAppWithTitle:@"MQTT呼叫服务" msg:@"邀请入会通知" userInfo:nil];
    }];
    
    /// 呼叫服务邀请入会确认通知回调
    [[FWMQTTClientBridge sharedManager] inviteConfirmBlock:^(InviteConfirm * _Nonnull notify) {
        SGLOG(@"++++++++++++邀请入会确认通知 = %@", notify);
        [weakSelf sendLocalNotificationToHostAppWithTitle:@"MQTT呼叫服务" msg:@"邀请入会确认通知" userInfo:nil];
    }];
    
    /// 呼叫服务成员的通话状态通知回调
    [[FWMQTTClientBridge sharedManager] accountCallStatusBlock:^(WaitingRoomBroadcast * _Nonnull notify) {
        SGLOG(@"++++++++++++成员邀请状态通知 = %@", notify);
        [weakSelf sendLocalNotificationToHostAppWithTitle:@"MQTT呼叫服务" msg:@"成员的通话状态通知" userInfo:nil];
    }];
    
    /// 呼叫服务自己的通话状态通知回调
    [[FWMQTTClientBridge sharedManager] myAccountCallStatusBlock:^(WaitingRoomUpdate * _Nonnull notify) {
        SGLOG(@"++++++++++++自己的通话状态通知 = %@", notify);
        [weakSelf sendLocalNotificationToHostAppWithTitle:@"MQTT呼叫服务" msg:@"自己的通话状态通知" userInfo:nil];
    }];
    
    /// 呼叫服务应用内推送通知回调
    [[FWMQTTClientBridge sharedManager] inAppPushNotificationBlock:^(PushNotification * _Nonnull notify) {
        SGLOG(@"++++++++++++应用内推送通知 = %@", notify);
        [weakSelf sendLocalNotificationToHostAppWithTitle:@"MQTT呼叫服务" msg:@"应用内推送通知" userInfo:nil];
    }];
    
    /// 呼叫服务聊天消息通知回调
    [[FWMQTTClientBridge sharedManager] chatNotificationBlock:^(RegChatNotify * _Nonnull notify) {
        SGLOG(@"++++++++++++聊天消息通知 = %@", notify);
        switch (notify.imBody.type) {
                /// 文本消息
            case MessageType_MtText: {
                [weakSelf sendLocalNotificationToHostAppWithTitle:@"MQTT呼叫服务" msg:@"聊天消息通知(文本消息)" userInfo:nil];
                /// IM聊天接收到文本消息
                [weakSelf imReceiveChatText:notify.imBody.message];
            }
                break;
                /// 图片消息
            case MessageType_MtPicture: {
                [weakSelf sendLocalNotificationToHostAppWithTitle:@"MQTT呼叫服务" msg:@"聊天消息通知(图片消息)" userInfo:nil];
                /// IM聊天接收到图片消息
                [weakSelf imReceiveChatImagePath:notify.imBody.message];
            }
                break;
                /// 语音消息
            case MessageType_MtAudio: {
                [weakSelf sendLocalNotificationToHostAppWithTitle:@"MQTT呼叫服务" msg:@"聊天消息通知(语音消息)" userInfo:nil];
                /// IM聊天接收到语音消息
                [weakSelf imReceiveChatAudioPath:notify.imBody.message];
            }
                break;
            default:
                break;
        }
    }];
}

#pragma mark - IM聊天接收到文本消息
/// IM聊天接收到文本消息
/// @param message 文本消息
- (void)imReceiveChatText:(NSString *)message {
    
    if (kStringIsEmpty(message)) {
        [FWToastBridge showToastAction:@"接收文本数据为空"];
        return;
    }
    self.viewModel.promptText = message;
}

#pragma mark - IM聊天接收到图片消息
/// IM聊天接收到图片消息
/// @param imagePath 图片地址
- (void)imReceiveChatImagePath:(NSString *)imagePath {
    
    if (kStringIsEmpty(imagePath)) {
        [FWToastBridge showToastAction:@"接收图片数据为空"];
        return;
    }
    [self.receiveImageView sd_setImageWithURL:[[FWToolHelper sharedManager] placeImg:imagePath] placeholderImage:nil];
}

#pragma mark - IM聊天接收到语音消息
/// IM聊天接收到语音消息
/// @param audioPath 语音地址
- (void)imReceiveChatAudioPath:(NSString *)audioPath {
    
    if (kStringIsEmpty(audioPath)) {
        [FWToastBridge showToastAction:@"接收音频数据为空"];
        return;
    }
    /// 设置播放代理
    [VCSAudioManager sharedManager].audioPlayer.delegate = self;
    /// 开始播放
    [[VCSAudioManager sharedManager].audioPlayer playerStartWithFilePath:audioPath complete:^(BOOL isFailed) {
        if (isFailed) {
            [FWToastBridge showToastAction:@"音频文件地址无效，播放失败"];
        }
    }];
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

#pragma mark - -------- VCSAudioManagerProtocol代理方法 ---------
#pragma mark 开始录制
/// 开始录音
- (void)recordBegined {
    
    /// 录制音频按钮设置选中
    self.publishVoiceButton.selected = YES;
    /// 录制音量显示组件显示
    self.recorderView.hidden = NO;
}

#pragma mark 录制完成
/// 录制完成
- (void)recordFinshed {
    
    /// 录制音频按钮设置非选中
    self.publishVoiceButton.selected = NO;
    /// 录制音量显示组件隐藏
    self.recorderView.hidden = YES;
    /// 请求录制音频信息
    [self requestRecorderAudio];
}

#pragma mark 正在录音中，录音音量监测
/// 正在录音中，录音音量监测
/// @param volume 音量
- (void)recordingVoiceWithVolume:(double)volume {
    
    if (0 < volume <= 0.06) {
        [self.recorderImageView setImage:kGetImage(@"icon_record_animate_01.png")];
    } else if (0.06 < volume <= 0.13) {
        [self.recorderImageView setImage:kGetImage(@"icon_record_animate_02.png")];
    } else if (0.13 < volume <= 0.20) {
        [self.recorderImageView setImage:kGetImage(@"icon_record_animate_03.png")];
    } else if (0.20 < volume <= 0.27) {
        [self.recorderImageView setImage:kGetImage(@"icon_record_animate_04.png")];
    } else if (0.27 < volume <= 0.34) {
        [self.recorderImageView setImage:kGetImage(@"icon_record_animate_05.png")];
    } else if (0.34 < volume <= 0.41) {
        [self.recorderImageView setImage:kGetImage(@"icon_record_animate_06.png")];
    } else if (0.41 < volume <= 0.48) {
        [self.recorderImageView setImage:kGetImage(@"icon_record_animate_07.png")];
    } else if (0.48 < volume <= 0.55) {
        [self.recorderImageView setImage:kGetImage(@"icon_record_animate_08.png")];
    } else if (0.55 < volume <= 0.62) {
        [self.recorderImageView setImage:kGetImage(@"icon_record_animate_09.png")];
    } else if (0.62 < volume <= 0.69) {
        [self.recorderImageView setImage:kGetImage(@"icon_record_animate_10.png")];
    } else if (0.69 < volume <= 0.76) {
        [self.recorderImageView setImage:kGetImage(@"icon_record_animate_11.png")];
    } else if (0.76 < volume <= 0.83) {
        [self.recorderImageView setImage:kGetImage(@"icon_record_animate_12.png")];
    } else if (0.83 < volume <= 0.9) {
        [self.recorderImageView setImage:kGetImage(@"icon_record_animate_13.png")];
    } else {
        [self.recorderImageView setImage:kGetImage(@"icon_record_animate_14.png")];
    }
}

#pragma mark 开始播放音频
/// 开始播放音频
/// @param state 状态(加载中、加载失败、加载成功正在播放、未知)
/// @param playerItem 播放载体
- (void)audioPlayBeginedWithState:(AVPlayerItemStatus)state playerItem:(AVPlayerItem *)playerItem {
    
    SGLOG(@"++++++++++++开始播放音频状态 = %ld 错误码 = %@", state, playerItem.error);
}

#pragma mark 正在播放音频
/// 正在播放音频
/// @param totalTime 总时长
/// @param currentTime 当前时长
- (void)audioPlayingWithTotalTime:(NSTimeInterval)totalTime time:(NSTimeInterval)currentTime {
    
    SGLOG(@"++++++++++++正在播放, 播放总时长 = %f 当前播放时间 = %f", totalTime, currentTime);
}

#pragma mark 音频播放完成
/// 音频播放完成
- (void)audioPlayFinished {
    
    SGLOG(@"++++++++++++播放完成");
}

#pragma mark - 资源释放
- (void)dealloc {
    
    SGLOG(@"++++++++++++释放资源：%@", kStringFromClass(self));
}

@end
