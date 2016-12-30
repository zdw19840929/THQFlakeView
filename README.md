# FlakeView

### 说明

在使用CAEmitterLayer，CAEmitterCell做雪花飘落效果的时候，遇到了几个坑： 

* 直接使用雪花会直接布满整个屏幕 
* 实现顶部飘落效果后导致飘花数量偏差太大   
* 实现从顶部飘落后效果后切换底部tab或者home出去再回来会从新飘落。

FlakeView针对这几个坑，做了封装。详见[FlakeView踩过的坑](./FlakeView/FlakeView踩过的坑.md)

### 使用

#### 初始化与配置

````
@interface ViewController ()
@property (nonatomic, strong) CLNNFlakeView *snowView;
@end

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UIImage *image = [UIImage imageNamed:@"snow"];
    NSArray *images = @[image];
    self.snowView = [[CLNNFlakeView alloc] initWithFrame:self.view.bounds images:images lastTime:90 velocity:700 birthRate:10];
    self.snowView.viewController = self;
    [self.navigationController.view addSubview:self.snowView];
    self.snowView.scale = 0.2;
    self.snowView.scaleRange = 0.2;
    self.snowView.yAcceleration = 100;
    self.snowView.velocityArray = @[@50];
    [self.snowView animationStart];
}
````

关于self.snowView.viewController = self;的说明，需要需要在特定的控制器里才出现雪花，DEMO里是ViewController,但是需要雪花从导航栏顶部开始飘落（实际使用中配合换肤效果不会像DEMO这么挫），所以把snowView加在self.navigationController.view上（可以根据实际需求加在UIViewController或者UITabBarController的视图上），此时home出去再回来的时候需要判断ViewController是否是正在显示的从而决定是否铺满雪花，如果ViewController正在显示就铺满雪花，如果没有正在显示就不做动作。但是snowView是加在导航控制器的视图上的，在snowView内部无法知道获取需要显示的场景控制器（ViewController），也就是不知道此时自己是否应该显示。因此self.snowView.viewController = self;让snowView知道自己显示的场景控制器。snowView对viewController是弱引用的不会导致内存泄漏。

为了解决切换tab再回来重新飘落的问题在需要雪花的场景控制器里添加如下代码：

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



