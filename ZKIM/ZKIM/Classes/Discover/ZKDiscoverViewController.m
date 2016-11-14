//
//  ZKDiscoverViewController.m
//  ZKIM
//
//  Created by ZK on 16/9/18.
//  Copyright © 2016年 ZK. All rights reserved.
//

#import "ZKDiscoverViewController.h"
#import "ZKMeTableCell.h"

@interface ZKDiscoverViewController ()

@end

@implementation ZKDiscoverViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:NSStringFromClass([self.superclass class]) bundle:nibBundleOrNil];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.dataSource = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Discover_Plist" ofType:@"plist"]];
    [self.tableView reloadData];
}

@end
