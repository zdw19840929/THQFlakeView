//
//  CLNNFlakeImageView.m
//  GrainEffect
//
//  Created by 赵清 on 2016/12/9.
//  Copyright © 2016年 zhouen. All rights reserved.
//

#import "THQFlakeImageView.h"

@implementation THQFlakeImageView

- (instancetype)init {
    self = [self initWithFrame:CGRectZero];;
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [self initWithFrame:frame images:nil];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame images:(NSArray *)images{
    self = [self initWithFrame:frame images:images lastTime:30 velocity:10 birthRate:10];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame images:(NSArray *)images lastTime:(CGFloat)seconds velocity:(CGFloat)velocity birthRate:(float)rate{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = NO;
        _lastTime = seconds != 0 ? seconds :30;
        _velocity = velocity != 0 ? velocity : 10;
        _birthRate = rate != 0 ? rate : 10;
        if (images) {
            _images = images;
        }
        
        _scale = 1.0;
        _scaleRange = 0.0;
        _yAcceleration = 0.0;
    }
    return self;
}

- (void)animationStart {
    if (self.isAnimating) {
        return;
    }
    if (self.images.count == 0) {
        NSLog(@"图片个数为0");
        if (self.superview) {
            [self removeFromSuperview];
        }
        return;
    }
    self.animating = YES;
}

- (void)animationStop {
    if (!self.isAnimating) {
        return;
    }
}

- (void)hideFlakeView {}
- (void)showFlakeView {}

@end
