//
//  FWInviteViewController.h
//  VCSSDK_Example
//
//  Created by SailorGa on 2021/7/29.
//  Copyright © 2021 SailorGa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FWLoginModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FWInviteViewController : UIViewController

/// 登录信息
@property (strong, nonatomic) FWLoginModel *loginModel;

@end

NS_ASSUME_NONNULL_END
