//
//  ZKChatViewController.m
//  ZKIM
//
//  Created by ZK on 16/9/20.
//  Copyright © 2016年 ZK. All rights reserved.
//

#import "ZKChatViewController.h"
#import "ZKChatPanel.h"
#import "ZKChatCell.h"
#import "ZKChatLayout.h"
#import "ZKChatRefreshHeader.h"

@interface ZKChatViewController () <UITableViewDelegate, UITableViewDataSource, ZKChatPanelDelegate, EMChatManagerDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ZKChatPanel   *chatBar;
@property (nonatomic, strong) NSMutableArray <ZKChatLayout *> *layouts;
@property (nonatomic, copy) NSString *lastMsgID;
@property (nonatomic, assign) BOOL firstLoad;
@property (nonatomic, strong) ZKChatRefreshHeader *refreshHeader;

@property (nonatomic, copy) NSString *conversationID;
@property (nonatomic, copy) NSString *toID;

@end

@implementation ZKChatViewController

+ (instancetype)chatViewControllerWithConversationID:(NSString *)conversationID toID:(NSString *)toID
{
    ZKChatViewController *chatVC = [[ZKChatViewController alloc] init];
    chatVC.conversationID = conversationID;
    chatVC.toID = toID;
    return chatVC;
}

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
    EMConversation *conversation = [[EMClient sharedClient].chatManager getConversation:_conversationID type:EMConversationTypeChat createIfNotExist:YES];
    
    if (_layouts) {
        ZKChatLayout *layout = _layouts.firstObject;
        _lastMsgID = layout.message.messageId;
    }
    
    [conversation loadMessagesStartFromId:_lastMsgID count:15 searchDirection:EMMessageSearchDirectionUp completion:^(NSArray *aMessages, EMError *aError) {
        
        if (aError) {
            DLog(@"获取聊天数据失败 -- %@", aError);
            return;
        }
        if (!aMessages.count && _layouts.count) {
            [_refreshHeader noMoreData];
            return;
        }
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            NSMutableArray <ZKChatLayout *> *tempArray = [[NSMutableArray alloc] init];
            
            for (NSInteger i = 0; i < aMessages.count; i ++) {
                
                ZKMessage *zkmsg = [[ZKMessage alloc] initWithEMMessage:aMessages[i]];
                zkmsg.preTimestamp = tempArray.lastObject.message.timestamp;
                ZKChatLayout *layout = [[ZKChatLayout alloc] initWithZKMessage:zkmsg];
                DLog(@" === %@", layout.message.contentText);
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
        if (newMsgs.count != 15) { // 没有更多历史信息
            [weak_self.refreshHeader autoHide];
        }
        
        weak_self.firstLoad = NO;
    }
    else {
    
        [weak_self.tableView setContentOffset:CGPointMake(0, [weak_self calculateHeightWithLayouts:newMsgs])];
        
        [weak_self.refreshHeader endRefresh];
    }
}

- (CGFloat)calculateHeightWithLayouts:(NSArray *)layouts
{
    __block CGFloat layoutsHeight = 0;
    [layouts enumerateObjectsUsingBlock:^(ZKChatLayout *layout, NSUInteger idx, BOOL * _Nonnull stop) {
        layoutsHeight += layout.height;
    }];
    return layoutsHeight;
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
    
    _chatBar = [ZKChatPanel chatPanel];
    _chatBar.delegate = self;
    [self.view addSubview:_chatBar];
    _chatBar.bottom = self.view.height + kEmoticonInputViewHeight;
    
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
    ZKChatCell *cell = [ZKChatCell cellWithTableView:tableView];
    cell.cellLayout = _layouts[indexPath.item];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = _layouts[indexPath.item].height;
    return height;
}

#pragma mark - 发送消息
#pragma mark - <ZKChatPanelDelegate>

- (void)chatPanel:(ZKChatPanel *)charPanel sendText:(NSString *)content
{
    DLog(@"发送消息===%@", content);
    
    EMMessage *message = [self generateMessageWithText:content];
    [self insertMsgToDataSourceWithMessage:message];
    
    [[EMClient sharedClient].chatManager sendMessage:message progress:nil completion:^(EMMessage *message, EMError *error) {
        if (error) {
            DLog(@"文字消息发送失败 -- %@", error.errorDescription);
            return;
        }
        [_tableView reloadData];
        DLog(@"文字消息发送成功!");
    }];
}

- (void)chatPanelSendMediaDict:(NSDictionary *)dict mediaType:(MediaType)mediaType
{
    DLog(@"dict:%@ == type:%zd", dict, mediaType);
    // 构造图片消息并发送
    NSArray *emmsgs = [self generateMessagesWithImageDatas:dict[@"imageDatas"]];
    for (EMMessage *emmsg in emmsgs) {
        [self insertMsgToDataSourceWithMessage:emmsg];
        [[EMClient sharedClient].chatManager sendMessage:emmsg progress:nil completion:^(EMMessage *message, EMError *error) {
            if (error) {
                DLog(@"图片消息发送失败 -- %@", error.errorDescription);
                return;
            }
            [_tableView reloadData];
            DLog(@"图片消息发送成功!");
        }];
    }
}

/*! 插入到数据源 自动偏移 tableView */
- (void)insertMsgToDataSourceWithMessage:(EMMessage *)message
{
    ZKMessage *msg = [[ZKMessage alloc] initWithEMMessage:message];
    msg.preTimestamp = _layouts.lastObject.message.timestamp;
    ZKChatLayout *layout = [[ZKChatLayout alloc] initWithZKMessage:msg];
    [_layouts addObject:layout];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_layouts.count-1 inSection:0];
    [_tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
    // 自动调整tableView的位移
    [_tableView reloadData];
    [UIView animateWithDuration:0.25 animations:^{
        [_chatBar setTableViewOffsetWithKeyboardY:_chatBar.keyboard_y barHeight:50.f];
    }];
}

#pragma mark - 构造消息

- (NSArray <EMMessage *> *)generateMessagesWithImageDatas:(NSArray <NSData *> *)imageDatas
{
    NSMutableArray *emmsgs = [NSMutableArray array];
    
    for (NSData *imageData in imageDatas) {
        UIImage *image = [UIImage imageWithData:imageData];
        
        EMImageMessageBody *body = [[EMImageMessageBody alloc] initWithData:imageData displayName:@"image.png"];
        body.compressionRatio = 1.f;
        body.size = image.size;
        
        NSString *from = [[EMClient sharedClient] currentUsername];
        
        // 生成 Message
        EMMessage *message = [[EMMessage alloc] initWithConversationID:_conversationID from:from to:_toID body:body ext:nil];
        message.chatType = EMChatTypeChat;
        
        [emmsgs addObject:message];
    }
    return emmsgs;
}

/*! 构造文字消息 */
- (EMMessage *)generateMessageWithText:(NSString *)text
{
    EMTextMessageBody *body = [[EMTextMessageBody alloc] initWithText:text];
    NSString *from = [[EMClient sharedClient] currentUsername];
    
    EMMessage *message = [[EMMessage alloc] initWithConversationID:_conversationID from:from to:_toID body:body ext:nil];
    message.chatType = EMChatTypeChat;
    
    return message;
}

#pragma mark - 接收消息
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
                [self insertMsgToDataSourceWithMessage:message];
            } break;
            case EMMessageBodyTypeImage: {
                [self insertMsgToDataSourceWithMessage:message];
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
