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
#define kMaxImageWH        (SCREEN_WIDTH*0.5) //!< 图片的最大显示尺寸

@interface ZKChatLayout ()

@end

@implementation ZKChatLayout

- (instancetype)initWithZKMessage:(ZKMessage *)message
{
    if (!message) return nil;
    if (self = [super init]) {
        _message = message;
        [self layout];
    }
    return self;
}

- (void)layout
{
    _height = 0;
    switch (_message.type) {
        case ZKMessageBodyTypeText: {
            [self layoutContentText];
            _height += _contentTextHeight;
            _height += 20*2; // 加上上下的边距
        } break;
        case ZKMessageBodyTypeImage: {
            [self layoutImage];
            _height += _imageSize.height;
            _height += 10*2; // 加上上下的边距
        } break;
        case ZKMessageBodyTypeLocation: {
            
        } break;
        case ZKMessageBodyTypeAudio: {
            [self layoutAudio];
            _height += _audioHeight;
            _height += 10*2;
        } break;
        case ZKMessageBodyTypeVideo: {
            
        } break;
    }
    
    if (_message.needShowTime) { // 展示时间的高度
        _height += 25;
    }
}

- (void)layoutAudio
{
    _audioHeight = 45.f;
}

- (void)layoutImage
{
    _imageSize = CGSizeZero;
    
    CGFloat maxImageWidth = kMaxImageWH;
    CGFloat maxImageHeight = kMaxImageWH;
    
    CGFloat imageWidth = _message.imageSize.width;
    CGFloat imageHeight = _message.imageSize.height;
    
    if (imageWidth > imageHeight) { // 如果是宽图
        if (imageWidth > maxImageWidth) {
            imageHeight = imageWidth * (maxImageWidth/imageWidth);
            imageWidth = maxImageWidth;
        }
    }
    else { // 如果是长图
        if (imageHeight > maxImageHeight) {
            imageWidth = imageWidth * (maxImageHeight/imageHeight);
            imageHeight = maxImageHeight;
        }
    }
    _imageSize = (CGSize){imageWidth, imageHeight};
}

- (void)layoutContentText
{
    _contentTextHeight = 0;
    
    ZKTextLinePositionModifier *modifier = [[ZKTextLinePositionModifier alloc] init];
    modifier.font = ContentTextFont;
    modifier.paddingTop = 2.f;
    modifier.paddingBottom = 2.f;
    
    NSMutableAttributedString *attributedString = [self matchText:_message.contentText];
    
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
    return [ZKRegularTool matchAttributedText:attributedString isMine:_message.isMine];
}

+ (CGFloat)maxLabelWidth
{
    return SCREEN_WIDTH-(41+(60+20+13))*WindowZoomScale;
}

@end
