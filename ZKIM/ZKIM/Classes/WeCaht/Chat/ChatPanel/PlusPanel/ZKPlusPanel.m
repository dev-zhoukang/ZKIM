//
//  ZKPlusPanel.m
//  ZKIM
//
//  Created by ZK on 16/10/21.
//  Copyright © 2016年 ZK. All rights reserved.
//

#import "ZKPlusPanel.h"
#import "ZKPhotoGetTool.h"

@interface ZKPlusElement : UIView

@property (nonatomic, strong) NSDictionary *info;
@property (nonatomic, strong) UIButton *btn;

@end

// -- const string --
extern NSString *const kImageName;
extern NSString *const kTitle;

@implementation ZKPlusElement {
    UILabel  *_label;
}

- (instancetype)init
{
    self = [super init];
    [self setup];
    return self;
}

- (void)setup
{
    _btn = [UIButton buttonWithType:UIButtonTypeSystem];
    _btn.backgroundColor = [UIColor clearColor];
    [self addSubview:_btn];
    _btn.size = (CGSize){60.f, 60.f};
    _btn.layer.borderWidth = .35f;
    _btn.layer.borderColor = [[UIColor lightGrayColor] colorWithAlphaComponent:.7].CGColor;
    _btn.layer.cornerRadius = 13.f;
    _btn.clipsToBounds = YES;
    
    UIImage *highlightBackImage = [UIImage imageWithColor:[UIColor lightGrayColor]];
    [_btn setBackgroundImage:highlightBackImage forState:UIControlStateHighlighted];
    
    _label = [[UILabel alloc] init];
    _label.text = @"测试测试";
    [self addSubview:_label];
    _label.font = [UIFont systemFontOfSize:13.f];
    _label.textAlignment = NSTextAlignmentCenter;
    _label.textColor = [UIColor lightGrayColor];
}

- (void)setInfo:(NSDictionary *)info
{
    _info = info;
    DLog(@" == %@", info);
    
    UIImage *image = [[UIImage imageNamed:info[kImageName]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [_btn setImage:image forState:UIControlStateNormal];
    _label.text = info[kTitle];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _btn.top = 10.f;
    _btn.centerX = self.width*0.5;
    
    _label.top = CGRectGetMaxY(_btn.frame) + 7.f;
    [_label sizeToFit];
    _label.centerX = self.width*0.5;
}

// ---

NSString *const kImageName = @"kImageName";
NSString *const kTitle = @"kTitle";

@end

// --- ZKPlusPanel ---

@interface ZKPlusPanel () <ZKPhotoGetToolDelegate>

@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) ZKPhotoGetTool *imageGetTool;

@end

CGFloat const kPlusPanelHeight = 216.f;

@implementation ZKPlusPanel

#pragma mark - Public

+ (instancetype)plusPanel
{
    static ZKPlusPanel *view = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        view = [self new];
    });
    return view;
}

#pragma mark - Init

- (instancetype)init
{
    if (self = [super init]) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    [self initData];
    self.size = (CGSize){SCREEN_WIDTH, 216.f};
    
    for (NSUInteger i = 0; i < _dataSource.count; i ++) {
        ZKPlusElement *element = [[ZKPlusElement alloc] init];
        element.btn.tag = i;
        [element.btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        element.info = _dataSource[i];
        element.backgroundColor = [UIColor clearColor];
        [self addSubview:element];
    }
}

- (void)initData
{
    _dataSource = @[
                    @{kImageName:@"sharemore_video_59x59_", kTitle:@"照相"},
                    @{kImageName:@"sharemore_pic_59x59_", kTitle:@"照片"},
                    @{kImageName:@"sharemore_sight_60x60_", kTitle:@"小视频"},
                    @{kImageName:@"sharemore_videovoip_60x60_", kTitle:@"视频"},
                    @{kImageName:@"sharemorePay_59x59_", kTitle:@"转账"},
                    @{kImageName:@"sharemore_location_59x59_", kTitle:@"位置"},
                    @{kImageName:@"sharemore_myfav_59x59_", kTitle:@"我的最爱"}
                    ];
    _imageGetTool = [ZKPhotoGetTool shareInstance];
    _imageGetTool.delegate = self;
}

- (void)btnClick:(UIButton *)btn
{
    switch (btn.tag) {
        case 0: {
            DLog(@"照相");
            [_imageGetTool choosePhotoDataWithType:ZKPhotoTypeTakePhoto];
        } break;
        case 1: {
            DLog(@"照片");
            [_imageGetTool choosePhotoDataWithType:ZKPhotoTypeLocalAlbumSheet];
        } break;
        case 2: {
            DLog(@"小视频");
        } break;
        case 3: {
            DLog(@"视频");
        } break;
        case 4: {
            DLog(@"转账");
        } break;
        case 5: {
            DLog(@"位置");
        } break;
        case 6: {
            DLog(@"我的最爱");
        } break;
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat leftMargin = 15.f;
    
    NSUInteger columns = 4;
    
    CGFloat elementW = round((SCREEN_WIDTH-leftMargin*2)/columns);
    CGFloat elementH = 100.f;
    
    CGFloat margH = 10.f;
    
    for (NSInteger i = 0; i < self.subviews.count; i++) {
        
        //列的索引
        NSInteger col = i % columns;
        //行的索引
        NSInteger row = i / columns;
        
        CGFloat btnX = col * elementW + leftMargin;
        CGFloat btnY = row * (margH + elementH);
        
        ZKPlusElement *element = self.subviews[i];
        element.frame = CGRectMake(btnX, btnY, elementW, elementH);
    }
}

#pragma mark - <ZKPhotoGetToolDelegate>

- (void)photoGetToolDidGotMediaModel:(ZKMediaModel *)mediaModel type:(MediaType)type
{
    if ([self.delegate respondsToSelector:@selector(plusPanelSendMediaModel:type:)]) {
        // chat panel 是其代理
        [self.delegate plusPanelSendMediaModel:mediaModel type:type];
    }
}

@end
