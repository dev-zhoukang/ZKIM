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

#define ContentTextFont    [UIFont systemFontOfSize:15.f]

@interface ZKChatLayout ()

@end

@implementation ZKChatLayout

- (instancetype)initWithChatEntity:(NSDictionary *)entity
{
    if (!entity) return nil;
    if (self = [super init]) {
        _chatEntity = entity;
        [self layout];
    }
    return self;
}

- (void)layout
{
    _height = 0;
    
    [self layoutContentText];
    _height += _contentTextHeight;
}

- (void)layoutContentText
{
    _contentTextHeight = 0;
    
    ZKTextLinePositionModifier *modifier = [[ZKTextLinePositionModifier alloc] init];
    modifier.font = ContentTextFont;
    modifier.paddingTop = 2.f;
    modifier.paddingBottom = 2.f;
    
    NSMutableAttributedString *attributedString = [self matchText:_chatEntity[@"content"]];
    
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
    return [ZKRegularTool matchAttributedText:attributedString];
}

+ (float)maxLabelWidth
{
    return SCREEN_WIDTH-(41+(60+20+13))*WindowZoomScale;
}

@end
