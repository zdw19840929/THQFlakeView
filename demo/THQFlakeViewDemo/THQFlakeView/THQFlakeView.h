//
//  THQFlakeView.h
//  GrainEffect
//
//  Created by 赵清 on 2016/12/9.
//  Copyright © 2016年 zhouen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THQFlakeImageView.h"

typedef void (^THQFlakeViewCompleteBlock)();

@interface THQFlakeView : THQFlakeImageView

// 特定的下雪花的控制器，THQFlakeView不一定是加在这个控制器上的，也有可能是加在UINavigationController上
@property (nonatomic, weak) UIViewController *viewController;

// 动画完成block
@property(readwrite, nonatomic, copy) THQFlakeViewCompleteBlock completeBlock;

- (instancetype)initWithFrame:(CGRect)frame images:(NSArray *)images lastTime:(CGFloat)seconds velocity:(CGFloat)velocity birthRate:(float)rate completeBlock:(void (^)())block;

@end
