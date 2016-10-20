//
//  ZKEmoticonInputView.m
//  ZKIM
//
//  Created by ZK on 16/10/20.
//  Copyright © 2016年 ZK. All rights reserved.
//

#import "ZKEmoticonInputView.h"
#import "ZKEmoticon.h"

@interface ZKEmoticonInputView () <UICollectionViewDelegate, UICollectionViewDataSource, UIInputViewAudioFeedback>

@property (nonatomic, strong) NSArray<UIButton *> *toolbarButtons;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIView *pageControl;
@property (nonatomic, strong) NSArray<ZKEmoticonGroup *> *emoticonGroups;
@property (nonatomic, strong) NSArray<NSNumber *> *emoticonGroupPageIndexs;
@property (nonatomic, strong) NSArray<NSNumber *> *emoticonGroupPageCounts;
@property (nonatomic, assign) NSInteger emoticonGroupTotalPageCount;
@property (nonatomic, assign) NSInteger currentPageIndex;

@end

static CGFloat const kViewHeight = 216.f;
static CGFloat const kToolbarHeight = 37.f;
static CGFloat const kOneEmoticonHeight = 50.f;
static CGFloat const kOnePageCount = 20.f;

@implementation ZKEmoticonInputView

+ (instancetype)shareView
{
    static ZKEmoticonInputView *view;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        view = [self new];
    });
    return view;
}

- (instancetype)init
{
    self = [super init];
    self.frame = (CGRect){CGPointZero, SCREEN_WIDTH, SCREEN_HEIGHT};
    self.backgroundColor = HexColor(0xf9f9f9);
    [self _initGroups];
    [self _initTopLine];
    [self _initCollectionView];
    [self _initToolbar];
    
    _currentPageIndex = NSNotFound;
    [self _toolbarBtnDidTapped:_toolbarButtons.firstObject];
    
    return self;
}

#pragma mark - Private

- (void)_initGroups
{
    _emoticonGroups = [self emoticonGroups];
    NSMutableArray *indexs = [NSMutableArray new];
    NSUInteger index = 0;
    for (ZKEmoticonGroup *group in _emoticonGroups) {
        [indexs addObject:@(index)];
        NSUInteger count = ceil(group.emoticons.count / (float)kOnePageCount);
        if (count == 0) count = 1;
        index += count;
    }
    _emoticonGroupPageIndexs = indexs;
    
    NSMutableArray *pageCounts = [NSMutableArray new];
    _emoticonGroupTotalPageCount = 0;
    for (ZKEmoticonGroup *group in _emoticonGroups) {
        NSUInteger pageCount = ceil(group.emoticons.count / (float)kOnePageCount);
        if (pageCount == 0) pageCount = 1;
        [pageCounts addObject:@(pageCount)];
        _emoticonGroupTotalPageCount += pageCount;
    }
    _emoticonGroupPageCounts = pageCounts;
}

- (void)_initTopLine
{
    
}

- (void)_initCollectionView
{
    
}

- (void)_initToolbar
{
    
}

- (void)_toolbarBtnDidTapped:(UIButton *)btn
{
    
}

- (NSArray<ZKEmoticonGroup *> *)emoticonGroups {
    static NSMutableArray *groups;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *emoticonBundlePath = [[NSBundle mainBundle] pathForResource:@"EmoticonWeibo" ofType:@"bundle"];
        NSString *emoticonPlistPath = [emoticonBundlePath stringByAppendingPathComponent:@"emoticons.plist"];
        NSDictionary *plist = [NSDictionary dictionaryWithContentsOfFile:emoticonPlistPath];
        NSArray *packages = plist[@"packages"];
        groups = (NSMutableArray *)[NSArray modelArrayWithClass:[ZKEmoticonGroup class] json:packages];
        
        NSMutableDictionary *groupDic = [NSMutableDictionary new];
        for (int i = 0, max = (int)groups.count; i < max; i++) {
            ZKEmoticonGroup *group = groups[i];
            if (group.groupID.length == 0) {
                [groups removeObjectAtIndex:i];
                i--;
                max--;
                continue;
            }
            NSString *path = [emoticonBundlePath stringByAppendingPathComponent:group.groupID];
            NSString *infoPlistPath = [path stringByAppendingPathComponent:@"info.plist"];
            NSDictionary *info = [NSDictionary dictionaryWithContentsOfFile:infoPlistPath];
            [group modelSetWithDictionary:info];
            if (group.emoticons.count == 0) {
                i--;
                max--;
                continue;
            }
            groupDic[group.groupID] = group;
        }
        
        NSArray<NSString *> *additionals = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[emoticonBundlePath stringByAppendingPathComponent:@"additional"] error:nil];
        for (NSString *path in additionals) {
            ZKEmoticonGroup *group = groupDic[path];
            if (!group) continue;
            NSString *infoJSONPath = [[[emoticonBundlePath stringByAppendingPathComponent:@"additional"] stringByAppendingPathComponent:path] stringByAppendingPathComponent:@"info.json"];
            NSData *infoJSON = [NSData dataWithContentsOfFile:infoJSONPath];
            ZKEmoticonGroup *addGroup = [ZKEmoticonGroup modelWithJSON:infoJSON];
            if (addGroup.emoticons.count) {
                for (ZKEmoticon *emoticon in addGroup.emoticons) {
                    emoticon.group = group;
                }
                [((NSMutableArray *)group.emoticons) insertObjects:addGroup.emoticons atIndex:0];
            }
        }
    });
    return groups;
}

@end
