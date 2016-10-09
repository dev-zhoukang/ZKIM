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
#import "ZKChatRefreshHeader.h"

@interface ZKChatViewController () <UITableViewDelegate, UITableViewDataSource, ZKChatBarDelegate, EMChatManagerDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ZKChatBar   *chatBar;
@property (nonatomic, strong) NSMutableArray <ZKChatLayout *> *layouts;
@property (nonatomic, copy) NSString *lastMsgID;
@property (nonatomic, assign) BOOL firstLoad;
@property (nonatomic, strong) ZKChatRefreshHeader *refreshHeader;

@end

@implementation ZKChatViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _layouts = [[NSMutableArray alloc] init];
    _lastMsgID = nil;
    _firstLoad = YES;
    
    [[EMClient sharedClient].chatManager addDelegate:self];
    [self setupUI];
    
    [self requestData];
}

- (void)requestData
{
    EMConversation *conversation = [[EMClient sharedClient].chatManager getConversation:@"6001" type:EMConversationTypeChat createIfNotExist:YES];
    
    if (_layouts) {
        ZKChatLayout *layout = _layouts.firstObject;
        _lastMsgID = layout.message.messageId;
    }
    
    [conversation loadMessagesStartFromId:_lastMsgID count:15 searchDirection:EMMessageSearchDirectionUp completion:^(NSArray *aMessages, EMError *aError) {
        
        if (aError) {
            DLog(@"获取聊天数据失败 -- %@", aError);
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
            
            @weakify(self)
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [weak_self.tableView reloadData];
                [weak_self autoSetTableViewContentOffsetWithNewMsgs:tempArray];
            });
        });
    }];
}

/*! 
 第一次进入: 展示最新数据
 下拉历史数据: 无缝连接记录
 */
- (void)autoSetTableViewContentOffsetWithNewMsgs:(NSArray *)newMsgs
{
    @weakify(self)
    
    if (weak_self.firstLoad) {
        
        CGFloat maxTabelHeight = SCREEN_HEIGHT-_topInset-_bottomInset;
        
        CGFloat delta = weak_self.tableView.contentSize.height - maxTabelHeight;
        if (delta > 0) {
            [weak_self.tableView setContentOffset:CGPointMake(0, delta + 10.f)];
        }
        weak_self.firstLoad = NO;
    }
    else {
        __block CGFloat newsHeight = 0;
        [newMsgs enumerateObjectsUsingBlock:^(ZKChatLayout *layout, NSUInteger idx, BOOL * _Nonnull stop) {
            newsHeight += layout.height;
        }];
        
        [weak_self.tableView setContentOffset:CGPointMake(0, newsHeight)];
        
        // 已经加载全部
        if (!newMsgs.count) {
            [weak_self.refreshHeader noMoreData];
        }
        
        [weak_self.refreshHeader endRefresh];
    }
}

- (void)setupUI
{
    self.title = @"聊天详情";
    
    _tableView = [[UITableView alloc]
                  initWithFrame:(CGRect){0, _topInset, SCREEN_WIDTH, SCREEN_HEIGHT-_topInset-_bottomInset} style:UITableViewStylePlain];
    _tableView.contentInset = UIEdgeInsetsMake(0, 0, 10.f, 0);
    
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
    
    @weakify(self)
    _refreshHeader = [ZKChatRefreshHeader headerWithTableView:_tableView refreshBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weak_self requestData];
        });
    }];
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
    return height;
}

#pragma mark - 发送消息
#pragma mark - <ZKChatBarDelegate>

- (void)charBar:(ZKChatBar *)chatBar sendText:(NSString *)content
{
    DLog(@"发送消息===%@", content);
    
    EMMessage *message = [self generateMessageWithText:content];
    
    ZKChatLayout *layout = [[ZKChatLayout alloc] initWithEMMessage:message];
    [_layouts addObject:layout];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_layouts.count-1 inSection:0];
    [_tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
    [_tableView setContentOffset:CGPointMake(0, _tableView.contentOffset.y+layout.height) animated:YES];
    
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

- (void)dealloc
{
    [_refreshHeader free];
}

@end
