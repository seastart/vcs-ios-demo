//
//  FWPlayerView.m
//  VCSSDK_Example
//
//  Created by SailorGa on 2020/4/30.
//  Copyright © 2020 SailorGa. All rights reserved.
//

#import "FWPlayerView.h"
#import "FWCameraView.h"
#import "FWYUVPlayerView.h"

/// 小窗口宽(横屏)
#define FWPlayVideoHorizontalWidth SCREEN_WIDTH / 2 - 5
/// 小窗口高(横屏)
#define FWPlayVideoHorizontalHeight (SCREEN_WIDTH / 2 - 5) * 9 / 16

/// 小窗口宽(竖屏)
#define FWPlayVideoVerticalWidth SCREEN_WIDTH / 2 - 5
/// 小窗口高(竖屏)
#define FWPlayVideoVerticalHeight (SCREEN_WIDTH / 2 - 5) * 16 / 9

@interface FWPlayerView () <VCSMeetingManagerCameraProtocol, UIGestureRecognizerDelegate>

/// 内容
@property (weak, nonatomic) IBOutlet UIView *contentView;
/// 本地采集预览
@property (nonatomic, strong) FWCameraView *cameraView;
/// 视频显示整体宽度
@property (nonatomic, assign) CGFloat videoWidth;
/// 播放ID查找缓存方法
@property (nonatomic, strong) NSMutableDictionary *playDic;
/// 播放ID查找缓存方法
@property (nonatomic, strong) NSMutableArray *playArray;
/// 视频采集对象是否展示在大画面中 YES是
@property (nonatomic, assign) BOOL isShowMaxVideoState;
/// 标记是否横屏
@property (nonatomic, assign) BOOL isHorizontalScreen;

@end

@implementation FWPlayerView

#pragma mark 初始化视图
/// 初始化视图
/// @param frame 位置尺寸
- (instancetype)initSGWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil].firstObject;
        self.contentView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        [self addSubview:self.contentView];
        /// 设置属性cameraView
        [self stepConfig];
    }
    return self;
}

#pragma mark - 页面重新绘制
- (void)layoutSubviews {
    
    [super layoutSubviews];
    /// 重新布局本地采集预览
    self.cameraView.frame = self.bounds;
}

#pragma mark - 懒加载本地采集预览
- (FWCameraView *)cameraView {
    
    if (!_cameraView) {
        _cameraView = [[FWCameraView alloc] initWithFrame:self.bounds];
    }
    return _cameraView;
}

#pragma mark - 设置属性
- (void)stepConfig {
    
    /// 加载本地采集预览
    [self insertSubview:self.cameraView atIndex:0];
    /// 默认采集大图
    self.isShowMaxVideoState = YES;
    /// 默认设置横屏
    self.isHorizontalScreen = [VCSMeetingManager sharedManager].meetingParam.isHorizontalScreen;
    /// 设置采集窗口代理
    [VCSMeetingManager sharedManager].cameraDelegate = self;
    /// 视图添加相机采集
    [[VCSMeetingManager sharedManager] onLocalDisplayViewReady:self.cameraView.player];
    /// 添加采集对象到维护数据
    [self.playArray addObject:self.cameraView];
    
    /// 视图添加视频父组件
    [self addSubview:self.scrollView];
}

#pragma mark - 懒加载播放ID缓存字典数据
- (NSMutableDictionary *)playDic {
    
    if (!_playDic) {
        _playDic = [NSMutableDictionary dictionary];
    }
    return _playDic;
}

#pragma mark - 懒加载播放ID缓存数组数据
- (NSMutableArray *)playArray {
    
    if (!_playArray) {
        _playArray = [NSMutableArray array];
    }
    return _playArray;
}

#pragma mark - 小窗口视频父组件
- (UIScrollView *)scrollView {
    
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - FWPlayVideoVerticalHeight, SCREEN_WIDTH, FWPlayVideoVerticalHeight)];
        /// 弹性开启
        _scrollView.bounces = YES;
        /// 隐藏滑动条
        _scrollView.showsVerticalScrollIndicator = NO;
        /// 隐藏滑动条
        _scrollView.showsHorizontalScrollIndicator = NO;
        /// 默认透明色
        _scrollView.backgroundColor = [UIColor clearColor];
    }
    return _scrollView;
}

