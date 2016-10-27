//
//  ZKPlusPanel.h
//  ZKIM
//
//  Created by ZK on 16/10/21.
//  Copyright © 2016年 ZK. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZKPlusPanelDelegate <NSObject>

@optional
- (void)plusPanelSendMediaDict:(NSDictionary *)dict type:(MediaType)mediaType;

@end

@interface ZKPlusPanel : UIView

+ (instancetype)plusPanel;
@property (nonatomic, weak) id <ZKPlusPanelDelegate> delegate;

@end

// -- ---
extern CGFloat const kPlusPanelHeight;
