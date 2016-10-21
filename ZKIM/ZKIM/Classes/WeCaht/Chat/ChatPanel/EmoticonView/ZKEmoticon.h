//
//  ZKEmoticon.h
//  ZKIM
//
//  Created by ZK on 16/10/20.
//  Copyright © 2016年 ZK. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ZKEmoticonGroup;

typedef NS_ENUM(NSInteger, ZKEmoticonType) {
    ZKEmoticonTypeImage = 0, //!< 图片表情
    ZKEmoticonTypeEmoji      //!< Emoji表情
};

@interface ZKEmoticon : NSObject

@property (nonatomic, copy) NSString *chs; //!< [开心]
@property (nonatomic, copy) NSString *cht; //!< [開心]
@property (nonatomic, copy) NSString *gif; //!< kaixin.gif
@property (nonatomic, copy) NSString *png; //!< kaixin.png
@property (nonatomic, copy) NSString *code;//!< 0x2f344d
@property (nonatomic, assign) ZKEmoticonType type; //!< 表情类型
@property (nonatomic, weak) ZKEmoticonGroup *group;//!< 表情组

@end

// ------ ZKEmoticonGroup -------

@interface ZKEmoticonGroup : NSObject

@property (nonatomic, copy) NSString *groupID; //!< com.sina.default
@property (nonatomic, assign) NSInteger *version;
@property (nonatomic, copy) NSString *nameCN;  //!< 浪小花
@property (nonatomic, copy) NSString *nameEN;  //!< langxiaohua
@property (nonatomic, copy) NSString *nameTW;
@property (nonatomic, assign) NSInteger displayOnly;
@property (nonatomic, assign) NSInteger groupType;
@property (nonatomic, strong) NSArray <ZKEmoticon *> *emoticons;

@end
