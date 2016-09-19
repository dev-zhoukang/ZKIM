//
//  AutoData.h
//  ZKIM
//
//  Created by ZK on 16/9/19.
//  Copyright © 2016年 ZK. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ZKLoginUser;

@interface AutoData : NSObject

+ (ZKLoginUser *)loginUser;
+ (void)removeLoginUser;
+ (void)synchronize;
+ (void)loginSuccess:(NSDictionary *)dict;

@end
