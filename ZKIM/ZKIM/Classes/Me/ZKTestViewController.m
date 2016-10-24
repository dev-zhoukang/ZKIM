

//
//  ZKTestViewController.m
//  ZKIM
//
//  Created by ZK on 16/10/20.
//  Copyright © 2016年 ZK. All rights reserved.
//

#import "ZKTestViewController.h"
#import "ZKEmoticonInputView.h"
#import "ZKChatPanel.h"
#import "ZKPlusPanel.h"

@interface ZKTestViewController ()

@end

@implementation ZKTestViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    ZKPlusPanel *panel = [ZKPlusPanel new];
    [self.view addSubview:panel];
    panel.bottom = SCREEN_HEIGHT;
}

@end
