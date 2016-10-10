//
//  ZKChatViewController.h
//  ZKIM
//
//  Created by ZK on 16/9/20.
//  Copyright © 2016年 ZK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZKChatViewController : ZKViewController

+ (instancetype)chatViewControllerWithConversationID:(NSString *)conversationID toID:(NSString *)toID;

@end
