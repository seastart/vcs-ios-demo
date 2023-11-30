//
//  FWAppDelegate.m
//  VCSSDK
//
//  Created by SailorGa on 04/27/2020.
//  Copyright (c) 2020 SailorGa. All rights reserved.
//

#import "FWAppDelegate.h"
#import "FWLoginViewController.h"
#import <IQKeyboardManager/IQKeyboardManager.h>
#import <ReplayKit/ReplayKit.h>
#import <VCSSDK/VCSBeauty.h>
#import <VCSSDK/VCSWebRTCManager.h>

@interface FWAppDelegate()

@end

@implementation FWAppDelegate

#pragma mark - 懒加载window
- (UIWindow *)window {
    
    if (!_window) {
        _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        _window.backgroundColor = [UIColor whiteColor];
        [_window makeKeyAndVisible];
    }
    return _window;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    /// 设置根视图
    [self setEntry];
    return YES;
}

#pragma mark - 设置根视图
- (void)setEntry {
    
    FWLoginViewController *login = [[FWLoginViewController alloc] init];
    UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:login];
    self.window.rootViewController = navigation;
    /// 部分基础设置
    [self setDefault];
}

#pragma mark - 部分基础设置
- (void)setDefault {
    
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

#pragma mark - 开启计时器
- (void)startTimer {
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
        SGLOG(@"++++++++++定时器任务");
    }];
    /// 加入runloop循环池
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    
    if ([url.absoluteString hasPrefix:@"vcsdemo"]) {
        SGLOG(@"++++++++++URL Scheme 唤起App事件");
    }
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    
    /// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    /// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    /// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    /// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
    /// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    /// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    
    /// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
