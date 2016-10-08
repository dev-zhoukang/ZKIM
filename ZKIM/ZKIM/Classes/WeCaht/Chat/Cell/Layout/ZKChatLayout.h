//
//  ZKChatLayout.h
//  ZKIM
//
//  Created by ZK on 16/9/29.
//  Copyright © 2016年 ZK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZKChatLayout : NSObject

- (instancetype)initWithEMMessage:(EMMessage *)message;

@property (nonatomic, strong) EMMessage *message;
@property (nonatomic, copy, readonly) NSString *text;
@property (nonatomic, assign, readonly) BOOL isMine;

@property (nonatomic, strong) YYTextLayout *contentTextLayout;
@property (nonatomic, assign) CGFloat      contentTextHeight;

@property (nonatomic, assign) CGFloat height; //!< 总高度

@end
