//
//  FWRegisterViewController.h
//  VCSSDK_Example
//
//  Created by SailorGa on 2020/4/27.
//  Copyright © 2020 SailorGa. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FWRegisterViewController : UIViewController

/// 模块类型(注册/重置密码)
@property (nonatomic, assign) FWUserCodeState state;

@end

NS_ASSUME_NONNULL_END