#pragma mark - 更改屏幕方向
/// 更改屏幕方向
/// @param isHorizontalScreen YES-切换横屏 NO-切换竖屏
- (void)changeScreenOrientation:(BOOL)isHorizontalScreen {
    
    /// 设置横竖屏方向
    self.isHorizontalScreen = isHorizontalScreen;
    self.sa_height = SCREEN_HEIGHT;
    self.sa_width = SCREEN_WIDTH;
    if (self.isHorizontalScreen) {
        self.scrollView.sa_y = SCREEN_HEIGHT - FWPlayVideoHorizontalHeight;
        self.scrollView.sa_width = SCREEN_WIDTH;
        self.scrollView.sa_height = FWPlayVideoHorizontalHeight;
    } else {
        self.scrollView.sa_y = SCREEN_HEIGHT - FWPlayVideoVerticalHeight;
        self.scrollView.sa_width = SCREEN_WIDTH;
        self.scrollView.sa_height = FWPlayVideoVerticalHeight;
    }
    /// 小窗口重置x坐标
    [self windowViewReset];
}

#pragma mark - 我的视频发生变化处理
/// 我的视频发生变化处理
/// @param videoState 视频状态
- (void)stepVideoState:(BOOL)videoState {
    
    [self.cameraView stepVideoState:videoState];
}

#pragma mark - 我的音频发生变化处理
/// 我的音频发生变化处理
/// @param audioState 音频状态
- (void)stepAudioState:(BOOL)audioState {
    
    [self.cameraView stepAudioState:audioState];
}

#pragma mark - ------- VCSMeetingManagerCameraProtocol的代理方法 -------
#pragma mark 实际的采集大小回调
/// 实际的采集大小回调
/// @param imageWidth 视频宽
/// @param imageHeight 视频高
- (void)captureVideoRealWithWidth:(int)imageWidth height:(int)imageHeight {
    
    SGLOG(@"+++++++本地实际的采集大小: imageWidth = %d, imageHeight = %d", imageWidth, imageHeight);
}

#pragma mark 摄像头采集视频数据回调
/// 摄像头采集视频数据回调
/// @param pixelbuffer 视频采集数据
- (void)captureCameraDataWithCVPixleBuffer:(CVPixelBufferRef)pixelbuffer {
    
    /// 显示 CVPixelBufferRef数据
    /// [self.player displayCVPixleBuffer:pixelbuffer];
}

#pragma mark - 有人进入房间
/// 有人进入房间
/// @param account 参会人信息
- (void)playEnterWithAccount:(Account *)account {
    
    NSString *streamId = [NSString stringWithFormat:@"%d", account.streamId];
    SGLOG(@"+++++有人进入房间 StreamID = %@", streamId);
    
    NSArray *playArr = [self.playDic allKeys];
    /// 默认不存在此用户窗口
    BOOL isCon = NO;
    @synchronized (playArr) {
        for (int i = 0; i < playArr.count; i ++) {
            if ([streamId isEqualToString:playArr[i]]) {
                /// 存在视频窗口
                isCon = YES;
                break;
            }
        }
    }
    
    if (!isCon) {
        /// 不存在窗口就去创建窗口
        CGRect rect;
        if (self.isHorizontalScreen) {
            rect = CGRectMake(0, 0, FWPlayVideoHorizontalWidth, FWPlayVideoHorizontalHeight);
        } else {
            rect = CGRectMake(0, 0, FWPlayVideoVerticalWidth, FWPlayVideoVerticalHeight);
        }
        FWYUVPlayerView *player = [[FWYUVPlayerView alloc] initSGWithFrame:rect account:account];
        player.userInteractionEnabled = YES;
        player.tag = [streamId integerValue];
        [self.scrollView insertSubview:player atIndex:0];
        
        /// Demo中暂时移除大小窗口切换手势，如项目中需要请自行添加
        /// 为视频添加双击手势
//        UITapGestureRecognizer *doubleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleRecognizerAction:)];
//        doubleRecognizer.numberOfTapsRequired = 2;
//        doubleRecognizer.cancelsTouchesInView = NO;
//        [player addGestureRecognizer:doubleRecognizer];
//        doubleRecognizer.view.tag = [streamId integerValue];
        
        @synchronized (self.playDic) {
            /// 视频流缓存下来(流ID作为Key，Player窗口作为Value)
            [self.playDic setValue:player forKey:streamId];
        }
        
        /// 此窗口数据进行保存 小窗口 重置x坐标 展示的都是小图
        [self.playArray addObject:player];
        [self windowViewReset];
    }
}

