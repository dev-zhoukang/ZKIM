//
//  ZKContactCell.h
//  ZKIM
//
//  Created by ZK on 16/10/8.
//  Copyright © 2016年 ZK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZKContactCell : UITableViewCell

@property (nonatomic, copy) NSString *name;
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
