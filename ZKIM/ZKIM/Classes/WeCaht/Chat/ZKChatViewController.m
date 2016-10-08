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
#import "ZKChatLayout.h"

@interface ZKChatViewController () <UITableViewDelegate, UITableViewDataSource, ZKChatBarDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ZKChatBar   *chatBar;
@property (nonatomic, strong) NSMutableArray <ZKChatLayout *> *layouts;

@end

@implementation ZKChatViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _layouts = [[NSMutableArray alloc] init];
    
    [self requestData];
    
    [self setupUI];
}

- (void)requestData
{
    EMConversation *conversation = [[EMClient sharedClient].chatManager getConversation:@"6001" type:EMConversationTypeChat createIfNotExist:YES];
    
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSArray *testData = @[
                              @{@"content":@"哈哈哈哈哈哈这是什么?", @"isMine":@0},
                              @{@"content":@"我也不知道啊!", @"isMine":@1},
                              @{@"content":@"那你为什么发这个东西? 我真的一点都不明白. 对了, 想问你一件事, 我想了好久差点忘了, 你十一放假去干嘛?", @"isMine":@0},
                              @{@"content":@"十一我没有事情做, 就在家歇着吧, 到时候来找我来一起看电影哈!", @"isMine":@1},
                              @{@"content":@"好的, 正想问你呢, 好的, 不见不散!", @"isMine":@0},
                              @{@"content":@"到时候你看看能不能借我一些钱呀, 好久都没有看见过钱长什么样了, 真的特别需要钱, 帮帮忙吧, 还有一件事, 就是...", @"isMine":@0},
                              @{@"content":@"还有什么, 请说", @"isMine":@1},
                              @{@"content":@"算了, 给你讲个笑话吧, 你们用盗版的时候有想过做出这款软件的程序员吗？他们该如何养家糊口？ -- 哈哈哈，别逗了，程序员哪有家要养啊! ", @"isMine":@0},
                              @{@"content":@"哈哈哈哈还好吧这个还是比较不错的哦继续将讲一个笑话, 我就告诉你", @"isMine":@1},
                              ];
        for (NSDictionary *entity in testData) {
            ZKChatLayout *layout = [[ZKChatLayout alloc] initWithChatEntity:entity];
            [_layouts addObject:layout];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [_tableView reloadData];
        });
    });
}

- (void)setupUI
{
    self.title = @"聊天详情";
    
    _tableView = [[UITableView alloc]
                  initWithFrame:(CGRect){0, _topInset, SCREEN_WIDTH, SCREEN_HEIGHT-_topInset-_bottomInset} style:UITableViewStylePlain];
    _tableView.backgroundColor = GlobalChatBGColor;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.alwaysBounceVertical = YES;
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    _chatBar = [ZKChatBar chatBar];
    _chatBar.delegate = self;
    _chatBar.left = 0;
    _chatBar.bottom = SCREEN_HEIGHT;
    [self.view addSubview:_chatBar];
}

#pragma mark - <UITableViewDelegate, UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _layouts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZKChatCell *cell = [ZKChatCell cellWithTableView:tableView type:ZKChatCellTypeText];
    cell.cellLayout = _layouts[indexPath.item];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = _layouts[indexPath.item].height;
    return height + 20 + 20;
}

#pragma mark - <ZKChatBarDelegate>

- (void)charBar:(ZKChatBar *)chatBar sendText:(NSString *)content
{
    DLog(@"发送消息===%@", content);
    
    EMMessage *message = [self generateMessageWithText:content];
    
    [[EMClient sharedClient].chatManager sendMessage:message progress:nil completion:^(EMMessage *message, EMError *error) {
        DLog(@"文字消息发送成功!");
    }];
}

/*! 构造消息 */
- (EMMessage *)generateMessageWithText:(NSString *)text
{
    EMTextMessageBody *body = [[EMTextMessageBody alloc] initWithText:text];
    NSString *from = [[EMClient sharedClient] currentUsername];
    
    EMMessage *message = [[EMMessage alloc] initWithConversationID:@"6001" from:from to:@"11" body:body ext:nil];
    message.chatType = EMChatTypeChat;
    
    return message;
}

@end
