//
//  AppDelegate.h
//  ZKIM
//
//  Created by ZK on 16/9/13.
//  Copyright © 2016年 ZK. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZKRootViewController, ZKNavigationController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) ZKRootViewController *rootViewController;
@property (nonatomic, strong) ZKNavigationController *rootNavigationController;

@end
