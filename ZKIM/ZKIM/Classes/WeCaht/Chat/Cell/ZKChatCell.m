//
//  ZKChatCell.m
//  ZKIM
//
//  Created by ZK on 16/9/29.
//  Copyright © 2016年 ZK. All rights reserved.
//

#import "ZKChatCell.h"
#import "ZKChatLayout.h"

@interface ZKChatCell ()

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UIImageView *bubbleImageView;
@property (nonatomic, strong) YYLabel     *contentLabel;

@property (nonatomic, assign) BOOL        isMine; //我的消息
@property (nonatomic, strong) UILongPressGestureRecognizer *longPress;

@end

@implementation ZKChatCell

#pragma mark - Init

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSeparatorStyleNone;
    
    _iconImageView = [[UIImageView alloc] init];
    _iconImageView.size = CGSizeMake(40.f, 40.f);
    _iconImageView.top = 10.f;
    _iconImageView.image = [UIImage imageNamed:@"me"];
    [self.contentView addSubview:_iconImageView];
    
    _bubbleImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:_bubbleImageView];
    
    _contentLabel = [[YYLabel alloc] init];
    _contentLabel.displaysAsynchronously = NO;
    _contentLabel.fadeOnAsynchronouslyDisplay = NO;
    _contentLabel.ignoreCommonProperties = YES;
    [self.contentView addSubview:_contentLabel];
    
    _longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    [_contentLabel addGestureRecognizer:_longPress];
}

#pragma mark - Pub

+ (instancetype)cellWithTableView:(UITableView *)tableView type:(ZKChatCellType)type
{
    static NSString *cellID = @"ZKChatCell";
    ZKChatCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[ZKChatCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    return cell;
}

#pragma mark - Gesture

- (void)handleLongPress:(UILongPressGestureRecognizer *)recognizer
{
    if (recognizer.state != UIGestureRecognizerStateBegan) return;
    
    UIMenuController *copyMenu = [UIMenuController sharedMenuController];
    
    UIMenuItem *copyItem = [[UIMenuItem alloc]
                            initWithTitle:@"复制"action:NSSelectorFromString(@"copyAction:")];
    UIMenuItem *deleteItem = [[UIMenuItem alloc]
                              initWithTitle:@"删除"action:NSSelectorFromString(@"deleteAction:")];
    
    [copyMenu setMenuItems:[NSArray arrayWithObjects:deleteItem, nil]];
    
    NSString *jsonValue = [@{@"text":_cellLayout.text, @"index":@(1)} json];
    
    [copyMenu setMenuItems:[NSArray arrayWithObjects:copyItem,deleteItem, nil]];
    
    BOOL labelResponse = [recognizer.view isKindOfClass:[UILabel class]] || [recognizer.view isKindOfClass:[YYLabel class]];
    if (labelResponse) {
        [_bubbleImageView becomeFirstResponder];
        [copyMenu setTargetRect:_bubbleImageView.bounds inView:_bubbleImageView];
        _bubbleImageView.accessibilityValue = jsonValue;
    }
    else{
        [recognizer.view becomeFirstResponder];
        [copyMenu setTargetRect:recognizer.view.bounds inView:recognizer.view];
        recognizer.view.accessibilityValue = jsonValue;
    }
    [copyMenu setMenuVisible:YES animated:YES];
    
    [self setSelected:YES animated:YES];
}

#pragma mark - Setter

- (void)setCellLayout:(ZKChatLayout *)cellLayout
{
    _cellLayout = cellLayout;
    _isMine = cellLayout.isMine;
    _contentLabel.textLayout = cellLayout.contentTextLayout;
    
    [self layout];
}

- (void)layout
{
    _bubbleImageView.image = [self getBubbleImage];
    
    CGFloat labelWidth = _cellLayout.contentTextLayout.textBoundingSize.width;
    CGFloat labelHeight = _cellLayout.contentTextLayout.textBoundingSize.height;
    _contentLabel.size = _cellLayout.contentTextLayout.textBoundingSize;
    _bubbleImageView.size = CGSizeMake(labelWidth+40.f, labelHeight+40.f);
    _bubbleImageView.top = 10.f;
    _contentLabel.top = 25.f;
    
    if (_isMine) {
        _iconImageView.right = SCREEN_WIDTH - 10.f;
        _bubbleImageView.right = CGRectGetMinX(_iconImageView.frame)-5.f;
        _contentLabel.right = CGRectGetMinX(_iconImageView.frame)-25.f;
    }
    else {
        _iconImageView.left = 10.f;
        _bubbleImageView.left = CGRectGetMaxX(_iconImageView.frame)+5.f;
        _contentLabel.left = CGRectGetMaxX(_iconImageView.frame)+25.f;
    }
}

- (UIImage *)getBubbleImage
{
    UIImage *oriImage = nil;
    if (_isMine) {
        oriImage = [[UIImage imageNamed:@"SenderTextNodeBkg"] tintedImageWithColor:RGBACOLOR(35, 130, 251, .87) style:UIImageTintStyleKeepingAlpha];
    }
    else {
        oriImage = [UIImage imageNamed:@"ReceiverTextNodeBkg"];
    }
    CGSize size = oriImage.size;
    UIImage *bubbleImage = [oriImage resizableImageWithCapInsets:UIEdgeInsetsMake(size.height*0.5, size.width*0.5, size.height*0.5, size.width*0.5)];
    return bubbleImage;
}

@end

////////////////////

@implementation UIImageView (Message)
#pragma mark - UIResponder

- (BOOL)canBecomeFirstResponder
{
    return true;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if (action == @selector(copyAction:)){
        return YES;
    }
    if (action == @selector(deleteAction:)){
        return YES;
    }
    return NO;
}

- (void)copyAction:(id)sender
{
    NSDictionary *dic = [self.accessibilityValue object];
    
    [[UIPasteboard generalPasteboard] setString:dic[@"text"]];
}

- (void)deleteAction:(id)sender
{
    NSDictionary *dic = [self.accessibilityValue object];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"dele" object:dic[@"index"]];
}

@end

