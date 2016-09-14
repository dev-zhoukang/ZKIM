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

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    _rootViewController = [[ZKRootViewController alloc] init];
    self.window.rootViewController = _rootViewController;
    
    //AppKey:注册的AppKey，详细见下面注释。
    //apnsCertName:推送证书名（不需要加后缀），详细见下面注释。
    EMOptions *options = [EMOptions optionsWithAppkey:kAppKey_EM];
    options.apnsCertName = @"istore_dev";
    EMError *error = [[EMClient sharedClient] initializeSDKWithOptions:options];
    if (error) {
        NSLog(@"初始化失败===%@", error.errorDescription);
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
