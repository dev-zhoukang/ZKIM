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
    
    //@property (nonatomic, assign, readonly) NSTimeInterval preTimeStamp; //!< 上条信息时间戳
    //@property (nonatomic, assign, readonly) BOOL needShowTime; //!< 需要展示时间
    _needShowTime = YES;
}

@end
