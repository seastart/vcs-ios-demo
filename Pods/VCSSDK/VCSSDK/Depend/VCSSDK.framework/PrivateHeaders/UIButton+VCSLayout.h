//
//  UIButton+VCSLayout.h
//  VCSSDK-VCSSDK
//
//  Created by SailorGa on 2020/8/3.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - 图片和文字位置类型
/**
 图片和文字位置类型
 
 - VCSLayoutStatusNormal: 正常位置，图左字右
 - VCSLayoutStatusImageRight: 图右字左
 - VCSLayoutStatusImageTop: 图上字下
 - VCSLayoutStatusImageBottom: 图下字上
 */
typedef enum : NSUInteger {
    VCSLayoutStatusNormal = 0,
    VCSLayoutStatusImageRight,
    VCSLayoutStatusImageTop,
    VCSLayoutStatusImageBottom,
} VCSLayoutStatus;

@interface UIButton(VCSLayout)

#pragma mark - 设置按钮图片和文字位置
/// 设置按钮图片和文字位置
/// @param status 位置类型
/// @param margin 间距
- (void)layoutWithStatus:(VCSLayoutStatus)status andMargin:(CGFloat)margin;

@end

NS_ASSUME_NONNULL_END
