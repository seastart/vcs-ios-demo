//
//  FWRoomViewModel.h
//  VCSSDK_Example
//
//  Created by SailorGa on 2020/6/23.
//  Copyright © 2020 SailorGa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FWEnterRoomModel.h"
#import "FWRoomtempTokenModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FWRoomViewModel : NSObject

/// 关联Class
@property (nonatomic, assign) Class viewClass;
/// 是否在加载状态
@property (nonatomic, assign) BOOL loading;

/// 进入房间信息
@property (nonatomic, strong) FWEnterRoomModel *enterRoomModel;

/// 房间文件信息
@property (nonatomic, strong) FWRoomtempTokenModel *roomtempTokenModel;

/// 提示框订阅
@property (nonatomic, strong, readonly) RACSubject *toastSubject;
/// 上传图片成功订阅
@property (nonatomic, strong, readonly) RACSubject *uploadFilesSubject;
/// 进入房间请求订阅
@property (nonatomic, strong, readonly) RACSubject *enterRoomSubject;
/// 锁定房间请求订阅
@property (nonatomic, strong, readonly) RACSubject *lockedRoomSubject;

#pragma mark - 重连会议需要调一次进入会议接口
- (void)reconnectionMeeting;

/// 获取上传文件Token
/// @param image 图片
- (void)roomtempUploadFilesToken:(UIImage *)image;

#pragma mark - 锁定房间
/// 锁定房间
/// @param locked YES-锁定 NO-解锁
- (void)lockedRoomWithLocked:(BOOL)locked;

@end

NS_ASSUME_NONNULL_END
