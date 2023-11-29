//
//  FWNetworkBridge.m
//  VCSSDK_Example
//
//  Created by SailorGa on 2020/4/28.
//  Copyright © 2020 SailorGa. All rights reserved.
//

#import "FWNetworkBridge.h"

#define VCSDemoDrawImageDownloadQueue "cn.seastart.vcsdemo.imageDownloadQueue"
#define ResponseCodeSucceed 200

@interface FWNetworkBridge ()

@end

@implementation FWNetworkBridge

#pragma mark - 初始化方法
/// 初始化方法
+ (FWNetworkBridge *)sharedManager {
    
    static FWNetworkBridge *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[FWNetworkBridge alloc] init];
    });
    return manager;
}

#pragma mark - 懒加载数据请求对象
- (AFHTTPSessionManager *)manager {
    
    if (!_manager) {
        _manager = [[AFHTTPSessionManager alloc] init];
        /// 设置接收数据类型(JSON) 请求是表单格式
        _manager.responseSerializer = [AFJSONResponseSerializer serializer];
        _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/plain", @"text/html", nil];
        /// 设置token
        [_manager.requestSerializer setValue:@"" forHTTPHeaderField:@"vcs-token"];
        /// 设置appid
        [_manager.requestSerializer setValue:VCSSDKAPPID forHTTPHeaderField:@"vcs-appid"];
        /// 设置signature
        [_manager.requestSerializer setValue:VCSSDKSIGNATURE forHTTPHeaderField:@"vcs-signature"];
        /// 设置请求超时的时间(10s)
        _manager.requestSerializer.timeoutInterval = 10.0f;
    }
    return _manager;
}

#pragma mark - 构建当前的请求完整地址(用于Demo可以自配置服务器使用)
- (NSString *)queryRequestBaseURL:(NSString *)api {
    
    return [NSString stringWithFormat:@"%@%@%@", [kSGUserDefaults objectForKey:DATADEFAULTAPIKEY], DATADAPIHEADER, api];
}

#pragma mark - 处理字典参数
/// 处理字典参数
/// @param params 参数列表
- (NSDictionary *)dealWithParams:(NSDictionary *)params {
    
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionaryWithDictionary:params];
    /// 补充timestamp参数
    [paramDict setValue:[NSString stringWithFormat:@"%ld", (NSInteger)[[FWToolHelper sharedManager] getNowTimeInterval]] forKey:@"timestamp"];
    /// 补充appid参数
    [paramDict setValue:VCSSDKAPPID forKey:@"appid"];
    
    /// 获取所有键值列表
    NSArray *allkeys = [paramDict allKeys];
    
    /// 对当前键值列表进行排序
    NSArray<NSString *> *resultArray = [allkeys sortedArrayUsingComparator:^NSComparisonResult(id _Nonnull obj1, id _Nonnull obj2) {
        return [obj1 compare:obj2];
    }];
    
    /// 遍历键值列表组织签名字符串
    __block NSMutableString *resultStr = [NSMutableString string];
    [resultArray enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *itemStr = [NSString stringWithFormat:@"%@=%@&", obj, [paramDict objectForKey:obj]];
        [resultStr appendString:itemStr];
    }];
    
    /// 截取签名字符串
    NSString *signStr = [resultStr substringWithRange:NSMakeRange(0, resultStr.length - 1)];
    
    /// HmacSHA1方式加密的字符串
    NSString *hmacSha1Str = [[FWToolHelper sharedManager] HmacSha1:VCSSDKAPPKEY data:signStr];
    /// 输出签名字符串
    SGLOG(@"+++++++++签名字符串 = %@, HmacSHA1方式加密的字符串 = %@", signStr, hmacSha1Str);
    /// 设置signature
    [self.manager.requestSerializer setValue:hmacSha1Str forHTTPHeaderField:@"vcs-signature"];
    /// 移除请求参数中的appid
    [paramDict removeObjectForKey:@"appid"];
    
    return paramDict;
}

