//
//  FWFilterView.h
//  VCSSDK_Example
//
//  Created by SailorGa on 2021/9/25.
//  Copyright © 2021 SailorGa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FWBeautyModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol FWFilterViewDelegate <NSObject>

/// 开启滤镜
- (void)filterViewDidSelectedFilter:(FWBeautyModel *)param;

@end

@interface FWFilterView : UICollectionView

@property (nonatomic, weak) id <FWFilterViewDelegate> mDelegate;

@property (nonatomic, assign) NSInteger selectedIndex;

@property (nonatomic, strong) NSArray<FWBeautyModel *> *filters;

- (void)setDefaultFilter:(FWBeautyModel *)filter;

@end

@interface FWFilterCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;

@end

NS_ASSUME_NONNULL_END
