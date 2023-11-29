//
//  FWMQTTClientViewModel.h
//  VCSSDK_Example
//
//  Created by SailorGa on 2021/3/15.
//  Copyright © 2021 SailorGa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FWMQTTClientModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FWMQTTClientViewModel : NSObject

/// 关联Class
@property (nonatomic, assign) Class viewClass;
/// 是否在加载状态
@property (nonatomic, assign) BOOL loading;

/// 房间ID
@property (copy, nonatomic) NSString *roomText;
/// 用户ID
@property (copy, nonatomic) NSString *userText;
/// 提示
@property (copy, nonatomic) NSString *promptText;

/// 上传请求订阅
@property (nonatomic, strong, readonly) RACSubject *uploadSubject;

/// 上传信息
@property (nonatomic, strong) FWMQTTClientModel *uploadModel;

/// 上传文件
/// @param fileData 文件数据
/// @param state 文件类型
- (void)uploadFileWithFileData:(NSData *)fileData state:(FWUserUploadFileState)state;

@end

NS_ASSUME_NONNULL_END