#pragma mark - GET方法
/// GET方法
/// @param api 请求短连接
/// @param params 请求参数
/// @param className  Model对象
/// @param resultBlock 结果返回
- (void)GET:(NSString *)api params:(NSDictionary *)params className:(NSString *)className result:(HttpResultBlock)resultBlock {
    
    NSString *baseURL = [self queryRequestBaseURL:api];
    NSDictionary *baseParams = [self dealWithParams:params];
    [self.manager GET:baseURL parameters:baseParams headers:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        /// 输出日志
        [self outputlog:YES way:@"GET" api:baseURL params:baseParams response:responseObject];
        [self result:responseObject className:className block:resultBlock];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        /// 输出日志
        [self outputlog:NO way:@"GET" api:baseURL params:baseParams response:error];
        if (resultBlock) {
            resultBlock(NO, error, [self networkError:error]);
        }
    }];
}

#pragma mark - POST方法
/// POST方法
/// @param api 请求短连接
/// @param params 请求参数
/// @param className  Model对象
/// @param resultBlock 结果返回
- (void)POST:(NSString *)api params:(NSDictionary *)params className:(NSString *)className result:(HttpResultBlock)resultBlock {
    
    NSString *baseURL = [self queryRequestBaseURL:api];
    NSDictionary *baseParams = [self dealWithParams:params];
    [self.manager POST:baseURL parameters:baseParams headers:nil progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        /// 输出日志
        [self outputlog:YES way:@"POST" api:baseURL params:baseParams response:responseObject];
        [self result:responseObject className:className block:resultBlock];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        /// 输出日志
        [self outputlog:NO way:@"POST" api:baseURL params:baseParams response:error];
        if (resultBlock) {
            resultBlock(NO, error, [self networkError:error]);
        }
    }];
}

#pragma mark - 上传文件
/// 上传文件
/// @param api 图片上传地址
/// @param params 请求参数
/// @param fileData 文件数据
/// @param fileName 与指定数据关联的文件名(如：iimChatImage.jpg)
/// @param mimeType 指定数据的MIME类型(如：image/jpg)
/// @param className  Model对象
/// @param resultBlock 结果返回
- (void)uploadFile:(NSString *)api params:(nullable NSDictionary *)params fileData:(NSData *)fileData fileName:(NSString *)fileName mimeType:(NSString *)mimeType className:(NSString *)className result:(HttpResultBlock)resultBlock {
    
    NSString *baseURL = [self queryRequestBaseURL:api];
    NSDictionary *baseParams = [self dealWithParams:params];
    [self.manager POST:baseURL parameters:baseParams headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData> _Nonnull formData) {
        [formData appendPartWithFileData:fileData name:@"file" fileName:fileName mimeType:mimeType];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        CGFloat progress = 100.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount;
        SGLOG(@"++++++++上传进度%.2lf%%", progress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
         /// 输出日志
        [self outputlog:YES way:@"POST" api:api params:params response:responseObject];
        [self result:responseObject className:className block:resultBlock];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        /// 输出日志
        [self outputlog:NO way:@"POST" api:api params:params response:error];
        if (resultBlock) {
            resultBlock(NO, error, [self networkError:error]);
        }
    }];
}

#pragma mark - 相应结果解析
/// 相应结果解析
/// @param response 相应结果
/// @param className Model对象
/// @param block 结果返回
- (void)result:(id)response className:(NSString *)className block:(HttpResultBlock)block {
    
    NSInteger api_code = [[response objectForKey:@"code"] integerValue];
    NSString *api_msg = api_code == ResponseCodeSucceed ? @"数据请求成功" : [response objectForKey:@"msg"];
    id resp = response;
    if (!kStringIsEmpty(className)) {
        Class classVC = NSClassFromString(className);
        NSError *error;
        FWBaseModel *result = [[classVC alloc] initWithDictionary:response error:&error];
        if (error) {
            SGLOG(@"++++++++解析出错:%@",response);
        } else {
            resp = result;
        }
    }
    if (block) {
        block(api_code == ResponseCodeSucceed, resp, api_msg);
    }
}

