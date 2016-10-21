//
//  ZKChatBar.m
//  ZKIM
//
//  Created by ZK on 16/9/20.
//  Copyright © 2016年 ZK. All rights reserved.
//

#import "ZKChatBar.h"
#import "ZKEmoticonInputView.h"

#define kChatPanelHeight   (kChatBarHeight + kEmoticonInputViewHeight)

@interface ZKChatBar() <UITextViewDelegate, ZKEmoticonInputViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton   *recordBtn;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIView     *emoticonContainer;
@property (weak, nonatomic) IBOutlet UIView     *inputBarContainer;

@property (nonatomic, strong) UIButton          *selectedBtn;
@property (nonatomic, strong) UIControl         *tapControl;
@property (nonatomic, assign) CGFloat           oriHeight; // 如果输入文字很多, 记录高度(语音切换回来还原)
@property (nonatomic, assign) BOOL isChangingBoard;

@end

static CGFloat keyboard_y;

CGFloat const kChatBarHeight = 50.f;
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
    self.size = (CGSize){SCREEN_WIDTH, kChatPanelHeight};
    _textView.delegate = self;
    _textView.returnKeyType = UIReturnKeySend;
    _textView.font = [UIFont systemFontOfSize:15.f];
    
    [self addBorderForView:_recordBtn];
    [self addBorderForView:_textView];

    ZKEmoticonInputView *emoticonView = [ZKEmoticonInputView shareView];
    [_emoticonContainer addSubview:emoticonView];
    emoticonView.frame = emoticonView.bounds;
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

+ (instancetype)shareChatBar
{
    static ZKChatBar *bar;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        bar = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].firstObject;
    });
    return bar;
}

#pragma mark - Noti

- (void)handleKeyboardDidChangeFrame:(NSNotification *)note
{
    if (_isChangingBoard) return;
    
    CGRect keyboardFrame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    _keyboardFrame = keyboardFrame;
    
    NSTimeInterval duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    keyboard_y = keyboardFrame.origin.y;
    
    [UIView animateWithDuration:duration animations:^{
        self.bottom = keyboardFrame.origin.y+216;
        [self setTableViewOffsetWithKeyboardFrame:keyboardFrame barHeight:_inputBarContainer.height];
    } completion:^(BOOL finished) {
        self.tapControl.hidden = keyboardFrame.origin.y==SCREEN_HEIGHT;
    }];
}

/*! 根据内容设置 tableView的位移 */
- (void)setTableViewOffsetWithKeyboardFrame:(CGRect)keyboardFrame barHeight:(CGFloat)barHeight
{
    UITableView *tableView = [self tableView];
    
    CGFloat maxTabelHeight = SCREEN_HEIGHT-64.f-(keyboardFrame.size.height+barHeight);
    
    CGFloat delta = tableView.contentSize.height - maxTabelHeight;
    if (delta > 0) {
        [tableView setContentOffset:CGPointMake(0, delta+kBottomInset)];
    }
    [tableView setContentInset:UIEdgeInsetsMake(tableView.contentInset.top,
                                                0,
                                                (SCREEN_HEIGHT-keyboardFrame.origin.y)+kBottomInset+(barHeight-kChatBarHeight),
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
    switch (btn.tag) {
        case 0: {
             btn.selected = !btn.selected;
            DLog(@"Voive按钮点击");
            _recordBtn.hidden = btn.selected;
            
            NSString *imageName = btn.selected?@"ToolViewKeyboard_35x35_":@"ToolViewInputVoice_35x35_";
            
            if (btn.isSelected) {
                if (_oriHeight > kChatBarHeight) {
                    self.height = _oriHeight;
                }
                [_textView becomeFirstResponder];
            }
            else {
                _oriHeight = self.height;
                [self animateSetHeight:kChatBarHeight];
                [_textView resignFirstResponder];
            }
            [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
            
        } break;
        case 1: {

            _isChangingBoard = YES;
            [_textView resignFirstResponder];
            
            if (_textView.inputView) {
                _textView.inputView = nil;
                _isChangingBoard = NO;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.03 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [_textView becomeFirstResponder];
                });
                
                [btn setImage:[UIImage imageNamed:@"ToolViewEmotion_35x35_"] forState:UIControlStateNormal];
                [btn setImage:[UIImage imageNamed:@"ToolViewEmotionHL_35x35_"] forState:UIControlStateHighlighted];
            }
            else {
                ZKEmoticonInputView *emoticonView = [ZKEmoticonInputView shareView];
                _textView.inputView = emoticonView;
                emoticonView.delegate = self;
                _isChangingBoard = NO;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.03 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [_textView becomeFirstResponder];
                });
                
                [btn setImage:[UIImage imageNamed:@"ToolViewKeyboard_35x35_"] forState:UIControlStateNormal];
                [btn setImage:[UIImage imageNamed:@"ToolViewKeyboardHL_35x35_"] forState:UIControlStateHighlighted];
            }
            
        } break;
        case 2: {
            DLog(@"Plus按钮点击");
            //imageName = @"TypeSelectorBtn_Black_35x35_";
        } break;
    }
}

- (IBAction)recordBtnClick
{
    
}

- (void)autoLayoutHeight
{
    CGFloat chatBarNewHeight = [_textView sizeThatFits:CGSizeMake(_textView.width , MAXFLOAT)].height+14.f;
    
    if (chatBarNewHeight < kChatBarHeight) {
        [self animateSetHeight:kChatBarHeight];
        return;
    }
    
    [self animateSetHeight:chatBarNewHeight];
}

- (void)animateSetHeight:(CGFloat)chatBarNewHeight
{
    if (chatBarNewHeight > kChatBarHeight*3*WindowZoomScale) {
        return;
    }
    
    [UIView animateWithDuration:0.35
                          delay:0.0
                        options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.height = 216 + chatBarNewHeight;
                         self.bottom = keyboard_y+216;
                         [self setTableViewOffsetWithKeyboardFrame:_keyboardFrame barHeight:chatBarNewHeight];
                         
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
