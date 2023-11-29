//
//  FWBeautyView.h
//  VCSSDK_Example
//
//  Created by SailorGa on 2021/9/28.
//  Copyright © 2021 SailorGa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FWBeautyModel.h"

NS_ASSUME_NONNULL_BEGIN

@class FWBeautyView;

@protocol FWBeautyViewDelegate <NSObject>

- (void)beautyCollectionView:(FWBeautyView *)beautyView didSelectedParam:(FWBeautyModel *)param;

@end

@interface FWBeautyView : UICollectionView

@property (nonatomic, assign) id<FWBeautyViewDelegate> mDelegate;

@property (nonatomic, assign) NSInteger selectedIndex;

@property (nonatomic, strong) NSArray <FWBeautyModel *> *dataArray;

@end

@interface FWBeautyCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;

@end

NS_ASSUME_NONNULL_END
