//
//  ZKHomeViewController.m
//  ZKIM
//
//  Created by ZK on 16/9/13.
//  Copyright © 2016年 ZK. All rights reserved.
//

#import "ZKHomeViewController.h"
#import "ZKWeChatListViewController.h"
#import "ZKContactViewController.h"
#import "ZKDiscoverViewController.h"
#import "ZKMeViewController.h"
#import "ZKNavigationController.h"

@interface ZKHomeViewController ()

@property (weak, nonatomic) IBOutlet UIView *tabView;
@property (strong, nonatomic) IBOutletCollection(ZKHVButton) NSArray *tabBtns;
@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (nonatomic, strong) ZKHVButton *selectedBtn;
@property (nonatomic, strong) NSArray <UIViewController *> *viewControllers;

@end

@implementation ZKHomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupUI];
    self.pageIndex = 0;
}

- (void)setupUI
{
    [self setupTabBtn];
    [self setupPageViewController];
}

- (void)setupPageViewController
{
    _pageViewController = [[UIPageViewController alloc]
                           initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:@{UIPageViewControllerOptionInterPageSpacingKey:@0.f}];
    _pageViewController.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.view insertSubview:_pageViewController.view belowSubview:_tabView];
    [self addChildViewController:_pageViewController];
    
    [_pageViewController.view autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
    [_pageViewController.view autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:_tabView withOffset:0];
}

- (void)setupTabBtn
{
    NSArray *imageNames = @[@"tabbar_mainframe", @"tabbar_contacts", @"tabbar_discover", @"tabbar_me"];
    NSArray *titles = @[@"微信", @"通讯录", @"发现", @"我"];
    
    for (int i = 0; i < imageNames.count; i ++) {
        [self setupTabBtn:_tabBtns[i]
                withTitle:titles[i]
          normalImageName:imageNames[i]
        selectedImageName:[NSString stringWithFormat:@"%@HL", imageNames[i]]];
    }
}

- (void)setupTabBtn:(ZKHVButton *)btn withTitle:(NSString *)title normalImageName:(NSString *)normalImageName selectedImageName:(NSString *)selectedImageName
{
    btn.backgroundColor = [UIColor clearColor];
    [btn setImage:[UIImage imageNamed:normalImageName] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:selectedImageName] forState:UIControlStateSelected];
    
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [btn setTitleColor:GlobalGreenColor forState:UIControlStateSelected];
    btn.titleLabel.font = [UIFont systemFontOfSize:11.f];
}

#pragma mark - Actions

- (IBAction)tabBtnClick:(ZKHVButton *)btn
{
    self.pageIndex = btn.tag;
}

#pragma mark - Setter

- (void)setPageIndex:(NSInteger)pageIndex
{
    _pageIndex = pageIndex;
    NSInteger count = self.viewControllers.count;
    if (pageIndex<0 || pageIndex >= count) {
        DLog(@"pageIndex不合法");
        return;
    }
    [_pageViewController setViewControllers:@[self.viewControllers[pageIndex]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    [self.tabBtns enumerateObjectsUsingBlock:^(ZKHVButton *button, NSUInteger idx, BOOL * _Nonnull stop) {
        button.selected = button.tag == pageIndex;
        button.userInteractionEnabled = !button.selected;
    }];
}

#pragma mark - Getter

- (NSArray<UIViewController *> *)viewControllers
{
    if (!_viewControllers) {
        _viewControllers = @[
                             [self VCWithClass:[ZKWeChatListViewController class] title:@"微信"],
                             [self VCWithClass:[ZKContactViewController class] title:@"通讯录"],
                             [self VCWithClass:[ZKDiscoverViewController class] title:@"发现"],
                             [self VCWithClass:[ZKMeViewController class] title:@"我"]
                             ];
    }
    return _viewControllers;
}

- (UIViewController *)VCWithClass:(Class)class title:(NSString *)title
{
    UIViewController *viewController = [[class alloc] init];
    viewController.title = title;
    return viewController;
}

@end
