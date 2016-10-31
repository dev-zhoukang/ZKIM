//
//  ZKConfig.h
//  ZKIM
//
//  Created by ZK on 16/9/13.
//  Copyright © 2016年 ZK. All rights reserved.
//

#import <Foundation/Foundation.h>

#define _applicationContext [ApplicationContext sharedContext]
#define _loginUser          [AuthData loginUser]

#define RGBCOLOR(r,g,b)     [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1] //RGB进制颜色值
#define RGBACOLOR(r,g,b,a)  [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)] //RGBA进制颜色值
#define HexColor(hexValue)  [UIColor colorWithRed:((float)(((hexValue) & 0xFF0000) >> 16))/255.0 green:((float)(((hexValue) & 0xFF00) >> 8))/255.0 blue:((float)((hexValue) & 0xFF))/255.0 alpha:1]   //16进制颜色值，如：#000000 , 注意：在使用的时候hexValue写成：0x000000

#define GlobalGreenColor       RGBCOLOR(31.f, 185.f, 34.f)
#define GlobalBGColor          RGBCOLOR(239.f, 239.f, 245.f)
#define GlobalChatBGColor      RGBCOLOR(230.f, 230.f, 230.f)
#define ThemColor              HexColor(0x096096)

//通用色调的色值
#define KB_TINT_COLOR                       HexColor(0xbe9653)       /* 褐色 */
#define KB_TINT_HIGHLIGHT_COLOR             HexColor(0xbe9653)       /* 褐色，高亮效果 */
#define KP_TINT_COLOR                       HexColor(0xff72bb)       /* 粉红色 */
#define KP_TINT_HIGHLIGHT_COLOR             HexColor(0xeb5ea7)       /* 粉红色，高亮效果 */

#ifdef __OBJC__
#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define DLog(...)
#endif
#endif

#define FileManager   [NSFileManager defaultManager]

//自定义字体名称
#define FZLTHFontName     @"_GBK-"                     //方正兰亭黑_GBK
#define FZLTZHFontName    @"FZLTZHUNHK--GBK1-0"        //方正兰亭准黑_GBK

extern NSString *const kAppKey_EM;
extern NSString *const UserDefaultKey_LoginUser;
extern NSString *const UserDefaultKey_LoginResult;
extern NSString *const Notification_LoginSuccess;
extern NSString *const UserDefaultKey_timeDifference;



