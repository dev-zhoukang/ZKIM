

//
//  ZKTestViewController.m
//  ZKIM
//
//  Created by ZK on 16/10/20.
//  Copyright © 2016年 ZK. All rights reserved.
//

#import "ZKTestViewController.h"
#import "ZKEmoticonInputView.h"

@interface ZKTestViewController ()

@end

@implementation ZKTestViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    ZKEmoticonInputView *emoticonView = [ZKEmoticonInputView shareView];
    [self.view addSubview:emoticonView];
    emoticonView.bottom = SCREEN_HEIGHT;
    emoticonView.size = (CGSize){SCREEN_WIDTH, 216.f};
}

@end
