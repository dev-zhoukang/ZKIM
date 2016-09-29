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
    
    _iconImageView = [[UIImageView alloc] init];
    _iconImageView.size = CGSizeMake(40.f, 40.f);
    _iconImageView.top = 10.f;
    _iconImageView.image = [UIImage imageNamed:@"me"];
    [self.contentView addSubview:_iconImageView];
    
    _bubbleImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:_bubbleImageView];
    
    _contentLabel = [[YYLabel alloc] init];
    _contentLabel.displaysAsynchronously = YES;
    _contentLabel.fadeOnAsynchronouslyDisplay = NO;
    _contentLabel.ignoreCommonProperties = YES;
    [self.contentView addSubview:_contentLabel];
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

#pragma mark - Setter

- (void)setCellLayout:(ZKChatLayout *)cellLayout
{
    _cellLayout = cellLayout;
    _isMine = [cellLayout.chatEntity[@"isMine"] boolValue];
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
        oriImage = [UIImage imageNamed:@"SenderTextNodeBkg"];
    }
    else {
        oriImage = [UIImage imageNamed:@"ReceiverTextNodeBkg"];
    }
    CGSize size = oriImage.size;
    UIImage *bubbleImage = [oriImage resizableImageWithCapInsets:UIEdgeInsetsMake(size.height*0.5, size.width*0.5, size.height*0.5, size.width*0.5)];
    return bubbleImage;
}

@end
