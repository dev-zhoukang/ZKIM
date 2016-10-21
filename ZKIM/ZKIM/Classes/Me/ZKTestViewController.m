

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

@interface ZKTestViewController ()

@end

@implementation ZKTestViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    ZKChatPanel *bar = [ZKChatPanel chatPanel];
    [self.view addSubview:bar];
    bar.bottom = SCREEN_HEIGHT;
}

@end
