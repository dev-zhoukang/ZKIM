//
//  ZKAlertView.h
//  ZKIM
//
//  Created by ZK on 16/10/9.
//  Copyright © 2016年 ZK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZKAlertView : UIView

typedef NS_ENUM(NSInteger, ZKAlertIconType) { //图标样式
    ZKAlertIconTypeHeart,          //心形
    ZKAlertIconTypeAttention,      //感叹号
    ZKAlertIconTypeCamera,         //照相机
    ZKAlertIconTypeIdentification, //认证
    ZKAlertIconTypeTrash           //垃圾桶
};

+ (instancetype)showErrorMessage:(NSString *)message;

/** 直接弹框 无标题 按钮无回调 */
+ (instancetype)showWithMessage:(NSString *)message
                       iconType:(ZKAlertIconType)iconType
                    buttonTitle:(NSString *)buttonTitle;

+ (instancetype)showWithMessage:(NSString *)message iconType:(ZKAlertIconType)iconType buttonTitle:(NSString *)buttonTitle done:(void (^)(NSInteger buttonIndex))completionBlock;
+ (instancetype)showYesAndNoWithMessage:(NSString *)message done:(void (^)(NSInteger buttonIndex))completionBlock;
+ (instancetype)showWithMessage:(NSString *)message cancelTitle:(NSString *)cancelTitle doneTitle:(NSString *)doneTitle done:(void (^)(NSInteger buttonIndex))completionBlock;
+ (instancetype)showWithTitle: (NSString *)title message:(NSString *)message cancelTitle:(NSString *)cancelTitle doneTitle:(NSString *)doneTitle done:(void (^)(NSInteger buttonIndex))completionBlock;

/** 直接弹框 有标题 按钮无回调 */
+ (instancetype)showWithTitle:(NSString *)title
                      message:(NSString *)message
                     iconType:(ZKAlertIconType)type
                  buttonTitle:(NSString *)buttonTitle;

/** 初始化弹框 无标题 一个按钮 */
+ (instancetype)initWithMessage:(NSString *)message
                       iconType:(ZKAlertIconType)iconType
              cancelButtonTitle:(NSString *)cancelButtonTitle;

/** 初始化弹框 有标题 一个按钮 */
+ (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
                     iconType:(ZKAlertIconType)iconType
            cancelButtonTitle:(NSString *)cancelButtonTitle;

/** 初始化弹框 无标题 两个按钮 */
+ (instancetype)initWithMessage:(NSString *)message
                       iconType:(ZKAlertIconType)iconType
              cancelButtonTitle:(NSString *)cancelButtonTitle
              otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

/** 初始化弹框 有标题 两个按钮 */
+ (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
                     iconType:(ZKAlertIconType)iconType
            cancelButtonTitle:(NSString *)cancelButtonTitle
            otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

- (void)clickedIndex:(NSInteger)index;

/** 弹出弹框 */
- (void)showWithCompletionBlock:(void (^)(NSInteger buttonIndex))completionBlock;

@end

//-----------------

@interface CAShapeLayer (ZKViewMask)
+ (instancetype)zk_createMaskLayerWithbounds:(CGRect)bounds cornerWidth:(CGFloat)cornerWidth;
@end
