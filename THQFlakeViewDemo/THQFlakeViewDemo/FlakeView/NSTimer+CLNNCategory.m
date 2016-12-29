//
//  NSTimer+CLNNCategory.m
//  GrainEffect
//
//  Created by 赵清 on 2016/12/9.
//  Copyright © 2016年 zhouen. All rights reserved.
//

#import "NSTimer+CLNNCategory.h"

@implementation NSTimer (CLNNCategory)

+ (NSTimer *)cl_scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                         block:(void (^)())block
                                       repeats:(BOOL)repeats
{
    NSTimer *timer = [NSTimer timerWithTimeInterval:interval
                                             target:self
                                           selector:@selector(blockInvoke:)
                                           userInfo:[block copy]
                                            repeats:repeats];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    return timer;
}

+ (void)blockInvoke:(NSTimer *)timer
{
    void (^block)() = timer.userInfo;
    if (block)
    {
        block();
    }
}

@end