#pragma mark - 有人离开房间
/// 有人离开房间
/// @param account 参会人信息
- (void)playLeaveWithAccount:(Account *)account {
    
    NSString *streamId = [NSString stringWithFormat:@"%d", account.streamId];
    SGLOG(@"+++++有人离开房间 StreamID = %@", streamId);
    
    NSArray *playArr = [self.playDic allKeys];
    /// 默认不存在此用户窗口
    BOOL isCon = NO;
    @synchronized (playArr) {
        for (int i = 0; i < playArr.count; i ++) {
            if ([streamId isEqualToString:playArr[i]]) {
                /// 存在视频窗口
                isCon = YES;
                break;
            }
        }
    }
    
    if (isCon) {
        /// 窗口存在的情况下离开删除
        FWYUVPlayerView *player = (FWYUVPlayerView *)[self.playDic objectForKey:streamId];
        /// 移除
        [player removeFromSuperview];
        @synchronized (self.playDic) {
            /// 移除
            [self.playDic removeObjectForKey:streamId];
        }
        /// 成员离开 对大小窗口进行重整
        [self changeWindowResetLeaveWithAccount:account];
    }
}

#pragma mark - 会议时成员状态更新
/// 会议时成员状态更新
/// @param account  参会人信息
- (void)playStateWithAccount:(Account *)account {
    
    NSString *streamId = [NSString stringWithFormat:@"%d", account.streamId];
    FWYUVPlayerView *player = (FWYUVPlayerView *)[self.playDic objectForKey:streamId];
    /// 会议时成员状态更新
    [player playStateWithAccount:account];
}

#pragma mark - 会议时成员音频变化更新
/// 会议时成员音频变化更新
/// @param audioArray 音频变化列表
- (void)playAudioWithAudioArray:(NSMutableArray *)audioArray {
    
    /// NSArray *resultArray = [audioArray sortedArrayUsingSelector:@selector(comparePower:)];
    /// 语音激励当前主窗口焦点切换
    /// [self encourageAudioSpeaking:[resultArray firstObject]];
    // 遍历音频列表，设置UI状态
    for (NSDictionary *audioData in audioArray) {
        NSString *streamId = [NSString stringWithFormat:@"%@", [audioData objectForKey:@"streamId"]];
        /// 取绝对值
        int volume = abs([[audioData objectForKey:@"db"] intValue]);
        float progress = 0.0;
        /// 注意：此处只是示意，您可根据自己的需求变换成等级或者百分比
        if (volume >= 0 && volume < 18) {
            progress = 1.0;
        } else if (volume >= 18 && volume < 30) {
            progress = 0.8;
        } else if (volume >= 30 && volume < 46) {
            progress = 0.6;
        } else if (volume >= 46 && volume < 54) {
            progress = 0.4;
        } else if (volume >= 54 && volume < 60) {
            progress = 0.2;
        } else {
            progress = 0.0;
        }
        FWYUVPlayerView *player = (FWYUVPlayerView *)[self.playDic objectForKey:streamId];
        if (player) {
            [player playAudioWithVolume:progress];
        } else {
            [self.cameraView playAudioWithVolume:progress];
        }
    }
}

#pragma mark - 当前有人在共享屏幕
/// 当前有人在共享屏幕
/// @param streamId 流媒体连接标识
/// @param isSharing 是否在共享
- (void)sharingDesktop:(NSString *)streamId isSharing:(BOOL)isSharing {
    
    if (!kStringIsEmpty(streamId)) {
        FWYUVPlayerView *player = (FWYUVPlayerView *)[self.playDic objectForKey:streamId];
        /// 通知当前正在共享屏幕
        [player sharingDesktop:isSharing];
    }
}

