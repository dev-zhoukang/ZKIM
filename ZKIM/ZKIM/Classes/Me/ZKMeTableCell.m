//
//  ZKMeTableCell.m
//  ZKIM
//
//  Created by ZK on 16/9/19.
//  Copyright © 2016年 ZK. All rights reserved.
//

#import "ZKMeTableCell.h"

@interface ZKMeTableCell()

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel     *title;

@end

@implementation ZKMeTableCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *cellIdentify = @"ZKMeTableCell";
    
    ZKMeTableCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"ZKMeTableCell" owner:nil options:nil].firstObject;
    }
    cell.layer.cornerRadius = 5;
    cell.clipsToBounds = YES;
    return cell;
}

#pragma mark - Setter

- (void)setDataInfo:(NSDictionary *)dataInfo
{
    _dataInfo = dataInfo;
    
    _title.text = dataInfo[@"title"];
    _icon.image = [UIImage imageNamed:dataInfo[@"icon"]];
}

@end
