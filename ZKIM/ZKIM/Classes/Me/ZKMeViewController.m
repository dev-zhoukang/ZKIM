//
//  ZKMeViewController.m
//  ZKIM
//
//  Created by ZK on 16/11/14.
//  Copyright © 2016年 ZK. All rights reserved.
//

#import "ZKMeViewController.h"
#import "ZKProfileHeader.h"

@interface ZKMeViewController ()

@end

@implementation ZKMeViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:NSStringFromClass([self.superclass class]) bundle:nibBundleOrNil];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIView *headerContainer = [UIView new];
    headerContainer.size = (CGSize){SCREEN_WIDTH, 86.f+22.f};
    
    ZKProfileHeader *header = [ZKProfileHeader header];
    [headerContainer addSubview:header];
    header.frame = headerContainer.bounds;
    
    self.tableView.tableHeaderView = headerContainer;
    
    self.dataSource = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Me_Plist" ofType:@"plist"]];
    [self.tableView reloadData];
}

@end
