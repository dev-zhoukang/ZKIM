//
//  ZKChatLayout.h
//  ZKIM
//
//  Created by ZK on 16/9/29.
//  Copyright © 2016年 ZK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZKMessage.h"

@interface ZKChatLayout : NSObject

- (instancetype)initWithZKMessage:(ZKMessage *)message;

@property (nonatomic, strong) ZKMessage *message;

@property (nonatomic, strong) YYTextLayout *contentTextLayout;
@property (nonatomic, assign) CGFloat      contentTextHeight;

@property (nonatomic, assign) CGFloat height; //!< 总高度

@end
