//
//  ZKLoginHomeViewController.m
//  ZKIM
//
//  Created by ZK on 16/9/14.
//  Copyright © 2016年 ZK. All rights reserved.
//

#import "ZKLoginHomeViewController.h"
#import "ZKLoginViewController.h"

@interface ZKLoginHomeViewController ()

@end

@implementation ZKLoginHomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - Actions

- (IBAction)loginBtnClick
{
    [self pushLoginVCWithType:ZKLoginTypeLogin];
}

- (IBAction)regBtnClick
{
    [self pushLoginVCWithType:ZKLoginTypeRegister];
}

- (void)pushLoginVCWithType:(ZKLoginType)loginType
{
    ZKLoginViewController *loginVC = [[ZKLoginViewController alloc] init];
    loginVC.loginType = loginType;
    [self.navigationController pushViewController:loginVC animated:YES];
}

@end
