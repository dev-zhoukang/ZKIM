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
@property (weak, nonatomic) IBOutlet UIButton   *voiceBtn;
@property (weak, nonatomic) IBOutlet UIButton   *emojiBtn;
@property (weak, nonatomic) IBOutlet UIButton   *plusBtn;

@property (nonatomic, strong) UIButton          *selectedBtn;
@property (nonatomic, strong) UIControl         *tapControl;
@property (nonatomic, assign) CGFloat           oriHeight; // 如果输入文字很多, 记录高度(语音切换回来还原)
@property (nonatomic, assign) BOOL              emoticonViewShowing;

@end

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
    _emoticonViewShowing = NO;
    
    self.size = (CGSize){SCREEN_WIDTH, kChatPanelHeight};
    _textView.delegate = self;
    _textView.returnKeyType = UIReturnKeySend;
    _textView.font = [UIFont systemFontOfSize:15.f];
    
    [self addBorderForView:_recordBtn];
    [self addBorderForView:_textView];

    ZKEmoticonInputView *emoticonView = [ZKEmoticonInputView shareView];
    [_emoticonContainer addSubview:emoticonView];
    emoticonView.frame = emoticonView.bounds;
    
    [self setImageForBtn:_voiceBtn nor:@"ToolViewInputVoice_35x35_" highlight:@"ToolViewInputVoiceHL_35x35_"];
    [self setImageForBtn:_emojiBtn nor:@"ToolViewEmotion_35x35_" highlight:@"ToolViewEmotionHL_35x35_"];
    [self setImageForBtn:_plusBtn nor:@"TypeSelectorBtn_Black_35x35_" highlight:@"TypeSelectorBtnHL_Black_35x35_"];
}

- (void)setImageForBtn:(UIButton *)btn nor:(NSString *)nor highlight:(NSString *)highlight
{
    [btn setImage:[UIImage imageNamed:nor] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:highlight] forState:UIControlStateHighlighted];
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

- (void)didMoveToWindow
{
    [super didMoveToWindow];
    [_textView resignFirstResponder];
}

+ (instancetype)chatBar
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].firstObject;
}

#pragma mark - Noti (键盘)

- (void)handleKeyboardDidChangeFrame:(NSNotification *)note
{
    CGRect keyboardFrame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    if (keyboardFrame.origin.y == SCREEN_HEIGHT && _emoticonViewShowing) { // 是退下键盘 且 需要显示表情面板
        keyboardFrame = (CGRect){0, SCREEN_HEIGHT-kEmoticonInputViewHeight, SCREEN_WIDTH, kEmoticonInputViewHeight}; //将表情面板当做新键盘
    }
    
    DLog(@"keyboardFrame == %@", NSStringFromCGRect(keyboardFrame));
    
    NSTimeInterval duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    _keyboard_y = keyboardFrame.origin.y;
    
    [UIView animateWithDuration:duration animations:^{
        self.bottom = _emoticonViewShowing ? SCREEN_HEIGHT : (keyboardFrame.origin.y+kEmoticonInputViewHeight);
        [self setTableViewOffsetWithKeyboardY:keyboardFrame.origin.y barHeight:_inputBarContainer.height];
    } completion:^(BOOL finished) {
        self.tapControl.hidden = (keyboardFrame.origin.y==SCREEN_HEIGHT && !_emoticonViewShowing);
    }];
}

/*! 根据内容设置 tableView的位移 */
- (void)setTableViewOffsetWithKeyboardY:(CGFloat)keyboardY barHeight:(CGFloat)barHeight
{
    UITableView *tableView = [self tableView];
    
    CGFloat maxTabelHeight = SCREEN_HEIGHT-64.f-(SCREEN_HEIGHT-keyboardY+barHeight);
    
    CGFloat delta = tableView.contentSize.height - maxTabelHeight;
    if (delta > 0) {
        [tableView setContentOffset:CGPointMake(0, delta+kBottomInset)];
    }
    [tableView setContentInset:UIEdgeInsetsMake(tableView.contentInset.top,
                                                0,
                                                (SCREEN_HEIGHT-keyboardY)+kBottomInset+(barHeight-kChatBarHeight),
                                                0)];
}

#pragma mark - <UITextViewDelegate>

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    [self hideEmoticonView];
    return YES;
}

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
    
    switch (btn.tag) {
        case 0: {
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
        case 1: { //表情键盘
            DLog(@" 是选中: %d", btn.isSelected);
            
            if (btn.isSelected) { // 显示表情
                [self showEmoticonView];
            }
            else {
                [self hideEmoticonView];
                [_textView becomeFirstResponder];
            }
            
        } break;
        case 2: {
            DLog(@"Plus按钮点击");
            //imageName = @"TypeSelectorBtn_Black_35x35_";
        } break;
    }
}

- (void)showEmoticonView
{
    _emoticonViewShowing = YES;
    
    [_emojiBtn setImage:[UIImage imageNamed:@"ToolViewKeyboard_35x35_"] forState:UIControlStateNormal];
    [_emojiBtn setImage:[UIImage imageNamed:@"ToolViewKeyboardHL_35x35_"] forState:UIControlStateHighlighted];
    //失去焦点，隐藏键盘
    [_textView resignFirstResponder];
}

- (void)hideEmoticonView
{
    _emoticonViewShowing = NO;
    _emojiBtn.selected = NO;
    [_emojiBtn setImage:[UIImage imageNamed:@"ToolViewEmotion_35x35_"] forState:UIControlStateNormal];
    [_emojiBtn setImage:[UIImage imageNamed:@"ToolViewEmotionHL_35x35_"] forState:UIControlStateHighlighted];
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
                         self.height = kEmoticonInputViewHeight + chatBarNewHeight;
                         self.bottom = _keyboard_y+kEmoticonInputViewHeight;
                         [self setTableViewOffsetWithKeyboardY:_keyboard_y barHeight:chatBarNewHeight];
                         
                         [self layoutIfNeeded];
                     } completion:nil];
}

- (void)tapAction
{
    [KeyWindow endEditing:YES];
    if (_emoticonViewShowing) {
        [UIView animateWithDuration:0.25 animations:^{
            self.bottom = SCREEN_HEIGHT+kEmoticonInputViewHeight;
            [self setTableViewOffsetWithKeyboardY:SCREEN_HEIGHT barHeight:_inputBarContainer.height];
        }];
    }
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
