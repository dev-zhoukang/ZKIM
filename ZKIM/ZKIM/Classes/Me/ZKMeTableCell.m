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
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *wechatNum;


@end

@implementation ZKMeTableCell

+ (instancetype)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentify_Profile = @"ZKMeTableCell_Profile";
    static NSString *cellIdentify_Common = @"ZKMeTableCell_Common";
    
    if (!indexPath.section) {
        ZKMeTableCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify_Profile];
        if (!cell) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"ZKMeTableCell" owner:nil options:nil].lastObject;
        }
        return cell;
    }
    
    ZKMeTableCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify_Common];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"ZKMeTableCell" owner:nil options:nil].firstObject;
    }cell.layer.cornerRadius = 5;
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
