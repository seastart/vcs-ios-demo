//
//  FWCastingViewController.m
//  VCSSDK_Example
//
//  Created by SailorGa on 2023/5/23.
//  Copyright © 2023 SailorGa. All rights reserved.
//

#import "FWCastingViewController.h"
#import "FWCastingViewModel.h"

@interface FWCastingViewController ()

/// 投屏按钮
@property (weak, nonatomic) IBOutlet UIButton *startCastingButton;
/// 音频按钮
@property (weak, nonatomic) IBOutlet UIButton *enableAudioButton;
/// 投屏地址
@property (weak, nonatomic) IBOutlet UITextField *domainTextField;
/// 用户名称
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
/// 发送延时标签
@property (weak, nonatomic) IBOutlet UILabel *delayedLabel;
/// 发送信息标签
@property (weak, nonatomic) IBOutlet UILabel *sendLabel;

/// ViewModel
@property (strong, nonatomic) FWCastingViewModel *viewModel;

@end

@implementation FWCastingViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    /// 初始化UI
    [self buildView];
}

#pragma mark - 页面出现前
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    /// 显示顶部导航栏
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark - 初始化UI
- (void)buildView {
    
    /// 设置title
    self.navigationItem.title = NSLocalizedString(@"屏幕投屏", nil);
    /// 设置ViewModel
    [self setupViewModel];
    /// 绑定动态响应信号
    [self bindSignal];
}

#pragma mark - 设置ViewModel
- (void)setupViewModel {
    
    /// 初始化ViewModel
    self.viewModel = [[FWCastingViewModel alloc] init];
    /// ViewModel关联Class
    self.viewModel.viewClass = [self class];
}

#pragma mark - 绑定信号
- (void)bindSignal {
    
    @weakify(self);
    
    /// 绑定投屏地址
    RAC(self.domainTextField, text) = RACObserve(self.viewModel, domainText);
    /// 绑定用户名称
    RAC(self.usernameTextField, text) = RACObserve(self.viewModel, usernameText);
    
    /// 监听投屏地址
    [self.domainTextField.rac_textSignal subscribeNext:^(NSString * _Nullable text) {
        @strongify(self);
        self.viewModel.domainText = text;
    }];
    
    /// 监听用户名称
    [self.usernameTextField.rac_textSignal subscribeNext:^(NSString * _Nullable text) {
        @strongify(self);
        self.viewModel.usernameText = text;
    }];
    
    /// 绑定音频按钮事件
    [[self.enableAudioButton rac_signalForControlEvents :UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        /// 变更按钮选中状态
        self.enableAudioButton.selected = !self.enableAudioButton.selected;
    }];
    
    /// 绑定投屏按钮事件
    [[self.startCastingButton rac_signalForControlEvents :UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        /// 构建投屏配置
        [self.viewModel buildMediaConfig];
    }];
    
    /// 构建完成订阅
    [self.viewModel.buildSubject subscribeNext:^(id _Nullable value) {
        @strongify(self);
        /// 开启投屏服务端
        [self startCastingWithConfig:value];
    }];
    
    /// 提示框订阅
    [self.viewModel.toastSubject subscribeNext:^(id _Nullable message) {
        if (!kStringIsEmpty(message)) {
            [SVProgressHUD showInfoWithStatus:message];
        }
    }];
    
    /// 绑定启用音频按钮状态
    [RACObserve(self.enableAudioButton, selected) subscribeNext:^(NSNumber * _Nullable value) {
        @strongify(self);
        /// 变更音频启用状态
        self.viewModel.enableAudio = value.boolValue;
        /// 变更音频启用状态
        [[FWCastingBridge sharedManager] enableCastingAudio:self.viewModel.enableAudio];
    }];
    
    /// 监听订阅加载状态
    [RACObserve(self.viewModel, loading) subscribeNext:^(NSNumber * _Nullable value) {
        if(value.boolValue) {
            [SVProgressHUD show];
        } else {
            [SVProgressHUD dismiss];
        }
    }];
    
    /// 发送延时通知回调
    [[FWCastingBridge sharedManager] delayedBlock:^(NSInteger timestamp) {
        @strongify(self);
        /// 更新发送延时标签内容
        self.delayedLabel.text = [NSString stringWithFormat:@"当前服务延时：%ld", timestamp];
    }];
    
    /// 发送信息通知回调
    [[FWCastingBridge sharedManager] sendBlock:^(NSString * _Nonnull sendInfo) {
        @strongify(self);
        /// 更新发送信息标签内容
        self.sendLabel.text = [NSString stringWithFormat:@"当前上行信息：%@", sendInfo];
    }];
}

#pragma mark - 开启投屏服务端
/// 开启投屏服务端
/// - Parameter mediaConfig: 配置参数
- (void)startCastingWithConfig:(VCSCastingMediaConfig *)mediaConfig {
    
    /// 配置投屏参数
    [[FWCastingBridge sharedManager] setupCastingConfig:mediaConfig];
}

#pragma mark - 资源释放
- (void)dealloc {
    
    SGLOG(@"++++++++++++释放资源：%@", kStringFromClass(self));
}

@end
