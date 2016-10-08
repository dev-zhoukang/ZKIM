//
//  ZKContactCell.m
//  ZKIM
//
//  Created by ZK on 16/10/8.
//  Copyright © 2016年 ZK. All rights reserved.
//

#import "ZKContactCell.h"

@interface ZKContactCell ()

@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;


@end

@implementation ZKContactCell

- (void)awakeFromNib
{
    [super awakeFromNib];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *cellIdentify = @"ZKContactCell";
    ZKContactCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].firstObject;
    }
    return cell;
}

#pragma mark - Setter

- (void)setName:(NSString *)name
{
    _name = name;
    
    _nameLabel.text = name;
}

@end
