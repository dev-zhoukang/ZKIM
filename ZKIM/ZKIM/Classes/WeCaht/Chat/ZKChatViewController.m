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
#import "MJRefresh.h"

@interface ZKChatViewController () <UITableViewDelegate, UITableViewDataSource, ZKChatBarDelegate, EMChatManagerDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ZKChatBar   *chatBar;
@property (nonatomic, strong) NSMutableArray <ZKChatLayout *> *layouts;
@property (nonatomic, copy) NSString *lastMsgID;

@end

@implementation ZKChatViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _layouts = [[NSMutableArray alloc] init];
    _lastMsgID = nil;
    
    [[EMClient sharedClient].chatManager addDelegate:self];
    [self setupUI];
    
    [self requestData];
    
    __weak typeof(self) weakSelf = self;
    
    _tableView.mj_header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
        [weakSelf requestData];
    }];
}

- (void)requestData
{
    EMConversation *conversation = [[EMClient sharedClient].chatManager getConversation:@"6001" type:EMConversationTypeChat createIfNotExist:YES];
    
    if (_layouts) {
        ZKChatLayout *layout = _layouts.firstObject;
        EMMessage *lastMsg = layout.message;
        _lastMsgID = lastMsg.messageId;
    }
    
    @weakify(self)
    
    [conversation loadMessagesStartFromId:_lastMsgID count:10 searchDirection:EMMessageSearchDirectionUp completion:^(NSArray *aMessages, EMError *aError) {
        
        if (aError) {
            DLog(@"获取聊天数据失败 -- %@", aError);
            [weak_self.tableView.mj_header endRefreshing];
            return;
        }
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            NSMutableArray *tempArray = [[NSMutableArray alloc] init];
            
            for (EMMessage *message in aMessages) {
                ZKChatLayout *layout = [[ZKChatLayout alloc] initWithEMMessage:message];
                [tempArray addObject:layout];
            }
            
            NSRange indexsRange = NSMakeRange(0, tempArray.count);
            [_layouts insertObjects:tempArray atIndexes:[NSIndexSet indexSetWithIndexesInRange:indexsRange]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [weak_self.tableView.mj_header endRefreshing];
                [_tableView reloadData];
            });
        });
    }];
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

#pragma mark - <EMChatManagerDelegate>

- (void)messagesDidReceive:(NSArray *)aMessages
{
    [self parseMessages:aMessages];
}

- (void)parseMessages:(NSArray *)messages
{
    for (EMMessage *message in messages) {
        EMMessageBody *body = message.body;
        switch (body.type) {
            case EMMessageBodyTypeText: {
                EMTextMessageBody *textBody = (EMTextMessageBody *)body;
                NSString *text = textBody.text;
                DLog(@"文字消息 -- %@", text);
                
            } break;
            case EMMessageBodyTypeImage: {
                
            } break;
            case EMMessageBodyTypeLocation: {
                
            } break;
            case EMMessageBodyTypeVoice: {
                
            } break;
            case EMMessageBodyTypeVideo: {
                
            } break;
            case EMMessageBodyTypeFile: {
                
            } break;
                
            default: break;
        }
    }
}

@end
