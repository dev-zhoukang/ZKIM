//
//  ZKChatPanel.m
//  ZKIM
//
//  Created by ZK on 16/9/20.
//  Copyright © 2016年 ZK. All rights reserved.
//

#import "ZKChatPanel.h"
#import "ZKRecordHelper.h"
#import "EMCDDeviceManager.h"

#define kChatPanelHeight   (kChatBarHeight + kEmoticonInputViewHeight)

@interface ZKChatPanel() <UITextViewDelegate, ZKEmoticonInputViewDelegate, ZKPlusPanelDelegate, ZKRecordHelperDelegate>

@property (weak, nonatomic) IBOutlet UIButton   *recordBtn;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIView     *panelContainer; // 放表情和plus面板
@property (weak, nonatomic) IBOutlet UIView     *inputBarContainer;
@property (weak, nonatomic) IBOutlet UIButton   *voiceBtn;
@property (weak, nonatomic) IBOutlet UIButton   *emojiBtn;
@property (weak, nonatomic) IBOutlet UIButton   *plusBtn;

@property (nonatomic, strong) UIButton          *selectedBtn;
@property (nonatomic, strong) UIControl         *tapControl;
@property (nonatomic, assign) CGFloat           oriHeight; // 如果输入文字很多, 记录高度(语音切换回来还原)
@property (nonatomic, assign) BOOL              emoticonViewShowing;
@property (nonatomic, assign) BOOL              shouldShowPlusPanel;

@property (nonatomic, strong) ZKEmoticonInputView *emoticonView;
@property (nonatomic, strong) ZKPlusPanel         *plusPanel;

@property (nonatomic, strong) ZKRecordHelper      *recordHelper;

@end

static CGFloat const kChatBarHeight = 50.f;
static CGFloat const kBottomInset = 10.f;

@implementation ZKChatPanel

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
    _shouldShowPlusPanel = NO;
    
    _keyboard_y = SCREEN_HEIGHT;
    
    self.size = (CGSize){SCREEN_WIDTH, kChatPanelHeight};
    _textView.delegate = self;
    _textView.returnKeyType = UIReturnKeySend;
    _textView.font = [UIFont systemFontOfSize:15.f];
    
    [self addBorderForView:_recordBtn];
    [self addBorderForView:_textView];
    
    UIColor *highlightColor = [[UIColor blackColor] colorWithAlphaComponent:.22];
    [_recordBtn setBackgroundImage:[UIImage imageWithColor:highlightColor] forState:UIControlStateHighlighted];
    [_recordBtn setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
    _recordBtn.hitEdgeInsets = UIEdgeInsetsMake(-7, 0, -7, 0);

    _emoticonView = [ZKEmoticonInputView shareView];
    [_panelContainer addSubview:_emoticonView];
    _emoticonView.frame = _panelContainer.bounds;
    
    _plusPanel = [ZKPlusPanel plusPanel];
    _plusPanel.delegate = self;
    [_panelContainer addSubview:_plusPanel];
    _plusPanel.frame = _panelContainer.bounds;
    
    [self setImageForBtn:_voiceBtn nor:@"ToolViewKeyboard_35x35_" highlight:@"ToolViewKeyboardHL_35x35_"];
    [self setImageForBtn:_emojiBtn nor:@"ToolViewEmotion_35x35_" highlight:@"ToolViewEmotionHL_35x35_"];
    [self setImageForBtn:_plusBtn nor:@"TypeSelectorBtn_Black_35x35_" highlight:@"TypeSelectorBtnHL_Black_35x35_"];
    
    _recordHelper = [ZKRecordHelper recordHelperWithButton:_recordBtn];
    _recordHelper.delegate = self;
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
    /*
     [_textView resignFirstResponder];
     self.bottom = self.superview.height + kEmoticonInputViewHeight;
     self.left = 0;
     */
}

+ (instancetype)chatPanel
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
    
    NSTimeInterval duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [self showEmoticonViewWithKeyboardY:keyboardFrame.origin.y duration:duration];
}

