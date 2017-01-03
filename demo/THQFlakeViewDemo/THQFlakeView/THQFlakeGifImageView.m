//
//  THQFlakeGifImageView.m
//  GrainEffect
//
//  Created by 赵清 on 2016/12/9.
//  Copyright © 2016年 zhouen. All rights reserved.
//

#import "THQFlakeGifImageView.h"
#import "NSTimer+THQCategory.h"

@interface THQFlakeGifImageView ()

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation THQFlakeGifImageView

- (void)animationStart {
    [super animationStart];
    
    self.timer = [NSTimer thq_scheduledTimerWithTimeInterval:1.0/self.birthRate block:^{
        [self setNeedsDisplay];
    } repeats:YES];
    [self.timer fire];
}

- (void)animationStop {
    [super animationStop];
    [self.timer invalidate];
}

- (void)drawRect:(CGRect)rect{
    
    static int i = 0;
    NSLog(@"%s---%d",__func__,++i);
    if (self.subviews.count>200) {
        return;
    }
    
    for (UIImage *image in self.images) {
        [self createSubImageViews:image];
    }
}

- (void)createSubImageViews:(UIImage *)image {
    // 根据缩放比例求宽高
    CGFloat scaleRandom = 0;
    if (self.scaleRange != 0) {
        scaleRandom = rand() % (int)(self.scaleRange * 100) / 100.0;
    }
    CGFloat width = image.size.width * (scaleRandom ? (self.scale + scaleRandom) : self.scale);
    CGFloat height = image.size.height * (scaleRandom ? (self.scale + scaleRandom) : self.scale);
    
    //雪花起点X
    int startX = arc4random()%(int)self.bounds.size.width - 10;
    
    //雪花起点y
    int startY = -height - 20;
    
    //雪花终点x
    int endX = self.yAcceleration > 0 ? (arc4random()%(int)self.bounds.size.width - 10) : startX;
    
    //雪花终点Y
    int endY = self.bounds.size.height + height + 20;
    
    //雪花速度计入随机变量
    int randomSpeed = arc4random()%15;
    while (randomSpeed > 8) {
        randomSpeed = arc4random()%15;
    }
    
    UIImageView *snowView = [[UIImageView alloc] initWithImage:image];
    snowView.frame = CGRectMake(startX, startY, width, height);
    [self addSubview:snowView];
    
    //雪花下落的动画
    [UIView animateWithDuration:(endY - startY)/self.velocity - randomSpeed animations:^{
        snowView.frame = CGRectMake(endX, endY, width, height);
    } completion:^(BOOL finished) {
        [snowView removeFromSuperview];
    }];
}

@end
