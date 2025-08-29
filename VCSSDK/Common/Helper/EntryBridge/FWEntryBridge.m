//
//  FWEntryBridge.m
//  VCSSDK_Example
//
//  Created by SailorGa on 2025/8/25.
//  Copyright © 2025 SailorGa. All rights reserved.
//

#import <IQKeyboardManager/IQKeyboardManager.h>
#import "FWLoginViewController.h"
#import <VCSSDK/VCSBeauty.h>
#import "FWSceneDelegate.h"
#import "FWAppDelegate.h"
#import "FWEntryBridge.h"

@interface FWEntryBridge()

@end

@implementation FWEntryBridge

/// 初始化方法
+ (FWEntryBridge *)sharedManager {
    
    static FWEntryBridge *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        manager = [[FWEntryBridge alloc] init];
    });
    return manager;
}

/// 获取当前窗口
- (UIWindow *)getCurrentWindow {
    
    /// 获取当前活跃场景的 delegate（iOS 13+）
    if (@available(iOS 13.0, *)) {
        NSSet<UIScene *> *scenes = [UIApplication sharedApplication].connectedScenes;
        /// 取首个活跃场景
        UIWindowScene *windowScene = (UIWindowScene *)[[scenes allObjects] firstObject];
        FWSceneDelegate *sceneDelegate = (FWSceneDelegate *)windowScene.delegate;
        UIWindow *currentWindow = sceneDelegate.window;
        /// 返回当前窗口
        return currentWindow;
    } else {
        /// iOS 12 以下沿用旧方式
        FWAppDelegate *appDelegate = (FWAppDelegate *)[[UIApplication sharedApplication] delegate];
        UIWindow *currentWindow = appDelegate.window;
        /// 返回当前窗口
        return currentWindow;
    }
}

/// 部分基础设置
- (void)setupDefault {
    
    /// 启动日志服务(示例代码，注：当前环境已经不可使用)
    /// [[FWLoggerBridge sharedManager] startLogger:@"https://log.swmeeting.cn/test4" secretKey:@"123" deviceId:DeviceUUID];
    /// 让线程休眠一段时间来达到修改启动页面停留时间效果
    /// [NSThread sleepForTimeInterval:3];
    /// 存储默认服务器
    [kSGUserDefaults setObject:DATADEFAULTAPI forKey:DATADEFAULTAPIKEY];
    
    /// 启用键盘功能
    [[IQKeyboardManager sharedManager] setEnable:YES];
    /// 键盘弹出时点击背景键盘收回
    [[IQKeyboardManager sharedManager] setShouldResignOnTouchOutside:YES];
    /// 禁用IQKeyboard的Toolbar
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
    
    /// 提示框样式
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    /// 提示框背景颜色
    /// [SVProgressHUD setBackgroundColor:[UIColor colorWithWhite:0.f alpha:0.6]];
    [SVProgressHUD setBackgroundColor:[UIColor blackColor]];
    /// 提示框内容颜色
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    /// 提示框显示最短时间
    [SVProgressHUD setMinimumDismissTimeInterval:2.f];
    /// 提示框文本字体
    [SVProgressHUD setFont:[UIFont systemFontOfSize:14.f weight:UIFontWeightRegular]];
    /// 提示框无文本圆环半径
    [SVProgressHUD setRingNoTextRadius:18.f];
    /// 提示框有文本圆环半径
    [SVProgressHUD setRingRadius:18.f];
    /// 提示框阴影不透明度
    [SVProgressHUD setShadowOpacity:0.f];
    /// 提示框阴影半径
    [SVProgressHUD setShadowRadius:0.f];
    /// 提示框圆角
    [SVProgressHUD setCornerRadius:8.f];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wnonnull"
    /// 提示框信息消息图像
    [SVProgressHUD setInfoImage:nil];
    /// 提示框成功消息图像
    [SVProgressHUD setSuccessImage:nil];
    /// 提示框错误消息图像
    [SVProgressHUD setErrorImage:nil];
#pragma clang diagnostic pop
    
    /// 添加内存监测白名单
    [NSObject addClassNamesToWhitelist:@[@"UIAlertController", @"UITextField", @"UITextView", @"SFSafariViewController", @"RPSystemBroadcastPickerView", @"RPBroadcastPickerStandaloneViewController", @"UIDocumentPickerViewController", @"QLPreviewController"]];
    
    /// 初始化美颜服务
    [[VCSBeautyManager sharedManager] setupRenderKit:g_auth_package authDataSize:sizeof(g_auth_package) logLevel:VCSBeautyLogLevelError];
}

/// 设置窗口根视图
- (void)setWindowRootView {
    
    FWLoginViewController *login = [[FWLoginViewController alloc] init];
    UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:login];
    self.getCurrentWindow.rootViewController = navigation;
    [self.getCurrentWindow makeKeyAndVisible];
}

@end
