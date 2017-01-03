//
//  CLNNFlakeImageView.h
//  GrainEffect
//
//  Created by 赵清 on 2016/12/9.
//  Copyright © 2016年 zhouen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface THQFlakeImageView : UIView

// 动画图片数组
@property (nonatomic, copy) NSArray<UIImage *> *images;

// 每个image对应的速度，为空则使用默认的velocity属性值
@property (nonatomic, copy) NSArray *velocityArray;

// 是否在动画中
@property (nonatomic, getter=isAnimating) BOOL animating;

// 持续时间
@property (nonatomic, assign) CGFloat lastTime;

// 速度，当velocityArray为空时使用这个
@property (nonatomic, assign) CGFloat velocity;

// 每秒产生个数
@property (nonatomic, assign) float birthRate;

// 缩放比例，默认为1不缩放
@property (nonatomic, assign) CGFloat scale;

// 缩放比例范围，实际大小为（scale - scaleRange，scale + scaleRange）
@property (nonatomic, assign) CGFloat scaleRange;

// 横向加速度
@property (nonatomic, assign) CGFloat yAcceleration;

- (instancetype)initWithFrame:(CGRect)frame images:(NSArray *)images;
- (instancetype)initWithFrame:(CGRect)frame images:(NSArray *)images lastTime:(CGFloat)seconds velocity:(CGFloat)velocity birthRate:(float)rate;

// 初始开始
- (void)animationStart;
// 手动结束
- (void)animationStop;

// 切换到别的页面隐藏
- (void)hideFlakeView;
// 切换回来重新显示
- (void)showFlakeView;

@end
