//
//  ZKChatCell.h
//  ZKIM
//
//  Created by ZK on 16/9/29.
//  Copyright © 2016年 ZK. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ZKChatCellType) {
    ZKChatCellTypeText,
    ZKChatCellTypeImage
};

@interface ZKChatCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView type:(ZKChatCellType)type;

- (void)updateCellWithInfo:(NSDictionary *)info;

@end
