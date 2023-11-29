//
//  FWNetCallViewController.h
//  VCSSDK_Example
//
//  Created by SailorGa on 2020/8/24.
//  Copyright © 2020 SailorGa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FWLoginModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FWNetCallViewController : UIViewController

/// 登录信息
@property (strong, nonatomic) FWLoginModel *loginModel;

@end

NS_ASSUME_NONNULL_END
