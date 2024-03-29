//
//  NSTimer+THQCategory.h
//  GrainEffect
//
//  Created by 赵清 on 2016/12/9.
//  Copyright © 2016年 zhouen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (THQCategory)

+ (NSTimer *)thq_scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                         block:(void (^)())block
                                       repeats:(BOOL)repeats;

@end
