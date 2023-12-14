//
//  FWNetCallViewController.m
//  VCSSDK_Example
//
//  Created by SailorGa on 2020/8/24.
//  Copyright © 2020 SailorGa. All rights reserved.
//

#import "FWNetCallViewController.h"
#import "FWNetCallViewModel.h"
#import "FWNetCallBridge.h"
#import <UserNotifications/UserNotifications.h>

@interface FWNetCallViewController ()

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

/// 呼叫用户状态结构
@property (strong, nonatomic) WaitingAccount *selfAccount;
/// 呼叫用户状态结构
@property (strong, nonatomic) WaitingAccount *waitingAccount;
/// 呼叫列表
@property (strong, nonatomic) NSMutableArray *callDataArray;

/// ViewModel
@property (strong, nonatomic) FWNetCallViewModel *viewModel;

@end

@implementation FWNetCallViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /// 初始化UI
    [self buildView];
}

#pragma mark - 页面出现前
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    /// 连接呼叫服务
    [[FWNetCallBridge sharedManager] startNetCallWithLoginModel:self.loginModel];
}

#pragma mark - 页面已经消失
- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    /// 停止并释放呼叫服务
    [[FWNetCallBridge sharedManager] stop];
}

#pragma mark - 懒加载呼叫用户状态结构
- (WaitingAccount *)waitingAccount {
    
    if (!_waitingAccount) {
        _waitingAccount = [[WaitingAccount alloc] init];
        _waitingAccount.callId = [[FWToolHelper sharedManager] getUniqueIdentifier];
        /// 15606946786 - b2a04ab737cd4ea98e8088254ff05066
        /// 15606946788 - f8524062446d4758b2776dd237aa149d
        /// 15606946788 - fdf64b937faf4f5f9e41a34a39510d76
        _waitingAccount.id_p = @"fdf64b937faf4f5f9e41a34a39510d76";
        _waitingAccount.name = @"15606946788";
        _waitingAccount.nickname = @"15606946788";
        _waitingAccount.portrait = @"http://crazy.image.alimmdn.com/iSaior/14878273006128.png";
        _waitingAccount.roomNo = self.viewModel.roomText;
        _waitingAccount.status = InviteStatus_Waiting;
    }
    return _waitingAccount;
}

#pragma mark - 懒加载呼叫用户状态结构
- (WaitingAccount *)selfAccount {
    
    if (!_selfAccount) {
        _selfAccount = [[WaitingAccount alloc] init];
        _selfAccount.callId = [[FWToolHelper sharedManager] getUniqueIdentifier];
        /// 15606946786 - b2a04ab737cd4ea98e8088254ff05066
        /// 15606946788 - f8524062446d4758b2776dd237aa149d
        /// 15606946788 - 60165d81b9df4b5194e9acb97183ee3c
        _selfAccount.id_p = self.loginModel.data.account.id;
        _selfAccount.name = self.loginModel.data.account.name;
        _selfAccount.nickname = self.loginModel.data.account.nickname;
        _selfAccount.portrait = @"http://crazy.image.alimmdn.com/iSaior/14878273006128.png";
        _selfAccount.roomNo = self.viewModel.roomText;
        _selfAccount.status = InviteStatus_Waiting;
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
    
    /// 设置title
    self.navigationItem.title = @"呼叫服务";
    
    /// 设置默认数据
    self.roomTextField.text = @"915606946789";
    self.userTextField.text = @"0a1d333f098f4a75aece803249b90601";
    
    /// 初始化ViewModel
    self.viewModel = [[FWNetCallViewModel alloc] init];
    /// ViewModel关联Class
    self.viewModel.viewClass = [self class];
    
    /// 绑定动态响应信号
    [self bindSignal];
    /// 监听呼叫服务广播回调
    [self onListenNetCall];
}

#pragma mark - 监听呼叫服务广播回调
- (void)onListenNetCall {
    
    WeakSelf();
    
    /// 呼叫服务邀请入会通知回调
    [[FWNetCallBridge sharedManager] inviteBlock:^(InviteNotification * _Nonnull notify) {
        SGLOG(@"++++++++++++邀请入会通知 = %@", notify);
        [weakSelf sendLocalNotificationToHostAppWithTitle:@"VCSDEMO呼叫服务" msg:@"邀请入会通知" userInfo:nil];
    }];
    
    /// 呼叫服务邀请入会确认通知回调
    [[FWNetCallBridge sharedManager] inviteConfirmBlock:^(InviteConfirm * _Nonnull notify) {
        SGLOG(@"++++++++++++邀请入会确认通知 = %@", notify);
        [weakSelf sendLocalNotificationToHostAppWithTitle:@"VCSDEMO呼叫服务" msg:@"邀请入会确认通知" userInfo:nil];
    }];
    
    /// 呼叫服务成员的通话状态通知回调
    [[FWNetCallBridge sharedManager] accountCallStatusBlock:^(WaitingRoomBroadcast * _Nonnull notify) {
        SGLOG(@"++++++++++++成员邀请状态通知 = %@", notify);
        [weakSelf sendLocalNotificationToHostAppWithTitle:@"VCSDEMO呼叫服务" msg:@"成员的通话状态通知" userInfo:nil];
    }];
    
    /// 呼叫服务自己的通话状态通知回调
    [[FWNetCallBridge sharedManager] myAccountCallStatusBlock:^(WaitingRoomUpdate * _Nonnull notify) {
        SGLOG(@"++++++++++++自己的通话状态通知 = %@", notify);
        [weakSelf sendLocalNotificationToHostAppWithTitle:@"VCSDEMO呼叫服务" msg:@"自己的通话状态通知" userInfo:nil];
    }];
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
    [[self.inviteConfirmButton rac_signalForControlEvents :UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        /// 发起邀请
        [[FWNetCallBridge sharedManager] inviteWithRoomNo:self.viewModel.roomText targetId:self.viewModel.userText];
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
        /// 更新帐户信息
        [[FWNetCallBridge sharedManager] updateWaitingAccountInfo:account];
    }];
    
    /// 绑定发起呼叫按钮事件
    [[self.callButton rac_signalForControlEvents :UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        for (WaitingAccount *account in self.callDataArray) {
            account.status = InviteStatus_Waiting;
        }
        /// 发起呼叫
        [[FWNetCallBridge sharedManager] callWithAccountsArray:self.callDataArray currentMember:self.selfAccount roomNo:self.viewModel.roomText restart:YES role:ConferenceRole_CrMember];
    }];
    
    /// 绑定取消呼叫按钮事件
    [[self.callCancelButton rac_signalForControlEvents :UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        for (WaitingAccount *account in self.callDataArray) {
            account.status = InviteStatus_Canceled;
        }
        /// 取消呼叫
        [[FWNetCallBridge sharedManager] callCancelNewWithAccountsArray:self.callDataArray roomNo:self.viewModel.roomText];
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
