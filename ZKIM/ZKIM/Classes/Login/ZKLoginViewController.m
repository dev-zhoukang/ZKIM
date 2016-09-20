//
//  ZKLoginViewController.m
//  ZKIM
//
//  Created by ZK on 16/9/14.
//  Copyright © 2016年 ZK. All rights reserved.
//

#import "ZKLoginViewController.h"
#import "EMSDK.h"
#import "ZKHomeViewController.h"

@interface ZKLoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *accountTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *doneBtn;

@end

@implementation ZKLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [_doneBtn setTitle:_loginType == ZKLoginTypeLogin?@"登录":@"注册" forState:UIControlStateNormal];
}

#pragma mark - Actions

- (IBAction)doneBtnClick
{
    if (_loginType == ZKLoginTypeRegister) {
        [self startRegisterRequest];
    }
    else {
        [self startLoginRequest];
    }
}

- (void)startRegisterRequest
{
    EMError *error = [[EMClient sharedClient] registerWithUsername:_accountTextField.text password:_passwordTextField.text];
    if (error) {
        NSString *errorHintStr = [NSString stringWithFormat:@"注册失败:%@", error.errorDescription];
        [USSuspensionView showWithMessage:errorHintStr];
    }
    else {
        [USSuspensionView showWithMessage:@"注册成功, 请登录"];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)startLoginRequest
{
    EMError *error = [[EMClient sharedClient] loginWithUsername:_accountTextField.text password:_passwordTextField.text];
    if (error) {
        NSString *errorHintStr = [NSString stringWithFormat:@"登录失败:%@", error.errorDescription];
        [USSuspensionView showWithMessage:errorHintStr];
    }
    else {
        // 设置自动登录
        [[EMClient sharedClient].options setIsAutoLogin:YES];
        NSDictionary *info = @{
                               @"account":_accountTextField.text,
                               @"password":_passwordTextField.text // 不应该明文存储在本地, 这只是Demo, 所以...
                               };
        [AuthData loginSuccess:info];
        [USSuspensionView showWithMessage:@"正在登录..."];
        [KeyWindow endEditing:YES];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
             [_applicationContext dismissNavigationControllerAnimated:YES completion:nil];
        });
    }
}

@end
