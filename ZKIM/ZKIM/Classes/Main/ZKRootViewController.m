//
//  ZKRootViewController.m
//  ZKIM
//
//  Created by ZK on 16/9/13.
//  Copyright © 2016年 ZK. All rights reserved.
//

#import "ZKRootViewController.h"
#import "ZKHomeViewController.h"
#import "ZKLoginHomeViewController.h"
#import "ZKNavigationController.h"
#import "ZKLoginUser.h"

@interface ZKRootViewController ()

@end

@implementation ZKRootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    ZKHomeViewController *homeViewController = [[ZKHomeViewController alloc] init];
    UINavigationController *navc = [[UINavigationController alloc] initWithRootViewController:homeViewController];
    [navc setNavigationBarHidden:YES animated:NO];
    
    [self addChildViewController:navc];
    [self.view insertSubview:navc.view atIndex:0];
    [navc.view autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    
    if (!_loginUser) {
        ZKLoginHomeViewController *loginHomeVC = [[ZKLoginHomeViewController alloc] init];
        [_applicationContext presentNavigationController:loginHomeVC animated:NO completion:nil];
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
