//
//  FWSceneDelegate.m
//  VCSSDK_Example
//
//  Created by SailorGa on 2025/8/25.
//  Copyright © 2025 SailorGa. All rights reserved.
//

#import "FWSceneDelegate.h"

@interface FWSceneDelegate ()

@end

@implementation FWSceneDelegate

/// 首次创建或系统恢复时调用
/// - Parameters:
///   - scene: 连接场景对象
///   - session: 场景会话对象
///   - connectionOptions: 场景启动时的上下文信息
- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
    
    /// Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
    /// If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
    /// This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
    
    if (@available(iOS 13.0, *)) {
        /// 获取窗口画布
        UIWindowScene *windowScene = (UIWindowScene *)scene;
        /// 创建应用窗口
        self.window = [[UIWindow alloc] initWithWindowScene:windowScene];
        /// 设置窗口布局
        self.window.frame = windowScene.coordinateSpace.bounds;
        /// 基础设置
        [[FWEntryBridge sharedManager] setupDefault];
        /// 设置窗口根视图
        [[FWEntryBridge sharedManager] setWindowRootView];
    }
}

/// 应用被系统销毁时调用
/// - Parameter scene: 连接场景对象
- (void)sceneDidDisconnect:(UIScene *)scene {
    
    /// Called as the scene is being released by the system.
    /// This occurs shortly after the scene enters the background, or when its session is discarded.
    /// Release any resources associated with this scene that can be re-created the next time the scene connects.
    /// The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
}

/// 应用变为活跃状态时调用
/// - Parameter scene: 连接场景对象
- (void)sceneDidBecomeActive:(UIScene *)scene {
    
    /// Called when the scene has moved from an inactive state to an active state.
    /// Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
}

/// 应用即将变为非活跃状态时调用
/// - Parameter scene: 连接场景对象
- (void)sceneWillResignActive:(UIScene *)scene {
    
    /// Called when the scene will move from an active state to an inactive state.
    /// This may occur due to temporary interruptions (ex. an incoming phone call).
}

/// 应用即将进入前台时调用
/// - Parameter scene: 连接场景对象
- (void)sceneWillEnterForeground:(UIScene *)scene {
    
    /// Called as the scene transitions from the background to the foreground.
    /// Use this method to undo the changes made on entering the background.
}

/// 应用完全进入后台时调用
/// - Parameter scene: 连接场景对象
- (void)sceneDidEnterBackground:(UIScene *)scene {
    
    /// Called as the scene transitions from the foreground to the background.
    /// Use this method to save data, release shared resources, and store enough scene-specific state information
    /// to restore the scene back to its current state.
}

@end
