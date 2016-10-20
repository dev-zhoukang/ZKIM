//
//  ZKEmoticon.m
//  ZKIM
//
//  Created by ZK on 16/10/20.
//  Copyright © 2016年 ZK. All rights reserved.
//

#import "ZKEmoticon.h"

@implementation ZKEmoticon

+ (NSArray *)modelPropertyBlacklist
{
    return @[@"group"];
}

@end

// ------ ZKEmoticonGroup -------

@implementation ZKEmoticonGroup

+ (NSDictionary *)modelCustomPropertyMapper
{
    return @{@"groupID" : @"id",
             @"nameCN" : @"group_name_cn",
             @"nameEN" : @"group_name_en",
             @"nameTW" : @"group_name_tw",
             @"displayOnly" : @"display_only",
             @"groupType" : @"group_type"};
}

+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{@"emoticons" : [ZKEmoticon class]};
}

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic
{
    [_emoticons enumerateObjectsUsingBlock:^(ZKEmoticon *emoticon, NSUInteger idx, BOOL *stop) {
        emoticon.group = self;
    }];
    return YES;
}

@end
