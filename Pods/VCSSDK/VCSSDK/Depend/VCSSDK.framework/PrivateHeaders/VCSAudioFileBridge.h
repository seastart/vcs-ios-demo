//
//  VCSAudioFileBridge.h
//  VCSSDK
//
//  Created by SailorGa on 2021/3/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - 获取音频信息回调
/// 获取音频信息回调
/// @param fileName 文件名称
/// @param fileSize 文件大小
/// @param fileTime 录音时长
/// @param filePath 文件路径
/// @param audioData 音频数据
typedef void (^VCSAudioFileBridgeResultBlock)(NSString * _Nullable fileName, long long fileSize, NSTimeInterval fileTime, NSString * _Nullable filePath, NSData * _Nullable audioData);

@interface VCSAudioFileBridge : NSObject

#pragma mark - 录音文件保存路径
/// 录音文件保存路径
/// @param fileName 文件名称(如：20210325.aac)
+ (NSString *)audioDefaultFilePath:(nullable NSString *)fileName;

#pragma mark - 创建文件
/// 创建文件
/// @param data 文件数据
+ (NSString *)audioCreateFileWithData:(NSData *)data;

#pragma mark - 获取文件名
/// 获取文件名
/// @param filePath 文件路径
/// @param hasFileType 是否包含文件类型(包含后缀，如：20210325.aac，不包含文件类型，如：20210325)
+ (NSString *)audioGetFileNameWithFilePath:(nullable NSString *)filePath type:(BOOL)hasFileType;

#pragma mark - 获取文件大小
/// 获取文件大小
/// @param filePath 文件路径
+ (long long)audioGetFileSizeWithFilePath:(nullable NSString *)filePath;

#pragma mark - 获取录音时长
/// 获取录音时长
/// @param filePath 文件路径
+ (NSTimeInterval)recorderDurationWithFilePath:(nullable NSString *)filePath;

#pragma mark - 获取音频信息
/// 获取音频信息
/// @param filePath 文件路径
/// @param resultBlock 结果回调
+ (void)audioGetFileAudioInfoWithFilePath:(nullable NSString *)filePath result:(VCSAudioFileBridgeResultBlock)resultBlock;

#pragma mark - 删除文件
/// 删除文件
/// @param filePath 文件路径
+ (void)audioDeleteFileWithFilePath:(nullable NSString *)filePath;

@end

NS_ASSUME_NONNULL_END
