//
//  FWRoomViewModel.m
//  VCSSDK_Example
//
//  Created by SailorGa on 2020/6/23.
//  Copyright © 2020 SailorGa. All rights reserved.
//

#import "FWRoomViewModel.h"
#import <VCSSDK/VCSSDK.h>

@implementation FWRoomViewModel

#pragma mark - 初始化ViewModel
- (instancetype)init {
    
    if (self = [super init]) {
        _uploadFilesSubject = [RACSubject subject];
        _lockedRoomSubject = [RACSubject subject];
        _enterRoomSubject = [RACSubject subject];
        _toastSubject = [RACSubject subject];
        _loading = NO;
    }
    return self;
}

#pragma mark - 获取上传文件Token
/// 获取上传文件Token
/// @param image 图片
- (void)roomtempUploadFilesToken:(UIImage *)image {
    
    self.loading = YES;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:[NSString stringWithFormat:@"%ld.png", (NSInteger)[[FWToolHelper sharedManager] getNowTimeInterval]] forKey:@"name"];
    [params setValue:[[FWToolHelper sharedManager] calulateImageFileSize:image] forKey:@"size"];
    [params setValue:[[FWToolHelper sharedManager] calulateImageSha256Base64File:image] forKey:@"unique"];
    [params setValue:[NSString stringWithFormat:@"%ld", (NSInteger)[[FWToolHelper sharedManager] getTomorrowDay]] forKey:@"expire_at"];
    [[FWNetworkBridge sharedManager] POST:FWUserRoomtempTokenInfofacePart params:params className:@"FWRoomtempTokenModel" result:^(BOOL isSuccess, id _Nullable result, NSString * _Nullable errorMsg) {
        self.loading = NO;
        if (isSuccess && result) {
            self.roomtempTokenModel = (FWRoomtempTokenModel *)result;
            if (self.roomtempTokenModel.data.finished) {
                /// 文件已经存在
                [self.uploadFilesSubject sendNext:self.roomtempTokenModel.data.fileinfo.url];
                return;
            }
            /// 获取到Token之后上传图片
            [self uploadFilesWithImage:image];
        } else {
            [self.toastSubject sendNext:errorMsg];
        }
    }];
}

#pragma mark - 上传图片到服务器
/// 上传图片到服务器
/// @param image 图片
- (void)uploadFilesWithImage:(UIImage *)image {
    
    self.loading = YES;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.roomtempTokenModel.data.token.AWSAccessKeyId forKey:@"AWSAccessKeyId"];
    [params setValue:self.roomtempTokenModel.data.token.acl forKey:@"acl"];
    [params setValue:self.roomtempTokenModel.data.token.key forKey:@"key"];
    [params setValue:@(self.roomtempTokenModel.data.token.success_action_status) forKey:@"success_action_status"];
    [params setValue:self.roomtempTokenModel.data.token.Policy forKey:@"Policy"];
    [params setValue:self.roomtempTokenModel.data.token.Signature forKey:@"Signature"];
    [[FWNetworkBridge sharedManager] uploadFile:self.roomtempTokenModel.data.token.url params:params fileData:UIImageJPEGRepresentation(image, 0.5) fileName:@"imChatImage.jpg" mimeType:@"image/jpg" className:@"" result:^(BOOL isSuccess, id  _Nullable result, NSString * _Nullable errorMsg) {
        self.loading = NO;
        [self.uploadFilesSubject sendNext:self.roomtempTokenModel.data.fileinfo.url];
    }];
}

#pragma mark - 重连会议需要调一次进入会议接口
- (void)reconnectionMeeting {
    
    self.loading = YES;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.enterRoomModel.data.room.no forKey:@"room_no"];
    [params setValue:self.enterRoomModel.data.room.password forKey:@"password"];
    [params setValue:self.enterRoomModel.data.upload_id forKey:@"upload_id"];
    
    [[FWNetworkBridge sharedManager] POST:FWUserEnterRoomInfofacePart params:params className:@"FWEnterRoomModel" result:^(BOOL isSuccess, id _Nullable result, NSString * _Nullable errorMsg) {
        self.loading = NO;
        if (isSuccess && result) {
            self.enterRoomModel = (FWEnterRoomModel *)result;
            [self.enterRoomSubject sendNext:@""];
        } else {
            [self.toastSubject sendNext:errorMsg];
        }
    }];
}

#pragma mark - 锁定房间
/// 锁定房间
/// @param locked YES-锁定 NO-解锁
- (void)lockedRoomWithLocked:(BOOL)locked {
    
    self.loading = YES;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.enterRoomModel.data.room.id forKey:@"room_id"];
    [params setValue:locked ? @"true" : @"false" forKey:@"lock"];
    [[FWNetworkBridge sharedManager] POST:FWUserRoomLockInterfacePart params:params className:@"FWBaseModel" result:^(BOOL isSuccess, id _Nullable result, NSString * _Nullable errorMsg) {
        self.loading = NO;
        if (isSuccess && result) {
            [self.lockedRoomSubject sendNext:@""];
        } else {
            [self.toastSubject sendNext:errorMsg];
        }
    }];
}

@end
