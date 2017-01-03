//
//  THQFlakeView.h
//  GrainEffect
//
//  Created by 赵清 on 2016/12/9.
//  Copyright © 2016年 zhouen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THQFlakeImageView.h"

static const NSString *THQFlakeViewappWillEnterForegroundNotification = @"AppWillEnterForegroundNotification";

@interface THQFlakeView : THQFlakeImageView

// 特定的下雪花的控制器，THQFlakeView不一定是加在这个控制器上的，也有可能是加在UINavigationController上
@property (nonatomic, weak) UIViewController *viewController;

@end
