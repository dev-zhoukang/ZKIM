//
//  ZKLoginViewController.h
//  ZKIM
//
//  Created by ZK on 16/9/14.
//  Copyright © 2016年 ZK. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ZKLoginType) {
    ZKLoginTypeLogin,
    ZKLoginTypeRegister
};

@interface ZKLoginViewController : ZKViewController

@property (nonatomic, assign) ZKLoginType loginType;

@end
