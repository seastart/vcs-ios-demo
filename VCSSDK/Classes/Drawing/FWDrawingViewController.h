//
//  FWDrawingViewController.h
//  VCSSDK_Example
//
//  Created by SailorGa on 2020/8/4.
//  Copyright © 2020 SailorGa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <VCSSDK/VCSDrawing.h>

NS_ASSUME_NONNULL_BEGIN

@interface FWDrawingViewController : UIViewController

/// 共享类型
@property (assign, nonatomic) FWShareState state;
/// 电子白板服务器地址
@property (copy, nonatomic) NSString *addressText;
/// 电子白板服务器端口
@property (copy, nonatomic) NSString *portText;
/// 房间ID
@property (copy, nonatomic) NSString *roomText;
/// 用户ID
@property (copy, nonatomic) NSString *userText;

@end

NS_ASSUME_NONNULL_END
