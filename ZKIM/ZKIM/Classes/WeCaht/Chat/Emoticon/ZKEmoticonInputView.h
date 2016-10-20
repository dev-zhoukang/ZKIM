//
//  ZKEmoticonInputView.h
//  ZKIM
//
//  Created by ZK on 16/10/20.
//  Copyright © 2016年 ZK. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZKEmoticonInputView;

@protocol ZKEmoticonInputViewDelegate <NSObject>

@optional
- (void)emoticonInputViewDidTapText:(NSString *)text;
- (void)emoticonInputViewDidTapBackspace;
@end

@interface ZKEmoticonInputView : UIView

@property (nonatomic, weak) id <ZKEmoticonInputViewDelegate> delegate;

+ (instancetype)shareView;

@end
