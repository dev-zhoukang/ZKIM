//
//  ZKMessage.m
//  ZKIM
//
//  Created by ZK on 16/10/27.
//  Copyright © 2016年 ZK. All rights reserved.
//

#import "ZKMessage.h"

@implementation ZKMessage

- (instancetype)initWithEMMessage:(EMMessage *)emmsg
{
    if (!emmsg) return nil;
    _emmsg = emmsg;
    self = [super init];
    [self setup];
    return self;
}

- (void)setup
{
    _type = (ZKMessageBodyType)_emmsg.body.type;
    _messageId = _emmsg.messageId;
    
    if (_type == ZKMessageBodyTypeText) {
        EMTextMessageBody *textBody = (EMTextMessageBody *)_emmsg.body;
        _contentText = [textBody.text copy];
    }
    _timestamp = _emmsg.timestamp;
    _messageStatus = (ZKMessageStatus)_emmsg.status;
    _isMine = [[EMClient sharedClient].currentUsername isEqualToString:_emmsg.from];
}

- (void)setPreTimestamp:(NSTimeInterval)preTimestamp
{
    _preTimestamp = preTimestamp;
    NSDate *pre_date = [NSDate dateWithTimeStamp:preTimestamp];
    NSDate *this_date = [NSDate dateWithTimeStamp:_timestamp];
    NSInteger delta = (NSInteger)[this_date timeIntervalSinceDate:pre_date];
    
    _needShowTime = delta>60;
}

@end
