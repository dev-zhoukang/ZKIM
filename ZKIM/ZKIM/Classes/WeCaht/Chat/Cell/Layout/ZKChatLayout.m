//
//  ZKChatLayout.m
//  ZKIM
//
//  Created by ZK on 16/9/29.
//  Copyright © 2016年 ZK. All rights reserved.
//

#import "ZKChatLayout.h"
#import "ZKTextLinePositionModifier.h"
#import "ZKRegularTool.h"

#define ContentTextFont    [UIFont systemFontOfSize:15.8f]

@interface ZKChatLayout ()

@end

@implementation ZKChatLayout

- (instancetype)initWithEMMessage:(EMMessage *)message
{
    if (!message) return nil;
    if (self = [super init]) {
        _message = message;
        _needShowTime = YES;
        [self layout];
    }
    return self;
}

- (void)layout
{
    _height = 0;
    
    _isMine = [[EMClient sharedClient].currentUsername isEqualToString:_message.from];
    
    EMMessageBody *body = _message.body;
    switch (body.type) {
        case EMMessageBodyTypeText: {
            [self layoutContentText];
        } break;
        case EMMessageBodyTypeImage: {
            
        } break;
        case EMMessageBodyTypeLocation: {
            
        } break;
        case EMMessageBodyTypeVoice: {
            
        } break;
        case EMMessageBodyTypeVideo: {
            
        } break;
        case EMMessageBodyTypeFile: {
            
        } break;
            
        default: break;
    }
    
    _height += _contentTextHeight;
    _height += 20*2; // 加上上下的边距
    
    if (_needShowTime) { // 展示时间的高度
        _height += 20;
    }
}

- (void)layoutContentText
{
    _contentTextHeight = 0;
    
    ZKTextLinePositionModifier *modifier = [[ZKTextLinePositionModifier alloc] init];
    modifier.font = ContentTextFont;
    modifier.paddingTop = 2.f;
    modifier.paddingBottom = 2.f;
    EMTextMessageBody *textBody = (EMTextMessageBody *)_message.body;
    _text = textBody.text;
    
    NSMutableAttributedString *attributedString = [self matchText:textBody.text];
    
    YYTextContainer *container = [[YYTextContainer alloc] init];
    container.size = CGSizeMake([[self class] maxLabelWidth], MAXFLOAT);
    container.maximumNumberOfRows = 0;
    container.linePositionModifier = modifier;
    
    YYTextLayout *layout = [YYTextLayout layoutWithContainer:container text:attributedString];
    _contentTextLayout = layout;
    
    _contentTextHeight = [modifier heightForLineCount:layout.rowCount];
}

- (NSMutableAttributedString *)matchText:(NSString *)string
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    attributedString.font = ContentTextFont;
    return [ZKRegularTool matchAttributedText:attributedString isMine:_isMine];
}

+ (float)maxLabelWidth
{
    return SCREEN_WIDTH-(41+(60+20+13))*WindowZoomScale;
}

@end
