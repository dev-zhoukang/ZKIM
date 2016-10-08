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

@interface ZKChatViewController () <UITableViewDelegate, UITableViewDataSource, ZKChatBarDelegate, EMChatManagerDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ZKChatBar   *chatBar;
@property (nonatomic, strong) NSMutableArray <ZKChatLayout *> *layouts;

@end

@implementation ZKChatViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _layouts = [[NSMutableArray alloc] init];
    [[EMClient sharedClient].chatManager addDelegate:self];
    
    [self requestData];
    
    [self setupUI];
}

- (void)requestData
{
    EMConversation *conversation = [[EMClient sharedClient].chatManager getConversation:@"6001" type:EMConversationTypeChat createIfNotExist:YES];
    
    [conversation loadMessagesStartFromId:nil count:20 searchDirection:EMMessageSearchDirectionUp completion:^(NSArray *aMessages, EMError *aError) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            for (EMMessage *message in aMessages) {
                ZKChatLayout *layout = [[ZKChatLayout alloc] initWithEMMessage:message];
                [_layouts addObject:layout];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
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
