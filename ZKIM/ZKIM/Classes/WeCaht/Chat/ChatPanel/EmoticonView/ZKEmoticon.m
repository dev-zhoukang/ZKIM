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

/*! If the default json-to-model transform does not fit to your model object, implement
 this method to do additional process. You can also use this method to validate the
 model's properties.
 */
- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic
{
    [_emoticons enumerateObjectsUsingBlock:^(ZKEmoticon *emoticon, NSUInteger idx, BOOL *stop) {
        emoticon.group = self;
    }];
    return YES;
}

@end
