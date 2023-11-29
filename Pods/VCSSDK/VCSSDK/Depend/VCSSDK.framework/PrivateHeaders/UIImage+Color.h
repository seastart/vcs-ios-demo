//
//  UIImage+Color.h
//  VCSSDK
//
//  Created by SailorGa on 2020/8/3.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage(Color)

/// 创建纯色图片
/// @param color 生成纯色图片的颜色
/// @param imageSize 需要创建纯色图片的尺寸
+ (UIImage *)createImageWithColor:(UIColor *)color withSize:(CGSize)imageSize;

/// 创建圆角图片
/// @param originalImage 原始图片
/// @param radius 圆角大小
+ (UIImage *)imageWithOriginalImage:(UIImage *)originalImage radius:(CGFloat)radius;

/// 创建圆角纯色图片
/// @param color 设置圆角纯色图片的颜色
/// @param imageSize 设置圆角角纯色图片的尺寸
/// @param radius 圆角大小
+ (UIImage *)createRoundedImageWithColor:(UIColor *)color withSize:(CGSize)imageSize radius:(CGFloat)radius;

/// 生成带圆环的圆角图片
/// @param originalImage 原始图片
/// @param borderColor 圆环颜色
/// @param borderWidth 圆环宽度
+ (UIImage *)imageWithOriginalImage:(UIImage *)originalImage withBorderColor:(UIColor *)borderColor withBorderWidth:(CGFloat)borderWidth;

@end

NS_ASSUME_NONNULL_END
