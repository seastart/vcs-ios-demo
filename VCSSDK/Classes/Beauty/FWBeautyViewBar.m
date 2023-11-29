//
//  FWBeautyViewBar.m
//  VCSSDK_Example
//
//  Created by SailorGa on 2021/9/28.
//  Copyright © 2021 SailorGa. All rights reserved.
//

#import "FWBeautyViewBar.h"
#import "FWBeautyView.h"
#import "FWFilterView.h"
#import "FWSlider.h"

@interface FWBeautyViewBar() <FWFilterViewDelegate, FWBeautyViewDelegate>

/// 内容
@property (strong, nonatomic) UIView *contentView;

/// 页眉工具栏
@property (weak, nonatomic) IBOutlet UIView *headerView;
/// 页脚工具栏
@property (weak, nonatomic) IBOutlet UIView *footerView;

/// 美肤按钮
@property (weak, nonatomic) IBOutlet UIButton *beautySkinButton;
/// 滤镜按钮
@property (weak, nonatomic) IBOutlet UIButton *beautyFilterButton;

/// 滤镜页
@property (weak, nonatomic) IBOutlet FWFilterView *filterView;
/// 美肤页
@property (weak, nonatomic) IBOutlet FWBeautyView *beautyView;

/// 参数滑竿
@property (weak, nonatomic) IBOutlet FWSlider *beautySlider;

/// 选中的滤镜
@property (nonatomic, strong) FWBeautyModel *seletedParam;

@end

@implementation FWBeautyViewBar

#pragma mark - 初始化视图
/// 初始化视图
- (instancetype)init {

    self = [super init];
    if (self) {
        /// 配置UI属性
        [self stepConfig];
    }
    return self;
}

#pragma mark - 初始化方法
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil].firstObject;
        self.contentView.frame = self.bounds;
        [self addSubview:self.contentView];
        /// 配置属性
        [self stepConfig];
    }
    return self;
}

#pragma mark - 初始化视图
/// 初始化视图
/// @param aDecoder 解码器
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.contentView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil].firstObject;
        self.contentView.frame = self.bounds;
        [self addSubview:self.contentView];
        /// 配置UI属性
        [self stepConfig];
    }
    return self;
}

#pragma mark - 页面重新绘制
/// 页面重新绘制
- (void)layoutSubviews {
    
    [super layoutSubviews];
    /// 重置内容layout
    self.contentView.frame = self.bounds;
}

#pragma mark - 配置属性
- (void)stepConfig {
    
    /// 设置美肤
    [self setupBeautySkin];
    /// 设置滤镜
    [self setupBeautyFilter];
    /// 绑定动态响应信号
    [self bindSignal];
}

#pragma mark - 绑定信号
- (void)bindSignal {
    
    @weakify(self);
    
    /// 绑定美肤按钮事件
    [[self.beautySkinButton rac_signalForControlEvents :UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        [self bottomButtonSelected:control];
    }];
    
    /// 绑定滤镜按钮事件
    [[self.beautyFilterButton rac_signalForControlEvents :UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        [self bottomButtonSelected:control];
    }];
}

#pragma mark - 底部工具栏选中事件
/// 底部工具栏选中事件
/// @param sender 按钮
- (void)bottomButtonSelected:(UIButton *)sender {
    
    if (sender.selected) {
        sender.selected = NO;
        [self hiddenTopViewWithAnimation:YES];
        return ;
    }
    self.beautySkinButton.selected = NO;
    self.beautyFilterButton.selected = NO;
    
    sender.selected = YES;
    
    self.filterView.hidden = !self.beautyFilterButton.selected;
    self.beautyView.hidden = !self.beautySkinButton.selected;
    
    if (self.beautySkinButton.selected) {
        NSInteger selectedIndex = self.beautyView.selectedIndex;
        self.beautySlider.hidden = selectedIndex < 0;
        
        if (selectedIndex >= 0) {
            FWBeautyModel *modle = self.beautyView.dataArray[selectedIndex];
            self.seletedParam = modle;
            self.beautySlider.value = modle.value / modle.ratio;
        }
    }
    
    if (self.beautyFilterButton.selected) {
        NSInteger selectedIndex = self.filterView.selectedIndex;
        self.beautySlider.hidden = selectedIndex <= 0;
        
        if (selectedIndex >= 0) {
            FWBeautyModel *modle = self.filterView.filters[selectedIndex];
            self.seletedParam = modle;
            self.beautySlider.value = modle.value / modle.ratio;
        }
    }
    
    [self showTopViewWithAnimation:self.headerView.isHidden];
}

