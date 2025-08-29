//
//  FWAppDelegate.m
//  VCSSDK
//
//  Created by SailorGa on 04/27/2020.
//  Copyright (c) 2020 SailorGa. All rights reserved.
//

#import "FWAppDelegate.h"

@interface FWAppDelegate()

@end

@implementation FWAppDelegate

/// 首次启动或重新启动时调用
/// - Parameters:
///   - application: 应用实例
///   - launchOptions: 启动时的上下文信息
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    if (@available(iOS 13.0, *)) {
        /// iOS 13+ 由 SceneDelegate 处理，此处留空
    } else {
        /// iOS 12 及以下初始化窗口
        self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        /// 设置窗口背景色
        self.window .backgroundColor = [UIColor whiteColor];
        /// 全局相关配置
        [self baseSet:application didFinishLaunchingWithOptions:launchOptions];
    }
    
    return YES;
}

/// 全局相关配置
/// - Parameters:
///   - application: 应用实例
///   - launchOptions: 启动时的上下文信息
- (void)baseSet:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    /// 基础设置
    [[FWEntryBridge sharedManager] setupDefault];
    /// 设置窗口根视图
    [[FWEntryBridge sharedManager] setWindowRootView];
}

/// 通过URL进入应用的响应
/// - Parameters:
///   - application: 应用程序对象
///   - url: 访问路径
///   - options: 启动项
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    
    if ([url.absoluteString hasPrefix:@"vcsdemo"]) {
        SGLOG(@"++++++++++URL Scheme 唤起App事件");
    }
    return YES;
}

/// 系统需要​​创建一个新的场景 (UIScene)​​ 时调用
/// - Parameters:
///   - application: 应用实例
///   - connectingSceneSession: 场景会话对象
///   - options: 连接场景时的选项参数
- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    
    /// Called when a new scene session is being created.
    /// Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}

/// 主动关闭并丢弃一个或多个场景​​时调用
/// - Parameters:
///   - application: 应用实例
///   - sceneSessions: 场景会话对象集合
- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    
    /// Called when the user discards a scene session.
    /// If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    /// Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}

/// 应用即将变为非活跃状态时调用
/// - Parameter application: 应用实例
- (void)applicationWillResignActive:(UIApplication *)application {
    
    /// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    /// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

/// 应用完全进入后台时调用
/// - Parameter application: 应用实例
- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    /// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    /// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

/// 应用即将进入前台时调用
/// - Parameter application: 应用实例
- (void)applicationWillEnterForeground:(UIApplication *)application {
    
    /// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

/// 应用变为活跃状态时调用
/// - Parameter application: 应用实例
- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    /// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

/// 应用被系统终止前调用
/// - Parameter application: 应用实例
- (void)applicationWillTerminate:(UIApplication *)application {
    
    /// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
