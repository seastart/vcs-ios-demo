//
//  FWBeautyViewController.m
//  VCSSDK_Example
//
//  Created by SailorGa on 2021/9/28.
//  Copyright © 2021 SailorGa. All rights reserved.
//

#import "FWBeautyViewController.h"
#import "FWBeautyViewBar.h"
#import <VCSSDK/VCSBeauty.h>

@interface FWBeautyViewController () <FWBeautyViewBarDelegate>

/// 美颜本地预览
@property (weak, nonatomic) IBOutlet UIView *superView;
/// 关闭页面按钮
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
/// 相机切换按钮
@property (weak, nonatomic) IBOutlet UIButton *cameraButton;
/// 美颜操作工具栏
@property (weak, nonatomic) IBOutlet FWBeautyViewBar *beautyViewBar;
/// 美颜与非美颜对比按钮
@property (weak, nonatomic) IBOutlet UIButton *beautyContrastButton;

@end

@implementation FWBeautyViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    /// 初始化UI
    [self buildView];
}

#pragma mark - 页面出现前
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    /// 隐藏顶部导航栏
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    /// 装载美颜本地预览
    [[VCSBeautyManager sharedManager] installLocalDisplayViewReady:self.superView frame:self.superView.bounds];
}

#pragma mark - 页面即将消失
- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    /// 隐藏顶部导航栏
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    /// 卸载美颜本地预览
    [[VCSBeautyManager sharedManager] uninstallLocalDisplay];
}

#pragma mark - 页面重新绘制
/// 页面重新绘制
- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    /// 更新渲染组件布局
    [[VCSBeautyManager sharedManager] renewDisplayWithFrame:self.superView.bounds];
}

#pragma mark - 初始化UI
- (void)buildView {
    
    /// 美颜操作工具栏代理设置
    self.beautyViewBar.delegate = self;
    /// 绑定动态响应信号
    [self bindSignal];
}

#pragma mark - 绑定信号
- (void)bindSignal {
    
    @weakify(self);
    
    /// 绑定关闭页面按钮事件
    [[self.closeButton rac_signalForControlEvents: UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        /// 退出页面
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    /// 绑定切换相机按钮事件
    [[self.cameraButton rac_signalForControlEvents: UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        [[VCSBeautyManager sharedManager] changeCameraDevice];
    }];
    
    /// 美颜与非美颜对比按钮(按下)事件
    [[self.beautyContrastButton rac_signalForControlEvents:UIControlEventTouchDown] subscribeNext:^(__kindof UIControl * _Nullable control) {
        [[VCSBeautyManager sharedManager] onBeautySwitch:NO];
    }];
    
    /// 美颜与非美颜对比按钮(抬起)事件
    [[self.beautyContrastButton rac_signalForControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        [[VCSBeautyManager sharedManager] onBeautySwitch:YES];
    }];
}

#pragma mark - -------- FWBeautyViewBarDelegate --------
#pragma mark 滤镜改变
/// 滤镜改变
- (void)filterNameChange:(NSString *)filterName {
    
    /// 切换滤镜
    [VCSBeautyManager sharedManager].filterName = filterName;
}

#pragma mark 滤镜程度改变
/// 滤镜程度改变
- (void)filterValueChange:(double)filterLevel {
    
    /// 修改滤镜程度
    [VCSBeautyManager sharedManager].filterLevel = filterLevel;
}

#pragma mark 美颜参数改变
/// 美颜参数改变
- (void)beautyParamValueChange:(double)level type:(FWBeautySkin)type {
    
    switch (type) {
        case FWBeautySkinBlurLevel:
            [VCSBeautyManager sharedManager].blurLevel = level;
            break;
        case FWBeautySkinColorLevel:
            [VCSBeautyManager sharedManager].whiteLevel = level;
            break;
        case FWBeautySkinRedLevel:
            [VCSBeautyManager sharedManager].redLevel = level;
            break;
        case FWBeautySkinSharpen:
            [VCSBeautyManager sharedManager].sharpen = level;
            break;
        default:
            break;
    }
}

#pragma mark 显示页眉工具栏
/// 显示页眉工具栏
- (void)showHeaderView:(BOOL)shown {
    
    self.beautyContrastButton.hidden = !shown;
}

#pragma mark - 资源释放
- (void)dealloc {
    
    SGLOG(@"++++++++++++释放资源：%@", kStringFromClass(self));
}

@end
