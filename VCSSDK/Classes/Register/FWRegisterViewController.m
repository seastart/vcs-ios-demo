//
//  FWRegisterViewController.m
//  VCSSDK_Example
//
//  Created by SailorGa on 2020/4/27.
//  Copyright © 2020 SailorGa. All rights reserved.
//

#import "FWRegisterViewController.h"
#import "FWRoomConfigViewController.h"
#import "FWRegisterViewModel.h"

@interface FWRegisterViewController ()

/// 手机号码
@property (weak, nonatomic) IBOutlet UITextField *mobileTextField;
/// 验证码
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
/// 密码
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
/// 提示信息
@property (weak, nonatomic) IBOutlet UILabel *promptLabel;
/// 获取验证码按钮
@property (weak, nonatomic) IBOutlet UIButton *codeButton;
/// 提交按钮(注册/重置)
@property (weak, nonatomic) IBOutlet UIButton *submitButton;

/// 验证码计时器
@property (strong, nonatomic) dispatch_source_t timer;
/// ViewModel
@property (strong, nonatomic) FWRegisterViewModel *viewModel;

@end

@implementation FWRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /// 初始化UI
    [self buildView];
}

#pragma mark - 初始化UI
- (void)buildView {
    
    /// 设置title
    self.navigationItem.title = @"注册/重置";
    
    /// 初始化ViewModel
    self.viewModel = [[FWRegisterViewModel alloc] init];
    /// ViewModel关联Class
    self.viewModel.viewClass = [self class];
    /// 设置模块类型(注册/重置密码)
    self.viewModel.state = self.state;
    
    /// 绑定动态响应信号
    [self bindSignal];
}

#pragma mark - 绑定信号
- (void)bindSignal {
    
    @weakify(self);
    
    /// 绑定提示信息
    RAC(self.promptLabel, text) = RACObserve(self.viewModel, promptText);
    
    /// 监听手机号码变化
    [self.mobileTextField.rac_textSignal subscribeNext:^(NSString * _Nullable text) {
        @strongify(self);
        self.viewModel.mobileText = text;
    }];
    
    /// 监听验证码变化
    [self.codeTextField.rac_textSignal subscribeNext:^(NSString * _Nullable text) {
        @strongify(self);
        self.viewModel.codeText = text;
    }];
    
    /// 监听密码变化
    [self.passwordTextField.rac_textSignal subscribeNext:^(NSString * _Nullable text) {
        @strongify(self);
        self.viewModel.passwordText = text;
    }];
    
    /// 获取验证码请求订阅
    [self.viewModel.mobileCodeSubject subscribeNext:^(id _Nullable message) {
        @strongify(self);
        /// 获取验证码成功处理
        [self countdownAction];
    }];
    
    /// 注册请求订阅
    [self.viewModel.registerSubject subscribeNext:^(id _Nullable message) {
        @strongify(self);
        /// 注册成功处理
        [self registerCompleted];
    }];
    
    /// 重置密码请求订阅
    [self.viewModel.resetCodeSubject subscribeNext:^(id _Nullable message) {
        @strongify(self);
        /// 重置密码成功返回上级目录
        [self.navigationController popViewControllerAnimated:YES];
    }];
        
    /// 绑定获取验证码按钮事件
    [[self.codeButton rac_signalForControlEvents :UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        /// 获取短信验证码
        [self.viewModel getMobileCode];
    }];
    
    /// 绑定注册/重置按钮事件
    [[self.submitButton rac_signalForControlEvents :UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        /// 提交按钮处理
        [self.viewModel submitClick];
    }];
}

#pragma mark - 获取验证码开始读秒
- (void)countdownAction {
    
    // 倒计时时间
    __block NSInteger time = 59;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    // 每秒执行
    dispatch_source_set_timer(self.timer,DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(self.timer, ^{
        // 倒计时结束，关闭
        if(time <= 0) {
            dispatch_source_cancel(self.timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                // 设置常规效果的样式
                [self noneStyle];
            });
        } else {
            int seconds = time % 60;
            dispatch_async(dispatch_get_main_queue(), ^{
                // 设置label读秒效果
                [self countdownStyle:seconds];
            });
            time--;
        }
    });
    dispatch_resume(self.timer);
}

#pragma mark - 设置验证码按钮效果
#pragma mark 常规效果
- (void)noneStyle {
    
    [self.codeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [self.codeButton setTitleColor:RGB(255.0, 91.0, 80.0) forState:UIControlStateNormal];
    // 开启用户交互关闭
    self.codeButton.userInteractionEnabled = YES;
}

#pragma mark 读秒效果
- (void)countdownStyle:(int)seconds {
    
    [self.codeButton setTitle:[NSString stringWithFormat:@"%.2dS",seconds] forState:UIControlStateNormal];
    [self.codeButton setTitleColor:RGB(184.0, 184.0, 184.0) forState:UIControlStateNormal];
    // 在这个状态下 用户交互关闭，防止再次点击 button 再次计时
    self.codeButton.userInteractionEnabled = NO;
}

#pragma mark - 注册成功处理
- (void)registerCompleted {
    
    /// 跳转入会配置页面
    FWRoomConfigViewController *roomConfigVC = [[FWRoomConfigViewController alloc] init];
    roomConfigVC.loginModel = self.viewModel.loginModel;
    [self.navigationController pushViewController:roomConfigVC animated:YES];
}

#pragma mark - 资源释放
- (void)dealloc {
    
    SGLOG(@"++++++++++++释放资源：%@", kStringFromClass(self));
}

@end
