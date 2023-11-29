//
//  FWDrawingConfigViewController.m
//  VCSSDK_Example
//
//  Created by SailorGa on 2020/8/4.
//  Copyright © 2020 SailorGa. All rights reserved.
//

#import "FWDrawingConfigViewController.h"
#import "FWDrawingConfigViewModel.h"
#import "FWDrawingViewController.h"

@interface FWDrawingConfigViewController ()

/// 电子白板服务器地址
@property (weak, nonatomic) IBOutlet UITextField *addressTextField;
/// 电子白板服务器端口
@property (weak, nonatomic) IBOutlet UITextField *portTextField;
/// 房间ID
@property (weak, nonatomic) IBOutlet UITextField *roomTextField;
/// 用户ID
@property (weak, nonatomic) IBOutlet UITextField *userTextField;
/// 提示信息
@property (weak, nonatomic) IBOutlet UILabel *promptLabel;
/// 开启电子白板
@property (weak, nonatomic) IBOutlet UIButton *openDrawingButton;
/// 开启共享图片
@property (weak, nonatomic) IBOutlet UIButton *sharePicturesButton;

/// ViewModel
@property (strong, nonatomic) FWDrawingConfigViewModel *viewModel;

@end

@implementation FWDrawingConfigViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /// 初始化UI
    [self buildView];
}

#pragma mark - 初始化UI
- (void)buildView {
    
    /// 设置title
    self.navigationItem.title = @"画板配置";
    
    /// 设置默认数据
    /// 121.40.163.43:3003(正式环境)
    /// 103.78.228.91:3003、vcs.anyconf.cn(测试环境)
    self.addressTextField.text = @"121.40.163.43";
    /// self.addressTextField.text = @"103.78.228.91";
    self.portTextField.text = @"3003";
    self.roomTextField.text = @"915606946786";
    self.userTextField.text = @"15606946786";
    
    /// 初始化ViewModel
    self.viewModel = [[FWDrawingConfigViewModel alloc] init];
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
    
    /// 电子白板服务器地址
    [self.addressTextField.rac_textSignal subscribeNext:^(NSString * _Nullable text) {
        @strongify(self);
        self.viewModel.addressText = text;
    }];
    
    /// 电子白板服务器端口
    [self.portTextField.rac_textSignal subscribeNext:^(NSString * _Nullable text) {
        @strongify(self);
        self.viewModel.portText = text;
    }];
    
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
    
    /// 绑定开启电子白板按钮事件
    [[self.openDrawingButton rac_signalForControlEvents :UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        /// 开启电子白板事件处理
        [self.viewModel openDrawingClick:FWShareDrawingState];
    }];
    
    /// 绑定开启共享图片按钮事件
    [[self.sharePicturesButton rac_signalForControlEvents :UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        /// 开启共享图片事件处理
        [self.viewModel openDrawingClick:FWSharePicturesState];
    }];
    
    /// 开启电子白板成功订阅
    [self.viewModel.drawingSubject subscribeNext:^(id _Nullable meetingParam) {
        @strongify(self);
        /// 开启电子白板成功
        [self openDrawingSucceed];
    }];
}

#pragma mark - 开启电子白板成功处理
- (void)openDrawingSucceed {
    
    /// 跳转电子白板页面
    FWDrawingViewController *drawingVC = [[FWDrawingViewController alloc] init];
    drawingVC.state = self.viewModel.state;
    drawingVC.addressText = self.viewModel.addressText;
    drawingVC.portText = self.viewModel.portText;
    drawingVC.roomText = self.viewModel.roomText;
    drawingVC.userText = self.viewModel.userText;
    [self.navigationController pushViewController:drawingVC animated:YES];
}

#pragma mark - 资源释放
- (void)dealloc {
    
    SGLOG(@"++++++++++++释放资源：%@", kStringFromClass(self));
}

@end
