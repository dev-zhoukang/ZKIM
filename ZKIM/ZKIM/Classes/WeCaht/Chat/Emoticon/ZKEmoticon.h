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
    ZKEmoticonTypeImage = 0, // 图片表情
    ZKEmoticonTypeEmoji      // Emoji表情
};

@interface ZKEmoticon : NSObject

@property (nonatomic, copy) NSString *chs; // 简体
@property (nonatomic, copy) NSString *cht; // 繁体
@property (nonatomic, copy) NSString *gif;
@property (nonatomic, copy) NSString *png;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, assign) ZKEmoticonType type;
@property (nonatomic, weak) ZKEmoticonGroup *group;

@end

// ------ ZKEmoticonGroup -------

@interface ZKEmoticonGroup : NSObject

@property (nonatomic, copy) NSString *groupID;
@property (nonatomic, assign) NSInteger *version;
@property (nonatomic, copy) NSString *nameCN;
@property (nonatomic, copy) NSString *nameEN;
@property (nonatomic, copy) NSString *nameTW;
@property (nonatomic, assign) NSInteger displayOnly;
@property (nonatomic, assign) NSInteger groupType;
@property (nonatomic, strong) NSArray <ZKEmoticon *> *emotions;

@end
