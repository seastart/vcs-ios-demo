//
//  FWNetworkViewController.m
//  VCSSDK_Example
//
//  Created by SailorGa on 2021/11/1.
//  Copyright © 2021 SailorGa. All rights reserved.
//

#import "FWNetworkViewController.h"
#import "FWNetworkViewModel.h"
#import <VCSSDK/VCSNetwork.h>

@interface FWNetworkViewController () <VCSNetworkManagerDelegate>

/// 服务地址
@property (weak, nonatomic) IBOutlet UITextField *streamHostTextField;
/// 服务端口
@property (weak, nonatomic) IBOutlet UITextField *streamPortTextField;
/// 用户编号
@property (weak, nonatomic) IBOutlet UITextField *streamIdTextField;
/// 上行码率
@property (weak, nonatomic) IBOutlet UITextField *upSpeedTextField;
/// 下行码率
@property (weak, nonatomic) IBOutlet UITextField *downSpeedTextField;
/// 测试时间
@property (weak, nonatomic) IBOutlet UITextField *timeTextField;

/// 提示信息
@property (weak, nonatomic) IBOutlet UILabel *promptLabel;
/// 开启网络检测按钮
@property (weak, nonatomic) IBOutlet UIButton *startButton;

/// ViewModel
@property (strong, nonatomic) FWNetworkViewModel *viewModel;

@end

@implementation FWNetworkViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    /// 初始化UI
    [self buildView];
}

#pragma mark - 初始化UI
- (void)buildView {
    
    /// 设置title
    self.navigationItem.title = @"网络检测";
    /// 设置ViewModel
    [self setupViewModel];
    /// 绑定动态响应信号
    [self bindSignal];
}

#pragma mark - 设置ViewModel
/// 设置ViewModel
- (void)setupViewModel {
    
    /// 初始化ViewModel
    self.viewModel = [[FWNetworkViewModel alloc] init];
    /// ViewModel关联Class
    self.viewModel.viewClass = [self class];
}

#pragma mark - 绑定信号
/// 绑定信号
- (void)bindSignal {
    
    @weakify(self);
    
    /// 绑定服务地址
    RAC(self.streamHostTextField, text) = RACObserve(self.viewModel, streamHostText);
    /// 绑定服务端口
    RAC(self.streamPortTextField, text) = RACObserve(self.viewModel, streamPortText);
    /// 绑定用户ID
    RAC(self.streamIdTextField, text) = RACObserve(self.viewModel, streamIdText);
    /// 绑定上行码率
    RAC(self.upSpeedTextField, text) = RACObserve(self.viewModel, upSpeedText);
    /// 绑定下行码率
    RAC(self.downSpeedTextField, text) = RACObserve(self.viewModel, downSpeedText);
    /// 绑定测试时间
    RAC(self.timeTextField, text) = RACObserve(self.viewModel, timeText);
    /// 绑定提示信息
    RAC(self.promptLabel, text) = RACObserve(self.viewModel, promptText);
    
    /// 绑定服务地址
    [self.streamHostTextField.rac_textSignal subscribeNext:^(NSString * _Nullable text) {
        @strongify(self);
        self.viewModel.streamHostText = text;
    }];
    
    /// 绑定服务端口
    [self.streamPortTextField.rac_textSignal subscribeNext:^(NSString * _Nullable text) {
        @strongify(self);
        self.viewModel.streamPortText = text;
    }];
    
    /// 绑定用户编号
    [self.streamIdTextField.rac_textSignal subscribeNext:^(NSString * _Nullable text) {
        @strongify(self);
        self.viewModel.streamIdText = text;
    }];
    
    /// 绑定上行码率
    [self.upSpeedTextField.rac_textSignal subscribeNext:^(NSString * _Nullable text) {
        @strongify(self);
        self.viewModel.upSpeedText = text;
    }];
    
    /// 绑定下行码率
    [self.downSpeedTextField.rac_textSignal subscribeNext:^(NSString * _Nullable text) {
        @strongify(self);
        self.viewModel.downSpeedText = text;
    }];
    
    /// 绑定测试时间
    [self.timeTextField.rac_textSignal subscribeNext:^(NSString * _Nullable text) {
        @strongify(self);
        self.viewModel.timeText = text;
    }];
    
    /// 监听订阅加载状态
    [RACObserve(self.viewModel, loading) subscribeNext:^(NSNumber * _Nullable value) {
        if(value.boolValue) {
            [SVProgressHUD show];
        } else {
            [SVProgressHUD dismiss];
        }
    }];
    
    /// 绑定开启网络监测按钮事件
    [[self.startButton rac_signalForControlEvents :UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        /// 开启网络监测事件
        [self.viewModel startNetworkDetection];
    }];
    
    /// 开启网络监测订阅
    [self.viewModel.detectionSubject subscribeNext:^(id _Nullable meetingParam) {
        @strongify(self);
        
        /// 创建网络监测配置
        VCSNetworkConfig *config = [[VCSNetworkConfig alloc] init];
        config.streamId = [self.viewModel.streamIdText intValue];
        
        config.streamHost = self.viewModel.streamHostText;
        config.streamPort = [self.viewModel.streamPortText intValue];
        
        config.upSpeed = [self.viewModel.upSpeedText intValue];
        config.downSpeed = [self.viewModel.downSpeedText intValue];
        config.duration = [self.viewModel.timeText intValue];
        
        config.deviceId = DeviceUUID;
        
        /// 开启网络检测
        [[VCSNetworkManager sharedManager] startDetectionWithConfig:config delegate:self];
    }];
}

#pragma mark - -------------- VCSNetworkManagerDelegate的代理方法 ---------------
#pragma mark 开启网络检测
/// 开启网络检测
/// @param networkManager 网络检测对象
- (void)networkManagerDidBegined:(nonnull VCSNetworkManager *)networkManager {
    
    self.viewModel.promptText = @"网络检测已开启";
}

#pragma mark 完成网络检测
/// 完成网络检测
/// @param networkManager 网络检测对象
/// @param uploadModel 上行网络状况
/// @param downModel 下行网络状况
/// @param connectModel 网络连接状况
- (void)networkManagerDidFinshed:(nonnull VCSNetworkManager *)networkManager uploadModel:(nullable VCSNetworkModel *)uploadModel downModel:(nullable VCSNetworkModel *)downModel connectModel:(VCSNetworkConnectModel *)connectModel {
    
    self.viewModel.promptText = @"网络检测已完成";
}

#pragma mark - 资源释放
- (void)dealloc {
    
    /// 停止网络监测
    [[VCSNetworkManager sharedManager] stopNetworkDetection];
    /// 输出跟踪日志
    SGLOG(@"++++++++++++释放资源：%@", kStringFromClass(self));
}

@end
