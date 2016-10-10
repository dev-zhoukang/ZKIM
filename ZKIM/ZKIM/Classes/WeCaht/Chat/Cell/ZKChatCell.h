//
//  ZKChatCell.h
//  ZKIM
//
//  Created by ZK on 16/9/29.
//  Copyright © 2016年 ZK. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZKChatLayout;

typedef NS_ENUM(NSInteger, ZKChatCellType) {
    ZKChatCellTypeText,
    ZKChatCellTypeImage
};

@interface ZKChatCell : UITableViewCell

@property (nonatomic, strong) ZKChatLayout *cellLayout;

+ (instancetype)cellWithTableView:(UITableView *)tableView type:(ZKChatCellType)type;

- (void)startLoading;
- (void)stopLoading;

@end
