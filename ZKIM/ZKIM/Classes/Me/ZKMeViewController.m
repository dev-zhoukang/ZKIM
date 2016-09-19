//
//  ZKMeViewController.m
//  ZKIM
//
//  Created by ZK on 16/9/18.
//  Copyright © 2016年 ZK. All rights reserved.
//

#import "ZKMeViewController.h"
#import "ZKMeTableCell.h"

@interface ZKMeViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray <NSArray *> *dataSource;

@end

@implementation ZKMeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _tableView.sectionIndexColor = [UIColor lightGrayColor];
    _tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    _tableView.sectionIndexTrackingBackgroundColor = [UIColor clearColor];
    _tableView.backgroundColor = GlobalBGColor;
}

#pragma mark - <UITableViewDelegate, UITableViewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    DLog(@"=====%zd", self.dataSource.count);
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
    return footer;
}

#pragma mark - Getter

- (NSArray<NSArray *> *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Me_Plist" ofType:@"plist"]];
    }
    return _dataSource;
}

@end
