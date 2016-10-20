//
//  ZKEmoticonInputView.m
//  ZKIM
//
//  Created by ZK on 16/10/20.
//  Copyright © 2016年 ZK. All rights reserved.
//

#import "ZKEmoticonInputView.h"
#import "ZKEmoticon.h"
#import "ZKEmoticonHelper.h"

@interface ZKEmoticonCell : UICollectionViewCell
@property (nonatomic, strong) ZKEmoticon *emoticon;
@property (nonatomic, assign) BOOL isDelete;
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation ZKEmoticonCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    _imageView = [UIImageView new];
    _imageView.size = CGSizeMake(32, 32);
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:_imageView];
    return self;
}

- (void)setEmoticon:(ZKEmoticon *)emoticon {
    if (_emoticon == emoticon) return;
    _emoticon = emoticon;
    [self updateContent];
}

- (void)setIsDelete:(BOOL)isDelete {
    if (_isDelete == isDelete) return;
    _isDelete = isDelete;
    [self updateContent];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self updateLayout];
}

- (void)updateContent {
    [_imageView cancelCurrentImageRequest];
    _imageView.image = nil;
    
    if (_isDelete) {
        _imageView.image = [UIImage imageNamed:@"compose_emotion_delete"];
    } else if (_emoticon) {
        if (_emoticon.type == ZKEmoticonTypeEmoji) {
            NSNumber *num = [NSNumber numberWithString:_emoticon.code];
            NSString *str = [NSString stringWithUTF32Char:num.unsignedIntValue];
            if (str) {
                UIImage *img = [UIImage imageWithEmoji:str size:_imageView.width];
                _imageView.image = img;
            }
        } else if (_emoticon.group.groupID && _emoticon.png){
            NSString *pngPath = [[ZKEmoticonHelper emoticonBundle] pathForScaledResource:_emoticon.png ofType:nil inDirectory:_emoticon.group.groupID];
            if (!pngPath) {
                NSString *addBundlePath = [[ZKEmoticonHelper emoticonBundle].bundlePath stringByAppendingPathComponent:@"additional"];
                NSBundle *addBundle = [NSBundle bundleWithPath:addBundlePath];
                pngPath = [addBundle pathForScaledResource:_emoticon.png ofType:nil inDirectory:_emoticon.group.groupID];
            }
            if (pngPath) {
                [_imageView setImageWithURL:[NSURL fileURLWithPath:pngPath] options:YYWebImageOptionIgnoreDiskCache];
            }
        }
    }
}

- (void)updateLayout {
    _imageView.center = CGPointMake(self.width / 2, self.height / 2);
}

@end

// ---------  ----------

@protocol ZKEmoticonScrollViewDelegate <UICollectionViewDelegate>
- (void)emoticonScrollViewDidTapCell:(ZKEmoticonCell *)cell;
@end

@interface ZKEmoticonScrollView : UICollectionView
@end

@implementation ZKEmoticonScrollView
{
    NSTimeInterval *_touchBeganTime;
    BOOL _touchMoved;
    UIImageView *_magnifier;
    UIImageView *_magnifierContent;
    __weak ZKEmoticonCell *_currentMagnifierCell;
    NSTimer *_backspaceTimer;
}

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout
{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    self.backgroundColor = [UIColor clearColor];
    self.backgroundView = [UIView new];
    self.pagingEnabled = YES;
    self.showsHorizontalScrollIndicator = NO;
    self.clipsToBounds = NO;
    self.canCancelContentTouches = NO;
    self.multipleTouchEnabled = NO;
    _magnifier = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"emoticon_keyboard_magnifier"]];
    _magnifierContent = [UIImageView new];
    _magnifierContent.size = CGSizeMake(40, 40);
    _magnifierContent.centerX = _magnifier.width / 2;
    [_magnifier addSubview:_magnifierContent];
    _magnifier.hidden = YES;
    [self addSubview:_magnifier];
    return self;
}

