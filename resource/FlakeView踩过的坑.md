

最近项目要求实现雪花飘落效果，然后随服务端传什么图片就下什么。产品要求相当飘忽——做的好看点。如果使用drawRect:画一些UIImageView就不好实现一些加速，选装等效果了，不符合那玄乎的需求。所以粒子动画效果CAEmitterLayer，CAEmitterCell来拯救我了。

关于iOS粒子动画，CAEmitterLayer，CAEmitterCell随便一个当关键词都能搜出一堆博客和Demo。（冷笑）给我一首歌的时间。结果顺利入坑。关于CAEmitterLayer和CAEmitterCell基本说明以及API，可至[CAEmitterLayer和CAEmitterCell](http://www.tuicool.com/articles/INbQJj)了解。

看起来不错，先来个demo。

### demo1

````
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    flakeLayer = [CAEmitterLayer layer];
   
    CGRect bounds = [[UIScreen mainScreen] bounds];
    flakeLayer.emitterPosition = CGPointMake(bounds.size.width / 2, -10); //center of rectangle//发射位置
    flakeLayer.emitterSize = CGSizeMake(self.view.bounds.size.width * 2.0, 0.0);//bounds.size;//发射源的尺寸大小
    flakeLayer.emitterShape = kCAEmitterLayerLine;
    // Spawn points for the flakes are within on the outline of the line
	flakeLayer.emitterMode	= kCAEmitterLayerOutline;//发射模式

    
    
    CAEmitterCell *emitterCell = [CAEmitterCell emitterCell];
    emitterCell.contents = (id)[[UIImage imageNamed:@"snow"] CGImage];//是个CGImageRef的对象,既粒子要展现的图片
    emitterCell.birthRate = 10;//粒子参数的速度乘数因子
    emitterCell.lifetime = 120.0;//生命周期
    emitterCell.lifetimeRange = 0.5;//生命周期范围
    
    emitterCell.velocity = -10;//速度
    emitterCell.velocityRange = 10;//速度范围
    emitterCell.yAcceleration = 10;//粒子y方向的加速度分量
    emitterCell.emissionLongitude = -M_PI / 2; // upx-y平面的发射方向  ....>> emissionLatitude：发射的z轴方向的角度
    emitterCell.emissionRange = M_PI / 4; // 90 degree cone for variety周围发射角度
	emitterCell.spinRange		= 0.25 * M_PI;		// slow spin子旋转角度范围
    emitterCell.scale = 0.2;//缩放比例：
    emitterCell.scaleSpeed = 0.0;//1.0;//缩放比例速度
    emitterCell.scaleRange = 0.0;//缩放比例范围；
    flakeLayer.emitterCells = [NSArray arrayWithObject:emitterCell];//粒子发射的粒子
    
    [self.view.layer insertSublayer:flakeLayer atIndex:0];
}
````

