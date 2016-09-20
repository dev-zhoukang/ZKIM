//
//  ZKWeChatViewController.m
//  ZKIM
//
//  Created by ZK on 16/9/18.
//  Copyright © 2016年 ZK. All rights reserved.
//

#import "ZKWeChatViewController.h"
#import "ZKWeChatCell.h"

@interface ZKWeChatViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *dataSource;

@end

@implementation ZKWeChatViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    _tableView.rowHeight = 67.f;
    _tableView.tableFooterView = [[UIView alloc] init];
}

#pragma mark - <UITableViewDelegate, UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZKWeChatCell *cell = [ZKWeChatCell cellWithTableView:tableView];
    cell.dataInfo = self.dataSource[indexPath.item];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Getter

// 测试数据, 见谅
- (NSArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = @[
                        @{@"nick":@"周杰伦", @"avatar":@"bla"},
                        @{@"nick":@"周杰伦", @"avatar":@"bla"},
                        @{@"nick":@"周杰伦", @"avatar":@"bla"},
                        @{@"nick":@"周杰伦", @"avatar":@"bla"},
                        @{@"nick":@"周杰伦", @"avatar":@"bla"},
                        @{@"nick":@"周杰伦", @"avatar":@"bla"},
                        @{@"nick":@"周杰伦", @"avatar":@"bla"},
                        @{@"nick":@"周杰伦", @"avatar":@"bla"},
                        @{@"nick":@"周杰伦", @"avatar":@"bla"},
                        @{@"nick":@"周杰伦", @"avatar":@"bla"},
                        @{@"nick":@"周杰伦", @"avatar":@"bla"},
                        @{@"nick":@"周杰伦", @"avatar":@"bla"},
                        @{@"nick":@"周杰伦", @"avatar":@"bla"},
                        @{@"nick":@"周杰伦", @"avatar":@"bla"},
                        @{@"nick":@"周杰伦", @"avatar":@"bla"},
                        @{@"nick":@"周杰伦", @"avatar":@"bla"},
                        @{@"nick":@"周杰伦", @"avatar":@"bla"},
                        @{@"nick":@"周杰伦", @"avatar":@"bla"},
                        @{@"nick":@"周杰伦", @"avatar":@"bla"},
                        @{@"nick":@"周杰伦", @"avatar":@"bla"},
                        @{@"nick":@"周杰伦", @"avatar":@"bla"},
                        @{@"nick":@"周杰伦", @"avatar":@"bla"},
                        @{@"nick":@"周杰伦", @"avatar":@"bla"},
                        @{@"nick":@"周杰伦", @"avatar":@"bla"},
                        @{@"nick":@"周杰伦", @"avatar":@"bla"},
                        @{@"nick":@"周杰伦", @"avatar":@"bla"},
                        @{@"nick":@"周杰伦", @"avatar":@"bla"},
                        @{@"nick":@"周杰伦", @"avatar":@"bla"},
                        @{@"nick":@"周杰伦", @"avatar":@"bla"},
                        @{@"nick":@"周杰伦", @"avatar":@"bla"},
                        @{@"nick":@"周杰伦", @"avatar":@"bla"},
                        @{@"nick":@"周杰伦", @"avatar":@"bla"},
                        @{@"nick":@"周杰伦", @"avatar":@"bla"},
                        @{@"nick":@"周杰伦", @"avatar":@"bla"},
                        @{@"nick":@"周杰伦", @"avatar":@"bla"},
                        @{@"nick":@"周杰伦", @"avatar":@"bla"},
                        @{@"nick":@"周杰伦", @"avatar":@"bla"},
                        @{@"nick":@"周杰伦", @"avatar":@"bla"},
                        @{@"nick":@"周杰伦", @"avatar":@"bla"},
                        @{@"nick":@"周杰伦", @"avatar":@"bla"},
                        @{@"nick":@"周杰伦", @"avatar":@"bla"},
                        @{@"nick":@"周杰伦", @"avatar":@"bla"},
                        @{@"nick":@"周杰伦", @"avatar":@"bla"},
                        @{@"nick":@"周杰伦", @"avatar":@"bla"},
                        @{@"nick":@"周杰伦", @"avatar":@"bla"}
                        ];
    }
    return _dataSource;
}

@end
