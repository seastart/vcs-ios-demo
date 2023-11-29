//
//  FWInviteViewController.m
//  VCSSDK_Example
//
//  Created by SailorGa on 2021/7/29.
//  Copyright © 2021 SailorGa. All rights reserved.
//

#import "FWInviteViewController.h"
#import "FWMQTTClientBridge.h"
#import <UserNotifications/UserNotifications.h>
#import "FWInviteViewModel.h"

@interface FWInviteViewController ()

/// 房间ID
@property (weak, nonatomic) IBOutlet UITextField *roomTextField;
/// 用户ID
@property (weak, nonatomic) IBOutlet UITextField *userTextField;
/// 提示信息
@property (weak, nonatomic) IBOutlet UILabel *promptLabel;
/// 发起邀请
@property (weak, nonatomic) IBOutlet UIButton *inviteButton;
/// 邀请确认
@property (weak, nonatomic) IBOutlet UIButton *inviteConfirmButton;

/// 返回按钮
@property (strong, nonatomic) UIBarButtonItem *gobackItem;

/// ViewModel
@property (strong, nonatomic) FWInviteViewModel *viewModel;

@end

@implementation FWInviteViewController

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

#pragma mark - 初始化UI
- (void)buildView {
    
    /// 连接呼叫服务
    [[FWMQTTClientBridge sharedManager] startNetCallWithLoginModel:self.loginModel];
    
    /// 设置title
    self.navigationItem.title = @"MQTT邀请服务";
    
    /// 设置默认数据
    self.roomTextField.text = @"921967756";
    self.userTextField.text = @"f8135b665b8e4e4988721b121003086a";
    
    /// 初始化ViewModel
    self.viewModel = [[FWInviteViewModel alloc] init];
    /// ViewModel关联Class
    self.viewModel.viewClass = [self class];
    
    /// 设置左侧操作按钮
    [self setupLeftBarItems];
    /// 绑定动态响应信号
    [self bindSignal];
    /// 监听邀请服务广播回调
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
    
    /// 绑定发起邀请按钮事件
    [[self.inviteButton rac_signalForControlEvents :UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        /// 发起邀请
        [[FWMQTTClientBridge sharedManager] inviteWithRoomNo:self.viewModel.roomText targetId:self.viewModel.userText];
    }];
    
    /// 绑定确认邀请按钮事件
    [[self.inviteConfirmButton rac_signalForControlEvents :UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        /// @strongify(self);
        /// 确认邀请
        /// [[FWMQTTClientBridge sharedManager] inviteConfirmWithInviteId:<#(nonnull NSString *)#> roomNo:<#(nonnull NSString *)#> targetId:<#(nonnull NSString *)#> isAccepted:<#(BOOL)#>];
    }];
}

#pragma mark - 监听呼叫服务广播回调
- (void)onListenNetCall {
    
    /// 呼叫服务邀请入会通知回调
    [[FWMQTTClientBridge sharedManager] inviteBlock:^(InviteNotification * _Nonnull notify) {
        SGLOG(@"++++++++++++邀请入会通知 = %@", notify);
        [self sendLocalNotificationToHostAppWithTitle:@"MQTT呼叫服务" msg:@"邀请入会通知" userInfo:nil];
    }];
    
    /// 呼叫服务邀请入会确认通知回调
    [[FWMQTTClientBridge sharedManager] inviteConfirmBlock:^(InviteConfirm * _Nonnull notify) {
        SGLOG(@"++++++++++++邀请入会确认通知 = %@", notify);
        [self sendLocalNotificationToHostAppWithTitle:@"MQTT呼叫服务" msg:@"邀请入会确认通知" userInfo:nil];
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

#pragma mark - 资源释放
- (void)dealloc {
    
    SGLOG(@"++++++++++++释放资源：%@", kStringFromClass(self));
}

@end
