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

@property (nonatomic, copy) NSString * session_key;
@property (nonatomic, retain) NSString * avatar;
@property (nonatomic, retain) NSString * birthday;
@property (nonatomic, retain) NSDictionary * payload;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, assign) GENDER gender;
@property (nonatomic, retain) NSString * uid;

@end