- (void)dealloc
{
    [self endBackspaceTimer];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    _touchMoved = NO;
    ZKEmoticonCell *cell = [self cellForTouches:touches];
    _currentMagnifierCell = cell;
    [self showMagnifierForCell:_currentMagnifierCell];
    
    if (cell.imageView.image && !cell.isDelete) {
        [[UIDevice currentDevice] playInputClick];
    }
    
    if (cell.isDelete) {
        [self endBackspaceTimer];
        [self performSelector:@selector(startBackspaceTimer) afterDelay:0.5];
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    _touchMoved = YES;
    if (_currentMagnifierCell && _currentMagnifierCell.isDelete) return;
    
    ZKEmoticonCell *cell = [self cellForTouches:touches];
    if (cell != _currentMagnifierCell) {
        if (!_currentMagnifierCell.isDelete && !cell.isDelete) {
            _currentMagnifierCell = cell;
        }
        [self showMagnifierForCell:cell];
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    ZKEmoticonCell *cell = [self cellForTouches:touches];
    if ((!_currentMagnifierCell.isDelete && cell.emoticon) || (!_touchMoved && cell.isDelete)) {
        if ([self.delegate respondsToSelector:@selector(emoticonScrollViewDidTapCell:)]) {
            [((id<ZKEmoticonScrollViewDelegate>) self.delegate) emoticonScrollViewDidTapCell:cell];
        }
    }
    [self hideMagnifier];
    [self endBackspaceTimer];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self hideMagnifier];
    [self endBackspaceTimer];
}

- (ZKEmoticonCell *)cellForTouches:(NSSet<UITouch *> *)touches
{
    UITouch *touch = touches.anyObject;
    CGPoint point = [touch locationInView:self];
    NSIndexPath *indexPath = [self indexPathForItemAtPoint:point];
    if (indexPath) {
        ZKEmoticonCell *cell = (id)[self cellForItemAtIndexPath:indexPath];
        return cell;
    }
    return nil;
}

- (void)showMagnifierForCell:(ZKEmoticonCell *)cell
{
    if (cell.isDelete || !cell.imageView.image) {
        [self hideMagnifier];
        return;
    }
    CGRect rect = [cell convertRect:cell.bounds toView:self];
    _magnifier.centerX = CGRectGetMidX(rect);
    _magnifier.bottom = CGRectGetMaxY(rect) - 9;
    _magnifier.hidden = NO;
    
    _magnifierContent.image = cell.imageView.image;
    _magnifierContent.top = 20;
    
    [_magnifierContent.layer removeAllAnimations];
    NSTimeInterval dur = 0.1;
    [UIView animateWithDuration:dur delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        _magnifierContent.top = 3;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:dur delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            _magnifierContent.top = 6;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:dur delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                _magnifierContent.top = 5;
            } completion:^(BOOL finished) {
            }];
        }];
    }];
}

- (void)hideMagnifier
{
    _magnifier.hidden = YES;
}

- (void)startBackspaceTimer
{
    [self endBackspaceTimer];
    @weakify(self);
    _backspaceTimer = [NSTimer timerWithTimeInterval:0.1 block:^(NSTimer *timer) {
        @strongify(self);
        if (!self) return;
        ZKEmoticonCell *cell = self->_currentMagnifierCell;
        if (cell.isDelete) {
            if ([self.delegate respondsToSelector:@selector(emoticonScrollViewDidTapCell:)]) {
                [[UIDevice currentDevice] playInputClick];
                [((id<ZKEmoticonScrollViewDelegate>) self.delegate) emoticonScrollViewDidTapCell:cell];
            }
        }
    } repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_backspaceTimer forMode:NSRunLoopCommonModes];
}

- (void)endBackspaceTimer {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(startBackspaceTimer) object:nil];
    [_backspaceTimer invalidate];
    _backspaceTimer = nil;
}
@end

