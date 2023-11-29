//
//  FWCastingBridge.m
//  VCSSDK_Example
//
//  Created by SailorGa on 2023/4/20.
//  Copyright © 2023 SailorGa. All rights reserved.
//

#import "FWCastingBridge.h"
#import <VCSSDK/VCSSDK.h>

@interface FWCastingBridge () <VCSCastingManagerDelegate>

/// 当前投屏状态
@property (nonatomic, assign) VCSCastingStatus castingStatus;
/// 当前屏幕录制状态
@property (nonatomic, assign) VCSCastingScreenStatus screenStatus;
/// 屏幕录制组件
@property (strong, nonatomic) RPSystemBroadcastPickerView *broadcastPickerView;
/// 发送延时通知回调
@property (copy, nonatomic) FWCastingBridgeDelayedBlock delayedBlock;
/// 发送信息通知回调
@property (copy, nonatomic) FWCastingBridgeSendBlock sendBlock;

@end

@implementation FWCastingBridge

#pragma mark - 获取投屏单例
/// 获取投屏单例
+ (FWCastingBridge *)sharedManager {
    
    static FWCastingBridge *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        manager = [[FWCastingBridge alloc] init];
    });
    return manager;
}

#pragma mark 对象初始化
/// 对象初始化
- (instancetype)init {
    
    self = [super init];
    if (self) {
        /// 恢复默认投屏状态
        self.castingStatus = VCSCastingStatusNormal;
        /// 恢复默认屏幕录制状态
        self.screenStatus = VCSCastingScreenStatusNormal;
    }
    return self;
}

#pragma mark - 屏幕录制组件
- (RPSystemBroadcastPickerView *)broadcastPickerView API_AVAILABLE(ios(12.0)) {
    
    if (!_broadcastPickerView) {
        _broadcastPickerView = [[RPSystemBroadcastPickerView alloc] init];
        _broadcastPickerView.preferredExtension = @"cn.seastart.vcsdemo.replayBroadcastUpload";
        _broadcastPickerView.showsMicrophoneButton = NO;
        _broadcastPickerView.hidden = YES;
    }
    return _broadcastPickerView;
}

#pragma mark - 配置投屏参数
/// 配置投屏参数
/// - Parameters:
///   - mediaConfig: 配置参数
- (void)setupCastingConfig:(VCSCastingMediaConfig *)mediaConfig {
    
    if ([VCSMeetingManager sharedManager].enterRoom) {
        /// 当前正在会议中，结束此次投屏操作
        [FWToastBridge showToastAction:@"当前正在会议中，请先退出当前会议再尝试投屏。"];
        return;
    }
    
    if (self.screenStatus == VCSCastingScreenStatusStart) {
        /// 停止投屏二次确认
        [self stopCastingAlert];
        /// 结束此次调用
        return;
    }
    
    /// 配置投屏参数
    [[VCSCastingManager sharedInstance] setupCastingConfig:mediaConfig appGroup:VCSAPPGROUP delegate:self];
    /// 显示选择器视图
    [self showBroadcastPicker];
}

#pragma mark - 启动投射音频
/// 启动投射音频
/// - Parameter enable: YES-启用 NO-关闭
- (void)enableCastingAudio:(BOOL)enable {
    
    /// 启动投射音频
    [[VCSCastingManager sharedInstance] enableCastingAudio:enable];
}

#pragma mark - 停止投屏再次确认
/// 停止投屏再次确认
- (void)stopCastingAlert {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"确定要停止投屏吗？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
    }];
    UIAlertAction *ensureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        /// 停止投屏
        [[VCSCastingManager sharedInstance] stopCasting];
    }];
    [alert addAction:cancelAction];
    [alert addAction:ensureAction];
    [[UIApplication sharedApplication].delegate.window.rootViewController presentViewController:alert animated:YES completion:nil];
}

#pragma mark - 显示选择器视图
/// 显示选择器视图
- (void)showBroadcastPicker {
    
    /// 将事件传递给开启录制按钮
    for (UIView *view in self.broadcastPickerView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            [(UIButton *)view sendActionsForControlEvents:UIControlEventTouchDown | UIControlEventTouchUpInside];
        }
    }
}

#pragma mark - ------- VCSCastingManagerDelegate代理实现 -------
#pragma mark 屏幕录制状态回调
/// 屏幕录制状态回调
/// @param status 状态码
- (void)onScreenRecordStatus:(VCSCastingScreenStatus)status {
    
    /// 记录当前共享屏幕状态
    self.screenStatus = status;
    
    /// 提示操作信息
    NSString *toastStr = @"连接错误";
    switch (status) {
        case VCSCastingScreenStatusError:
            toastStr = @"连接错误";
            break;
        case VCSCastingScreenStatusStop:
            toastStr = @"已经停止";
            break;
        case VCSCastingScreenStatusStart:
            toastStr = @"已经开始";
            break;
        default:
            break;
    }
    SGLOG(@"屏幕录制状态 = %@", toastStr);
}

#pragma mark 投屏状态回调
/// 投屏状态回调
/// @param status 状态码
/// @param reason 拒绝原因
- (void)onCastingScreenStatus:(VCSCastingStatus)status reason:(nullable NSString *)reason {
    
    /// 记录当前投屏状态
    self.castingStatus = status;
    
    /// 提示操作信息
    NSString *toastStr = @"默认状态";
    switch (status) {
        case VCSCastingStatusNormal:
            toastStr = @"默认状态";
            break;
        case VCSCastingStatusAccept:
            toastStr = @"允许投屏";
            break;
        case VCSCastingStatusRefuse:
            toastStr = @"拒绝投屏";
            break;
        case VCSCastingStatusFailed:
            toastStr = @"投屏失败";
            break;
        default:
            break;
    }
    SGLOG(@"投屏状态 = %@", toastStr);
}

#pragma mark 发送状态信息回调
/// 发送状态信息回调
/// @param sendModel 发送状态数据
- (void)onSendStreamModel:(VCSStreamSendModel *)sendModel {
    
    /// 发送信息通知回调
    if (self.sendBlock) {
        self.sendBlock([sendModel yy_modelToJSONString]);
    }
}

#pragma mark 当前服务延时回调
/// 当前服务延时回调
/// @param timestamp 服务延时
- (void)onSignalingDelayed:(NSInteger)timestamp {
    
    /// 发送延时通知回调
    if (self.delayedBlock) {
        self.delayedBlock(timestamp);
    }
}

#pragma mark - 发送延时通知回调
/// 发送延时通知回调
/// @param delayedBlock 发送延时通知回调
- (void)delayedBlock:(FWCastingBridgeDelayedBlock)delayedBlock {
    
    self.delayedBlock = delayedBlock;
}

#pragma mark - 发送信息通知回调
/// 发送信息通知回调
/// @param sendBlock 发送信息通知回调
- (void)sendBlock:(FWCastingBridgeSendBlock)sendBlock {
    
    self.sendBlock = sendBlock;
}

@end
