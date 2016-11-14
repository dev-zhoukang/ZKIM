//
//  ZKMeBaseViewController.m
//  ZKIM
//
//  Created by ZK on 16/9/18.
//  Copyright © 2016年 ZK. All rights reserved.
//

#import "ZKMeBaseViewController.h"
#import "ZKMeTableCell.h"
#import "MJRefresh.h"
#import "ZKTestViewController.h"

@interface ZKMeBaseViewController () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation ZKMeBaseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupTableView];
}

- (void)setupTableView
{
    _tableView.sectionIndexColor = [UIColor clearColor];
    _tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    _tableView.sectionIndexTrackingBackgroundColor = [UIColor clearColor];
    _tableView.backgroundColor = GlobalBGColor;
    _tableView.contentInset = UIEdgeInsetsMake(_topInset+15.f, 0, _bottomInset, 0);
    _tableView.separatorColor = HexColor(0xdcdcdc);
    _tableView.separatorInset = UIEdgeInsetsZero;
}

#pragma mark - <UITableViewDelegate, UITableViewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZKMeTableCell *cell = [ZKMeTableCell cellWithTableView:tableView];
    cell.dataInfo = self.dataSource[indexPath.section][indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 22.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footer = [[UIView alloc] init];
    footer.backgroundColor = [UIColor clearColor];
    footer.size = (CGSize){SCREEN_WIDTH, 22.f};
    
    UIView *topLine = [UIView new];
    [footer addSubview:topLine];
    topLine.backgroundColor = HexColor(0xdcdcdc);
    topLine.size = (CGSize){SCREEN_WIDTH, 1.f/[UIScreen mainScreen].scale};
    
    UIView *bottomLine = [UIView new];
    [footer addSubview:bottomLine];
    bottomLine.backgroundColor = section==self.dataSource.count-1 ? [UIColor clearColor] : HexColor(0xdcdcdc);
    bottomLine.size = topLine.size;
    bottomLine.bottom = footer.height;
    
    return footer;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ZKTestViewController *testVC = [[ZKTestViewController alloc] init];
    [self.navigationController pushViewController:testVC animated:YES];
}

@end
