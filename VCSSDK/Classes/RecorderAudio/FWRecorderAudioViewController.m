//
//  FWRecorderAudioViewController.m
//  VCSSDK_Example
//
//  Created by SailorGa on 2021/3/25.
//  Copyright © 2021 SailorGa. All rights reserved.
//

#import "FWRecorderAudioViewController.h"
#import <VCSSDK/VCSAudio.h>

@interface FWRecorderAudioViewController ()<VCSAudioManagerProtocol>

/// 录制音频按钮
@property (weak, nonatomic) IBOutlet UIButton *recorderButton;
/// 录制音量显示组件
@property (weak, nonatomic) IBOutlet UIView *recorderView;
/// 录制音量显示图片
@property (weak, nonatomic) IBOutlet UIImageView *recorderImageView;
/// 播放音频按钮
@property (weak, nonatomic) IBOutlet UIButton *playerButton;

/// 文件名称
@property (weak, nonatomic) IBOutlet UILabel *fileNameLabel;
/// 文件大小
@property (weak, nonatomic) IBOutlet UILabel *fileSizeLabel;
/// 录音时长
@property (weak, nonatomic) IBOutlet UILabel *fileTimeLabel;
/// 文件路径
@property (weak, nonatomic) IBOutlet UILabel *filePathLabel;

/// 录制音频Data
@property (weak, nonatomic) IBOutlet UITextView *audioDataTextView;

/// 返回按钮
@property (strong, nonatomic) UIBarButtonItem *gobackItem;

/// 录音文件Data
@property (nonatomic, strong) NSData *audioData;
/// 录音文件路径
@property (nonatomic, strong) NSString *filePath;

@end

@implementation FWRecorderAudioViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    /// 初始化UI
    [self buildView];
}

#pragma mark - 懒加载返回按钮
- (UIBarButtonItem *)gobackItem {
    
    if (!_gobackItem) {
        _gobackItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"icon_common_goback"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(gobackItemClick)];
    }
    return _gobackItem;
}

#pragma mark - 初始化UI
- (void)buildView {
    
    /// 设置title
    self.navigationItem.title = @"录音服务";
    /// 获取录音文件保存路径
    self.filePath = [VCSAudioFileBridge audioDefaultFilePath:nil];
    /// 设置左侧操作按钮
    [self setupLeftBarItems];
}

#pragma mark - 设置左侧操作按钮
- (void)setupLeftBarItems {
    
    /// 添加到NavigationItem
    self.navigationItem.leftBarButtonItem = self.gobackItem;
}

