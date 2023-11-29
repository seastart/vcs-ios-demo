//
//  FWFilterView.m
//  VCSSDK_Example
//
//  Created by SailorGa on 2021/9/25.
//  Copyright © 2021 SailorGa. All rights reserved.
//

#import "FWFilterView.h"

@interface FWFilterView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@end

@implementation FWFilterView

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor clearColor];
    self.delegate = self;
    self.dataSource = self ;
    [self registerClass:[FWFilterCell class] forCellWithReuseIdentifier:@"FWFilterCell"];
    
    _selectedIndex = 0;
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    
    _selectedIndex = selectedIndex;
    [self reloadData];
}

- (void)setDefaultFilter:(FWBeautyModel *)filter {
    
    for (int i = 0; i < self.filters.count; i ++) {
        FWBeautyModel *model = self.filters[i];
        if ([model.titleKey isEqualToString:filter.titleKey]) {
            self.selectedIndex = i;
            return;
        }
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.filters.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    FWFilterCell *cell = (FWFilterCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"FWFilterCell" forIndexPath:indexPath];
    
    FWBeautyModel *model = self.filters[indexPath.row];
    
    cell.titleLabel.text = model.title;
    cell.titleLabel.textColor = [UIColor whiteColor];
    cell.imageView.image = kGetImage(model.titleKey);
    
    cell.imageView.layer.borderWidth = 0.0 ;
    cell.imageView.layer.borderColor = [UIColor clearColor].CGColor;
    
    if (_selectedIndex == indexPath.row) {
        /// 选中样式
        cell.imageView.layer.borderWidth = 2.0;
        cell.imageView.layer.borderColor = RGBOF(0xFF5B50).CGColor;
        cell.titleLabel.textColor = RGBOF(0xFF5B50);
    }
    
    return cell;
}

#pragma mark ---- UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    _selectedIndex = indexPath.row;
    [self reloadData];
    
    FWBeautyModel *model = self.filters[indexPath.row];
    
    if (self.mDelegate && [self.mDelegate respondsToSelector:@selector(filterViewDidSelectedFilter:)]) {
        [self.mDelegate filterViewDidSelectedFilter:model];
    }
}


@end

@implementation FWFilterCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 54, 54)];
        self.imageView.layer.masksToBounds = YES;
        self.imageView.layer.cornerRadius = 3.0;
        self.imageView.layer.borderWidth = 0.0;
        self.imageView.layer.borderColor = [UIColor clearColor].CGColor;
        [self addSubview:self.imageView];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(-8, 54, 70, frame.size.height - 54)];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont systemFontOfSize:10];
        [self addSubview:self.titleLabel];
    }
    return self ;
}
@end
