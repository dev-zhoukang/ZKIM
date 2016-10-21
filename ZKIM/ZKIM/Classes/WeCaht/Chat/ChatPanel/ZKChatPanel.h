//
//  ZKChatPanel.h
//  ZKIM
//
//  Created by ZK on 16/9/20.
//  Copyright © 2016年 ZK. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZKChatPanel;

@protocol ZKChatPanelDelegate <NSObject>

@optional
- (void)charPanel:(ZKChatPanel *)chatPanel sendText:(NSString *)content;

@end

@interface ZKChatPanel : UIView

/** 初始化 注意: 不需要设置约束 也不需要监听键盘键盘弹出降落等 */
+ (instancetype)chatPanel;

/*! 根据内容设置 tableView的位移 */
- (void)setTableViewOffsetWithKeyboardY:(CGFloat)keyboardY barHeight:(CGFloat)barHeight;

@property (nonatomic, assign, readonly) CGFloat keyboard_y;
@property (nonatomic, weak) id <ZKChatPanelDelegate> delegate;

@end

