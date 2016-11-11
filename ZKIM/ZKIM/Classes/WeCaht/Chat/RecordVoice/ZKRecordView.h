//
//  ZKRecordView.h
//  ZKIM
//
//  Created by ZK on 16/10/31.
//  Copyright © 2016年 ZK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZKRecordView : UIView

+ (instancetype)shareRecordView;

- (void)showCancelBtn; // 显示取消按钮
- (void)hideCancelBtn; // 隐藏取消按钮
- (void)showTooShort;  

- (void)hide;
- (void)show;

- (void)setVolume:(double)volume;

@end
