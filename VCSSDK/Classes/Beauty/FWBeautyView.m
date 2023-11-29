//
//  FWBeautyView.m
//  VCSSDK_Example
//
//  Created by SailorGa on 2021/9/28.
//  Copyright © 2021 SailorGa. All rights reserved.
//

#import "FWBeautyView.h"

@interface FWBeautyView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@end

@implementation FWBeautyView

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor clearColor];
    self.delegate = self;
    self.dataSource = self;
    [self registerClass:[FWBeautyCell class] forCellWithReuseIdentifier:@"FWBeautyCell"];
    
    _selectedIndex = 0;
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    
    _selectedIndex = selectedIndex;
    [self reloadData];
}

#pragma mark ---- UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.dataArray.count ;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    FWBeautyCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FWBeautyCell" forIndexPath:indexPath];
    
    if (indexPath.row < self.dataArray.count) {
        
        FWBeautyModel *modle = self.dataArray[indexPath.row];
        
        /// 判断当前是否选中
        BOOL selected = (_selectedIndex == indexPath.row);
        
        cell.imageView.image = kGetImage(selected ? modle.selectedImageStr : modle.normalImageStr);
        cell.titleLabel.text = modle.title;
        cell.titleLabel.textColor = selected ? RGBOF(0x5EC7FE) : [UIColor whiteColor];
    }
    return cell;
}

#pragma mark ---- UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_selectedIndex == indexPath.row) {
        /// 点击为当前选中Item，丢弃该指令
        return;
    }
    FWBeautyModel *model = self.dataArray[indexPath.row];
    _selectedIndex = indexPath.row;
    
    [self reloadData];
    
    if (self.mDelegate && [self.mDelegate respondsToSelector:@selector(beautyCollectionView:didSelectedParam:)]) {
        [self.mDelegate beautyCollectionView:self didSelectedParam:model];
    }
}

#pragma mark ---- UICollectionViewDelegateFlowLayout
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(16, 16, 6, 16);
}

@end

@implementation FWBeautyCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.width)];
        self.imageView.layer.masksToBounds = YES;
        self.imageView.layer.cornerRadius = frame.size.width / 2.0;
        [self addSubview:self.imageView];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(-10, frame.size.width + 2, frame.size.width + 20, frame.size.height - frame.size.width - 2)];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.font = [UIFont systemFontOfSize:10];
        self.titleLabel.adjustsFontSizeToFitWidth = YES;
        
        [self addSubview:self.titleLabel];
    }
    return self;
}

@end
