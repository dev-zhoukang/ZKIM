//
//  ZKHomeViewController.m
//  ZKIM
//
//  Created by ZK on 16/9/13.
//  Copyright © 2016年 ZK. All rights reserved.
//

#import "ZKHomeViewController.h"

@interface ZKHomeViewController ()

@property (nonatomic, strong) ZKHVButton *selectedBtn;
@property (strong, nonatomic) IBOutletCollection(ZKHVButton) NSArray *tabBtns;

@end

@implementation ZKHomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupUI];
}

- (void)setupUI
{
    NSArray *imageNames = @[@"tabbar_mainframe", @"tabbar_contacts", @"tabbar_discover", @"tabbar_me"];
    NSArray *titles = @[@"微信", @"通讯录", @"发现", @"我"];
    
    for (int i = 0; i < imageNames.count; i ++) {
        [self setupTabBtn:_tabBtns[i]
                withTitle:titles[i]
          normalImageName:imageNames[i]
        selectedImageName:[NSString stringWithFormat:@"%@HL", imageNames[i]]];
    }
}

- (void)setupTabBtn:(ZKHVButton *)btn withTitle:(NSString *)title normalImageName:(NSString *)normalImageName selectedImageName:(NSString *)selectedImageName
{
    btn.backgroundColor = [UIColor clearColor];
    
    [btn setImage:[UIImage imageNamed:normalImageName] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:selectedImageName] forState:UIControlStateSelected];
    
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:11.f];
}

#pragma mark - Actions

- (IBAction)tabBtnClick:(ZKHVButton *)btn
{
    _selectedBtn.selected = NO;
    btn.selected = YES;
    _selectedBtn = btn;
    
    switch (btn.tag) {
        case 0: { // 微信
            
        } break;
        case 1: { // 通讯录
            
        } break;
        case 2: { // 发现
            
        } break;
        case 3: { // 我
            
        } break;
    }
}

@end
