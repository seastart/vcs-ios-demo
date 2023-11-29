//
//  FWWhiteBoardView.h
//  VCSSDK_Example
//
//  Created by SailorGa on 2020/5/28.
//  Copyright © 2020 SailorGa. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 结束会议按钮事件回调
typedef void(^FWWhiteBoardViewLogoutClickBlock)(void);

@interface FWWhiteBoardView : UIView

#pragma mark - 更改屏幕方向
/// 更改屏幕方向
/// @param isHorizontalScreen YES-切换横屏 NO-切换竖屏
- (void)changeScreenOrientation:(BOOL)isHorizontalScreen;

#pragma mark - 获取当前白板的显示状态
/// 获取当前白板的显示状态
- (BOOL)getShowState;

#pragma mark - 显示视图
/// 显示视图
/// @param host 白板地址
/// @param userId 用户ID
/// @param meetingId 会议ID
/// @param privileges 读写权限
/// @param imageUrl 图片地址
/// @param image 背景图片
- (void)showView:(NSString *)host userId:(NSString *)userId meetingId:(NSString *)meetingId privileges:(BOOL)privileges imageUrl:(nullable NSString *)imageUrl image:(nullable UIImage *)image;

#pragma mark - 隐藏视图
/// 隐藏视图
- (void)hiddenView;

/// 结束会议按钮事件回调
@property (copy, nonatomic) FWWhiteBoardViewLogoutClickBlock logoutClickBlock;

/// 结束会议按钮事件回调
/// @param logoutClickBlock 结束会议按钮事件回调
- (void)logoutClickBlock:(FWWhiteBoardViewLogoutClickBlock)logoutClickBlock;

@end

NS_ASSUME_NONNULL_END
