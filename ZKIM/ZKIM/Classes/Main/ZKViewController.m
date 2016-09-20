//
//  ZKViewController.m
//  ZKIM
//
//  Created by ZK on 16/9/20.
//  Copyright © 2016年 ZK. All rights reserved.
//

#import "ZKViewController.h"

@interface ZKViewController ()
@property(nonatomic, strong) UINavigationItem *myNavigationItem;
@end

@implementation ZKViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.clipsToBounds = YES;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.navigationBar.clipsToBounds = YES;
    self.navigationBar.translucent = NO;
    self.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"bg_nav"] forBarMetrics:UIBarMetricsDefault];
    
    NSShadow *shadow = [NSShadow new];
    NSDictionary *dict = @{NSShadowAttributeName:shadow,
                           NSFontAttributeName:[UIFont boldSystemFontOfSize:19.f],
                           NSForegroundColorAttributeName:[UIColor whiteColor]};
    self.navigationBar.titleTextAttributes = dict;
    
    if (self.navigationController) {
        self.navigationController.navigationBar.clipsToBounds = YES;
        self.navigationController.navigationBar.translucent = NO;
        self.navigationController.navigationBar.titleTextAttributes = dict;
        self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
        [self.navigationController.navigationBar setTitleVerticalPositionAdjustment:-2 forBarMetrics:UIBarMetricsDefault];
    }
    
    [self.view addSubview:self.navigationBar];
    [self.navigationBar pushNavigationItem:self.myNavigationItem animated:NO];
    [self.navigationBar autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
}

- (void)setup
{
    _topInset = 64.f;
    self.navigationBar = [[UINavigationBar alloc] initForAutoLayout];
    [self.navigationBar autoSetDimension:ALDimensionHeight toSize:_topInset];
    
    self.myNavigationItem = [[UINavigationItem alloc] initWithTitle:@""];
    [self.navigationBar setTitleVerticalPositionAdjustment:-2.f forBarMetrics:UIBarMetricsDefault];
    DLog(@"init 创建类 %@", NSStringFromClass([self class]));
}

#pragma mark - Setter

- (void)setTitle:(NSString *)title
{
    self.myNavigationItem.title = title;
    
    [super setTitle:title];
}

- (void)dealloc
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    DLog(@"dealloc 释放类 %@",  NSStringFromClass([self class]));
}

//---------------------- 以下代码是设置导航栏 -----------------------

- (NSString *)backuptitle
{
    NSArray *vcs = [self.navigationController viewControllers];
    
    NSString *title = nil;
    if (vcs && vcs.count > 1) {
        ZKViewController *vc = (ZKViewController *)vcs[vcs.count-2];
        if ([vc respondsToSelector:@selector(hint)] && vc.hint) {
            title = vc.hint;
        } else {
            title = vc.title;
        }
    }
    if (!title) title = @"返回";
    
    return title;
}

- (void)setNavigationBackButtonDefault
{
    /**
     NSString *title = nil;
     NSArray *array = self.navigationController.viewControllers;
     if (array && array.count >= 2) {
         title = [array[array.count-2] title];
     }
     [self setNavBackButtonWithTitle:title];
     */
    
    [self setNavBackButtonWithTitle:nil];
}

- (void)setNavBackButtonWithTitle:(NSString *)title
{
    UIButton *backButton = [self newBackArrowNavButtonWithTarget:self action:nil];
    
    if (!title || !title.length) {
        title = @"";
    }
    [backButton setTitle:title forState:UIControlStateNormal];
    
    float width = [title stringWidthWithFont:backButton.titleLabel.font height:44];
    backButton.frame = CGRectMake(0, 0, MAX(MIN(width, 60)+20, 44), 44);
    
    [self setNavigationBackButton:backButton];
    [backButton setExclusiveTouch:YES];
}

- (UIButton *)newBackArrowNavButtonWithTarget:(id)target action:(SEL)action
{
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 46, 44)];
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [rightButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [rightButton setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [rightButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 4, 0, 0)];
    [rightButton setContentEdgeInsets:UIEdgeInsetsMake(0, 0, 5, 0)];
    
    [rightButton setImage:[UIImage imageNamed:(@"pub_nav_back.png")] forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    if (action && target) {
        [rightButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    return rightButton;
}

- (void)setNavigationBackButton:(UIButton *)button
{
    [button addTarget:self action:@selector(navigationBackButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self setNavigationLeftView:button];
}

- (void)navigationBackButtonAction:(UIButton *)sender
{
    if (self.navigationController.viewControllers.count == 1) {
        [_applicationContext dismissNavigationControllerAnimated:YES completion:nil];
    }
    else if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)setNavigationLeftView:(UIView *)view
{
    [self setupNavigationRightLeftView:view isLeftView:YES];
}

- (void)setNavigationRightView:(UIView *)view
{
    [self setupNavigationRightLeftView:view isLeftView:NO];
}

/** 创建导航栏的左右视图, 左或右 */
- (void)setupNavigationRightLeftView:(UIView *)view isLeftView:(BOOL)isLeftView
{
    if ([view isKindOfClass:[UIButton class]]) {
        [(UIButton *)view setContentHorizontalAlignment:isLeftView
                                                                 ? UIControlContentHorizontalAlignmentLeft
                                                                 : UIControlContentHorizontalAlignmentRight];
    }
    
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:view];
    
    // 调整 BarButtonItem 的位置
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = 0;  //移动0个像素
    
    if (isLeftView) {
        if ([self respondsToSelector:@selector(myNavigationItem)] && ((ZKViewController *)self).myNavigationItem) {
            ((ZKViewController *)self).myNavigationItem.leftBarButtonItems = @[negativeSpacer, buttonItem];
        }else{
            self.navigationItem.leftBarButtonItems = @[negativeSpacer, buttonItem];
        }
    }
    else {
        if ([self respondsToSelector:@selector(myNavigationItem)] && ((ZKViewController *)self).myNavigationItem) {
            ((ZKViewController *)self).myNavigationItem.rightBarButtonItems = @[negativeSpacer, buttonItem];
        }
        else{
            self.navigationItem.rightBarButtonItems = @[negativeSpacer, buttonItem];
        }
    }
}

- (void)setNavigationRightViews:(NSArray *)views
{
    UIView *parentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    parentView.backgroundColor = [UIColor clearColor];
    parentView.clipsToBounds = YES;
    
    [self setNavigationRightView:parentView];
    
    UIView *view1 = [views objectAtIndex:0];
    UIView *view2 = [views objectAtIndex:1];
    [parentView addSubview:view1];
    [parentView addSubview:view2];
    
    CGRect parentFrame = parentView.frame;
    CGRect view1Frame = view1.frame;
    CGRect view2Frame = view1.frame;
    
    view2Frame.origin.x = parentFrame.size.width-view2Frame.size.width;
    view2Frame.origin.y = (parentFrame.size.height-view2Frame.size.height)/2;
    view1Frame.origin.x = view2Frame.origin.x-view1Frame.size.width;
    view1Frame.origin.y = view2Frame.origin.y;
    
    view1.frame = view1Frame;
    view2.frame = view2Frame;
}

- (void)setNavigationTitleView:(UIView *)view
{
    if ([self respondsToSelector:@selector(myNavigationItem)] && ((ZKViewController *)self).myNavigationItem) {
        ((ZKViewController *)self).myNavigationItem.titleView = view;
    }
    else{
        self.navigationItem.titleView = view;
    }
}


@end
