//
//  VCSNetworkModel.h
//  VCSSDK
//
//  Created by SailorGa on 2021/11/2.
//

#import "VCSBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark - 网络状况
/**
 网络状况
 
 - VCSNetworkStateNormal: 良好
 - VCSNetworkStatePoor: 不佳
 - VCSNetworkStateBad:  较差
 - VCSNetworkStateVeryBad: 极差
 */
typedef enum : NSInteger {
    
    VCSNetworkStateNormal = 0,
    VCSNetworkStatePoor = 1,
    VCSNetworkStateBad = 2,
    VCSNetworkStateVeryBad = 3
} VCSNetworkState;

@interface VCSNetworkModel : VCSBaseModel

/// 接收/发送包数
@property (nonatomic, assign) NSInteger recv;
/// 错序数
@property (nonatomic, assign) NSInteger miss;
/// 丢包数
@property (nonatomic, assign) NSInteger losf;
/// 速率/码率(kbps)
@property (nonatomic, assign) NSInteger speed;
/// 网络延迟
@property (nonatomic, assign) NSInteger delay;

/// 丢包率
@property (nonatomic, assign) float dropRate;
/// 网络状况
@property (nonatomic, assign) VCSNetworkState state;

@end

NS_ASSUME_NONNULL_END
