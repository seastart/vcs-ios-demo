//
//  VCSMeetingDesktopModel.h
//  VCSSDK
//
//  Created by SailorGa on 2021/11/12.
//

#import "VCSBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface VCSMeetingDesktopModel : VCSBaseModel

#pragma mark 共享屏幕当前帧率
/// 共享屏幕当前帧率
@property (assign, nonatomic) int fps;
#pragma mark 共享屏幕流宽
/// 共享屏幕流宽
@property (assign, nonatomic) int width;
#pragma mark 共享屏幕流高
/// 共享屏幕流高
@property (assign, nonatomic) int height;

@end

NS_ASSUME_NONNULL_END
