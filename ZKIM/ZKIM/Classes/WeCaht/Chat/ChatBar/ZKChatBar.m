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
    [self addObserver];
}

- (void)addObserver
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardDidChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
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

#pragma mark - Noti

- (void)handleKeyboardDidChangeFrame:(NSNotification *)note
{
    CGRect keyboardFrame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    DLog(@"keyboardFrame==%@", NSStringFromCGRect(keyboardFrame));
    DLog(@"self.frame===%@", NSStringFromCGRect(self.frame));
    
    [UIView animateWithDuration:0.5 animations:^{
        self.bottom = 100.f;
    }];
}

#pragma mark - Action

- (IBAction)chatBatBtnClick:(UIButton *)btn
{
    btn.selected = !btn.selected;
    switch (btn.tag) {
        case 0: {
            DLog(@"Voive按钮点击");
            _recordBtn.hidden = btn.selected;
        } break;
        case 1: {
            DLog(@"Emoj按钮点击");
        } break;
        case 2: {
            DLog(@"Plus按钮点击");
        } break;
    }
}

- (IBAction)recordBtnClick
{
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
