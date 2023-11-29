//
//  FWNetworkBridge.h
//  VCSSDK_Example
//
//  Created by SailorGa on 2020/4/28.
//  Copyright © 2020 SailorGa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^HttpResultBlock)(BOOL isSuccess, id _Nullable result, NSString * _Nullable errorMsg);

@interface FWNetworkBridge : NSObject

/// 数据请求对象
@property (strong, nonatomic) AFHTTPSessionManager *manager;

/// 初始化方法
+ (FWNetworkBridge *)sharedManager;

/// GET方法
/// @param api 请求短连接
/// @param params 请求参数
/// @param className  Model对象
/// @param resultBlock 结果返回
- (void)GET:(NSString *)api params:(NSDictionary *)params className:(NSString *)className result:(HttpResultBlock)resultBlock;

/// POST方法
/// @param api 请求短连接
/// @param params 请求参数
/// @param className  Model对象
/// @param resultBlock 结果返回
- (void)POST:(NSString *)api params:(NSDictionary *)params className:(NSString *)className result:(HttpResultBlock)resultBlock;

/// 上传文件
/// @param api 图片上传地址
/// @param params 请求参数
/// @param fileData 文件数据
/// @param fileName 与指定数据关联的文件名(如：iimChatImage.jpg)
/// @param mimeType 指定数据的MIME类型(如：image/jpg)
/// @param className  Model对象
/// @param resultBlock 结果返回
- (void)uploadFile:(NSString *)api params:(nullable NSDictionary *)params fileData:(NSData *)fileData fileName:(NSString *)fileName mimeType:(NSString *)mimeType className:(NSString *)className result:(HttpResultBlock)resultBlock;

/// 传入userToken
/// @param userToken userToken
- (void)setUserToken:(NSString *)userToken;

/// 清除userToken
- (void)clearUserToken;

/// 网络监测
- (void)networkMonitoring;

/// 下载图片
/// @param imageUrl 图片地址
- (void)downloadImageWithImageUrl:(nullable NSString *)imageUrl finishBlock:(nullable void(^)(UIImage * _Nullable image))finishBlock;

@end

NS_ASSUME_NONNULL_END
