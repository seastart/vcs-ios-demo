//
//  FWServeConfigViewController.m
//  VCSSDK_Example
//
//  Created by SailorGa on 2020/4/27.
//  Copyright © 2020 SailorGa. All rights reserved.
//

#import "FWServeConfigViewController.h"
#import "FWServeConfigViewModel.h"

@interface FWServeConfigViewController ()

/// 服务器地址
@property (weak, nonatomic) IBOutlet UITextField *serveAddrTextField;
/// 提示信息
@property (weak, nonatomic) IBOutlet UILabel *promptLabel;
/// 萤石常用服务器
@property (weak, nonatomic) IBOutlet UIButton *ezvizServeButton;
/// 海星常用服务器
@property (weak, nonatomic) IBOutlet UIButton *seastartServeButton;
/// 仕远常用服务器
@property (weak, nonatomic) IBOutlet UIButton *shiYuanServeButton;
/// 保存按钮
@property (weak, nonatomic) IBOutlet UIButton *saveButton;

/// ViewModel
@property (strong, nonatomic) FWServeConfigViewModel *viewModel;

@end

@implementation FWServeConfigViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /// 初始化UI
    [self buildView];
}

#pragma mark - 初始化UI
- (void)buildView {
    
    /// 设置title
    self.navigationItem.title = @"配置服务器";
    
    /// 设置当前服务器
    self.serveAddrTextField.text = [kSGUserDefaults objectForKey:DATADEFAULTAPIKEY];
    
    /// 初始化ViewModel
    self.viewModel = [[FWServeConfigViewModel alloc] init];
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
    
    /// 监听服务器地址变化
    [self.serveAddrTextField.rac_textSignal subscribeNext:^(NSString * _Nullable text) {
        @strongify(self);
        self.viewModel.serveAddrText = text;
    }];
    
    /// 服务器地址请求订阅
    [self.viewModel.saveServeAddrSubject subscribeNext:^(id _Nullable message) {
        @strongify(self);
        /// 设置服务器地址成功返回上级目录
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    /// 绑定萤石服务器按钮事件
    [[self.ezvizServeButton rac_signalForControlEvents :UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        self.serveAddrTextField.text = @"http://ezm.ys7.com";
        self.viewModel.serveAddrText = @"http://ezm.ys7.com";
    }];
    
    /// 绑定海星服务器按钮事件
    [[self.seastartServeButton rac_signalForControlEvents :UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        self.serveAddrTextField.text = @"http://vcs.anyconf.cn:5000";
        self.viewModel.serveAddrText = @"http://vcs.anyconf.cn:5000";
    }];
    
    /// 绑定仕远服务器按钮事件
    [[self.shiYuanServeButton rac_signalForControlEvents :UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        self.serveAddrTextField.text = @"http://47.99.169.94:5000";
        self.viewModel.serveAddrText = @"http://47.99.169.94:5000";
    }];
    
    /// 绑定保存按钮事件
    [[self.saveButton rac_signalForControlEvents :UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        [self.viewModel saveServeAddr];
    }];
}

#pragma mark - 资源释放
- (void)dealloc {
    
    SGLOG(@"++++++++++++释放资源：%@", kStringFromClass(self));
}

@end
