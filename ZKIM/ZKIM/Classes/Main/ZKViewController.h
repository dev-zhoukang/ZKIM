//
//  ZKViewController.h
//  ZKIM
//
//  Created by ZK on 16/9/20.
//  Copyright © 2016年 ZK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZKViewController : UIViewController
{
    CGFloat _topInset;
    CGFloat _bottomInset; //!< TabBar 高度
}

@property(nonatomic, strong) NSString *hint;
@property(nonatomic, assign) CGFloat topInset;

@property(nonatomic, strong) UINavigationBar *navigationBar;

//--------- 设置导航栏 -----------

- (NSString *)backuptitle;

// 设置回退按钮
- (void)setNavigationBackButton:(UIButton *)button;
- (void)setNavBackButtonWithTitle:(NSString *)title;

- (void)navigationBackButtonAction:(UIButton *)sender;

// 设置默认回退按钮
- (void)setNavigationBackButtonDefault;

// 为navigationbar设置左视图
- (void)setNavigationLeftView:(UIView *)view;

// 为navigationbar设置右视图
-(void)setNavigationRightView:(UIView *)view;

// 为navigationbar设置右视图集
- (void)setNavigationRightViews:(NSArray *)views;

// 为navigationbar设置标题视图
- (void)setNavigationTitleView:(UIView *)view;

@end