#pragma mark - 用于播放用户的特定画面
/// 用于播放用户的特定画面
/// @param linkId 视频链路ID
/// @param track 视频轨道
/// @param type 视频存储格式(0 - I420 , 1 - NV12, 2 - NV21)
/// @param lable 视频角度
/// @param width 宽/高
/// @param height 宽/高
/// @param yData 流媒体像素数据
/// @param uData 流媒体像素数据
/// @param vData 流媒体像素数据
- (void)playCallbackFrameWithLinkId:(int)linkId track:(int)track type:(int)type lable:(int)lable width:(int)width height:(int)height yData:(void *)yData uData:(void *)uData vData:(void *)vData {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (linkId) {
            NSString *streamId = [NSString stringWithFormat:@"%d", linkId];
            NSArray *playArr = [self.playDic allKeys];
            /// 默认此用户不存在窗口
            BOOL isCon = NO;
            @synchronized (playArr) {
                for (int i = 0; i < playArr.count; i ++) {
                    if ([streamId isEqualToString:playArr[i]]) {
                        /// 此用户存在视频窗口
                        isCon = YES;
                        break;
                    }
                }
            }
            if (isCon) {
                FWYUVPlayerView *player = (FWYUVPlayerView *)[self.playDic objectForKey:streamId];
                [player playCallbackFrameWithLinkId:linkId track:track type:type lable:lable width:width height:height yData:yData uData:uData vData:vData];
            } else {
                if (yData) {
                    free(yData);
                }
                if (uData){
                    free(uData);
                }
                if (vData) {
                    free(vData);
                }
            }
        } else {
            if (yData) {
                free(yData);
            }
            if (uData){
                free(uData);
            }
            if (vData) {
                free(vData);
            }
        }
    });
}

#pragma mark - 语音激励当前主窗口焦点切换
- (void)encourageAudioSpeaking:(NSDictionary *)focusDic {
    
    NSInteger index = [[focusDic objectForKey:@"streamId"] integerValue];
    for (NSInteger i = 0; i < self.playArray.count; i ++) {
        if ([self.playArray[i] isKindOfClass:[FWYUVPlayerView class]]) {
            FWYUVPlayerView *player = (FWYUVPlayerView *)[self.playArray objectAtIndex:i];
            if (index == player.tag && !player.isMaxPlayer) {
                /// 大小窗口切换数据更换
                [self changeWindowResetWithPlayer:player index:i];
                break;
            } else if (index == player.tag && player.isMaxPlayer) {
                SGLOG(@"+++++++点击本地采集Camera");
                break;
            }
        }
    }
}

#pragma mark - 小窗口进行大小图切换 大窗口暂时不能点击
- (void)doubleRecognizerAction:(id)sender {
    
//    UITapGestureRecognizer *singleTap = (UITapGestureRecognizer *)sender;
//    NSInteger index = [singleTap view].tag;
//    for (NSInteger i = 0; i < self.playArray.count; i ++) {
//        if ([self.playArray[i] isKindOfClass:[FWYUVPlayerView class]]) {
//            FWYUVPlayerView *player = (FWYUVPlayerView *)[self.playArray objectAtIndex:i];
//            if (index == player.tag && !player.isMaxPlayer) {
//                /// 大小窗口切换数据更换
//                [self changeWindowResetWithPlayer:player index:i];
//                /// 工具按钮隐藏
//                player.kickoutButton.hidden = player.forbiddenAudioButton.hidden = player.forbiddenVideoButton.hidden = player.streamVideoInceptButton.hidden = player.streamAudioInceptButton.hidden = !player.kickoutButton.hidden;
//                break;
//            } else if (index == player.tag && player.isMaxPlayer) {
//                SGLOG(@"+++++++点击本地采集Camera");
//                break;
//            }
//        }
//    }
}

