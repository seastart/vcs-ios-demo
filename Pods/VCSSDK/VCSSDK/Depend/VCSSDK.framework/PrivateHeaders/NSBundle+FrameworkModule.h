//
//  NSBundle+FrameworkModule.h
//  VCSSDK
//
//  Created by SailorGa on 2020/8/1.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSBundle(FrameworkModule)

/// 通过bundle获取资源路径
+ (NSBundle *)bundleForFramework:(Class)frameworkClass module:(NSString *)module;

/// 通过bundle获取资源路径
+ (NSString *)bundleStrForFramework:(Class)frameworkClass module:(NSString *)module;

/// 通过bundle路径获取Image
+ (UIImage *)imageName:(NSString *)imageName bundleStrForFramework:(Class)frameworkClass module:(NSString *)module;

/// 按比例获取图片高度
+ (CGFloat)getHeightByImageName:(NSString *)imageName bundleStrForFramework:(Class)frameworkClass module:(NSString *)module;

@end

NS_ASSUME_NONNULL_END
