//
//  AppDelegate.m
//  THQFlakeViewDemo
//
//  Created by 赵清 on 2016/12/29.
//  Copyright © 2016年 赵清. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [_window makeKeyAndVisible];
    //背景色
    _window.backgroundColor = [UIColor whiteColor];
    
    UITabBarController *tabbarController = [[UITabBarController alloc] init];
    ViewController *viewVC = [[ViewController alloc] init];
    viewVC.title = @"111111";
    UINavigationController *navVC = [[UINavigationController alloc]initWithRootViewController:viewVC];
    
    ViewController *viewVC1 = [[ViewController alloc] init];
    viewVC1.view.backgroundColor = [UIColor redColor];
    viewVC1.title = @"222222";
    UINavigationController *navVC1 = [[UINavigationController alloc]initWithRootViewController:viewVC1];
    tabbarController.viewControllers = @[navVC,navVC1];
    _window.rootViewController = tabbarController;
    
    return YES;
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"applicationWillEnterForeground" object:nil];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
