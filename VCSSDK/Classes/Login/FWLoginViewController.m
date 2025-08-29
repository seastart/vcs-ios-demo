//
//  FWLoginViewController.m
//  VCSSDK_Example
//
//  Created by SailorGa on 2020/4/27.
//  Copyright © 2020 SailorGa. All rights reserved.
//

#import "FWLoginViewController.h"
#import "FWRegisterViewController.h"
#import "FWServeConfigViewController.h"
#import "FWDrawingConfigViewController.h"
#import "FWRoomConfigViewController.h"
#import "FWNetCallViewController.h"
#import "FWMQTTClientViewController.h"
#import "FWRecorderAudioViewController.h"
#import "FWInviteViewController.h"
#import "FWBeautyViewController.h"
#import "FWNetworkViewController.h"
#import "FWCastingViewController.h"
#import "FWCdnPullViewController.h"
#import "FWLoginViewModel.h"
#import <ReplayKit/ReplayKit.h>
#import <VCSSDK/VCSCastingManager.h>

@interface FWLoginViewController ()

/// 账号
@property (weak, nonatomic) IBOutlet UITextField *accountTextField;
/// 密码
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
/// 提示信息
@property (weak, nonatomic) IBOutlet UILabel *promptLabel;
/// 登录按钮
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
/// 注册按钮
@property (weak, nonatomic) IBOutlet UIButton *registerButton;
/// 重置密码按钮
@property (weak, nonatomic) IBOutlet UIButton *resetCodeButton;
/// 配置服务器按钮
@property (weak, nonatomic) IBOutlet UIButton *serveConfigButton;
/// 电子白板按钮
@property (weak, nonatomic) IBOutlet UIButton *drawingConfigButton;
/// CDN拉流按钮
@property (weak, nonatomic) IBOutlet UIButton *cdnPullStreamButton;
/// 呼叫服务按钮
@property (weak, nonatomic) IBOutlet UIButton *netCallButton;
/// MQTT呼叫服务按钮
@property (weak, nonatomic) IBOutlet UIButton *mqttNetCallButton;
/// 录音服务按钮
@property (weak, nonatomic) IBOutlet UIButton *audioRecorderButton;
/// 邀请服务按钮
@property (weak, nonatomic) IBOutlet UIButton *inviteButton;
/// 美颜服务按钮
@property (weak, nonatomic) IBOutlet UIButton *beautyButton;
/// 网络监测按钮
@property (weak, nonatomic) IBOutlet UIButton *networkButton;
/// 当前服务器地址
@property (weak, nonatomic) IBOutlet UILabel *serveAddrLable;

/// 投屏按钮
@property (strong, nonatomic) UIBarButtonItem *barItem;

/// ViewModel
@property (strong, nonatomic) FWLoginViewModel *viewModel;

@end

@implementation FWLoginViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    /// 初始化UI
    [self buildView];
}

#pragma mark - 懒加载开启投屏按钮
- (UIBarButtonItem *)barItem {
    
    if (!_barItem) {
        _barItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"屏幕投屏", nil) style:UIBarButtonItemStylePlain target:self action:@selector(castingClick)];
        [_barItem setTintColor:RGBOF(0x0039B3)];
        [_barItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:14], NSFontAttributeName, nil] forState:UIControlStateNormal];
        [_barItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:14], NSFontAttributeName, nil] forState:UIControlStateSelected];
    }
    return _barItem;
}

#pragma mark - 页面出现前
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    /// 展示当前服务器地址
    self.serveAddrLable.text = [NSString stringWithFormat:@"当前服务器地址：%@",[kSGUserDefaults objectForKey:DATADEFAULTAPIKEY]];
}

#pragma mark - 初始化UI
- (void)buildView {
    
    /// 设置默认数据
    self.accountTextField.text = @"15606946786";
    self.passwordTextField.text = @"abc@12345";
    
    /// 设置title
    self.navigationItem.title = @"VCSDEMO";
    /// 设置导航栏按钮
    self.navigationItem.rightBarButtonItem = self.barItem;
    /// 初始化ViewModel
    self.viewModel = [[FWLoginViewModel alloc] init];
    /// ViewModel关联Class
    self.viewModel.viewClass = [self class];
    
    /// 绑定动态响应信号
    [self bindSignal];
}

