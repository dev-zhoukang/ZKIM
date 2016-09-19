//
//  AutoData.m
//  ZKIM
//
//  Created by ZK on 16/9/19.
//  Copyright © 2016年 ZK. All rights reserved.
//

#import "AutoData.h"
#import "ZKLoginUser.h"

static ZKLoginUser *loginUser;

@implementation AutoData

+ (ZKLoginUser *)loginUser
{
    if (!loginUser) {
        NSDictionary *info = [userDefaults objectForKey:UserDefaultKey_LoginUser];
        if (info) {
            loginUser = [ZKLoginUser mj_objectWithKeyValues:info];
        }
    }
    return loginUser;
}

+ (void)loginSuccess:(NSDictionary *)info
{
    loginUser = [ZKLoginUser mj_objectWithKeyValues:info];
    [self synchronize];
    
    //通知其他页面刷新数据
    [[NSNotificationCenter defaultCenter] postNotificationName:Notification_LoginSuccess object:nil];
}

+ (void)removeLoginUser
{
    loginUser = nil;
    [self synchronize];
}

+ (void)synchronize
{
    if (loginUser) {
        [userDefaults setObject:loginUser.mj_keyValues forKey:UserDefaultKey_LoginUser];
    }
    else {
        [userDefaults removeObjectForKey:UserDefaultKey_LoginUser];
    }
    
    [userDefaults synchronize];
}

@end
