//
//  ZKMeTableCell.h
//  ZKIM
//
//  Created by ZK on 16/9/19.
//  Copyright © 2016年 ZK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZKMeTableCell : UITableViewCell

@property (nonatomic, strong) NSDictionary *dataInfo;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
