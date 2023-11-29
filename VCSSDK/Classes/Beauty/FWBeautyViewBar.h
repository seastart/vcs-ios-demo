//
//  FWBeautyViewBar.h
//  VCSSDK_Example
//
//  Created by SailorGa on 2021/9/28.
//  Copyright © 2021 SailorGa. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol FWBeautyViewBarDelegate <NSObject>

/// 滤镜改变
- (void)filterNameChange:(NSString *)filterName;

/// 滤镜程度改变
- (void)filterValueChange:(double)filterLevel;

/// 美颜参数改变
- (void)beautyParamValueChange:(double)level type:(FWBeautySkin)type;

/// 显示页眉工具栏
- (void)showHeaderView:(BOOL)shown;

@end

@interface FWBeautyViewBar : UIView

@property (nonatomic, assign) id<FWBeautyViewBarDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
