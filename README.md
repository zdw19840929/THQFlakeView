# FlakeView

### 说明

在使用CAEmitterLayer，CAEmitterCell做雪花飘落效果的时候，遇到了几个坑： 

* 直接使用雪花会直接布满整个屏幕 
* 实现顶部飘落效果后导致飘花数量偏差太大   
* 实现从顶部飘落后效果后切换底部tab或者home出去再回来会从新飘落。

FlakeView针对这几个坑，做了封装（暂时不支持GIF）。详见[FlakeView踩过的坑](./resource/FlakeView踩过的坑.md)

效果图:图太大单独放到了另一个md文件中，可直接下载demo运行看效果

### 使用

#### 初始化与配置

````
@interface ViewController ()
@property (nonatomic, strong) CLNNFlakeView *flakeView;
@end

- (void)flakeStart {    
    UIImage *image = [UIImage imageNamed:@"snow"];
    NSArray *images = @[image];
    self.flakeView = [[THQFlakeView alloc] initWithFrame:self.view.bounds images:images lastTime:10 velocity:50 birthRate:10 completeBlock:^{
        // 动画完成后执行这块代码
        numbers++;
        [defaults setObject:@(numbers) forKey:UserDefaultsFlakeViewId];
        
    }];
    self.flakeView.viewController = self;
    [self.navigationController.view addSubview:self.flakeView];
    self.flakeView.scale = 0.2;
    self.flakeView.scaleRange = 0.2;
    self.flakeView.yAcceleration = 100;
    self.flakeView.velocityArray = @[@50];
    [self.flakeView animationStart];
}
````

关于self.snowView.viewController = self;的说明，需要需要在特定的控制器里才出现雪花，DEMO里是ViewController,但是需要雪花从导航栏顶部开始飘落（实际使用中配合换肤效果不会像DEMO这么挫），所以把snowView加在self.navigationController.view上（可以根据实际需求加在UIViewController或者UITabBarController的视图上），此时home出去再回来的时候需要判断ViewController是否是正在显示的从而决定是否铺满雪花，如果ViewController正在显示就铺满雪花，如果没有正在显示就不做动作。但是snowView是加在导航控制器的视图上的，在snowView内部无法获取需要显示的场景控制器（ViewController）的指针，也就是不知道此时自己是否应该显示。因此self.snowView.viewController = self;让snowView知道自己显示的场景控制器。snowView对viewController是弱引用的不会导致内存泄漏。

#### 额外处理

为了解决切换tab再回来重新飘落的问题在需要雪花的场景控制器里添加如下代码：

````
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.flakeView) {
        [self.flakeView showFlakeView];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if (self.flakeView) {
        [self.flakeView hideFlakeView];
    }
}
````

### API

* 初始化方法：

```
- (instancetype)initWithFrame:(CGRect)frame images:(NSArray *)images;
- (instancetype)initWithFrame:(CGRect)frame images:(NSArray *)images lastTime:(CGFloat)seconds velocity:(CGFloat)velocity birthRate:(float)rate;
```

* 雪花参数基本配置参数：

````
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
````

* 开始接触函数：

```
// 初始开始
- (void)animationStart;
// 手动结束
- (void)animationStop;
```

* 展示隐藏函数：

```
// 切换到别的页面隐藏
- (void)hideFlakeView;
// 切换回来重新显示
- (void)showFlakeView;
```

* 保存雪花飘落的场景控制器指针，以保证home出去再回来时正常显示：

```
// 特定的下雪花的控制器，CLNNFlakeView不一定是加在这个控制器上的，也有可能是加在UINavigationController上
@property (nonatomic, weak) UIViewController *viewController;
```



