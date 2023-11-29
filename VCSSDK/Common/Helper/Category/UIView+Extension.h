//
//  UIView+Extension.h
//  seastart-base-templates-1.0-iOS
//
//  Created by SailorGa on 2015/12/29.
//  Copyright © 2015年 SailorGa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView(Extension)

@property CGFloat sa_width;
@property CGFloat sa_height;
@property CGFloat sa_x;
@property CGFloat sa_y;
@property CGFloat sa_right;
@property CGFloat sa_bottom;
@property CGFloat sa_centerX;
@property CGFloat sa_centerY;
@property CGSize  sa_size;
@property CGFloat sa_radius;

- (void)addBorderColor:(UIColor *)color;
- (UIImage *)makeImageWithView;
+ (instancetype)sa_viewFromXib;

@end