#pragma mark - 绑定信号
- (void)bindSignal {
    
    @weakify(self);
    
    /// 绑定提示信息
    RAC(self.promptLabel, text) = RACObserve(self.viewModel, promptText);
    
    /// 监听账号变化
    [self.accountTextField.rac_textSignal subscribeNext:^(NSString * _Nullable text) {
        @strongify(self);
        self.viewModel.accountText = text;
    }];
    
    /// 监听密码变化
    [self.passwordTextField.rac_textSignal subscribeNext:^(NSString * _Nullable text) {
        @strongify(self);
        self.viewModel.passwordText = text;
    }];
    
    /// 登录请求订阅
    [self.viewModel.loginSubject subscribeNext:^(NSNumber * _Nullable value) {
        @strongify(self);
        /// 登录成功处理or呼叫服务处理
        switch (value.integerValue) {
            case FWUserOperateStateLogin:
                /// 登录
                [self loginClick];
                break;
            case FWUserOperateStateNetCall:
                /// 呼叫服务
                [self netCallClick];
                break;
            case FWUserOperateStateMQTTNetCall:
                /// MQTT呼叫服务
                [self mqttNetCallClick];
                break;
            case FWUserOperateStateInvite:
                /// MQTT邀请服务
                [self mqttInviteClick];
                break;
            default:
                break;
        }
    }];
    
    /// 绑定登录按钮事件
    [[self.loginButton rac_signalForControlEvents :UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        /// 登录
        [self.viewModel commitLoginWithState:FWUserOperateStateLogin];
    }];
    
    /// 绑定注册按钮事件
    [[self.registerButton rac_signalForControlEvents :UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        /// 注册事件处理
        [self registerClick];
    }];
    
    /// 绑定重置密码按钮事件
    [[self.resetCodeButton rac_signalForControlEvents :UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        /// 重置密码事件处理
        [self resetCodeClick];
    }];
    
    /// 绑定配置服务器按钮事件
    [[self.serveConfigButton rac_signalForControlEvents :UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        /// 配置服务器事件处理
        [self serveConfigClick];
    }];
    
    /// 绑定电子白板按钮事件
    [[self.drawingConfigButton rac_signalForControlEvents :UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        /// 电子白板按钮事件处理
        [self drawingConfigClick];
    }];
    
    /// 绑定CDN拉流按钮
    [[self.cdnPullStreamButton rac_signalForControlEvents :UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        /// CDN拉流按钮事件
        [self cdnPullStreamClick];
    }];
    
    /// 绑定呼叫服务按钮事件
    [[self.netCallButton rac_signalForControlEvents :UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        /// 登录(呼叫服务需要先登录)
        [self.viewModel commitLoginWithState:FWUserOperateStateNetCall];
    }];
    
    /// 绑定MQTT呼叫服务按钮事件
    [[self.mqttNetCallButton rac_signalForControlEvents :UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        /// 登录(呼叫服务需要先登录)
        [self.viewModel commitLoginWithState:FWUserOperateStateMQTTNetCall];
    }];
    
    /// 绑定录音服务按钮事件
    [[self.audioRecorderButton rac_signalForControlEvents :UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        /// 录音服务按钮事件处理
        [self recorderAudioClick];
    }];
    
    /// 绑定邀请服务按钮事件
    [[self.inviteButton rac_signalForControlEvents :UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        /// 登录(邀请服务需要先登录)
        [self.viewModel commitLoginWithState:FWUserOperateStateInvite];
    }];
    
    /// 绑定美颜服务按钮事件
    [[self.beautyButton rac_signalForControlEvents :UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        /// 美颜服务按钮事件处理
        [self beautyClick];
    }];
    
    /// 绑定网络监测按钮事件
    [[self.networkButton rac_signalForControlEvents :UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        /// 网络监测按钮事件处理
        [self networkClick];
    }];
}

