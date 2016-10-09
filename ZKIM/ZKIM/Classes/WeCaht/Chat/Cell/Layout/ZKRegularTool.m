//
//  ZKRegularTool.m
//  ZKIM
//
//  Created by ZK on 16/9/29.
//  Copyright © 2016年 ZK. All rights reserved.
//

#import "ZKRegularTool.h"

#define RegularTextColor  HexColor(0x63bebd)

@implementation ZKRegularTool
+ (NSMutableAttributedString *)matchAttributedText:(NSMutableAttributedString *)text isMine:(BOOL)isMine
{
    text.color = isMine?[UIColor whiteColor]:[UIColor blackColor];
    
    // 高亮状态的背景
    YYTextBorder *highlightBorder = [[YYTextBorder alloc] init];
    highlightBorder.insets = UIEdgeInsetsMake(-1.f, 0, -3.f, 0);
    highlightBorder.cornerRadius = 3.f;
    highlightBorder.fillColor = HexColor(0xbfdffe);
    
    // 匹配表情
    NSRegularExpression *regular = [ZKRegularTool regularEmotion];
    NSArray <NSTextCheckingResult *> * emoticonResults = [regular matchesInString:text.string options:kNilOptions range:NSMakeRange(0, text.string.length)];
    
    NSUInteger emoClipLength = 0;
    for (NSTextCheckingResult *emo in emoticonResults) {
        if (emo.range.location == NSNotFound && emo.range.length <= 1) continue;
        NSRange range = emo.range;
        range.location -= emoClipLength;
        NSString *emoString = [text.string substringWithRange:range];
        NSString *imagePath = [[self class] getFaceNameMap][emoString];
        UIImage *image = [UIImage imageNamed:imagePath];
        if (!image) continue;
        
        NSAttributedString *emoText = [NSAttributedString attachmentStringWithEmojiImage:image fontSize:15];
        [text replaceCharactersInRange:range withAttributedString:emoText];
        emoClipLength += range.length - 1;
    }
    
    // 匹配网址
    NSArray *urlResults = [[ZKRegularTool regularWebUrl] matchesInString:text.string options:kNilOptions range:NSMakeRange(0, text.string.length)];
    for (NSTextCheckingResult *urlResult in urlResults) {
        if (urlResult.range.location == NSNotFound && urlResult.range.length <= 1) continue;
        if ([text attribute:YYTextHighlightAttributeName atIndex:urlResult.range.location] == nil) {
            [text setColor:RegularTextColor range:urlResult.range];
            
            YYTextHighlight *highlight = [YYTextHighlight new];
            [highlight setBackgroundBorder:highlightBorder];
            
            NSString *content = [text attributedSubstringFromRange:urlResult.range].string;
            highlight.userInfo = @{kWebUrlLink: content};
            [text setTextHighlight:highlight range:urlResult.range];
        }
    }
    
    // 匹配手机
    NSArray *telResults = [[ZKRegularTool regularMobileNumber] matchesInString:text.string options:kNilOptions range:NSMakeRange(0, text.string.length)];
    for (NSTextCheckingResult *telResult in telResults) {
        if (telResult.range.location == NSNotFound && telResult.range.length <= 1) continue;
        if ([text attribute:YYTextHighlightAttributeName atIndex:telResult.range.location] == nil) {
            [text setColor:RegularTextColor range:telResult.range];
            
            NSString *contentStr = [text attributedSubstringFromRange:telResult.range].string;
            
            YYTextHighlight *highlight = [YYTextHighlight new];
            [highlight setBackgroundBorder:highlightBorder];
            
            highlight.userInfo = @{kTelNumber: contentStr};
            [text setTextHighlight:highlight range:telResult.range];
        }
    }
    
    // 匹配座机
    NSArray *phoneResults = [[ZKRegularTool regularPhoneNumber] matchesInString:text.string options:kNilOptions range:NSMakeRange(0, text.string.length)];
    for (NSTextCheckingResult *phoneResult in phoneResults) {
        if (phoneResult.range.location == NSNotFound && phoneResult.range.length <= 1) continue;
        if ([text attribute:YYTextHighlightAttributeName atIndex:phoneResult.range.location] == nil) {
            [text setColor:RegularTextColor range:phoneResult.range];
            
            NSString *contentStr = [text attributedSubstringFromRange:phoneResult.range].string;
            
            YYTextHighlight *highlight = [[YYTextHighlight alloc] init];
            [highlight setBackgroundBorder:highlightBorder];
            
            highlight.userInfo = @{kPhoneNumber: contentStr};
            [text setTextHighlight:highlight range:phoneResult.range];
        }
    }
    return text;

}

