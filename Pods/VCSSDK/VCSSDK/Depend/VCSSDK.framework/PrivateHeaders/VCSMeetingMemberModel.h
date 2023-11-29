//
//  VCSMeetingMemberModel.h
//  VCSSDK
//
//  Created by SailorGa on 2021/7/4.
//

#import "VCSBaseModel.h"
#import "RoomServer.pbobjc.h"

NS_ASSUME_NONNULL_BEGIN

@interface VCSMeetingMemberModel : VCSBaseModel

/// 流媒体标识(sdk_no)
@property (nonatomic, copy) NSString *streamId;
/// 接收视频状态(YES-接收 NO-屏蔽)
@property (nonatomic, assign) BOOL acceptvVideoState;
/// 接收音频状态(YES-接收 NO-屏蔽)
@property (nonatomic, assign) BOOL acceptvAudioState;
/// 成员信息
@property (nonatomic, strong) Account *account;
/// 超时累计时间
@property (nonatomic, assign) NSInteger timeout;

@end

NS_ASSUME_NONNULL_END
