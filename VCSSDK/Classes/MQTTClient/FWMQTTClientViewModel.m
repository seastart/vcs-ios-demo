//
//  FWMQTTClientViewModel.m
//  VCSSDK_Example
//
//  Created by SailorGa on 2021/3/15.
//  Copyright © 2021 SailorGa. All rights reserved.
//

#import "FWMQTTClientViewModel.h"

@interface FWMQTTClientViewModel()

@end

@implementation FWMQTTClientViewModel

#pragma mark - 初始化ViewModel
- (instancetype)init {
    
    if (self = [super init]) {
        _uploadSubject = [RACSubject subject];
        _uploadModel = [[FWMQTTClientModel alloc] init];
        _loading = NO;
    }
    return self;
}

/// 上传文件
/// @param fileData 文件数据
/// @param state 文件类型
- (void)uploadFileWithFileData:(NSData *)fileData state:(FWUserUploadFileState)state {
    
    if (kDataIsEmpty(fileData)) {
        self.promptText = @"上传数据为空";
        return;
    }
    self.loading = YES;
    self.promptText = @"上传中...";
    
    NSString *fileName = @"imChatImage.jpg";
    NSString *mimeType = @"image/jpeg";
    switch (state) {
        case FWUserUploadFileStatePicture:
            fileName = @"imChatImage.jpg";
            mimeType = @"image/jpeg";
            break;
        case FWUserUploadFileStateAudio:
            fileName = @"imChatAudio.aac";
            mimeType = @"audio/aac";
            break;
        default:
            break;
    }
    
    [[FWNetworkBridge sharedManager] uploadFile:FWUserChatFileUploadInterfacePart params:nil fileData:fileData fileName:fileName mimeType:mimeType className:@"FWMQTTClientModel" result:^(BOOL isSuccess, id  _Nullable result, NSString * _Nullable errorMsg) {
        self.loading = NO;
        if (isSuccess && result) {
            self.promptText = @"上传成功";
            self.uploadModel = (FWMQTTClientModel *)result;
            [self.uploadSubject sendNext:@(state)];
        } else {
            self.promptText = errorMsg;
        }
    }];
}

@end
