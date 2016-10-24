//
//  PreviewSupplementaryView.h
//  ImagePickerSheetController
//
//  Created by marujun on 15/8/6.
//  Copyright (c) 2015年 marujun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PreviewSupplementaryView : UICollectionReusableView

@property (nonatomic, strong) UIButton *button;

@property (nonatomic, assign) BOOL selected;

@property (nonatomic, assign) UIEdgeInsets buttonInset;

+ (UIImage *)checkmarkImage;
+ (UIImage *)selectedCheckmarkImage;

@end
