//
//  ZKRootViewController.m
//  ZKIM
//
//  Created by ZK on 16/9/13.
//  Copyright © 2016年 ZK. All rights reserved.
//

#import "ZKRootViewController.h"
#import "ZKLoginHomeViewController.h"

@interface ZKRootViewController ()

@end

@implementation ZKRootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    ZKLoginHomeViewController *loginVC = [[ZKLoginHomeViewController alloc] init];
    UINavigationController *naVC = [[UINavigationController alloc] initWithRootViewController:loginVC];
    loginVC.navigationController.navigationBar.hidden = YES;
    [self addChildViewController:naVC];
    [self.view addSubview:naVC.view];
    
    [naVC.view autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
}

@end
