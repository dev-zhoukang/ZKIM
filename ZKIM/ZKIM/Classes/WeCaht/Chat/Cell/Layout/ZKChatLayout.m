//
//  ZKChatLayout.m
//  ZKIM
//
//  Created by ZK on 16/9/29.
//  Copyright © 2016年 ZK. All rights reserved.
//

#import "ZKChatLayout.h"

@implementation ZKChatLayout

- (instancetype)initWithChatEntity:(NSDictionary *)entity
{
    if (!entity) return nil;
    if (self = [super init]) {
        _chatEntity = entity;
        [self layout];
    }
    return self;
}

- (void)layout
{
    [self layoutText];
}

- (void)layoutText
{
    _height = 50;
}

@end
