//
//  ZKChatCell.m
//  ZKIM
//
//  Created by ZK on 16/9/29.
//  Copyright © 2016年 ZK. All rights reserved.
//

#import "ZKChatCell.h"

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
    _iconImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:_iconImageView];
    
    _bubbleImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:_bubbleImageView];
    
    _contentLabel = [[YYLabel alloc] init];
    [self.contentView addSubview:_contentLabel];
}

- (void)layoutSubviews
{
    
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

- (void)updateCellWithInfo:(NSDictionary *)info
{
    _isMine = info[@"isMine"];
    NSString *contentText = info[@"content"];
    
    
}

@end