// 拿到表情的 图片的代替字符和 图片名字
+(NSDictionary*)getFaceNameMap
{
    static NSDictionary *dic = nil;
    NSMutableDictionary *faceName = [[NSMutableDictionary alloc]init];
    if(!dic) {
        NSString* path=[[NSBundle mainBundle] pathForResource:@"faceMap_ch" ofType:@"plist"];
        dic =[NSDictionary dictionaryWithContentsOfFile:path];
    }
    for (NSString *key in dic.allKeys) {
        [faceName setValue:key forKey:[dic objectForKey:key]];
    }
    return faceName;
}

+ (NSRegularExpression *)regularWebUrl
{
    static NSRegularExpression *regularExpression;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        regularExpression = [NSRegularExpression regularExpressionWithPattern:@"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)"
                                                                      options:NSRegularExpressionDotMatchesLineSeparators | NSRegularExpressionCaseInsensitive
                                                                        error:nil];
    });
    return regularExpression;
}

+ (NSRegularExpression *)regularMobileNumber
{
    static NSRegularExpression *regularExpression;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        regularExpression = [NSRegularExpression regularExpressionWithPattern:@"((\\+86)|(86))?(13[0-9]|15[0-9]|18[0-9])\\d{8}"
                                                                      options:NSRegularExpressionDotMatchesLineSeparators | NSRegularExpressionCaseInsensitive
                                                                        error:nil];
    });
    return regularExpression;
}

+ (NSRegularExpression *)regularPhoneNumber
{
    static NSRegularExpression *regularPhone;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        regularPhone = [NSRegularExpression regularExpressionWithPattern:@"(\\(0\\d{2,3}\\)|0\\d{2,3}-|\\s)?[2-9]\\d{6,7}"
                                                                 options:NSRegularExpressionDotMatchesLineSeparators | NSRegularExpressionCaseInsensitive
                                                                   error:nil];
    });
    return regularPhone;
}

+ (NSRegularExpression *)regularEmotion
{
    static NSRegularExpression *regularEmotion;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        regularEmotion = [NSRegularExpression regularExpressionWithPattern:@"\\[[^\\[\\]\\s]+\\]"
                                                                   options:NSRegularExpressionDotMatchesLineSeparators | NSRegularExpressionCaseInsensitive
                                                                     error:nil];
    });
    return regularEmotion;
}

#pragma mark - 处理点击高亮文字的回调

+ (void)handleWebUrl:(NSString *)webUrl
{
    if (!webUrl) return;
    
//    MCSafariViewController *vc = [[MCSafariViewController alloc] init];
//    vc.url = webUrl;
//    [_applicationContext.navigationController pushViewController:vc animated:YES];
}

+ (void)handleTelPhone:(NSString *)telString
{
//    if (!telString) return;
//    
//    MCActionSheet *sheet = [MCActionSheet initWithTitle:[NSString stringWithFormat:@"%@ 可能是个电话号, 您可以:", telString] cancelButtonTitle:@"取消" otherButtonTitles:@"拨打", @"复制该电话号", nil];
//    [sheet showWithCompletionBlock:^(NSInteger buttonIndex) {
//        if (!buttonIndex) {
//            NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",telString]];
//            static UIWebView *phoneCallWebView;
//            if ( !phoneCallWebView ) {
//                phoneCallWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
//            }
//            [phoneCallWebView loadRequest:[NSURLRequest requestWithURL:phoneURL]];
//        }
//        else if (buttonIndex == 1) {
//            [[UIPasteboard generalPasteboard] setString:telString];
//            [MCTipView showIconWithTip:@"复制成功!"];
//        }
//    }];
}

@end

#pragma mark - ConstString

NSString *const kWebUrlLink = @"kWebUrlLink";
NSString *const kTelNumber  = @"kTelNumber";
NSString *const kPhoneNumber = @"kPhoneNumber";

