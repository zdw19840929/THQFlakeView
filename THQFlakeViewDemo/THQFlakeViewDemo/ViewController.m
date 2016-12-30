//
//  ViewController.m
//  THQFlakeViewDemo
//
//  Created by 赵清 on 2016/12/29.
//  Copyright © 2016年 赵清. All rights reserved.
//

#import "ViewController.h"
#import "CLNNFlakeView.h"

@interface ViewController ()
@property (nonatomic,strong) UIImageView *backgroundImgView;
@property (nonatomic, strong) CLNNFlakeView *snowView;
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

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"点击");
    
    if (self.snowView.isAnimating) {
        UIViewController *vc = [[UIViewController alloc] init];
        vc.view.backgroundColor = [UIColor redColor];
        [self.navigationController pushViewController:vc animated:YES];
    }else {
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
}




@end