#pragma mark - 退出事件
/// 退出事件
- (void)gobackItemClick {
    
    /// 停止并释放录音服务
    [[VCSAudioManager sharedManager] destroy];
    /// 退出页面
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 录制按钮按下事件
/// 录制按钮按下事件
/// @param sender 事件按钮
- (IBAction)startRecordingDownClick:(UIButton *)sender {
    
    /// 开启录制
    [self startRecording];
}

#pragma mark - 录制按钮抬起事件
/// 录制按钮抬起事件
/// @param sender 事件按钮
- (IBAction)stopRecordingUpClick:(UIButton *)sender {
    
    /// 停止录制
    [self stopRecording];
}

#pragma mark - 录制按钮拖动事件
/// 录制按钮拖动事件
/// @param sender 事件按钮
- (IBAction)stopRecordingExitClick:(UIButton *)sender {
    
    /// 停止录制
    [self stopRecording];
}

#pragma mark - 开始播放音频事件
/// 开始播放音频事件
/// @param sender 事件按钮
- (IBAction)startPlayerClick:(UIButton *)sender {
    
    /// 开始播放音频
    [self startPlayer];
}

#pragma mark - 开启录制
/// 开启录制
- (void)startRecording {
    
    if (kStringIsEmpty(self.filePath)) {
        [SVProgressHUD showInfoWithStatus:@"录制文件地址为空"];
        return;
    }
    /// 设置录制代理
    [VCSAudioManager sharedManager].audioRecorder.delegate = self;
    /// 设置监测录音音量
    [VCSAudioManager sharedManager].audioRecorder.monitorVolume = YES;
    /// 录音限制时长设置为0(不限制时长)
    [VCSAudioManager sharedManager].audioRecorder.totalTime = 0;
    /// 开启录制
    [[VCSAudioManager sharedManager].audioRecorder recorderStartWithFilePath:self.filePath complete:^(BOOL isFailed) {
        if (isFailed) {
            [SVProgressHUD showInfoWithStatus:@"音频文件地址无效，录制失败"];
        }
    }];
}

#pragma mark - 停止录制
/// 停止录制
- (void)stopRecording {
    
    if (kStringIsEmpty(self.filePath)) {
        [SVProgressHUD showInfoWithStatus:@"录制文件地址为空"];
        return;
    }
    /// 停止录制
    [[VCSAudioManager sharedManager].audioRecorder recorderStop];
}

#pragma mark - 开始播放音频
/// 开始播放录音
- (void)startPlayer {
    
    if (kDataIsEmpty(self.audioData)) {
        [SVProgressHUD showInfoWithStatus:@"录制音频数据为空"];
        return;
    }
    /// 获取文件路径
    /// NSString *filePath = @"http://download.lingyongqian.cn//music//ForElise.mp3";
    NSString *filePath = [VCSAudioFileBridge audioCreateFileWithData:self.audioData];
    /// 设置播放代理
    [VCSAudioManager sharedManager].audioPlayer.delegate = self;
    /// 开始播放
    [[VCSAudioManager sharedManager].audioPlayer playerStartWithFilePath:filePath complete:^(BOOL isFailed) {
        if (isFailed) {
            [SVProgressHUD showInfoWithStatus:@"音频文件地址无效，播放失败"];
        }
    }];
}

#pragma mark - 请求录制音频信息
/// 请求录制音频信息
- (void)requestRecorderAudio {
    
    /// 获取音频信息
    [VCSAudioFileBridge audioGetFileAudioInfoWithFilePath:self.filePath result:^(NSString * _Nullable fileName, long long fileSize, NSTimeInterval fileTime, NSString * _Nullable filePath, NSData * _Nullable audioData) {
        self.filePathLabel.text = filePath;
        self.fileNameLabel.text = fileName;
        self.fileSizeLabel.text = [NSString stringWithFormat:@"%lldByte", fileSize];
        self.fileTimeLabel.text = [NSString stringWithFormat:@"%.2fs", fileTime];
        self.audioDataTextView.text = [NSString stringWithFormat:@"%@", audioData];
        self.audioData = audioData;
        /// 输出日志
        SGLOG(@"++++++++++++录制文件路径 = %@, 录制文件大小 = %lld, 录制录音时长 = %.2fs", fileName, fileSize, fileTime);
    }];
}

#pragma mark - -------- VCSAudioManagerProtocol代理方法 ---------
#pragma mark 开始录制
/// 开始录音
- (void)recordBegined {
    
    /// 录制音频按钮设置选中
    self.recorderButton.selected = YES;
    /// 录制音量显示组件显示
    self.recorderView.hidden = NO;
}

#pragma mark 录制完成
/// 录制完成
- (void)recordFinshed {
    
    /// 录制音频按钮设置非选中
    self.recorderButton.selected = NO;
    /// 录制音量显示组件隐藏
    self.recorderView.hidden = YES;
    /// 请求录制音频信息
    [self requestRecorderAudio];
}

#pragma mark 正在录音中，录音音量监测
/// 正在录音中，录音音量监测
/// @param volume 音量
- (void)recordingVoiceWithVolume:(double)volume {
    
    if (0 < volume <= 0.06) {
        [self.recorderImageView setImage:kGetImage(@"icon_record_animate_01.png")];
    } else if (0.06 < volume <= 0.13) {
        [self.recorderImageView setImage:kGetImage(@"icon_record_animate_02.png")];
    } else if (0.13 < volume <= 0.20) {
        [self.recorderImageView setImage:kGetImage(@"icon_record_animate_03.png")];
    } else if (0.20 < volume <= 0.27) {
        [self.recorderImageView setImage:kGetImage(@"icon_record_animate_04.png")];
    } else if (0.27 < volume <= 0.34) {
        [self.recorderImageView setImage:kGetImage(@"icon_record_animate_05.png")];
    } else if (0.34 < volume <= 0.41) {
        [self.recorderImageView setImage:kGetImage(@"icon_record_animate_06.png")];
    } else if (0.41 < volume <= 0.48) {
        [self.recorderImageView setImage:kGetImage(@"icon_record_animate_07.png")];
    } else if (0.48 < volume <= 0.55) {
        [self.recorderImageView setImage:kGetImage(@"icon_record_animate_08.png")];
    } else if (0.55 < volume <= 0.62) {
        [self.recorderImageView setImage:kGetImage(@"icon_record_animate_09.png")];
    } else if (0.62 < volume <= 0.69) {
        [self.recorderImageView setImage:kGetImage(@"icon_record_animate_10.png")];
    } else if (0.69 < volume <= 0.76) {
        [self.recorderImageView setImage:kGetImage(@"icon_record_animate_11.png")];
    } else if (0.76 < volume <= 0.83) {
        [self.recorderImageView setImage:kGetImage(@"icon_record_animate_12.png")];
    } else if (0.83 < volume <= 0.9) {
        [self.recorderImageView setImage:kGetImage(@"icon_record_animate_13.png")];
    } else {
        [self.recorderImageView setImage:kGetImage(@"icon_record_animate_14.png")];
    }
}

#pragma mark 正中录音中，是否录音倒计时、录音剩余时长
/// 正中录音中，是否录音倒计时、录音剩余时长
/// @param time 录音剩余时长
/// @param isTimer 是否录音倒计时
- (void)recordingWithResidualTime:(NSTimeInterval)time timer:(BOOL)isTimer {
    
    SGLOG(@"++++++++++++录音倒计时 = %f 是否录音倒计时 = %@", time, isTimer ? @"是" : @"否");
}

#pragma mark 开始播放音频
/// 开始播放音频
/// @param state 状态(加载中、加载失败、加载成功正在播放、未知)
/// @param playerItem 播放载体
- (void)audioPlayBeginedWithState:(AVPlayerItemStatus)state playerItem:(AVPlayerItem *)playerItem {
    
    SGLOG(@"++++++++++++开始播放音频状态 = %ld 错误码 = %@", state, playerItem.error);
}

#pragma mark 正在播放音频
/// 正在播放音频
/// @param totalTime 总时长
/// @param currentTime 当前时长
- (void)audioPlayingWithTotalTime:(NSTimeInterval)totalTime time:(NSTimeInterval)currentTime {
    
    SGLOG(@"++++++++++++正在播放, 播放总时长 = %f 当前播放时间 = %f", totalTime, currentTime);
}

#pragma mark 音频播放完成
/// 音频播放完成
- (void)audioPlayFinished {
    
    SGLOG(@"++++++++++++播放完成");
}

#pragma mark - 资源释放
- (void)dealloc {
    
    SGLOG(@"++++++++++++释放资源：%@", kStringFromClass(self));
}

@end
