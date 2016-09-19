//
//  AppDelegate.m
//  ZKIM
//
//  Created by ZK on 16/9/13.
//  Copyright © 2016年 ZK. All rights reserved.
//

#import "AppDelegate.h"
#import "ZKRootViewController.h"
#import "EMSDK.h"
#import "ZKNavigationController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    _rootViewController = [[ZKRootViewController alloc] init];
    self.window.rootViewController = _rootViewController;
    
    EMOptions *options = [EMOptions optionsWithAppkey:kAppKey_EM];
    options.apnsCertName = @"istore_dev";
    EMError *error = [[EMClient sharedClient] initializeSDKWithOptions:options];
    if (error) {
        DLog(@"环信初始化失败===%@", error.errorDescription);
    }
    else {
        DLog(@"环信初始化成功");
    }
    
    return YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [[EMClient sharedClient] applicationDidEnterBackground:application];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [[EMClient sharedClient] applicationWillEnterForeground:application];
}

@end
