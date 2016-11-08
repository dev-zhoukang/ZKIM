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

@property (nonatomic, strong, readonly) ZKMessage *message;

@property (nonatomic, strong, readonly) YYTextLayout *contentTextLayout;
@property (nonatomic, assign, readonly) CGFloat      contentTextHeight;
@property (nonatomic, assign, readonly) CGSize      imageSize;
@property (nonatomic, assign, readonly) CGFloat     audioHeight;

@property (nonatomic, assign, readonly) CGFloat height; //!< 总高度

@end
