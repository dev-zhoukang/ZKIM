//
//  ZKChatViewController.m
//  ZKIM
//
//  Created by ZK on 16/9/20.
//  Copyright © 2016年 ZK. All rights reserved.
//

#import "ZKChatViewController.h"
#import "ZKChatBar.h"

@interface ZKChatViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ZKChatBar   *chatBar;

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
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

#pragma mark - Actions

- (void)didTapView
{
    [KeyWindow endEditing:YES];
}

@end
