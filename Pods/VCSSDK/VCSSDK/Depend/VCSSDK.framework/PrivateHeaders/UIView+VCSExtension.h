//
//  UIView+VCSExtension.h
//  VCSSDK
//
//  Created by SailorGa on 2020/5/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView(VCSExtension)

@property CGFloat vcs_width;
@property CGFloat vcs_height;
@property CGFloat vcs_x;
@property CGFloat vcs_y;
@property CGFloat vcs_right;
@property CGFloat vcs_bottom;
@property CGFloat vcs_centerX;
@property CGFloat vcs_centerY;
@property CGSize  vcs_size;
@property CGFloat vcs_radius;

- (void)addBorderColor:(UIColor *)color;
- (UIImage *)makeImageWithView;
+ (instancetype)vcs_viewFromXib;

@end

NS_ASSUME_NONNULL_END