#pragma mark - 输出日志
/// 输出日志
/// @param failure 成功or失败
/// @param way 请求方式
/// @param api 连接地址
/// @param params 参数
/// @param responseObject 响应信息
- (void)outputlog:(BOOL)failure way:(NSString *)way api:(NSString *)api params:(NSDictionary *)params response:(id)responseObject {
    
    NSMutableString *debugStr = [NSMutableString string];
    [debugStr appendString:failure ? @"\n+++++***请求成功***+++++\n" : @"\n+++++***请求失败***+++++\n"];
    [debugStr appendString:[NSString stringWithFormat:@"+++++%@请求：%@%@ \n",way, self.manager.baseURL.absoluteString, api]];
    [debugStr appendString:[NSString stringWithFormat:@"+++++请求头参数：%@ \n",self.manager.requestSerializer.HTTPRequestHeaders]];
    [debugStr appendString:[NSString stringWithFormat:@"+++++请求参数：%@ \n",params]];
    [debugStr appendString:[NSString stringWithFormat:@"+++++返回数据：%@ \n",[self UTF8Format:responseObject]]];
    [debugStr appendString:failure ? @"\n+++++***请求成功***+++++\n" : @"\n+++++***请求失败***+++++\n"];
    SGLOG(@"%@",debugStr);
}

#pragma mark - 格式化日志数据
- (NSString *)UTF8Format:(NSObject *)obj {
    
    if (!obj) {
        return @"";
    }
    NSString *desc = [obj description];
    desc = [NSString stringWithCString:[desc cStringUsingEncoding:NSUTF8StringEncoding] encoding:NSNonLossyASCIIStringEncoding];
    return desc;
}

#pragma mark - 网络请求失败提示信息
/// 网络请求失败提示信息
/// @param error 错误信息
- (NSString *)networkError:(NSError *)error {
    
    NSString *errorMessage = error.localizedDescription;
    if (error.code == -1001) {
        /// -1001 请求超时
        errorMessage = @"网络请求超时, 服务器内部错误";
    }
    return errorMessage;
}

#pragma mark - 传入userToken
/// 传入userToken
/// @param userToken userToken
- (void)setUserToken:(NSString *)userToken {
    
    SGLOG(@"++++++++新的 token = %@", userToken);
    [self.manager.requestSerializer setValue:userToken forHTTPHeaderField:@"vcs-token"];
}

#pragma mark - 清除userToken
/// 清除userToken
- (void)clearUserToken {
    
    SGLOG(@"++++++++清除userToken");
    [self.manager.requestSerializer setValue:nil forHTTPHeaderField:@"vcs-token"];
}

#pragma mark - 网络监测
/// 网络监测
- (void)networkMonitoring {
    
    /// 开启监测
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    /// 网络状态改变时的回调
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        SGLOG(@"+++++++++网络状态改变已经发生变化");
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWWAN:
                SGLOG(@"+++++++++移动网络");
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                SGLOG(@"+++++++++WiFi网络");
                break;
            case AFNetworkReachabilityStatusNotReachable:
                SGLOG(@"+++++++++此时网络暂时不可用");
                break;
            case AFNetworkReachabilityStatusUnknown:
                SGLOG(@"+++++++++未知仓库");
                break;
            default:
                break;
        }
    }];
}

#pragma mark - 下载图片
/// 下载图片
/// @param imageUrl 图片地址
- (void)downloadImageWithImageUrl:(nullable NSString *)imageUrl finishBlock:(nullable void(^)(UIImage * _Nullable image))finishBlock {
    
    if (kStringIsEmpty(imageUrl)) {
        /// 图片地址为空，丢弃该指令，并返回空图片
        if (finishBlock) {
            finishBlock(nil);
        }
        return;
    }
    
    __block UIImage *image = nil;
    /// 创建异步线程执行队列(将图片下载在异步线程进行)
    dispatch_async(dispatch_queue_create(VCSDemoDrawImageDownloadQueue, NULL), ^{
        /// 网络下载图片
        NSError *error;
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl] options:NSDataReadingMappedIfSafe error:&error];
        if (imageData) {
            image = [UIImage imageWithData:imageData];
        }
        /// 回到主线程更新UI
        dispatch_async(dispatch_get_main_queue(), ^{
            if (finishBlock) {
                /// 将下载的图片回调回去
                finishBlock(image);
            }
        });
    });
}

@end
