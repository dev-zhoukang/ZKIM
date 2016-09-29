//
//  ZKChatViewController.m
//  ZKIM
//
//  Created by ZK on 16/9/20.
//  Copyright © 2016年 ZK. All rights reserved.
//

#import "ZKChatViewController.h"
#import "ZKChatBar.h"
#import "ZKChatCell.h"

@interface ZKChatViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ZKChatBar   *chatBar;
@property (nonatomic, strong) NSArray *dataSource;

@end

@implementation ZKChatViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupUI];
}

- (void)setupUI
{
    self.title = @"聊天详情";
    
    _tableView = [[UITableView alloc]
                  initWithFrame:(CGRect){0, _topInset, SCREEN_WIDTH, SCREEN_HEIGHT} style:UITableViewStylePlain];
    _tableView.backgroundColor = GlobalChatBGColor;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_tableView];
    
    _chatBar = [ZKChatBar chatBar];
    _chatBar.left = 0;
    _chatBar.bottom = SCREEN_HEIGHT;
    [self.view addSubview:_chatBar];
    
    UIControl *control = [[UIControl alloc] initWithFrame:self.view.bounds];
    [self.view insertSubview:control belowSubview:_chatBar];
    [control addTarget:self action:@selector(didTapView) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - <UITableViewDelegate, UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZKChatCell *cell = [ZKChatCell cellWithTableView:tableView type:ZKChatCellTypeText];
    [cell updateCellWithInfo:self.dataSource[indexPath.item]];
    return cell;
}

#pragma mark - Getter

- (NSArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = @[
                        @{@"content":@"哈哈哈哈哈哈这是什么?", @"isMine":@0},
                        @{@"content":@"我也不知道啊!", @"isMine":@1},
                        @{@"content":@"那你为什么发这个东西? 我真的一点都不明白. 对了, 想问你一件事, 我想了好久差点忘了, 你十一放假去干嘛?", @"isMine":@0},
                        @{@"content":@"十一我没有事情做, 就在家歇着吧, 到时候来找我来看电影哈!", @"isMine":@1},
                        @{@"content":@"好的, 正想问你呢, 好的, 不见不散!", @"isMine":@0}
                        ];
    }
    return _dataSource;
}

#pragma mark - Actions

- (void)didTapView
{
    [KeyWindow endEditing:YES];
}

@end
