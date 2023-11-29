//
//  VCSNetworkBridge.h
//  VCSSDK
//
//  Created by SailorGa on 2022/9/28.
//

#import <AFNetworking/AFNetworking.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^NetworkResultBlock)(BOOL result, id _Nullable data, NSString * _Nullable errorMsg);

@interface VCSNetworkBridge : NSObject

#pragma mark - 获取网络工具对象
/// 获取网络工具对象
+ (VCSNetworkBridge *)sharedManager;

#pragma mark - 设置域名地址
/// 设置域名地址
/// - Parameters:
///   - domainUrl: 域名地址
///   - secretKey: 请求密钥
- (void)setupDomainUrl:(NSString *)domainUrl secretKey:(NSString *)secretKey;

#pragma mark - 设置用户令牌
/// 设置用户令牌
/// - Parameter token: 用户令牌
- (void)setupUserToken:(nullable NSString *)token;

#pragma mark - 发起GET请求
/// 发起GET请求
/// - Parameters:
///   - url: 请求接口
///   - params: 请求参数
///   - className: 结果对象
///   - resultBlock: 请求回调
- (void)GET:(NSString *)url params:(nullable NSDictionary *)params className:(nullable NSString *)className resultBlock:(NetworkResultBlock)resultBlock;

#pragma mark - 发起POST请求
/// 发起POST请求
/// - Parameters:
///   - url: 请求接口
///   - params: 请求参数
///   - className: 结果对象
///   - resultBlock: 请求回调
- (void)POST:(NSString *)url params:(nullable NSDictionary *)params className:(nullable NSString *)className resultBlock:(NetworkResultBlock)resultBlock;

#pragma mark - 发起POST上传图片
/// 发起POST上传图片
/// - Parameters:
///   - url: 请求接口
///   - params: 请求参数
///   - imageData: 图片数据
///   - className: 结果对象
///   - resultBlock: 请求回调
- (void)POST:(NSString *)url params:(nullable NSDictionary *)params imageData:(NSData *)imageData className:(nullable NSString *)className resultBlock:(NetworkResultBlock)resultBlock;

#pragma mark - 发起POST上传压缩包
/// 发起POST上传压缩包
/// - Parameters:
///   - url: 请求接口
///   - params: 请求参数
///   - fileData: 文件数据
///   - className: 结果对象
///   - resultBlock: 请求回调
- (void)POST:(NSString *)url params:(nullable NSDictionary *)params fileData:(NSData *)fileData className:(nullable NSString *)className resultBlock:(NetworkResultBlock)resultBlock;

@end

NS_ASSUME_NONNULL_END
