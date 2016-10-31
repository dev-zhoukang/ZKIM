//
//  UIButton+Common.m
//  ZKIM
//
//  Created by ZK on 16/10/31.
//  Copyright © 2016年 ZK. All rights reserved.
//

#import "UIButton+Common.h"

@implementation UIButton (Common)
@dynamic hitEdgeInsets;

static const NSString *keyHitEdgeInsets = @"HitTestEdgeInsets";

- (void)setHitEdgeInsets:(UIEdgeInsets)hitEdgeInsets
{
    NSValue *value = [NSValue value:&hitEdgeInsets
                       withObjCType:@encode(UIEdgeInsets)];
    objc_setAssociatedObject(self,
                             &keyHitEdgeInsets,
                             value,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIEdgeInsets)hitEdgeInsets
{
    NSValue *value = objc_getAssociatedObject(self, &keyHitEdgeInsets);
    if (value) {
        UIEdgeInsets edgeInsets;
        [value getValue:&edgeInsets];
        return edgeInsets;
    }
    else {
        return UIEdgeInsetsZero;
    }
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    if (UIEdgeInsetsEqualToEdgeInsets(self.hitEdgeInsets, UIEdgeInsetsZero)
        || !self.enabled
        || self.hidden) {
        return [super pointInside:point withEvent:event];
    }
    
    CGRect relativeFrame = self.bounds;
    CGRect hitFrame = UIEdgeInsetsInsetRect(relativeFrame, self.hitEdgeInsets);
    
    return CGRectContainsPoint(hitFrame, point);
}

@end
