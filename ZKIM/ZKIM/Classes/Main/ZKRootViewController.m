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

@interface ZKRootViewController ()

@end

@implementation ZKRootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    ZKHomeViewController *homeViewController = [[ZKHomeViewController alloc] init];
    _rootNavigationController = [[UINavigationController alloc] initWithRootViewController:homeViewController];
    [_rootNavigationController setNavigationBarHidden:YES animated:NO];
    
    [self addChildViewController:_rootNavigationController];
    [self.view insertSubview:_rootNavigationController.view atIndex:0];
    [_rootNavigationController.view autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    
    ZKLoginHomeViewController *loginHomeVC = [[ZKLoginHomeViewController alloc] init];
    [_applicationContext presentNavigationController:loginHomeVC animated:NO completion:nil];
}

@end
