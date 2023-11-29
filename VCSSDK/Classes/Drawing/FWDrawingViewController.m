//
//  FWDrawingViewController.m
//  VCSSDK_Example
//
//  Created by SailorGa on 2020/8/4.
//  Copyright © 2020 SailorGa. All rights reserved.
//

#import "FWDrawingViewController.h"

@interface FWDrawingViewController () <VCSDrawingDelegate>

/// 电子画板
@property (strong, nonatomic) VCSWhiteBoardView *whiteBoard;
/// 标题
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
/// 关闭共享按钮
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
/// 更换背景图片按钮
@property (weak, nonatomic) IBOutlet UIButton *changeButton;
/// 再一次更换背景图片按钮
@property (weak, nonatomic) IBOutlet UIButton *againChangeButton;
/// 清空背景图片按钮
@property (weak, nonatomic) IBOutlet UIButton *emptyBackButton;
/// 图片状态按钮
@property (weak, nonatomic) IBOutlet UIButton *pictureStateButton;

@end

@implementation FWDrawingViewController

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
}

#pragma mark - 页面即将消失
- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    /// 隐藏顶部导航栏
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark - 页面重新绘制
/// 页面重新绘制
- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    /// 重置画板layout
    self.whiteBoard.frame = self.view.bounds;
}

#pragma mark - 初始化UI
- (void)buildView {
    
    /// 当前房间ID以及用户ID
    self.titleLabel.text = [NSString stringWithFormat:@"%@(%@)",self.roomText, self.userText];
    /// 初始化电子画板
    self.whiteBoard = [[VCSWhiteBoardView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    /// 创建配置参数
    VCSDrawingParam *param = [[VCSDrawingParam alloc] init];
    param.penTitle = @"Pen";
    param.highlighterTitle = @"Highlighter";
    param.eraserTitle = @"Eraser";
    param.colorTitle = @"Color";
    param.clearTitle = @"Clear";
    param.pictureTitle = @"Picture";
    /// 设置按钮配置参数
    /// [self.whiteBoard setupDrawingParam:param];
    /// 设置电子画板代理
    self.whiteBoard.delegate = self;
    NSString *imageUrl = nil;
    if (self.state == FWSharePicturesState) {
        imageUrl = @"http://assets.sailorhub.cn/202108191355.png";
    }
    
    /// 显示加载框
    [FWToastBridge showToastAction];
    /// 首先下载图片
    [[FWNetworkBridge sharedManager] downloadImageWithImageUrl:imageUrl finishBlock:^(UIImage * _Nullable image) {
        /// 开启电子画板
        [self drawServicConnectWithImage:image imageUrl:imageUrl];
        /// 隐藏加载框
        [FWToastBridge hiddenToastAction];
    }];
    
    /// 添加到父视图
    [self.view insertSubview:self.whiteBoard atIndex:0];
    /// 绑定动态响应信号
    [self bindSignal];
}

#pragma mark - 开启电子画板
/// 开启电子画板
/// @param image 背景图片
/// @param imageUrl 背景图片地址
- (void)drawServicConnectWithImage:(nullable UIImage *)image imageUrl:(nullable NSString *)imageUrl {
    
    WeakSelf();
    /// 电子白板服务连接
    [self.whiteBoard drawServicConnectWithAddress:self.addressText port:[self.portText intValue] roomId:self.roomText userId:self.userText privileges:YES eraserImage:kGetImage(@"icon_room_eraser") image:image imageUrl:imageUrl connectBlock:^(VCSDrawConnectState state) {
        SGLOG(@"+++++++电子画板连接状态回调 = %ld", state);
    } clearBlock:^{
        /// 清空电子画板数据提示
        [weakSelf presentClearDrawingAlert];
    }];
}

#pragma mark - 绑定信号
- (void)bindSignal {
    
    @weakify(self);
    
    /// 绑定关闭按钮事件
    [[self.closeButton rac_signalForControlEvents :UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        /// 关闭事件处理
        [self.navigationController popViewControllerAnimated:self];
    }];
    
    /// 绑定更换背景图片按钮
    [[self.changeButton rac_signalForControlEvents :UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        /// 更换白板背景图片
        [self changeDrawBackImage:@"http://assets.sailorhub.cn/202108191348.png"];
    }];
    
    /// 绑定再一次更换背景图片按钮
    [[self.againChangeButton rac_signalForControlEvents :UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        /// 更换白板背景图片
        [self changeDrawBackImage:@"http://assets.sailorhub.cn/202108191355.png"];
    }];
    
    /// 清空背景图片按钮
    [[self.emptyBackButton rac_signalForControlEvents :UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        /// 更换白板背景图片
        [self changeDrawBackImage:nil];
    }];
    
    /// 图片状态按钮
    [[self.pictureStateButton rac_signalForControlEvents :UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        /// 设置图片按钮状态
        [self setupPictureState];
    }];
}

#pragma mark - 更换画板背景图片
/// 更换画板背景图片
/// @param imageUrl 背景图片路径
- (void)changeDrawBackImage:(nullable NSString *)imageUrl {
    
    /// 显示加载框
    [FWToastBridge showToastAction];
    /// 首先下载图片
    [[FWNetworkBridge sharedManager] downloadImageWithImageUrl:imageUrl finishBlock:^(UIImage * _Nullable image) {
        /// 更换画板背景图片(共享图片)
        [self.whiteBoard changeDrawBackImageWithImage:image imageUrl:imageUrl];
        /// 隐藏加载框
        [FWToastBridge hiddenToastAction];
    }];
}

#pragma mark - 设置图片按钮状态
/// 设置图片按钮状态
- (void)setupPictureState {
    
    self.pictureStateButton.selected = !self.pictureStateButton.selected;
    [self.whiteBoard setupPictureButtonWithState:self.pictureStateButton.selected];
}

#pragma mark - 清空电子画板数据提示
/// 清空电子画板数据提示
- (void)presentClearDrawingAlert {
    
    WeakSelf();
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"确定要清空画板所有数据吗？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
    }];
    UIAlertAction *ensureAction = [UIAlertAction actionWithTitle:@"清空" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {
        /// 清空电子画板数据
        [weakSelf.whiteBoard drawingClear];
    }];
    [alert addAction:cancelAction];
    [alert addAction:ensureAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - ------- VCSDrawingDelegate的代理方法 -------
#pragma mark 图片按钮点击事件
/// 图片按钮点击事件
- (void)onSelectedPictureEvent {
    
    SGLOG(@"++++++++++++电子画板图片按钮点击事件");
    /// 这里可以实现去选取图片、上传等操作
    /// 成功后调取画板changeDrawBackImageWithImageUrl:方法更换画板背景图片或共享图片
}

#pragma mark 电子画板图片变更事件
/// 电子画板图片变更事件
/// @param imageUrl 背景图片路径
- (void)onChangeDrawBackImageEvent:(nullable NSString *)imageUrl {
    
    /// 显示加载框
    [FWToastBridge showToastAction];
    /// 首先下载图片
    [[FWNetworkBridge sharedManager] downloadImageWithImageUrl:imageUrl finishBlock:^(UIImage * _Nullable image) {
        /// 更换本地背景图片
        [self.whiteBoard setupDrawBackImage:image];
        /// 隐藏加载框
        [FWToastBridge hiddenToastAction];
    }];
}

#pragma mark - 资源释放
- (void)dealloc {
    
    SGLOG(@"++++++++++++释放资源：%@", kStringFromClass(self));
}

@end
