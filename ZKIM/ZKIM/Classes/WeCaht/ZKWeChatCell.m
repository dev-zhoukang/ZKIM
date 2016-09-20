//
//  ZKWeChatCell.m
//  ZKIM
//
//  Created by ZK on 16/9/20.
//  Copyright © 2016年 ZK. All rights reserved.
//

#import "ZKWeChatCell.h"

@implementation ZKWeChatCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *cellIdentify = @"ZKWeChatCell";
    ZKWeChatCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].firstObject;
    }
    return cell;
}

- (void)setDataInfo:(NSDictionary *)dataInfo
{
    _dataInfo = dataInfo;
}

@end
