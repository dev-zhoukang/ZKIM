//
//  ZKContactViewController.m
//  ZKIM
//
//  Created by ZK on 16/9/18.
//  Copyright © 2016年 ZK. All rights reserved.
//

#import "ZKContactViewController.h"
#import "ZKContactCell.h"

@interface ZKContactViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

static NSString *kCellIdentify = @"ZKContactCell";

@implementation ZKContactViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initProperty];
    
    [self setupTableView];
    
    [self requestData];
}

- (void)initProperty
{
    _dataSource = [[NSMutableArray alloc] init];
}

- (void)setupTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _topInset, SCREEN_WIDTH, SCREEN_HEIGHT-_topInset) style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    _tableView.backgroundColor = GlobalBGColor;
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    _tableView.rowHeight = 55.f;
}

- (void)requestData
{
    NSArray *users_db = [[EMClient sharedClient].contactManager getContacts];
    if (users_db) {
        _dataSource = users_db.copy;
        [_tableView reloadData];
    }
    
    EMError *error = nil;
    NSArray *users_net = [[EMClient sharedClient].contactManager getContactsFromServerWithError:&error];
    if (!error) {
        DLog(@"获取好友列表成功! -- %@", users_net);
        _dataSource = users_net.copy;
        [_tableView reloadData];
    }
    else {
        DLog(@"获取好友列表失败! -- %@", error.errorDescription);
    }
}

#pragma mark - <UITableViewDelegate, UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZKContactCell *cell = [ZKContactCell cellWithTableView:tableView];
    cell.name = _dataSource[indexPath.item];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