#pragma mark - 大小窗口切换数据更换(点击本地采集流)
- (void)changeWindowResetWithCamera:(FWCameraView *)camera index:(NSInteger)index {
    
    /// 第一个一定是视频流地址
    self.isShowMaxVideoState = YES;
    FWYUVPlayerView *onePlayer = (FWYUVPlayerView *)[self.playArray firstObject];
    /// 工具按钮隐藏
    onePlayer.kickoutButton.hidden = onePlayer.forbiddenAudioButton.hidden = onePlayer.forbiddenVideoButton.hidden = onePlayer.streamVideoInceptButton.hidden = onePlayer.streamAudioInceptButton.hidden = !onePlayer.kickoutButton.hidden;
    CGRect newRect = onePlayer.frame;
    
    onePlayer.frame = camera.frame;
    [self.scrollView insertSubview:onePlayer atIndex:0];
    /// 大画面放入底层
    camera.frame = newRect;
    [self insertSubview:camera atIndex:0];
    /// 手动修正预览界面
    [[VCSMeetingManager sharedManager] revisePreviewSize:camera.frame.size];
    /// 数组中元素交换位置 点击的去第一位 跟大图互换
    [self.playArray exchangeObjectAtIndex:0 withObjectAtIndex:index];
    /// 小窗口 重置x坐标 展示的都是小图
    [self windowViewReset];
}

#pragma mark - 大小窗口切换数据更换(点击视频流)
- (void)changeWindowResetWithPlayer:(FWYUVPlayerView *)player index:(NSInteger)index {
    
    /// 找到对应的点击视图 进行大小坐标互换，切换
    [self setupPlayerViewMax:player isMaxPlayer:YES];
    /// 取出第一个大窗口视图
    CGRect newRect = CGRectZero;
    id className = [self.playArray firstObject];
    if ([className isKindOfClass:[FWCameraView class]]) {
        /// 本地采集对象
        FWCameraView *camera = (FWCameraView *)className;
        newRect = camera.frame;
        camera.frame = player.frame;
        [self.scrollView insertSubview:camera atIndex:0];
        /// 手动修正预览界面
        [[VCSMeetingManager sharedManager] revisePreviewSize:camera.frame.size];
    } else {
        /// 对方画面小对象
        FWYUVPlayerView *onePlayer = (FWYUVPlayerView *)className;
        newRect = onePlayer.frame;
        onePlayer.frame = player.frame;
        [self.scrollView insertSubview:onePlayer atIndex:0];
        /// 工具按钮隐藏
        onePlayer.kickoutButton.hidden = onePlayer.forbiddenAudioButton.hidden = onePlayer.forbiddenVideoButton.hidden = onePlayer.streamVideoInceptButton.hidden = onePlayer.streamAudioInceptButton.hidden = !onePlayer.kickoutButton.hidden;
    }
    /// 画面放入底层
    player.frame = newRect;
    [self insertSubview:player atIndex:0];
    
    /// 数组中元素交换位置 点击的去第一位 跟大图互换
    [self.playArray exchangeObjectAtIndex:0 withObjectAtIndex:index];
    /// 小窗口 重置x坐标 展示的都是小图
    [self windowViewReset];
}

#pragma mark - 小窗口 重置x坐标 展示的都是小图
- (void)windowViewReset {
    
    /// 分屏展示子窗口
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * (self.playArray.count - 1)/2, 0);
    for (int i = 0; i < self.playArray.count; i ++) {
        if (0 == i) {
            /// 跳出此次循环
            continue;
        }
        CGFloat width = SCREEN_WIDTH / 2;;
        id className = [self.playArray objectAtIndex:i];
        [UIView animateWithDuration:0.25 animations:^{
            if ([className isKindOfClass:[FWCameraView class]]) {
                /// 本地采集对象
                self.isShowMaxVideoState = NO;
                FWCameraView *camera = (FWCameraView *)className;
                camera.sa_x = width * (i - 1);
                if (self.isHorizontalScreen) {
                    camera.sa_height = FWPlayVideoHorizontalHeight;
                    camera.sa_width = FWPlayVideoHorizontalWidth;
                } else {
                    camera.sa_height = FWPlayVideoVerticalHeight;
                    camera.sa_width = FWPlayVideoVerticalWidth;
                }
            } else if ([className isKindOfClass:[FWYUVPlayerView class]]) {
                /// 对方画面小对象
                FWYUVPlayerView *player = (FWYUVPlayerView *)className;
                player.sa_x = width * (i - 1);
                if (self.isHorizontalScreen) {
                    player.sa_height = FWPlayVideoHorizontalHeight;
                    player.sa_width = FWPlayVideoHorizontalWidth;
                } else {
                    player.sa_height = FWPlayVideoVerticalHeight;
                    player.sa_width = FWPlayVideoVerticalWidth;
                }
                /// 都是小画面
                [self setupPlayerViewMax:player isMaxPlayer:NO];
            }
        }];
    }
}

