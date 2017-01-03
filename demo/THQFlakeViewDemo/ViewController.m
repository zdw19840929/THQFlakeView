//
//  ViewController.m
//  THQFlakeViewDemo
//
//  Created by 赵清 on 2016/12/29.
//  Copyright © 2016年 赵清. All rights reserved.
//

#import "ViewController.h"
#import "THQFlakeView.h"

static const NSUInteger maxFlakeNumbers = 3;
static NSString *UserDefaultsFlakeViewId = @"THQFlakeViewFlakeNumbers";

@interface ViewController ()
@property (nonatomic,strong) UIImageView *backgroundImgView;
@property (nonatomic, strong) THQFlakeView *flakeView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.backgroundImgView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    self.backgroundImgView.image = [UIImage imageNamed:@"snow_background.jpg"];
    [self.view addSubview:self.backgroundImgView];
}

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

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"点击");
    
    if (self.flakeView.isAnimating) {
        UIViewController *vc = [[UIViewController alloc] init];
        vc.view.backgroundColor = [UIColor redColor];
        [self.navigationController pushViewController:vc animated:YES];
    }else {
        [self flakeStart];
    }
}

- (void)flakeStart {
    __block NSUInteger numbers = 0;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    numbers = [[defaults objectForKey:UserDefaultsFlakeViewId] integerValue];
    // 超出次数限制直接返回
    if (numbers >= maxFlakeNumbers) {
        return;
    }
    
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




@end
