//
//  ZKChatBar.m
//  ZKIM
//
//  Created by ZK on 16/9/20.
//  Copyright © 2016年 ZK. All rights reserved.
//

#import "ZKChatBar.h"

@interface ZKChatBar() <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton   *recordBtn;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (nonatomic, strong) UIButton          *selectedBtn;
@property (nonatomic, strong) UIControl         *tapControl;
@property (nonatomic, assign) CGFloat           oriHeight; // 如果输入文字很多, 记录高度(语音切换回来还原)

@end

static CGFloat keyboard_y;

static CGFloat const kBarDefaultHeight = 50.f;
static CGFloat const kBottomInset = 10.f;

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
    self.size = (CGSize){SCREEN_WIDTH, kBarDefaultHeight};
    _textView.delegate = self;
    _textView.returnKeyType = UIReturnKeySend;
    _textView.font = [UIFont systemFontOfSize:15.f];
    
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
    _keyboardFrame = keyboardFrame;
    
    NSTimeInterval duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    keyboard_y = keyboardFrame.origin.y;
    
    [UIView animateWithDuration:duration animations:^{
        self.bottom = keyboardFrame.origin.y;
        [self setTableViewOffsetWithKeyboardFrame:keyboardFrame];
    } completion:^(BOOL finished) {
        self.tapControl.hidden = keyboardFrame.origin.y==SCREEN_HEIGHT;
    }];
}

/*! 根据内容设置 tableView的位移 */
- (void)setTableViewOffsetWithKeyboardFrame:(CGRect)keyboardFrame
{
    UITableView *tableView = [self tableView];
    
    CGFloat maxTabelHeight = SCREEN_HEIGHT-64.f-(keyboardFrame.size.height+self.height);
    
    CGFloat delta = tableView.contentSize.height - maxTabelHeight;
    if (delta > 0) {
        [tableView setContentOffset:CGPointMake(0, delta+kBottomInset)];
    }
    [tableView setContentInset:UIEdgeInsetsMake(tableView.contentInset.top,
                                                0,
                                                (SCREEN_HEIGHT-keyboardFrame.origin.y)+kBottomInset+(self.height-kBarDefaultHeight),
                                                0)];
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

#pragma mark - 发送消息
/*! 发送消息 */
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        textView.text = [textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if ([textView.text isEqualToString:@""]) {
            return NO;
        }
        
        if ([self.delegate respondsToSelector:@selector(charBar:sendText:)]) {
            [self.delegate charBar:self sendText:textView.text];
            textView.text = @"";
        }
        return NO;
    }
    return YES;
}

#pragma mark - Action

- (IBAction)chatBatBtnClick:(UIButton *)btn
{
    btn.selected = !btn.selected;
    
    NSString *imageName = nil;
    
    switch (btn.tag) {
        case 0: {
            DLog(@"Voive按钮点击");
            _recordBtn.hidden = btn.selected;
            
            imageName = btn.selected?@"ToolViewKeyboard_35x35_":@"ToolViewInputVoice_35x35_";
            
            if (btn.isSelected) {
                if (_oriHeight > kBarDefaultHeight) {
                    self.height = _oriHeight;
                }
                [_textView becomeFirstResponder];
            }
            else {
                _oriHeight = self.height;
                [self animateSetHeight:kBarDefaultHeight];
                [_textView resignFirstResponder];
            }
            
        } break;
        case 1: {
            DLog(@"Emoj按钮点击");
            imageName = btn.selected?@"ToolViewKeyboard_35x35_":@"ToolViewEmotion_35x35_";
        } break;
        case 2: {
            DLog(@"Plus按钮点击");
            imageName = @"TypeSelectorBtn_Black_35x35_";
        } break;
    }
    
    [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
}

- (IBAction)recordBtnClick
{
    
}

- (void)autoLayoutHeight
{
    CGFloat chatBarNewHeight = [_textView sizeThatFits:CGSizeMake(_textView.width , MAXFLOAT)].height+14.f;
    
    if (chatBarNewHeight < kBarDefaultHeight) {
        [self animateSetHeight:kBarDefaultHeight];
        return;
    }
    
    [self animateSetHeight:chatBarNewHeight];
}

- (void)animateSetHeight:(CGFloat)chatBarNewHeight
{
    if (chatBarNewHeight > kBarDefaultHeight*3*WindowZoomScale) {
        return;
    }
    
    [UIView animateWithDuration:0.35
                          delay:0.0
                        options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.height = chatBarNewHeight;
                         self.bottom = keyboard_y;
                         [self setTableViewOffsetWithKeyboardFrame:_keyboardFrame];
                         
                         [self layoutIfNeeded];
                     } completion:nil];
}

#pragma mark - Getter

- (UIControl *)tapControl
{
    if (!_tapControl) {
        _tapControl = [[UIControl alloc] initWithFrame:KeyWindow.bounds];
        [_tapControl addTarget:self action:@selector(tapAction) forControlEvents:UIControlEventTouchUpInside];
        [self.viewController.view insertSubview:_tapControl belowSubview:self];
    }
    return _tapControl;
}

- (void)tapAction
{
    [KeyWindow endEditing:YES];
}

#pragma mark - 获取 view 所在控制器

- (UIViewController *)viewController
{
    UIViewController *viewController = nil;
    UIResponder *next = self.nextResponder;
    while (next) {
        if ([next isKindOfClass:[UIViewController class]]) {
            viewController = (UIViewController *)next;
            break;
        }
        next = next.nextResponder;
    }
    return viewController;
}

- (UITableView *)tableView
{
    __block UITableView *tableView = nil;

    [self.viewController.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UITableView class]]) {
            tableView = obj;
            *stop = YES;
        }
    }];
    return tableView;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
