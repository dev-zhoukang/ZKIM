//
//  ZKXMPPManager.m
//  ZKIM
//
//  Created by ZK on 16/9/20.
//  Copyright © 2016年 ZK. All rights reserved.
//

#import "ZKXMPPManager.h"
#import "EMSDK.h"

@implementation ZKXMPPManager

- (instancetype)shareManager
{
    static ZKXMPPManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[ZKXMPPManager alloc] init];
    });
    return manager;
}

+ (void)initEMSDK
{
    EMOptions *options = [EMOptions optionsWithAppkey:kAppKey_EM];
    options.apnsCertName = @"istore_dev";
    EMError *error = [[EMClient sharedClient] initializeSDKWithOptions:options];
    if (error) {
        DLog(@"环信初始化失败===%@", error.errorDescription);
    }
    else {
        DLog(@"环信初始化成功");
    }
}

+ (void)applicationDidEnterBackground:(UIApplication *)application
{
    [[EMClient sharedClient] applicationDidEnterBackground:application];
}

+ (void)applicationWillEnterForeground:(UIApplication *)application
{
    [[EMClient sharedClient] applicationWillEnterForeground:application];
}

@end
