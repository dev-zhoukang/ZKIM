//
//  ZKChatPanel.m
//  ZKIM
//
//  Created by ZK on 16/10/21.
//  Copyright © 2016年 ZK. All rights reserved.
//

#import "ZKChatPanel.h"
#import "ZKChatBar.h"
#import "ZKEmoticonInputView.h"

@implementation ZKChatPanel

#pragma mark - Public

+ (instancetype)shareChatPanel
{
    static ZKChatPanel *view;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        view = [self new];
    });
    return view;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    
}

@end
