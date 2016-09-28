//
//  ZKChatBar.m
//  ZKIM
//
//  Created by ZK on 16/9/20.
//  Copyright © 2016年 ZK. All rights reserved.
//

#import "ZKChatBar.h"

@interface ZKChatBar() <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *recordBtn;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (nonatomic, strong) UIButton *selectedBtn;

@end

static CGFloat keyboard_y;

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
    _textView.delegate = self;
    
    [self addBorderForView:_recordBtn];
    [self addBorderForView:_textView];
}

- (void)addBorderForView:(UIView *)view
{
    view.clipsToBounds = YES;
    view.layer.cornerRadius = 5.f;
    view.layer.borderColor = [UIColor grayColor].CGColor;
    view.layer.borderWidth = .3f;
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
    NSTimeInterval duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    keyboard_y = keyboardFrame.origin.y;
    
    [UIView animateWithDuration:duration animations:^{
        self.bottom = keyboardFrame.origin.y;
    }];
}

#pragma mark - <UITextViewDelegate>

- (void)textViewDidChangeSelection:(UITextView *)textView
{
    [self autoLayoutHeight];
}

- (void)textViewDidChange:(UITextView *)textView
{
    [self autoLayoutHeight];
}

#pragma mark - Action

- (IBAction)chatBatBtnClick:(UIButton *)btn
{
    btn.selected = !btn.selected;
    switch (btn.tag) {
        case 0: {
            DLog(@"Voive按钮点击");
            _recordBtn.hidden = btn.selected;
            if (btn.isSelected) {
                [_textView becomeFirstResponder];
            }
            else {
                [_textView resignFirstResponder];
            }
            
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

- (void)autoLayoutHeight
{
    if (!_textView.text.length) {
        return;
    }
    
    CGSize size = [_textView sizeThatFits:CGSizeMake(_textView.width , MAXFLOAT)];
    
    [_textView autoSetDimension:ALDimensionHeight toSize:size.height];
    
    [UIView animateWithDuration:0.12
                          delay:0.0
                        options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.height = MAX(size.height + 14.f, 50.f);
                         self.bottom = keyboard_y;
                         [self layoutIfNeeded];
                     } completion:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