// -------  -----------

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
    UIView *line = [UIView new];
    line.width = self.width;
    line.height = CGFloatFromPixel(1);
    line.backgroundColor = UIColorHex(bfbfbf);
    line.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self addSubview:line];
}

- (void)_initCollectionView
{
    CGFloat itemWidth = (kScreenWidth - 10 * 2) / 7.0;
    itemWidth = CGFloatPixelRound(itemWidth);
    CGFloat padding = (kScreenWidth - 7 * itemWidth) / 2.0;
    CGFloat paddingLeft = CGFloatPixelRound(padding);
    CGFloat paddingRight = kScreenWidth - paddingLeft - itemWidth * 7;
    
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(itemWidth, kOneEmoticonHeight);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.sectionInset = UIEdgeInsetsMake(0, paddingLeft, 0, paddingRight);
    
    _collectionView = [[ZKEmoticonScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kOneEmoticonHeight * 3) collectionViewLayout:layout];
    [_collectionView registerClass:[ZKEmoticonCell class] forCellWithReuseIdentifier:@"cell"];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.top = 5;
    [self addSubview:_collectionView];
    
    _pageControl = [UIView new];
    _pageControl.size = CGSizeMake(kScreenWidth, 20);
    _pageControl.top = _collectionView.bottom - 5;
    _pageControl.userInteractionEnabled = NO;
    [self addSubview:_pageControl];
}

- (void)_initToolbar
{
    UIView *toolbar = [UIView new];
    toolbar.size = CGSizeMake(kScreenWidth, kToolbarHeight);
    
    UIImageView *bg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"compose_emotion_table_right_normal"]];
    bg.size = toolbar.size;
    [toolbar addSubview:bg];
    
    UIScrollView *scroll = [UIScrollView new];
    scroll.showsHorizontalScrollIndicator = NO;
    scroll.alwaysBounceHorizontal = YES;
    scroll.size = toolbar.size;
    scroll.contentSize = toolbar.size;
    [toolbar addSubview:scroll];
    
    NSMutableArray *btns = [NSMutableArray new];
    UIButton *btn;
    for (NSUInteger i = 0; i < _emoticonGroups.count; i++) {
        ZKEmoticonGroup *group = _emoticonGroups[i];
        btn = [self _createToolbarButton];
        [btn setTitle:group.nameCN forState:UIControlStateNormal];
        btn.left = kScreenWidth / (float)_emoticonGroups.count * i;
        btn.tag = i;
        [scroll addSubview:btn];
        [btns addObject:btn];
    }
    
    toolbar.bottom = self.height;
    [self addSubview:toolbar];
    _toolbarButtons = btns;
}

- (UIButton *)_createToolbarButton {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.exclusiveTouch = YES;
    btn.size = CGSizeMake(kScreenWidth / _emoticonGroups.count, kToolbarHeight);
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitleColor:UIColorHex(5D5C5A) forState:UIControlStateSelected];
    
    UIImage *img;
    img = [UIImage imageNamed:@"compose_emotion_table_left_normal"];
    img = [img resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, img.size.width - 1) resizingMode:UIImageResizingModeStretch];
    [btn setBackgroundImage:img forState:UIControlStateNormal];
    
    img = [UIImage imageNamed:@"compose_emotion_table_left_selected"];
    img = [img resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, img.size.width - 1) resizingMode:UIImageResizingModeStretch];
    [btn setBackgroundImage:img forState:UIControlStateSelected];
    
    [btn addTarget:self action:@selector(_toolbarBtnDidTapped:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

- (void)_toolbarBtnDidTapped:(UIButton *)btn
{
    NSInteger groupIndex = btn.tag;
    NSInteger page = ((NSNumber *)_emoticonGroupPageIndexs[groupIndex]).integerValue;
    CGRect rect = CGRectMake(page * _collectionView.width, 0, _collectionView.width, _collectionView.height);
    [_collectionView scrollRectToVisible:rect animated:NO];
    [self scrollViewDidScroll:_collectionView];
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
