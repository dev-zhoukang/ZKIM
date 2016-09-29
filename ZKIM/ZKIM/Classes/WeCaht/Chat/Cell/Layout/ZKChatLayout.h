//
//  ZKChatLayout.h
//  ZKIM
//
//  Created by ZK on 16/9/29.
//  Copyright © 2016年 ZK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZKChatLayout : NSObject

- (instancetype)initWithChatEntity:(NSDictionary *)chatEntity;

@property (nonatomic, strong) NSDictionary *chatEntity;
@property (nonatomic, assign) CGFloat height; //!< 总高度


@end