//
//  ZKHVButton.h
//  ZKIM
//
//  Created by ZK on 16/9/14.
//  Copyright © 2016年 ZK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZKHVButton : UIButton

/** 图片和文字之间的垂直间距,默认为0 */
@property (assign, nonatomic) CGFloat space;

/** 重置图片的尺寸,默认取图片原有的尺寸 */
@property (assign, nonatomic) CGSize imageResize;

@end
