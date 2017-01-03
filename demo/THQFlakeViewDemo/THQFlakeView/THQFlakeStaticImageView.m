//
//  THQFlakeStaticImageView.m
//  GrainEffect
//
//  Created by 赵清 on 2016/12/7.
//  Copyright © 2016年 zhouen. All rights reserved.
//

#import "THQFlakeStaticImageView.h"

@interface THQFlakeStaticImageView ()
@property (nonatomic, strong) CAEmitterLayer *emitterLayer;
@property (nonatomic, copy) NSArray *emitterCells;
@end

@implementation THQFlakeStaticImageView

- (instancetype)initWithFrame:(CGRect)frame images:(NSArray *)images lastTime:(CGFloat)seconds velocity:(CGFloat)velocity birthRate:(float)rate{
    self = [super initWithFrame:frame images:images lastTime:seconds velocity:velocity birthRate:rate];
    if (self) {
        [self emitterLayerInit];
    }
    return self;
}

- (void)emitterLayerInit {
    _emitterLayer = [CAEmitterLayer layer];
    CGRect bounds = self.bounds;
    _emitterLayer.emitterPosition = CGPointMake(bounds.size.width / 2, -30); //center of rectangle//发射位置
    _emitterLayer.emitterSize = CGSizeMake(bounds.size.width, 0.0);//bounds.size;//发射源的尺寸大小
    _emitterLayer.emitterShape = kCAEmitterLayerRectangle;
    _emitterLayer.emitterMode = kCAEmitterLayerVolume;
    [self.layer insertSublayer:self.emitterLayer atIndex:0];
}

-(CAEmitterCell*)createSubLayerContainer:(float)birthRate lifetime:(float)lifetime{
    CAEmitterCell* containerLayer = [CAEmitterCell emitterCell];
    containerLayer.birthRate = birthRate;
    containerLayer.velocity	= 0;
    containerLayer.lifetime	= lifetime;
    return containerLayer;
}

- (CAEmitterCell *)emitterCell:(UIImage *)image birthRate:(float)birthRate speed:(NSInteger)speed{
    CAEmitterCell *emitterCell = [CAEmitterCell emitterCell];
    emitterCell.contents = (id)[image CGImage];//是个CGImageRef的对象,既粒子要展现的图片
    emitterCell.birthRate = birthRate;//粒子参数的速度乘数因子
    emitterCell.lifetime = 120;//生命周期
    emitterCell.lifetimeRange = 0.5;//生命周期范围
    
    emitterCell.velocity = speed;//速度
    emitterCell.velocityRange = 10;//速度范围
    emitterCell.yAcceleration = self.yAcceleration / 10;//粒子y方向的加速度分量
    emitterCell.emissionLongitude = M_PI / 2; // upx-y平面的发射方向  ....>> emissionLatitude：发射的z轴方向的角度
    emitterCell.emissionRange = M_PI / 4; // 90 degree cone for variety周围发射角度
    emitterCell.spinRange = 0.5 * M_PI;		// slow spin子旋转角度范围
    
    emitterCell.scale = self.scale;//缩放比例：
    emitterCell.scaleSpeed = 0.005; //1.0;//缩放比例速度
    emitterCell.scaleRange = self.scaleRange;//缩放比例范围；

    return emitterCell;
}

- (void)animationStart {
    [super animationStart];    
    NSMutableArray *mutableArray = [NSMutableArray array];
    for (int i=0; i<self.images.count; i++) {
        UIImage *image = self.images[i];
        NSInteger speed = self.velocity;
        if (self.velocityArray.count > i) {
            speed = [self.velocityArray[i] intValue];
        }        
        if (self.birthRate < 5){
            CAEmitterCell* containerLayer = [self createSubLayerContainer:self.birthRate lifetime:1.1/((float)self.birthRate)];
            CAEmitterCell *cell = [self emitterCell:image birthRate:self.birthRate speed:speed];
            containerLayer.emitterCells = @[cell];
            [mutableArray addObject:containerLayer];
            
        }else if (self.birthRate < 10) {
            CAEmitterCell* containerLayer = [self createSubLayerContainer:4 lifetime:1.1/4.0];
            CAEmitterCell *cell = [self emitterCell:image birthRate:self.birthRate speed:speed];
            containerLayer.emitterCells = @[cell];
            [mutableArray addObject:containerLayer];
        }else {
            CAEmitterCell* containerLayer = [self createSubLayerContainer:10 lifetime:0.25];
            CAEmitterCell *cell = [self emitterCell:image birthRate:self.birthRate/2.25 speed:speed];
            containerLayer.emitterCells = @[cell];
            [mutableArray addObject:containerLayer];
        }
        
    }
    self.emitterLayer.emitterCells = mutableArray;//粒子发射的粒子
}

- (void)animationStop {
    [super animationStop];
    self.emitterLayer.birthRate = 0;
}

- (void)showFlakeView {
    NSMutableArray *mutableArray = [NSMutableArray array];
    for (int i=0; i<self.images.count; i++) {
        UIImage *image = self.images[i];
        NSInteger speed = self.velocity;
        if (self.velocityArray.count > i) {
            speed = [self.velocityArray[i] intValue];
        }
        CAEmitterCell *cell = [self emitterCell:image birthRate:self.birthRate speed:speed];
        [mutableArray addObject:cell];
    }
    self.emitterLayer.emitterCells = mutableArray;
}

@end
