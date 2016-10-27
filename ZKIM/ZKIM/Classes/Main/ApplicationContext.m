//
//  ApplicationContext.m
//  USEvent
//
//  Created by marujun on 15/9/14.
//  Copyright (c) 2015年 MaRuJun. All rights reserved.
//

#import "ApplicationContext.h"
#import "AppDelegate.h"

@interface ApplicationContext ()
{
    UINavigationController *_presentNavigationController;
    UIViewController *_presentedViewController;
}

@end

@implementation ApplicationContext

+ (instancetype)sharedContext
{
    static ApplicationContext *sharedContext = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedContext = [[self alloc] init];
    });
    return sharedContext;
}

- (CGFloat)height
{
    return self.rootViewController.view.frame.size.height;
}

- (ZKRootViewController *)rootViewController
{
    return [(AppDelegate *)[[UIApplication sharedApplication] delegate] rootViewController];
}

- (UINavigationController *)navigationController
{
    //return self.rootViewController.rootNavigationController;
    return nil;
}

- (ZKHomeViewController *)homeViewController
{
    return (ZKHomeViewController *)self.navigationController.viewControllers.firstObject;
}

- (void)presentNavigationController:(UIViewController *)viewController animated:(BOOL)animated completion:(void (^)(void))completion
{
    if(_presentNavigationController){
        [self removePresentController:_presentNavigationController];
    }
    
    _presentNavigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    [_presentNavigationController setNavigationBarHidden:true animated:false];
    
    [self.rootViewController.view addSubview:_presentNavigationController.view];
    [self.rootViewController addChildViewController:_presentNavigationController];
    [_presentNavigationController.view autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    
    if(animated){
        CGFloat viewHeight = _presentNavigationController.view.bounds.size.height;
        [_presentNavigationController.view autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:viewHeight];
        [_presentNavigationController.view autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:-viewHeight];
        [self.rootViewController.view layoutIfNeeded];
        
        [self animations:^{
            [_presentNavigationController.view autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0];
            [_presentNavigationController.view autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
            [self.rootViewController.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            !completion?:completion();
        }];
    }
    else {
        !completion?:completion();
    }
}

- (void)removePresentController:(UIViewController *)viewController
{
    [viewController.view removeFromSuperview];
    [viewController removeFromParentViewController];
    
    viewController = nil;
}

- (void)dismissNavigationControllerAnimated:(BOOL)animated completion:(void (^)(void))completion
{
    if (!animated) {
        [self removePresentController:_presentNavigationController];
        if (completion) completion();
        return;
    }
    
    CGFloat viewHeight = _presentNavigationController.view.bounds.size.height;
    [self animations:^{
        [_presentNavigationController.view autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:viewHeight];
        [_presentNavigationController.view autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:-viewHeight];
        [self.rootViewController.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self removePresentController:_presentNavigationController];
        !completion?:completion();
    }];
}

#pragma mark - 

- (void)presentViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(void(^)())completion
{
    if(_presentedViewController){
        [self removePresentController:_presentedViewController];
    }
    
    _presentedViewController = viewController;
    
    [self.rootViewController.view addSubview:viewController.view];
    [self.rootViewController addChildViewController:viewController];
    [viewController.view autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    
    if(animated){
        CGFloat viewHeight = viewController.view.bounds.size.height;
        [viewController.view autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:viewHeight];
        [viewController.view autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:-viewHeight];
        [self.rootViewController.view layoutIfNeeded];
        
        [self animations:^{
            [viewController.view autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0];
            [viewController.view autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
            [self.rootViewController.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            !completion?:completion();
        }];
    }
    else {
        !completion?:completion();
    }
}

- (void)dismissViewControllerAnimated:(BOOL)animated completion:(void (^)())completion
{
    if (!animated) {
        [self removePresentController:_presentedViewController];
        if (completion) completion();
        return;
    }
    
    CGFloat viewHeight = _presentedViewController.view.bounds.size.height;
    
    [self animations:^{
        [_presentedViewController.view autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:viewHeight];
        [_presentedViewController.view autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:-viewHeight];
        [self.rootViewController.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self removePresentController:_presentedViewController];
        !completion?:completion();
    }];
}

#pragma mark - Private

- (void)animations:(void(^)())animations completion:(void(^)(BOOL finished))completion
{
    [UIView animateWithDuration:0.5
                          delay:0.f
         usingSpringWithDamping:1.f
          initialSpringVelocity:1.f
                        options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState
                     animations:animations
                     completion:completion];
}

@end
