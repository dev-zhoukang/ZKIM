//
//  AppDelegate.m
//  ZKIM
//
//  Created by ZK on 16/9/13.
//  Copyright © 2016年 ZK. All rights reserved.
//

#import "AppDelegate.h"
#import "ZKRootViewController.h"
#import "ZKXMPPManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    _rootViewController = [[ZKRootViewController alloc] init];
    self.window.rootViewController = _rootViewController;
    
    // 初始化环信
    [ZKXMPPManager initEMSDK];
    
    return YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [ZKXMPPManager applicationDidEnterBackground:application];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [ZKXMPPManager applicationWillEnterForeground:application];
}

@end
