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

#define kChatPanelHeight   (kChatBarHeight+kEmoticonInputViewHeight)

@interface ZKChatPanel ()

@property (nonatomic, assign) ZKChatBar           *chatBar;
@property (nonatomic, assign) ZKEmoticonInputView *emoticonView;

@end

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

#pragma mark - Init

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
    self.size = (CGSize){SCREEN_WIDTH, kChatPanelHeight};
    
    _chatBar = [ZKChatBar shareChatBar];
    _emoticonView = [ZKEmoticonInputView shareView];
    
    [self addSubview:_chatBar];
    [self addSubview:_emoticonView];
}

#pragma mark - Layout

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _emoticonView.bottom = self.height;
    _chatBar.top = 0;
}

@end
