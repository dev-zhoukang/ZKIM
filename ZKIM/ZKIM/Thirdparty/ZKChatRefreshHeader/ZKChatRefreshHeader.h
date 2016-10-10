//
//  ZKChatRefreshHeader.h
//  ZKIM
//
//  Created by ZK on 16/10/9.
//  Copyright © 2016年 ZK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZKChatRefreshHeader : UIView

+ (instancetype)headerWithTableView:(UITableView *)tableView refreshBlock:(void (^)())block;
- (void)endRefresh;
- (void)noMoreData;
- (void)autoHide;

- (void)free;

@end
