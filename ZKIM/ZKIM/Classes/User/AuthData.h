//
//  AuthData.h
//  ZKIM
//
//  Created by ZK on 16/9/19.
//  Copyright © 2016年 ZK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZKLoginUser.h"

@interface AuthData : NSObject

+ (ZKLoginUser *)loginUser;
+ (void)removeLoginUser;
+ (void)synchronize;
+ (void)loginSuccess:(NSDictionary *)dict;

@end
