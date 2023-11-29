//
//  FWRoomViewController.h
//  VCSSDK_Example
//
//  Created by SailorGa on 2020/4/27.
//  Copyright © 2020 SailorGa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <VCSSDK/VCSSDK.h>
#import <ReplayKit/ReplayKit.h>
#import "FWEnterRoomModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FWRoomViewController : UIViewController

/// 登录信息
@property (nonatomic, strong) FWLoginModel *loginModel;
/// 会议配置信息
@property (nonatomic, strong) VCSMeetingParam *meetingParam;
/// 进入房间信息
@property (nonatomic, strong) FWEnterRoomModel *enterRoomModel;

@end

NS_ASSUME_NONNULL_END
