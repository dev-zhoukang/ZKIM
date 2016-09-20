//
//  ZKChatBar.m
//  ZKIM
//
//  Created by ZK on 16/9/20.
//  Copyright © 2016年 ZK. All rights reserved.
//

#import "ZKChatBar.h"

@interface ZKChatBar()
@property (weak, nonatomic) IBOutlet UIButton *recordBtn;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (nonatomic, strong) UIButton *selectedBtn;
@end

@implementation ZKChatBar

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setup];
}

- (void)setup
{
    _recordBtn.clipsToBounds = YES;
    _recordBtn.layer.cornerRadius = 5.f;
    _recordBtn.layer.borderColor = [UIColor grayColor].CGColor;
    _recordBtn.layer.borderWidth = .3f;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

+ (instancetype)chatBar
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].firstObject;
}

#pragma mark - Action

- (IBAction)chatBatBtnClick:(UIButton *)btn
{
    btn.selected = !btn.selected;
}

- (IBAction)recordBtnClick {
}


@end
