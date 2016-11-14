//
//  ZKProfileHeader.m
//  ZKIM
//
//  Created by ZK on 16/11/14.
//  Copyright © 2016年 ZK. All rights reserved.
//

#import "ZKProfileHeader.h"

@interface ZKProfileHeader () <UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *wechatNum;

@end

@implementation ZKProfileHeader

+ (instancetype)header
{
    ZKProfileHeader *header = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].lastObject;
    [header updateUI];
    return header;
}

- (void)updateUI
{
    NSURL *iconUrl = [NSURL URLWithString:_loginUser.avatar];
    [_icon setImageWithURL:iconUrl placeholder:[UIImage imageNamed:@"zk_icon"]];
}

@end
