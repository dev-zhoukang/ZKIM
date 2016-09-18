
//
//  ZKNavigationController.m
//  ZKIM
//
//  Created by ZK on 16/9/18.
//  Copyright © 2016年 ZK. All rights reserved.
//

#import "ZKNavigationController.h"

@interface ZKNavigationController () <UIGestureRecognizerDelegate>

@end

@implementation ZKNavigationController

+ (void)initialize
{
    UINavigationBar *barAppearance = [UINavigationBar appearance];
    barAppearance.tintColor = [UIColor whiteColor];
    [barAppearance setBackgroundImage:[UIImage imageNamed:@"bg_nav"] forBarMetrics:UIBarMetricsDefault];
    barAppearance.barStyle = UIBarStyleBlack;
    
    NSMutableDictionary *barAttributes = [[NSMutableDictionary alloc] init];
    barAttributes[NSForegroundColorAttributeName] = [UIColor whiteColor];
    barAttributes[NSFontAttributeName] = [UIFont boldSystemFontOfSize:20.f];
    
    [barAppearance setTitleTextAttributes:barAttributes];
    
    UIBarButtonItem *itemAppearance = [UIBarButtonItem appearance];
    NSMutableDictionary *itemAttributes = [[NSMutableDictionary alloc] init];
    itemAttributes[NSForegroundColorAttributeName] = [UIColor whiteColor];
    itemAttributes[NSFontAttributeName] = [UIFont systemFontOfSize:17.f];
    itemAttributes[NSShadowAttributeName] = [NSValue valueWithUIOffset:UIOffsetZero];
    [itemAppearance setTitleTextAttributes:itemAttributes forState:UIControlStateNormal];
    [itemAppearance setTitleTextAttributes:itemAttributes forState:UIControlStateHighlighted];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.interactivePopGestureRecognizer.delegate = self;
}

#pragma mark - <UIGestureRecognizerDelegate>

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return self.childViewControllers.count > 1;
}

#pragma mark - Overwrite

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.childViewControllers.count > 0) {
        NSString *title = @"返回";
        if (self.childViewControllers.count == 1) {
            title = self.childViewControllers.firstObject.title;
        }
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

//- (UIViewController *)childViewControllerForStatusBarStyle
//{
//    return self.topViewController;
//}
//
//- (UIViewController *)childViewControllerForStatusBarHidden
//{
//    return self.topViewController;
//}

@end