#pragma mark - 开启页眉工具栏
/// 开启页眉工具栏
- (void)showTopViewWithAnimation:(BOOL)animation {
    
    if (animation) {
        self.headerView.alpha = 0.0;
        self.headerView.transform = CGAffineTransformMakeTranslation(0, self.headerView.frame.size.height / 2.0);
        self.headerView.hidden = NO;
        [UIView animateWithDuration:0.35 animations:^{
            self.headerView.transform = CGAffineTransformIdentity;
            self.headerView.alpha = 1.0;
        }];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(showHeaderView:)]) {
            [self.delegate showHeaderView:YES];
        }
    } else {
        self.headerView.transform = CGAffineTransformIdentity;
        self.headerView.alpha = 1.0;
    }
}

#pragma mark - 关闭页眉工具栏
/// 关闭页眉工具栏
- (void)hiddenTopViewWithAnimation:(BOOL)animation {
    
    if (self.headerView.hidden) {
        return;
    }
    if (animation) {
        self.headerView.alpha = 1.0;
        self.headerView.transform = CGAffineTransformIdentity;
        self.headerView.hidden = NO;
        [UIView animateWithDuration:0.35 animations:^{
            self.headerView.transform = CGAffineTransformMakeTranslation(0, self.headerView.frame.size.height / 2.0);
            self.headerView.alpha = 0.0;
        } completion:^(BOOL finished) {
            self.headerView.hidden = YES;
            self.headerView.alpha = 1.0;
            self.headerView.transform = CGAffineTransformIdentity;
            
            self.beautySkinButton.selected = NO;
            self.beautyFilterButton.selected = NO;
        }];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(showHeaderView:)]) {
            [self.delegate showHeaderView:NO];
        }
    } else {
        self.headerView.hidden = YES;
        self.headerView.alpha = 1.0;
        self.headerView.transform = CGAffineTransformIdentity;
    }
}

#pragma mark - 滑竿值变化
/// 滑竿值变化
/// @param sender 滑竿对象
- (IBAction)sliderChangeEnd:(FWSlider *)sender {
    
    self.seletedParam.value = sender.value;
    
    if (self.beautyFilterButton.selected) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(filterValueChange:)]) {
            [self.delegate filterValueChange:self.seletedParam.value];
        }
    } else {
        if (self.delegate && [self.delegate respondsToSelector:@selector(beautyParamValueChange:type:)]) {
            [self.delegate beautyParamValueChange:self.seletedParam.value type:self.seletedParam.param];
        }
    }
}

#pragma mark - 设置美肤
/// 设置美肤
- (void)setupBeautySkin {
    
    /// 设置代理
    self.beautyView.mDelegate = self;
    /// 设置美肤列表
    self.beautyView.dataArray = [self getSkinData];
}

#pragma mark - 设置滤镜
/// 设置滤镜
- (void)setupBeautyFilter {
    
    /// 设置代理
    self.filterView.mDelegate = self;
    /// 设置滤镜列表
    self.filterView.filters = [self getFilterData];
}

#pragma mark - -------- FWFilterViewDelegate --------
#pragma mark 选择滤镜回调
/// 选择滤镜回调
- (void)filterViewDidSelectedFilter:(FWBeautyModel *)param {
    
    /// 保存设置的滤镜
    self.seletedParam = param;
    if (self.filterView.selectedIndex > 0) {
        self.beautySlider.value = param.value / param.ratio;
        self.beautySlider.hidden = NO;
    } else {
        self.beautySlider.hidden = YES;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(filterNameChange:)]) {
        [self.delegate filterNameChange:self.seletedParam.titleKey];
    }
}

#pragma mark - -------- FWBeautyViewDelegate --------
#pragma mark 选择美肤项回调
/// 选择美肤项回调
- (void)beautyCollectionView:(FWBeautyView *)beautyView didSelectedParam:(FWBeautyModel *)param {
    
    self.seletedParam = param;
    self.beautySlider.value = param.value / param.ratio;
    self.beautySlider.hidden = NO;
}