#pragma mark - 登录成功处理
- (void)loginClick {
    
    /// 跳转入会配置页面
    FWRoomConfigViewController *roomConfigVC = [[FWRoomConfigViewController alloc] init];
    roomConfigVC.loginModel = self.viewModel.loginModel;
    [self.navigationController pushViewController:roomConfigVC animated:YES];
}

#pragma mark - 注册按钮事件
- (void)registerClick {
    
    /// 跳转注册页面
    FWRegisterViewController *registerVC = [[FWRegisterViewController alloc] init];
    registerVC.state = FWUserCodeStateRegister;
    [self.navigationController pushViewController:registerVC animated:YES];
}

#pragma mark - 重置密码按钮事件
- (void)resetCodeClick {
    
    /// 跳转重置密码页面
    FWRegisterViewController *registerVC = [[FWRegisterViewController alloc] init];
    registerVC.state = FWUserCodeStateResetCode;
    [self.navigationController pushViewController:registerVC animated:YES];
}

#pragma mark - 配置服务器按钮事件
- (void)serveConfigClick {
    
    /// 跳转配置服务器页面
    FWServeConfigViewController *serveConfigVC = [[FWServeConfigViewController alloc] init];
    [self.navigationController pushViewController:serveConfigVC animated:YES];
}

#pragma mark - 电子白板按钮事件
- (void)drawingConfigClick {
    
    /// 跳转电子白板配置页面
    FWDrawingConfigViewController *drawingConfigVC = [[FWDrawingConfigViewController alloc] init];
    [self.navigationController pushViewController:drawingConfigVC animated:YES];
}

#pragma mark - CDN拉流按钮事件
- (void)cdnPullStreamClick {
    
    FWCdnPullViewController *cdnPullVC = [[FWCdnPullViewController alloc] init];
    [self.navigationController pushViewController:cdnPullVC animated:YES];
}

#pragma mark - 呼叫服务按钮事件
- (void)netCallClick {
    
    /// 跳转呼叫服务页面
    FWNetCallViewController *netCallVC = [[FWNetCallViewController alloc] init];
    netCallVC.loginModel = self.viewModel.loginModel;
    [self.navigationController pushViewController:netCallVC animated:YES];
}

#pragma mark - MQTT呼叫服务按钮事件
- (void)mqttNetCallClick {
    
    /// 跳转MQTT呼叫服务页面
    FWMQTTClientViewController *mqttNetCallVC = [[FWMQTTClientViewController alloc] init];
    mqttNetCallVC.loginModel = self.viewModel.loginModel;
    [self.navigationController pushViewController:mqttNetCallVC animated:YES];
}

#pragma mark - MQTT邀请服务按钮事件
- (void)mqttInviteClick {
    
    /// 跳转MQTT邀请服务页面
    FWInviteViewController *inviteVC = [[FWInviteViewController alloc] init];
    inviteVC.loginModel = self.viewModel.loginModel;
    [self.navigationController pushViewController:inviteVC animated:YES];
}

#pragma mark - 录音服务按钮事件
- (void)recorderAudioClick {
    
    /// 跳转录音服务页面
    FWRecorderAudioViewController *recorderAudioVC = [[FWRecorderAudioViewController alloc] init];
    [self.navigationController pushViewController:recorderAudioVC animated:YES];
}

#pragma mark - 美颜服务按钮事件
- (void)beautyClick {
    
    /// 跳转美颜服务页面
    FWBeautyViewController *beautyVC = [[FWBeautyViewController alloc] init];
    [self.navigationController pushViewController:beautyVC animated:YES];
}

#pragma mark - 网络监测按钮事件处理
- (void)networkClick {
    
    /// 跳转网络监测页面
    FWNetworkViewController *networkVC = [[FWNetworkViewController alloc] init];
    [self.navigationController pushViewController:networkVC animated:YES];
}

#pragma mark - 投屏按钮事件处理
- (void)castingClick {
    
    /// 跳转屏幕投屏页面
    FWCastingViewController *castingVC = [[FWCastingViewController alloc] init];
    [self.navigationController pushViewController:castingVC animated:YES];
}

#pragma mark - 资源释放
- (void)dealloc {
    
    SGLOG(@"++++++++++++释放资源：%@", kStringFromClass(self));
}

@end
