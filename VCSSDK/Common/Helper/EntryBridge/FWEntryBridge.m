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
    [IQKeyboardManager sharedManager].enable = YES;
    /// 键盘弹出时点击背景键盘收回
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    /// 添加内存监测白名单
    [NSObject addClassNamesToWhitelist:@[@"UIAlertController", @"UITextField", @"RPSystemBroadcastPickerView", @"RPBroadcastPickerStandaloneViewController"]];
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
