//
//  VCSMeetingAcceptQualityModel.h
//  VCSSDK
//
//  Created by SailorGa on 2021/7/4.
//

#import "VCSBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@class VCSMeetingAcceptQualityModel;
@protocol VCSMeetingAcceptQualityModel
@end

@class FWMeetingAcceptQualityItemModel;
@protocol FWMeetingAcceptQualityItemModel
@end

@interface VCSMeetingAcceptQualityModel : VCSBaseModel

@property (nonatomic, copy) NSArray <FWMeetingAcceptQualityItemModel> *recvinfo;

@end

@interface FWMeetingAcceptQualityItemModel : VCSBaseModel

/// SDKNO
@property (nonatomic, copy) NSString *linkid;
/// 接收包数
@property (nonatomic, assign) int recv;
/// 补偿包数
@property (nonatomic, assign) int comp;
/// 总丢包数
@property (nonatomic, assign) int losf;
/// 端到端丢包率
@property (nonatomic, assign) float lrl;
/// 服务器到端丢包率
@property (nonatomic, assign) float lrd;
/// 音频包数
@property (nonatomic, assign) int audio;
/// 视频包数
@property (nonatomic, assign) int video;

/* ------ 传输码率 ------ */
/// 总速率
@property (nonatomic, assign) float total_speed;
/// 音频速率
@property (nonatomic, assign) float audio_speed;
/// 视频速率
@property (nonatomic, assign) float video_speed;

@end

NS_ASSUME_NONNULL_END