![效果图](https://github.com/thinkq/ImageResource/blob/master/THQFlakeView_resource/第一个.gif)



效果如图，注意到雪花总是一下铺满整个屏幕的，我要的是从顶部开始飘落。

在github上[**CUSSender**](https://github.com/JJMM/CUSSender)找到解决办法：先在屏幕顶部生成10个速度0，生命周期为0.35的CAEmitterCell，然后利用这10个CAEmitterCell生成飘落的雪花CAEmitterCell

代码：

### demo2

````

-(void)initializeValue{
    // Configure the particle emitter to the top edge of the screen
    CAEmitterLayer *parentLayer = self;
    parentLayer.emitterPosition = CGPointMake(320 / 2.0, -30);
    parentLayer.emitterSize		= CGSizeMake(320 * 2.0, 0);;
    
    // Spawn points for the flakes are within on the outline of the line
    parentLayer.emitterMode		= kCAEmitterLayerOutline;
	parentLayer.emitterShape	= kCAEmitterLayerLine;
    
    parentLayer.shadowOpacity = 1.0;
	parentLayer.shadowRadius  = 0.0;
	parentLayer.shadowOffset  = CGSizeMake(0.0, 1.0);
	parentLayer.shadowColor   = [[UIColor whiteColor] CGColor];
    parentLayer.seed = (arc4random()%100)+1;

    
    CAEmitterCell* containerCell = [self createSubLayerContainer];
    containerCell.name = @"containerLayer";
    NSMutableArray *subLayerArray = [NSMutableArray array];
    NSArray *contentArray = [self getContentsByArray:self.imageNameArray];
    for (UIImage *image in contentArray) {
        [subLayerArray addObject:[self createSubLayer:image]];
    }
    
    if (containerCell) {
        containerCell.emitterCells = subLayerArray;
        parentLayer.emitterCells = [NSArray arrayWithObject:containerCell];
    }else{
        parentLayer.emitterCells = subLayerArray;
    }
}

// 重点：containerCell
-(CAEmitterCell*)createSubLayerContainer{
    CAEmitterCell* containerCell = [CAEmitterCell emitterCell];
	containerCell.birthRate			= 10.0;
	containerCell.velocity			= 0;
	containerCell.lifetime			= 0.35;
    return containerCell;
}

-(CAEmitterCell *)createSubLayer:(UIImage *)image{
    CAEmitterCell *emitterCell = [CAEmitterCell emitterCell];
    
    emitterCell.birthRate		= 5.0;
    emitterCell.lifetime		= 120.0;
	
	emitterCell.velocity		= -100;				// falling down slowly
	emitterCell.velocityRange = 0;
	emitterCell.yAcceleration = 2;
    emitterCell.emissionRange = 0.5 * M_PI;		// some variation in angle
    emitterCell.spinRange		= 0.25 * M_PI;		// slow spin
    
    emitterCell.contents		= (id)[image CGImage];
    emitterCell.color			= [[UIColor colorWithRed:0.600 green:0.658 blue:0.743 alpha:1.000] CGColor];

    return emitterCell;
}
````

但是这样的话我想每秒产生2个雪花，会密密麻麻产生好多。

分析：如果按照demo1里，我需要每秒产生2个雪花，直接设置emitterCell的birthRate为2，CAEmitterLayer就会每秒产生2个，这是正常的。但是到了demo2，CAEmitterLayer首先每秒生成10个生命周期为0.35的containerCell，containerCell每秒产生两个emitterCell

因为此时雪花总数为：

````
containerLayer.birthRate * containerLayer.lifetime * cellLayer.birthRate
````

设置cellLayer.birthRate=2.0雪花每秒产生两个，则实际是10 * 0.35 * 2，每秒7个。因为containerCell的存在是雪花数量多了3.5倍，因此要想办法中和掉这个倍数。

首先想到的是干脆直接通过containerCell控制数量，需要多少个雪花就产生多少个containerCell，每个containerCell产生一个emitterCell(雪花)，代码为：

````
-(CAEmitterCell*)createSubLayerContainer{
    CAEmitterCell* containerCell = [CAEmitterCell emitterCell];
	containerCell.birthRate			= 2.0;
	containerCell.velocity			= 0;
	containerCell.lifetime			= 1.01;
    return containerCell;
}
-(CAEmitterCell *)createSubLayer:(UIImage *)image{
    CAEmitterCell *emitterCell = [CAEmitterCell emitterCell];
    
    emitterCell.birthRate		= 1.0;
}
````

这样每个containerCell正好产生一个emitterCell，想来应该正常了但是实验结果是大部分都不正常。数目不是太多就是太少。最后摸索出了分段进行：

self.birthRate为每秒产生雪花个数，这样实际数目不会有太大差距

```
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
```

解决第一个坑:让雪花从头开始飘落并且保证数目正确。运行起来看：

![second](https://github.com/thinkq/ImageResource/blob/master/THQFlakeView_resource/second.gif)



从上图可以看到当切换底部tab的时候雪花会重新飘落，实验发现home出去再回来同样会导致雪花重新飘落。这就比较坑了。这个没源码猜不透为什么，但这个时候demo1的一下铺满的效果就可以用来解决问题。我们检测当雪花飘落之后如果切换了tab再切换回来判断如果还在飘落时间范围内就让雪花直接铺满整个屏幕。

````
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
````

在控制器里添加代码：

````
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.snowView) {
        [self.snowView showFlakeView];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if (self.snowView) {
        [self.snowView hideFlakeView];
    }
}
````

以便在适当的时候触发showFlakeView方法，以使雪花占满整个屏幕
