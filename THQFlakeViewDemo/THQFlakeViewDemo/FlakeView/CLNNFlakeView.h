//
//  CLNNFlakeView.h
//  GrainEffect
//
//  Created by 赵清 on 2016/12/9.
//  Copyright © 2016年 zhouen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLNNFlakeImageView.h"
@interface CLNNFlakeView : CLNNFlakeImageView

// 特定的下雪花的控制器，CLNNFlakeView不一定是加在这个控制器上的，也有可能是加在UINavigationController上
@property (nonatomic, weak) UIViewController *viewController;

// 发送home出去再回来的通知NAME
@property (nonatomic, copy) NSString *appWillEnterForegroundNotification;

@end
