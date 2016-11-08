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
    
    _timestamp = _emmsg.timestamp;
    _messageStatus = (ZKMessageStatus)_emmsg.status;
    _isMine = [[EMClient sharedClient].currentUsername isEqualToString:_emmsg.from];
    
    // 解析消息
    switch (_type) {
        case ZKMessageBodyTypeText: {
            EMTextMessageBody *textBody = (EMTextMessageBody *)_emmsg.body;
            _contentText = [textBody.text copy];
        } break;
        case ZKMessageBodyTypeImage: {
            EMImageMessageBody *body = (EMImageMessageBody *)_emmsg.body;
            _imageSize = body.size;
            
            _localPath = [body.localPath copy];
            
            if ([FileManager fileExistsAtPath:body.localPath]) {
                _largeImage = [UIImage imageWithContentsOfFile:body.localPath];
            }
            _largeImageRemotePath = body.remotePath;
            
            if ([FileManager fileExistsAtPath:body.thumbnailLocalPath]) {
                _thumbnailImage = [UIImage imageWithContentsOfFile:body.thumbnailLocalPath];
            }
            _thumbnailRemotePath = body.thumbnailRemotePath;
            
        } break;
        case ZKMessageBodyTypeLocation: {
            
        } break;
        case ZKMessageBodyTypeVideo: {
            
        } break;
        case ZKMessageBodyTypeAudio: {
            EMVoiceMessageBody *body = (EMVoiceMessageBody *)_emmsg.body;
            _audioLocalPath = body.localPath.copy;
            _audioRemotePath = body.remotePath.copy;
            _audioDuration = body.duration;
        } break;
            
        default: break;
    }
    
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
