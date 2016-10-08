//
//  ZKRegularTool.h
//  ZKIM
//
//  Created by ZK on 16/9/29.
//  Copyright © 2016年 ZK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZKRegularTool : NSObject
/** 将 string 匹配正则, 高亮显示 */
+ (NSMutableAttributedString *)matchAttributedText:(NSMutableAttributedString *)attributedString isMine:(BOOL)isMine;

/** 网址正则 如: www.hoolai.com */
+ (NSRegularExpression *)regularWebUrl;

/** 手机号码正则 如: 18613375661 */
+ (NSRegularExpression *)regularMobileNumber;

/** 座机正则 如: 76547623 */
+ (NSRegularExpression *)regularPhoneNumber;

/** 表情正则 如: [害羞] */
+ (NSRegularExpression *)regularEmotion;

//-------处理点击电话等高亮文字点击回调-------

+ (void)handleWebUrl:(NSString *)webUrl;
+ (void)handleTelPhone:(NSString *)telString;

@end

#pragma mark - Config

extern NSString *const kWebUrlLink;
extern NSString *const kTelNumber;
extern NSString *const kPhoneNumber;

