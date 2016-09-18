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

@interface ZKRootViewController ()

@end

@implementation ZKRootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    ZKHomeViewController *homeViewController = [[ZKHomeViewController alloc] init];
    
    [self addChildViewController:homeViewController];
    [self.view insertSubview:homeViewController.view atIndex:0];
    [homeViewController.view autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    
//    ZKLoginHomeViewController *loginHomeVC = [[ZKLoginHomeViewController alloc] init];
//    [_applicationContext presentNavigationController:loginHomeVC animated:NO completion:nil];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
