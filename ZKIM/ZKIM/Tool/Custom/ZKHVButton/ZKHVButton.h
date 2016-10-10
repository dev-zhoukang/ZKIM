//
//  ZKHVButton.h
//  ZKIM
//
//  Created by ZK on 16/9/14.
//  Copyright © 2016年 ZK. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 内容对齐方式 */
typedef NS_ENUM(NSInteger, ZKHVButtonAlignment) {
    ZKHVButtonAlignmentBottom, //!< 下对齐, Default
    ZKHVButtonAlignmentTop,    //!< 上对齐
    ZKHVButtonAlignmentCenter  //!< 上下居中
};

@interface ZKHVButton : UIButton

/** 图片和文字之间的垂直间距,默认为5.f */
@property (nonatomic, assign) CGFloat space;

@property (nonatomic, assign) ZKHVButtonAlignment verticalAlignment;

@end
