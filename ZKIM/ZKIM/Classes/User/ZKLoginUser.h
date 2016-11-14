//
//  ZKLoginUser.h
//  ZKIM
//
//  Created by ZK on 16/9/19.
//  Copyright © 2016年 ZK. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, GENDER) {
    GENDER_WOMAN,
    GENDER_MAN,
    GENDER_NONE
};

@interface ZKLoginUser : NSObject 

@property (nonatomic, copy) NSString       *account;
@property (nonatomic, copy) NSString       *password;
@property (nonatomic, copy) NSString       *session_key;
@property (nonatomic, copy) NSString       *avatar;
@property (nonatomic, copy) NSString       *birthday;
@property (nonatomic, strong) NSDictionary *payload;
@property (nonatomic, copy) NSString       *name;
@property (nonatomic, copy) NSString       *wechatNum;
@property (nonatomic, assign) GENDER       gender;
@property (nonatomic, copy) NSString       *uid;

@end