- (void)showEmoticonViewWithKeyboardY:(CGFloat)keyboardY duration:(NSTimeInterval)duration
{
    _keyboard_y = keyboardY;
    
    [UIView animateWithDuration:duration animations:^{
        self.bottom = _emoticonViewShowing ? SCREEN_HEIGHT : (keyboardY+kEmoticonInputViewHeight);
        _panelContainer.top = _inputBarContainer.height;
        [self setTableViewOffsetWithKeyboardY:keyboardY barHeight:_inputBarContainer.height];
        if (_shouldShowPlusPanel) {
            _plusPanel.top = 0;
            _emoticonView.top = _panelContainer.height;
        }
        else {
            _emoticonView.top = 0;
            _plusPanel.top = _panelContainer.height;
        }
    } completion:^(BOOL finished) {
        self.tapControl.hidden = (keyboardY==SCREEN_HEIGHT && !_emoticonViewShowing);
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
    [self willHideEmoticonView];
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
        
        if ([self.delegate respondsToSelector:@selector(chatPanel:sendText:)]) {
            [self.delegate chatPanel:self sendText:textView.text];
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
            [self tapVoiceBtn:btn];
        } break;
        case 1: { //表情键盘
            [self tapEmoticonBtn:btn];
        } break;
        case 2: {
            [self tapPlusBtn:btn];
        } break;
    }
}

- (void)tapPlusBtn:(UIButton *)btn
{
    _shouldShowPlusPanel = YES;
    
    if (btn.isSelected) { // 点击显示Plus面板
        [self tapShowPlusPanel];
    }
    else {
        [self tapHidePlusPanel];
    }
}

- (void)tapEmoticonBtn:(UIButton *)btn
{
    _shouldShowPlusPanel = NO;
    if (btn.isSelected) { // 点击显示表情
        [self tapShowEmoticonView];
    }
    else {
        [self tapHideEmoticonView];
    }
}

- (void)tapVoiceBtn:(UIButton *)btn
{
    DLog(@"Voive按钮点击");
    
    if (btn.selected) {
        _recordBtn.hidden = YES;
        [self setImageForBtn:_voiceBtn nor:@"ToolViewInputVoice_35x35_" highlight:@"ToolViewInputVoiceHL_35x35_"];
        if (_oriHeight > kChatBarHeight) {
            self.height = _oriHeight;
        }
        [_textView becomeFirstResponder];
    }
    else {
        _recordBtn.hidden = NO;
        [self setImageForBtn:_voiceBtn nor:@"ToolViewKeyboard_35x35_" highlight:@"ToolViewKeyboardHL_35x35_"];
        _oriHeight = self.height;
        [self animateSetHeight:kChatBarHeight];
        [_textView resignFirstResponder];
    }
}

- (void)tapShowPlusPanel
{
    _emoticonViewShowing = YES;
    _emojiBtn.selected = NO;
    
    [self setImageForBtn:_emojiBtn nor:@"ToolViewEmotion_35x35_" highlight:@"ToolViewEmotionHL_35x35_"];
    
    [self showEmoticonContainer];
}

/*! 显示下部面板 */
- (void)showEmoticonContainer
{
    if (_textView.isFirstResponder) {
        // 在弹出表情的时候有向上滑的效果
        _panelContainer.top = kEmoticonInputViewHeight*2;
        // 在退出键盘的时候 将表情视图设置成新的键盘frame
        [_textView resignFirstResponder];
    }
    else { // 在录音状态点击表情按钮
        CGFloat keyboardY = SCREEN_HEIGHT-kEmoticonInputViewHeight;
        [self showEmoticonViewWithKeyboardY:keyboardY duration:0.25];
    }
}

- (void)tapHidePlusPanel
{
    _emoticonViewShowing = NO;
    self.tapControl.hidden = YES;
    [_textView becomeFirstResponder];
}

- (void)tapShowEmoticonView
{
    _emoticonViewShowing = YES;
    _recordBtn.hidden = YES;
    _plusBtn.selected = NO; // 将按钮的选中状态归位
    
    [self setImageForBtn:_emojiBtn nor:@"ToolViewKeyboard_35x35_" highlight:@"ToolViewKeyboardHL_35x35_"];
    
    [self showEmoticonContainer];
}

- (void)tapHideEmoticonView
{
    [self willHideEmoticonView];
    self.tapControl.hidden = YES;
    [_textView becomeFirstResponder];
}

- (void)willHideEmoticonView
{
    _emojiBtn.selected = NO;
    _emoticonViewShowing = NO;
    
    [self setImageForBtn:_emojiBtn nor:@"ToolViewEmotion_35x35_" highlight:@"ToolViewEmotionHL_35x35_"];
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
    _plusBtn.selected = NO;
    _emojiBtn.selected = NO;
    [self setImageForBtn:_emojiBtn nor:@"ToolViewEmotion_35x35_" highlight:@"ToolViewEmotionHL_35x35_"];
    
    if (_emoticonViewShowing) {
        [UIView animateWithDuration:0.25 animations:^{
            self.bottom = SCREEN_HEIGHT+kEmoticonInputViewHeight;
            [self setTableViewOffsetWithKeyboardY:SCREEN_HEIGHT barHeight:_inputBarContainer.height];
        }completion:^(BOOL finished) {
            self.tapControl.hidden = YES;
        }];
    }
}

#pragma mark - <ZKPlusPanelDelegate>

- (void)plusPanelSendMediaModel:(ZKMediaModel *)mediaModel type:(MediaType)mediaType
{
    if ([self.delegate respondsToSelector:@selector(chatPanelSendMediaModel:mediaType:)]) {
        // chat VC 是其代理
        [self.delegate chatPanelSendMediaModel:mediaModel mediaType:mediaType];
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

#pragma mark - <ZKRecordHelperDelegate>

- (void)recordHelperDidStartRecord
{
    DLog(@"开始录音");
    
    NSString *dateStr = [[NSDate date] timestamp];
    NSString *pathStr = [NSString stringWithFormat:@"%@%zd", dateStr, Random(0, 100000)];
    
    [[EMCDDeviceManager sharedInstance] asyncStartRecordingWithFileName:pathStr completion:^(NSError *error) {
        if (error) {
            DLog(@"%@", error.description);
        }
    }];
}

- (void)recordHelperDidCancelRecord
{
    DLog(@"取消录音");
}

- (void)recordHelperDidEndRecordWithData:(NSData *)amrAudio duration:(NSTimeInterval)duration
{
    DLog(@"结束录音");
    [[EMCDDeviceManager sharedInstance] asyncStopRecordingWithCompletion:^(NSString *recordPath, NSInteger aDuration, NSError *error) {
        DLog(@"路径 == %@  时长 == %zd", recordPath, aDuration);
        if (error) {
            DLog(@"录音失败 == %@", error);
            return;
        }
        // 结束录音后 将录音信息传给代理
        ZKMediaModel *model = [ZKMediaModel new];
        model.audioPath = recordPath.copy;
        model.audioDuration = aDuration;
        
        if ([self.delegate respondsToSelector:@selector(chatPanelSendMediaModel:mediaType:)]) {
            [self.delegate chatPanelSendMediaModel:model mediaType:MediaType_Audio];
        }
    }];
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