#pragma mark - 成员离开对大小窗口进行重整
- (void)changeWindowResetLeaveWithAccount:(Account *)account {

    CGRect newRect = CGRectZero;
    NSInteger leaveIndex = 0;
    NSInteger streamId = (NSInteger)account.streamId;
    for (NSInteger i = 0; i < self.playArray.count; i ++) {
        id className = [self.playArray objectAtIndex:i];
        if ([className isKindOfClass:[FWYUVPlayerView class]]) {
            /// 此处离开的一定是视频流
            FWYUVPlayerView *player = (FWYUVPlayerView *)className;
            if (player.tag == streamId) {
                leaveIndex = i;
                newRect = player.frame;
                /// 删除这个人
                [self.playArray removeObject:player];
                break;
            }
        }
    }
    
    if (0 == leaveIndex) {
        /// 大窗口离开 取出第一个人窗口 直接设置成大窗口
        [self windowViewReset];
        id className = [self.playArray firstObject];
        if ([className isKindOfClass:[FWCameraView class]]) {
            /// 本地采集 成大窗口
            self.isShowMaxVideoState = NO;
            FWCameraView *camera = (FWCameraView *)className;
            camera.frame = newRect;
            [self insertSubview:camera atIndex:0];
            /// 手动修正预览界面
            [[VCSMeetingManager sharedManager] revisePreviewSize:camera.frame.size];
        } else if ([className isKindOfClass:[FWYUVPlayerView class]]) {
            /// 对方画面小对象 成大窗口
            FWYUVPlayerView *player = (FWYUVPlayerView *)className;
            player.frame = newRect;
            /// 都是小画面
            [self setupPlayerViewMax:player isMaxPlayer:YES];
            [self insertSubview:player atIndex:0];
        }
    }
    /// 小窗口 重置x坐标 展示的都是小图
    [self windowViewReset];
}

#pragma mark - 设置与会人员大窗口or小窗口
- (void)setupPlayerViewMax:(FWYUVPlayerView *)player isMaxPlayer:(BOOL)isMaxPlayer {
    
    /// 设置窗口大小标记
    player.isMaxPlayer = isMaxPlayer;
    /// 回调业务层切换流轨道
    if (self.resultBlock) {
        self.resultBlock([NSString stringWithFormat:@"%ld", (long)player.tag], player.isMaxPlayer);
    }
}

#pragma mark 播放画面缩放
/// 播放画面缩放
/// @param scale 缩放比例
- (void)playerViewZoomWithScale:(float)scale {
    
    [self.cameraView playerViewZoomWithScale:scale];
}

#pragma mark - 播放画面直接缩放
/// 播放画面直接缩放
/// @param point 位置坐标
- (void)playerViewDirectZoom {
    
    [self.cameraView playerViewDirectZoom];
}

#pragma mark 播放画面拖动
/// 播放画面拖动
/// @param offsetX X轴坐标系的偏移值
/// @param offsetY Y轴坐标系的偏移值
- (void)playerViewMoveWithOffsetX:(float)offsetX offsetY:(float)offsetY {
    
    [self.cameraView playerViewMoveWithOffsetX:offsetX offsetY:offsetY];
}

#pragma mark - 资源释放
- (void)dealloc {
    
    SGLOG(@"++++++++++++释放资源：%@", kStringFromClass(self));
}

@end
