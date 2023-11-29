//
//  FWWhiteBoardView.m
//  VCSSDK_Example
//
//  Created by SailorGa on 2020/5/28.
//  Copyright © 2020 SailorGa. All rights reserved.
//

#import "FWWhiteBoardView.h"
#import <VCSSDK/VCSSDK.h>
#import <VCSSDK/VCSDrawing.h>

@interface FWWhiteBoardView()

/// 内容
@property (weak, nonatomic) IBOutlet UIView *contentView;
/// 白板容器
@property (weak, nonatomic) IBOutlet UIView *boardView;
/// 退出会议室
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;
/// 关闭电子白板/图片分享
@property (weak, nonatomic) IBOutlet UIButton *closeBoardButton;

/// 电子画板
@property (strong, nonatomic) VCSWhiteBoardView *whiteBoard;
/// 标记是否横屏
@property (nonatomic, assign) BOOL isHorizontalScreen;

@end

@implementation FWWhiteBoardView

#pragma mark - 初始化方法
/// 初始化方法
/// @param frame frame
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil].firstObject;
        self.contentView.frame = self.bounds;
        [self addSubview:self.contentView];
        /// 配置属性
        [self stepConfig];
    }
    return self;
}

#pragma mark - 懒加载房间内成员
- (VCSWhiteBoardView *)whiteBoard {
    
    if (!_whiteBoard) {
        _whiteBoard = [[VCSWhiteBoardView alloc] initWithFrame:self.bounds];
    }
    return _whiteBoard;
}

#pragma mark - 页面重新绘制
/// 页面重新绘制
- (void)layoutSubviews {
    
    [super layoutSubviews];
    /// 重置画板layout
    _whiteBoard.frame = self.bounds;
}

#pragma mark - 配置属性
- (void)stepConfig {
    
    /// 默认设置横屏
    self.isHorizontalScreen = [VCSMeetingManager sharedManager].meetingParam.isHorizontalScreen;
    /// 绑定动态响应信号
    [self bindSignal];
}

#pragma mark - 绑定信号
- (void)bindSignal {
    
    @weakify(self);
    
    /// 退出会议室按钮事件
    [[self.logoutButton rac_signalForControlEvents :UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        if (self.logoutClickBlock) {
            self.logoutClickBlock();
        }
    }];
    
    /// 关闭电子白板/图片分享按钮事件
    [[self.closeBoardButton rac_signalForControlEvents :UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        /// 停止分享(包括：白板、图片、桌面)
        [[VCSMeetingManager sharedManager] sendRoomStopSharing];
    }];
}

#pragma mark - 更改屏幕方向
/// 更改屏幕方向
/// @param isHorizontalScreen YES-切换横屏 NO-切换竖屏
- (void)changeScreenOrientation:(BOOL)isHorizontalScreen {
    
    self.isHorizontalScreen = isHorizontalScreen;
    self.sa_height = SCREEN_HEIGHT;
    self.sa_width = SCREEN_WIDTH;
    _whiteBoard.sa_height = SCREEN_HEIGHT;
    _whiteBoard.sa_width = SCREEN_WIDTH;
}

#pragma mark - 获取当前白板的显示状态
/// 获取当前白板的显示状态
- (BOOL)getShowState {
    
    return !self.hidden;
}

#pragma mark - 显示视图
/// 显示视图
/// @param host 白板地址
/// @param userId 用户ID
/// @param meetingId 会议ID
/// @param privileges 读写权限
/// @param imageUrl 图片地址
/// @param image 背景图片
- (void)showView:(NSString *)host userId:(NSString *)userId meetingId:(NSString *)meetingId privileges:(BOOL)privileges imageUrl:(nullable NSString *)imageUrl image:(nullable UIImage *)image {
    
    NSString *address = nil;
    NSString *port = nil;
    if ([host containsString:@":"]) {
        /// 字符:分隔成数组
        NSArray *hostArray = [host componentsSeparatedByString:@":"];
        address = [hostArray firstObject];
        port = [hostArray lastObject];
    }
    /// 添加到父视图
    [self.boardView addSubview:self.whiteBoard];
    /// 电子白板服务连接
    [_whiteBoard drawServicConnectWithAddress:address port:[port intValue] roomId:meetingId userId:userId privileges:privileges eraserImage:nil image:image imageUrl:imageUrl connectBlock:nil clearBlock:nil];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.hidden = NO;
    }];
}

#pragma mark - 隐藏视图
/// 隐藏视图
- (void)hiddenView {
    
    /// 移除电子白板
    [_whiteBoard removeFromSuperview];
    _whiteBoard = nil;
    
    [UIView animateWithDuration:0.25 animations:^{
        self.hidden = YES;
    }];
}

#pragma mark - 结束会议按钮事件回调
/// 结束会议按钮事件回调
/// @param logoutClickBlock 结束会议按钮事件回调
- (void)logoutClickBlock:(FWWhiteBoardViewLogoutClickBlock)logoutClickBlock {
    
    self.logoutClickBlock = logoutClickBlock;
}

#pragma mark - 释放资源
- (void)dealloc {
    
    SGLOG(@"++++++++++++释放资源：%@", kStringFromClass(self));
}

@end
