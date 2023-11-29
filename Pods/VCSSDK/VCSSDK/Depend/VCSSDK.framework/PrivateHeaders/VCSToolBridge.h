//
//  VCSToolBridge.h
//  VCSSDK
//
//  Created by SailorGa on 2020/5/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VCSToolBridge : NSObject

/// 初始化方法
+ (VCSToolBridge *)sharedManager;

/// 检测当前App是否在后台
- (BOOL)applicationStateBackground;

/// 检测是否开启了相机权限
- (BOOL)checkCameraAuthorization;

/// 检测是否开启了麦克风权限
- (BOOL)checkMicrophoneAuthorization;

/// 字典转Json字符串
/// @param dict 字典数据
- (NSString *)convertToJsonData:(NSDictionary *)dict;

#pragma mark - 获取数据的十六进制字符串
/// 获取数据的十六进制字符串
/// @param data 格式化数据
- (NSString *)getHexStringForData:(NSData *)data;

#pragma mark - 分割字符串
/// 分割字符串
/// @param string 目标字符串
/// @param seprate 分隔符
- (NSMutableArray *)stringToArray:(NSString *)string seprate:(NSString *)seprate;

#pragma mark - 将数组拆分成固定长度
/// 将数组拆分成固定长度
/// @param originalArray 需要拆分的数组
/// @param subSize 指定长度
- (NSMutableArray *)splitWithOriginalArray:(NSMutableArray *)originalArray subSize:(int)subSize;

#pragma mark - 获取唯一标识符UUID
/// 获取唯一标识符UUID
- (NSString *)getUniqueIdentifier;

#pragma mark - 域名解析IP地址
/// 域名解析IP地址
/// @param domain 域名地址
- (NSString *)localDomainParsing:(NSString *)domain;

#pragma mark - 获取当前时间戳
/// 获取当前时间戳
- (NSTimeInterval)getNowTimeInterval;

#pragma mark - 获取当前时间戳(毫秒)
/// 获取当前时间戳(毫秒)
- (NSTimeInterval)getNowTimeIntervalMilli;

#pragma mark - 判断应用是否在Mac上运行
/// 判断应用是否在Mac上运行
- (BOOL)isiOSAppOnMac;

#pragma mark - HmacSHA1方式加密的字符串
/// HmacSHA1方式加密的字符串
/// @param key 加密Key
/// @param data 加密数据
- (NSString *)VCSHmacSha1:(NSString *)key data:(NSString *)data;

#pragma mark - HmacSHA256方式加密的字符串
/// HmacSHA256方式加密的字符串
/// @param data 加密数据
- (NSString *)VCSHmacSha256:(NSString *)data;

#pragma mark - MD5方式加密的字符串
/// MD5方式加密的字符串
/// @param data 加密数据
- (NSString *)VCSMD5:(NSString *)data;

#pragma mark - 构造远程视频索引键
/// 构造远程视频索引键
/// @param linkId 流媒体标识
/// @param trackNo 轨道号号码
+ (NSString *)formationStreamRemoteKey:(int)linkId trackNo:(int)trackNo;

#pragma mark - 判断掩码是否包含有该轨道
/// 判断掩码是否包含有该轨道
/// @param mask 轨道掩码
/// @param track 轨道号码
+ (BOOL)hasTrack:(int)mask track:(int)track;

#pragma mark - 获取掩码所包含的轨道列表
/// 获取掩码所包含的轨道列表
/// @param mask  轨道掩码
+ (NSArray *)maskCompriseByTrack:(int)mask;

@end

NS_ASSUME_NONNULL_END