#pragma mark - 获取所有美肤
/// 获取所有美肤
- (NSArray <FWBeautyModel *> *)getSkinData {
    
    NSArray *prams = @[@"blur_level", @"color_level", @"red_level", @"sharpen_level"];
    NSDictionary *titelDic = @{@"blur_level":@"精细磨皮", @"color_level":@"美白", @"red_level":@"红润", @"sharpen_level":@"锐化"};
    NSDictionary *normalImageDic = @{@"blur_level":@"icon_beauty_blur", @"color_level":@"icon_beauty_color", @"red_level":@"icon_beauty_red", @"sharpen_level":@"icon_beauty_sharpen"};
    NSDictionary *selectedImageDic = @{@"blur_level":@"icon_beauty_blur_select", @"color_level":@"icon_beauty_color_select", @"red_level":@"icon_beauty_red_select", @"sharpen_level":@"icon_beauty_sharpen_select"};
    NSDictionary *defaultValueDic = @{@"blur_level":@(0.5), @"color_level":@(0.3), @"red_level":@(0.3), @"sharpen_level":@(0.3)};
    
    float ratio[FWBeautySkinMax] = {1.0, 1.0, 1.0, 1.0};
    NSMutableArray *skinParams = [NSMutableArray array];
    
    for (NSUInteger i = 0; i < FWBeautySkinMax; i ++) {
        NSString *str = prams[i];
        FWBeautyModel *model = [[FWBeautyModel alloc] init];
        /// 视频处理类型(美肤)
        model.type = FWBeautyDefineSkin;
        model.param = i;
        model.title = [titelDic valueForKey:str];
        model.value = [[defaultValueDic valueForKey:str] floatValue];
        model.normalImageStr = [normalImageDic valueForKey:str];
        model.selectedImageStr = [selectedImageDic valueForKey:str];
        model.defaultValue = model.value;
        model.ratio = ratio[i];
        [skinParams addObject:model];
    }
    return [NSArray arrayWithArray:skinParams];
}

#pragma mark - 获取所有滤镜
/// 获取所有滤镜
- (NSArray <FWBeautyModel *> *)getFilterData {
    
    NSArray *beautyFiltersDataSource = @[@"origin",
                                         
                                         @"bailiang1",@"bailiang2",@"bailiang3",@"bailiang4",@"bailiang5",@"bailiang6",@"bailiang7",
                                         
                                         @"fennen1",@"fennen2",@"fennen3",@"fennen4",@"fennen5",@"fennen6",
                                         
                                         @"lengsediao1",@"lengsediao2",@"lengsediao3",@"lengsediao4",@"lengsediao5",@"lengsediao6",@"lengsediao7",@"lengsediao8",@"lengsediao11",
                                         
                                         @"nuansediao1",@"nuansediao2",
                                         
                                         @"gexing1",@"gexing2",@"gexing3",@"gexing4",@"gexing5",@"gexing6",@"gexing7",@"gexing10",@"gexing11",
                                         
                                         @"heibai1",@"heibai2",@"heibai3",@"heibai4"
    ];
    
    NSDictionary *filtersCHName = @{@"origin":@"原图",
                                    
                                    @"bailiang1":@"白亮1",@"bailiang2":@"白亮2",@"bailiang3":@"白亮3",@"bailiang4":@"白亮4",@"bailiang5":@"白亮5",@"bailiang6":@"白亮6",@"bailiang7":@"白亮7",
                                    
                                    @"fennen1":@"粉嫩1",@"fennen2":@"粉嫩2",@"fennen3":@"粉嫩3",@"fennen4":@"粉嫩4",@"fennen5":@"粉嫩5",@"fennen6":@"粉嫩6",
                                    
                                    @"lengsediao1":@"冷色调1",@"lengsediao2":@"冷色调2",@"lengsediao3":@"冷色调3",@"lengsediao4":@"冷色调4",@"lengsediao5":@"冷色调5",@"lengsediao6":@"冷色调6",@"lengsediao7":@"冷色调7",@"lengsediao8":@"冷色调8",@"lengsediao9":@"冷色调9",@"lengsediao10":@"冷色调10",@"lengsediao11":@"冷色调11",
                                    
                                    @"nuansediao1":@"暖色调1",@"nuansediao2":@"暖色调2",@"nuansediao3":@"暖色调3",
                                    
                                    @"gexing1":@"个性1",@"gexing2":@"个性2",@"gexing3":@"个性3",@"gexing4":@"个性4",@"gexing5":@"个性5",@"gexing6":@"个性6",@"gexing7":@"个性7",@"gexing8":@"个性8",@"gexing9":@"个性9",@"gexing10":@"个性10",@"gexing11":@"个性11",
                                    
                                    @"heibai1":@"黑白1",@"heibai2":@"黑白2",@"heibai3":@"黑白3",@"heibai4":@"黑白4",@"heibai5":@"黑白5",
    };
    NSMutableArray *filters = [NSMutableArray array];
    
    for (NSString *str in beautyFiltersDataSource) {
        FWBeautyModel *model = [[FWBeautyModel alloc] init];
        /// 视频处理类型(滤镜)
        model.type = FWBeautyDefineFilter;
        model.titleKey = str;
        model.title = [filtersCHName valueForKey:str];
        model.value = 0.4;
        model.ratio = 1.0;
        [filters addObject:model];
    }
    
    return [NSArray arrayWithArray:filters];
}

#pragma mark - 释放资源
- (void)dealloc {
    
    SGLOG(@"++++++++++++释放资源：%@", kStringFromClass(self));
}

@end
