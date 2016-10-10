//
//  ZKChatBar.h
//  ZKIM
//
//  Created by ZK on 16/9/20.
//  Copyright © 2016年 ZK. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZKChatBar;

@protocol ZKChatBarDelegate <NSObject>

@optional
- (void)charBar:(ZKChatBar *)chatBar sendText:(NSString *)content;

@end

@interface ZKChatBar : UIView

/** 初始化 */
+ (instancetype)chatBar;

/*! 根据内容设置 tableView的位移 */
- (void)setTableViewOffsetWithKeyboardFrame:(CGRect)keyboardFrame;

@property (nonatomic, assign, readonly) CGRect keyboardFrame;
@property (nonatomic, weak) id <ZKChatBarDelegate> delegate;

@end
