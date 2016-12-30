//
//  CLNNFlakeView.m
//  GrainEffect
//
//  Created by 赵清 on 2016/12/9.
//  Copyright © 2016年 zhouen. All rights reserved.
//
static const int NotUseTabBarController = 100;
#import "CLNNFlakeView.h"
#import "CLNNFlakeGifImageView.h"
#import "CLNNFlakeStaticImageView.h"

@interface CLNNFlakeView ()

@property (nonatomic, strong) CLNNFlakeImageView *currentAnimationView;

// 雪花持续时间到
@property (nonatomic, getter=isTimeup) BOOL timeup;

// 当使用tab的时候记录在那个index
@property (nonatomic, assign) NSUInteger inWhichTabIndex;

// 是否是切换了底部tab（使用CAEmitterLayer切换tab回来和home出去再回来会重头开始飘雪花）,如果是则回来直接让雪花布满整个屏幕，如果只是push一个新的控制器然后回到飘雪页面则正常飘落
@property (nonatomic, assign) BOOL shouldOverspread;

@end

@implementation CLNNFlakeView

- (instancetype)initWithFrame:(CGRect)frame images:(NSArray *)images lastTime:(CGFloat)seconds velocity:(CGFloat)velocity birthRate:(float)rate {
    self = [super initWithFrame:frame images:images lastTime:seconds velocity:velocity birthRate:rate];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillEnterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
    }
    return self;
}

#pragma mark Private
- (CLNNFlakeStaticImageView *)flakeStaticImageView {
    CLNNFlakeStaticImageView *flakeStaticImageView = [[CLNNFlakeStaticImageView alloc] initWithFrame:self.bounds images:self.images lastTime:self.lastTime velocity:self.velocity birthRate:self.birthRate];
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[CLNNFlakeStaticImageView class]]) {
            [view removeFromSuperview];
        }
    }
    [self addSubview:flakeStaticImageView];
    flakeStaticImageView.scale = self.scale;
    flakeStaticImageView.scaleRange = self.scaleRange;
    flakeStaticImageView.yAcceleration = self.yAcceleration;
    flakeStaticImageView.velocityArray = self.velocityArray;
    [flakeStaticImageView animationStart];
    self.currentAnimationView = flakeStaticImageView;
    return flakeStaticImageView;
}

- (CLNNFlakeGifImageView *)flakeGifImageView {
    CLNNFlakeGifImageView *flakeGifImageView = [[CLNNFlakeGifImageView alloc] initWithFrame:self.bounds images:self.images lastTime:self.lastTime velocity:self.velocity birthRate:self.birthRate];
    flakeGifImageView.backgroundColor = [UIColor clearColor];
    [self addSubview:flakeGifImageView];
    flakeGifImageView.scale = self.scale;
    flakeGifImageView.scaleRange = self.scaleRange;
    flakeGifImageView.yAcceleration = self.yAcceleration;
    [flakeGifImageView animationStart];
    self.currentAnimationView = flakeGifImageView;
    return flakeGifImageView;
}

- (UITabBarController *)tabBarController {
    for (UIView *view = self; view; view = view.superview) {
        UIResponder *nextResponder = [view nextResponder];
        if ([nextResponder isKindOfClass:[UITabBarController class]]) {
            return (UITabBarController *)nextResponder;
        }
    }
    return nil;
}

-(UIViewController *)topMostController
{
    NSMutableArray *controllersHierarchy = [[NSMutableArray alloc] init];
    
    UIViewController *topController = self.window.rootViewController;
    
    if (topController)
    {
        [controllersHierarchy addObject:topController];
    }
    
    while ([topController presentedViewController]) {
        
        topController = [topController presentedViewController];
        [controllersHierarchy addObject:topController];
    }
    
    if ([topController isKindOfClass:[UITabBarController class]]) {
        topController = ((UITabBarController *)topController).selectedViewController;
    }
    if ([topController isKindOfClass:[UINavigationController class]]) {
        topController = ((UINavigationController *)topController).topViewController;
    }
    return (UIViewController*)topController;
}

- (NSUInteger)tabBarControllerSelectedIndex {
    UITabBarController *tabBarController = [self tabBarController];
    if (tabBarController) {
        return tabBarController.selectedIndex;
    }
    return NotUseTabBarController;
}

- (void)appWillEnterForeground {
    if (self.viewController) {
        if ([self topMostController] == self.viewController) {
            self.shouldOverspread = YES;
            [self showFlakeView];
        }
        self.shouldOverspread = YES;
    }
}

#pragma mark Public
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)animationStart {
    [super animationStart];
    self.timeup = NO;
    self.inWhichTabIndex = [self tabBarControllerSelectedIndex];
    
    // 判断是gif还是static
    BOOL isGif = NO;
    for (UIImage *image in self.images) {
        if (image.images && image.images.count > 1) {
            isGif = YES;
            break;
        }
    }
    
    if (!isGif) {
        self.currentAnimationView = [self flakeStaticImageView];
        [self.currentAnimationView animationStart];
    }else {
        self.currentAnimationView = [self flakeGifImageView];
        [self.currentAnimationView animationStart];
    }

    // 持续时间
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, self.lastTime * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self animationStop];
    });
}

- (void)animationStop {
    [super animationStop];
    [self.currentAnimationView animationStop];
    self.timeup = YES;
    
    CGRect bounds = self.bounds;
    CGFloat height = bounds.size.height + 50;
    __block CGFloat miniVelocity = self.velocity;
    [self.velocityArray enumerateObjectsUsingBlock:^(NSNumber*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj floatValue] < miniVelocity) {
            miniVelocity = [obj floatValue];
        }
    }];
    NSLog(@"最后飘落时间%f", height / miniVelocity);
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, height / miniVelocity * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        self.animating = NO;
        if (self.superview) {
            [self removeFromSuperview];
        }
        NSLog(@"done");
    });
}

- (void)hideFlakeView {
    if (self.superview) {
        self.hidden = YES;
        if (self.inWhichTabIndex != NotUseTabBarController && self.inWhichTabIndex != [self tabBarControllerSelectedIndex]) {
            self.shouldOverspread = YES;
        }
    }
}

- (void)showFlakeView {
    if (self.superview && !self.isTimeup) {
        if (self.shouldOverspread && [self.currentAnimationView isKindOfClass:[CLNNFlakeStaticImageView class]]) {
            // 切换tab或者home 再切换回来后为了让雪花铺满整屏，强制重新创建flakeStaticImageView，并且调用showFlakeView而不是animationStart方法
            if (self.currentAnimationView && self.currentAnimationView.superview) {
                [self.currentAnimationView removeFromSuperview];
                self.currentAnimationView = nil;
            }
            self.currentAnimationView = [self flakeStaticImageView];
            [self.currentAnimationView showFlakeView];
            self.shouldOverspread = NO;
        }
    }
    self.hidden = NO;
}

@end
