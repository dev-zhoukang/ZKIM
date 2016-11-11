//
//  ZKRecordView.m
//  ZKIM
//
//  Created by ZK on 16/10/31.
//  Copyright © 2016年 ZK. All rights reserved.
//

#import "ZKRecordView.h"

@interface ZKRecordView ()

@property (nonatomic, strong) UIView      *bgView;
@property (nonatomic, strong) UILabel     *hintLabel;
@property (nonatomic, strong) UIView      *imagesContainer;
@property (nonatomic, strong) UIImageView *microphoneImageView;
@property (nonatomic, strong) UIImageView *volumeImageView;
@property (nonatomic, strong) UIImageView *backoutImageView;

@end

@implementation ZKRecordView

+ (instancetype)shareRecordView
{
    static ZKRecordView *view = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        view = [ZKRecordView new];
    });
    return view;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.size = (CGSize){SCREEN_WIDTH, SCREEN_HEIGHT};
    self.userInteractionEnabled = NO;
    
    _bgView = [UIView new];
    [self addSubview:_bgView];
    _bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.56];
    _bgView.size = (CGSize){150.f, 150.f};
    _bgView.layer.cornerRadius = 5.f;
    _bgView.layer.masksToBounds = YES;
    
    _hintLabel = [UILabel new];
    [_bgView addSubview:_hintLabel];
    _hintLabel.backgroundColor = [UIColor clearColor];
    _hintLabel.text = @"手指上滑 取消发送";
    _hintLabel.textAlignment = NSTextAlignmentCenter;
    _hintLabel.font = [UIFont systemFontOfSize:14.f];
    _hintLabel.textColor = [UIColor whiteColor];
    CGFloat labelWidth = [_hintLabel.text stringWidthWithFont:_hintLabel.font height:MAXFLOAT]+8.f;
    CGFloat labelHeight = _hintLabel.font.lineHeight+6.f;
    _hintLabel.size = (CGSize){labelWidth, labelHeight};
    _hintLabel.layer.cornerRadius = 3.f;
    _hintLabel.layer.masksToBounds = YES;
    
    _imagesContainer = [UIView new];
    [_bgView addSubview:_imagesContainer];
    _imagesContainer.size = (CGSize){100.f, 100.f};
    
    _microphoneImageView = [UIImageView new];
    [_imagesContainer addSubview:_microphoneImageView];
    _microphoneImageView.image = [UIImage imageNamed:@"RecordingBkg_62x100_"];
    _microphoneImageView.size = (CGSize){62.f, 100.f};
    
    _volumeImageView = [UIImageView new];
    [_imagesContainer addSubview:_volumeImageView];
    _volumeImageView.image = [UIImage imageNamed:@"RecordingSignal003_38x100_"];
    _volumeImageView.size = (CGSize){38.f, 100.f};
    
    _backoutImageView = [UIImageView new];
    [_bgView addSubview:_backoutImageView];
    _backoutImageView.image = [UIImage imageNamed:@"RecordCancel_100x100_"];
    _backoutImageView.size = (CGSize){100.f, 100.f};
    _backoutImageView.hidden = YES;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _bgView.centerX = self.centerX;
    _bgView.centerY = self.centerY-30.f;
    
    _imagesContainer.top = 15.f;
    _imagesContainer.centerX = _imagesContainer.superview.width*0.5;
    
    _backoutImageView.top = _imagesContainer.top;
    _backoutImageView.centerX = _imagesContainer.centerX;
    
    _volumeImageView.left = CGRectGetMaxX(_microphoneImageView.frame);
    
    _hintLabel.centerX = _hintLabel.superview.width*0.5;
    _hintLabel.top = CGRectGetMaxY(_imagesContainer.frame);
}

- (void)showCancelBtn
{
    _backoutImageView.hidden = NO;
    _imagesContainer.hidden = YES;
    _hintLabel.text = @"松开手指 取消发送";
    _hintLabel.backgroundColor = RGBACOLOR(170, 60, 49, .99);
}

- (void)hideCancelBtn
{
    _backoutImageView.hidden = YES;
    _imagesContainer.hidden = NO;
    _hintLabel.text = @"手指上滑 取消发送";
    _hintLabel.backgroundColor = [UIColor clearColor];
}

- (void)hide
{
    self.hidden = YES;
    [self hideCancelBtn];
}

- (void)show
{
    self.hidden = NO;
}

@end
