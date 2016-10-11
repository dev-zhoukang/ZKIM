//
//  ZKEmotionPanel.m
//  ZKIM
//
//  Created by ZK on 16/10/10.
//  Copyright © 2016年 ZK. All rights reserved.
//

#import "ZKEmotionPanel.h"

@interface ZKEmotionPanel ()

@property (nonatomic, strong) UIView *toolContainer;
@property (nonatomic, strong) UIView *emotionContainer;

@end

@implementation ZKEmotionPanel

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
    self.size = (CGSize){SCREEN_WIDTH, 250.f};
    
    _toolContainer = [[UIView alloc] init];
    [self addSubview:_toolContainer];
    _toolContainer.backgroundColor = [UIColor redColor];
    
    _emotionContainer = [[UIView alloc] init];
    [self addSubview:_emotionContainer];
    _emotionContainer.backgroundColor = [UIColor greenColor];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _toolContainer.size = (CGSize){SCREEN_WIDTH, 44.f};
    _toolContainer.bottom = self.height;
    
    _emotionContainer.height = self.height-_toolContainer.height;
    _emotionContainer.width = SCREEN_WIDTH;
    _emotionContainer.bottom = _emotionContainer.height;
}

@end
