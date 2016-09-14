//
//  ZKRootViewController.m
//  ZKIM
//
//  Created by ZK on 16/9/13.
//  Copyright © 2016年 ZK. All rights reserved.
//

#import "ZKRootViewController.h"
#import "ZKLoginViewController.h"

@interface ZKRootViewController ()

@end

@implementation ZKRootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    ZKLoginViewController *loginVC = [[ZKLoginViewController alloc] init];
    [self addChildViewController:loginVC];
    [self.view addSubview:loginVC.view];
    
    [loginVC.view autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
}

@end
