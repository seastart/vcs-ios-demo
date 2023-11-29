//
//  FWSlider.m
//  VCSSDK_Example
//
//  Created by SailorGa on 2021/9/28.
//  Copyright © 2021 SailorGa. All rights reserved.
//

#import "FWSlider.h"

@implementation FWSlider {
    
    UILabel *tipLabel;
    UIImageView *bgImgView;
    
    UIView *middleView;
    UIView *line;
}

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    [self setThumbImage:kGetImage(@"icon_beauty_slider_dot") forState:UIControlStateNormal];
    
    UIImage *bgImage = kGetImage(@"icon_beauty_slider_tip_bg");
    bgImgView = [[UIImageView alloc] initWithImage:bgImage];
    bgImgView.frame = CGRectMake(0, -bgImage.size.height, bgImage.size.width, bgImage.size.height);
    [self addSubview:bgImgView];
    
    tipLabel = [[UILabel alloc] initWithFrame:bgImgView.frame];
    tipLabel.text = @"";
    tipLabel.textColor = [UIColor darkGrayColor];
    tipLabel.font = [UIFont systemFontOfSize:14];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:tipLabel];
    
    bgImgView.hidden = YES;
    tipLabel.hidden = YES;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self setThumbImage:kGetImage(@"icon_beauty_slider_dot") forState:UIControlStateNormal];
        
        UIImage *bgImage = kGetImage(@"icon_beauty_slider_tip_bg");
        bgImgView = [[UIImageView alloc] initWithImage:bgImage];
        bgImgView.frame = CGRectMake(0, -bgImage.size.height, bgImage.size.width, bgImage.size.height);
        [self addSubview:bgImgView];
        
        tipLabel = [[UILabel alloc] initWithFrame:bgImgView.frame];
        tipLabel.text = @"";
        tipLabel.textColor = [UIColor darkGrayColor];
        tipLabel.font = [UIFont systemFontOfSize:14];
        tipLabel.textAlignment = NSTextAlignmentCenter;
        tipLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:tipLabel];
        
        bgImgView.hidden = YES;
        tipLabel.hidden = YES;
    }
    return self;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    if (!middleView) {
        
        middleView = [[UIView alloc] initWithFrame:CGRectMake(2, self.frame.size.height /2.0 - 1, 100, 4)];
        middleView.backgroundColor = RGBOF(0x1FB2FF);
        middleView.hidden = YES;
        [self insertSubview:middleView atIndex: self.subviews.count - 1];
    }
    
    if (!line) {
        
        line = [[UIView alloc] init];
        line.backgroundColor = [UIColor whiteColor];
        line.layer.masksToBounds = YES ;
        line.layer.cornerRadius = 1.0 ;
        line.hidden = YES;
        [self insertSubview:line atIndex: self.subviews.count - 1];
    }
    
    line.frame = CGRectMake(self.frame.size.width / 2.0 - 1.0, 4.0, 2.0, self.frame.size.height - 8.0) ;
    
    CGFloat value = self.value ;
    [self setValue:value animated:NO];
}

/// 设置 value
- (void)setValue:(float)value animated:(BOOL)animated {
    
    [super setValue:value animated:animated];
    
    tipLabel.text = [NSString stringWithFormat:@"%d",(int)(value * 100)];
    
    CGFloat x = value * (self.frame.size.width - 20) - tipLabel.frame.size.width * 0.5 + 10;
    CGRect frame = tipLabel.frame;
    frame.origin.x = x;
    
    bgImgView.frame = frame;
    tipLabel.frame = frame;
    tipLabel.hidden = !self.tracking;
    bgImgView.hidden = !self.tracking;
}

@end
