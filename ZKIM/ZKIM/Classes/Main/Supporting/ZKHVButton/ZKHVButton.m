//
//  ZKHVButton.m
//  ZKIM
//
//  Created by ZK on 16/9/14.
//  Copyright © 2016年 ZK. All rights reserved.
//

#import "ZKHVButton.h"

@implementation ZKHVButton

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
    _space = 5.f;
    _verticalAlignment = ZKHVButtonAlignmentBottom;
}

#pragma mark - Setter

- (void)setSpace:(CGFloat)space
{
    _space = space;
    
    [self setNeedsLayout];
}

#pragma mark - Overwrite

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect imageViewFrame = self.imageView.frame;
    CGRect titleFrame = self.titleLabel.frame;
    
    if (CGRectEqualToRect(CGRectZero, imageViewFrame) || CGRectEqualToRect(CGRectZero, titleFrame)) {
        return;
    }
    
    CGFloat contentHeight = imageViewFrame.size.height + _space + titleFrame.size.height;
    
    switch (_verticalAlignment) {
        case ZKHVButtonAlignmentBottom: {
            imageViewFrame.origin.y = self.bounds.size.height - contentHeight;
        } break;
        case ZKHVButtonAlignmentTop: {
            imageViewFrame.origin.y = 0;
        } break;
        case ZKHVButtonAlignmentCenter: {
            imageViewFrame.origin.y = (self.bounds.size.height - contentHeight) * 0.5;
        } break;
    }
    
    imageViewFrame.origin.x = (self.bounds.size.width - imageViewFrame.size.width) * 0.5;
    self.imageView.frame = imageViewFrame;
    
    titleFrame.origin.x = (self.bounds.size.width - titleFrame.size.width) * 0.5;
    titleFrame.origin.y = CGRectGetMaxY(imageViewFrame) + _space;
    self.titleLabel.frame = titleFrame;
}

@end
