//
//  ZKAlertView.m
//  ZKIM
//
//  Created by ZK on 16/10/9.
//  Copyright © 2016年 ZK. All rights reserved.
//

#import "ZKAlertView.h"

#define MsgLabelWidth       (210.f*WindowZoomScale)
#define MsgLabelHeight      [self textEstimatedHeightWithFont:[UIFont boldSystemFontOfSize:16.f] width:MsgLabelWidth]
#define AlertViewWidth      245.f*WindowZoomScale
#define AlertViewHeight     MIN((MAX((MsgLabelHeight+115.f),190.f))*WindowZoomScale, [UIScreen  mainScreen].bounds.size.height)

@interface ZKAlertView () {
    UILabel *_bgView;
    UIView *_btnView;
    UIView *_messageView;
    NSInteger _btnCount;
}

@property (strong, nonatomic) UILabel *messageLabel;
@property (strong, nonatomic) UIView *contentView;

@property (nonatomic, strong) CAShapeLayer *shapeLayer;
@property (nonatomic, copy) void (^completeBlock)(NSInteger buttonIndex);
@property (nonatomic, strong) NSString *cancelButtonTitle;
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) NSMutableArray *viewArray;
@property (nonatomic, strong) UIImageView *iconView;

@end

@implementation ZKAlertView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews
{
    self.backgroundColor =  [UIColor clearColor];
    
    _bgView = [[UILabel alloc] initForAutoLayout];
    _bgView.userInteractionEnabled = YES;
    _bgView.backgroundColor = RGBACOLOR(0, 0, 0, 0.6);
    [self addSubview:_bgView];
    
    _contentView = [[UIView alloc] initForAutoLayout];
    _contentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_contentView];
    
    _iconView = [[UIImageView alloc] initForAutoLayout];
    [_contentView addSubview:_iconView];
    _iconView.contentMode = UIViewContentModeScaleAspectFill;
    
    _messageView = [[UIView alloc] initForAutoLayout];
    [_contentView addSubview:_messageView];
    _messageView.backgroundColor = [UIColor clearColor];
    
    _messageLabel = [[UILabel alloc] initForAutoLayout];
    _messageLabel.numberOfLines = 0;
    _messageLabel.backgroundColor = [UIColor clearColor];
    _messageLabel.font = [UIFont systemFontOfSize:15];
    [_messageView addSubview:_messageLabel];
    
    _btnView = [[UIView alloc] initForAutoLayout];
    [_contentView addSubview:_btnView];
}

+ (instancetype)showErrorMessage:(NSString *)message {
    return [self showWithMessage:message iconType:ZKAlertIconTypeAttention buttonTitle:@"OK"];
}

+ (instancetype)showWithMessage:(NSString *)message
                       iconType:(ZKAlertIconType)type
                    buttonTitle:(NSString *)buttonTitle
{
    ZKAlertView *alertView = [self initWithTitle:nil
                                           message:message
                                          iconType:type
                                 cancelButtonTitle:buttonTitle?:@"确定"
                                 otherButtonTitles:nil];
    [alertView showWithCompletionBlock:nil];
    
    return alertView;
}

+ (instancetype)showYesAndNoWithMessage:(NSString *)message done:(void (^)(NSInteger buttonIndex))completionBlock {
    return [self showWithMessage:message cancelTitle:@"いいえ" doneTitle:@"はい" done:completionBlock];
}

+ (instancetype)showWithMessage:(NSString *)message cancelTitle:(NSString *)cancelTitle doneTitle:(NSString *)doneTitle done:(void (^)(NSInteger buttonIndex))completionBlock {
    ZKAlertView *alertView = [self initWithTitle:nil
                                           message:message
                                          iconType:ZKAlertIconTypeAttention
                                 cancelButtonTitle:cancelTitle
                                 otherButtonTitles:doneTitle, nil];
    [alertView showWithCompletionBlock:completionBlock];
    
    return alertView;
}

+ (instancetype)showWithTitle: (NSString *)title message:(NSString *)message cancelTitle:(NSString *)cancelTitle doneTitle:(NSString *)doneTitle done:(void (^)(NSInteger buttonIndex))completionBlock {
    ZKAlertView *alertView = [self initWithTitle:title
                                           message:message
                                          iconType:ZKAlertIconTypeAttention
                                 cancelButtonTitle:cancelTitle
                                 otherButtonTitles:doneTitle, nil];
    [alertView showWithCompletionBlock:completionBlock];
    
    return alertView;
}

+ (instancetype)showWithMessage:(NSString *)message
                       iconType:(ZKAlertIconType)type
                    buttonTitle:(NSString *)buttonTitle
                           done:(void (^)(NSInteger buttonIndex))completionBlock
{
    ZKAlertView *alertView = [self initWithTitle:nil
                                           message:message
                                          iconType:type
                                 cancelButtonTitle:buttonTitle?:@"确定"
                                 otherButtonTitles:nil];
    [alertView showWithCompletionBlock:completionBlock];
    
    return alertView;
}

+ (instancetype)showWithTitle:(NSString *)title
                      message:(NSString *)message
                     iconType:(ZKAlertIconType)type
                  buttonTitle:(NSString *)buttonTitle
{
    ZKAlertView *alertView = [self initWithTitle:title
                                           message:message
                                          iconType:type
                                 cancelButtonTitle:buttonTitle?:@"确定"
                                 otherButtonTitles:nil];
    [alertView showWithCompletionBlock:nil];
    
    return alertView;
}

+ (instancetype)initWithMessage:(NSString *)message
                       iconType:(ZKAlertIconType)iconType
              cancelButtonTitle:(NSString *)cancelButtonTitle
{
    return [self initWithTitle:nil
                       message:message
                      iconType:iconType
             cancelButtonTitle:cancelButtonTitle
             otherButtonTitles:nil];
}

+ (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
                     iconType:(ZKAlertIconType)iconType
            cancelButtonTitle:(NSString *)cancelButtonTitle
{
    return [self initWithTitle:title
                       message:message
                      iconType:iconType
             cancelButtonTitle:cancelButtonTitle
             otherButtonTitles:nil];
}

+ (instancetype)initWithMessage:(NSString *)message
                       iconType:(ZKAlertIconType)iconType
              cancelButtonTitle:(NSString *)cancelButtonTitle
              otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION
{
    NSMutableArray *otherTitleArray = [NSMutableArray array];
    va_list _arguments;
    va_start(_arguments, otherButtonTitles);
    for (NSString *key = otherButtonTitles; key != nil; key = (__bridge NSString *)va_arg(_arguments, void *)) {
        [otherTitleArray addObject:key];
    }
    va_end(_arguments);
    
    return [self initWithTitle:nil
                       message:message
                      iconType:iconType
             cancelButtonTitle:cancelButtonTitle
         otherButtonTitleArray:otherTitleArray];
}

+ (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
                     iconType:(ZKAlertIconType)iconType
            cancelButtonTitle:(NSString *)cancelButtonTitle
            otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION
{
    NSMutableArray *otherTitleArray = [NSMutableArray array];
    va_list _arguments;
    va_start(_arguments, otherButtonTitles);
    for (NSString *key = otherButtonTitles; key != nil; key = (__bridge NSString *)va_arg(_arguments, void *)) {
        [otherTitleArray addObject:key];
    }
    va_end(_arguments);
    
    return [self initWithTitle:title
                       message:message
                      iconType:iconType
             cancelButtonTitle:cancelButtonTitle
         otherButtonTitleArray:otherTitleArray];
}

+ (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
                     iconType:(ZKAlertIconType)iconType
            cancelButtonTitle:(NSString *)cancelButtonTitle
        otherButtonTitleArray:(NSArray *)otherButtonTitleArray
{
    ZKAlertView *alerView = [[ZKAlertView alloc] init];
    
    NSString *imageName = nil;
    switch (iconType) {
        case ZKAlertIconTypeHeart:
            imageName = @"ZKAlertView_heart";
            break;
        case ZKAlertIconTypeAttention:
            imageName = @"ZKAlertView_attention";
            break;
        case ZKAlertIconTypeCamera:
            imageName = @"ZKAlertView_camera";
            break;
        case ZKAlertIconTypeTrash:
            imageName = @"ZKAlertView_trash";
            break;
        case ZKAlertIconTypeIdentification:
            imageName = @"ZKAlertView_identification";
            break;
    }
    alerView.iconView.image = [UIImage imageNamed:imageName];
    
    if (message) {
        
        if (title) {
            CGFloat titleFontSize = 16.f;
            UIFont *titleFont = [UIFont boldSystemFontOfSize:titleFontSize];
            CGFloat titleWidth = [title stringWidthWithFont:titleFont height:titleFontSize];
            
            // title只能显示一行
            while (titleWidth > MsgLabelWidth) {
                titleFontSize --;
                titleWidth = [title stringWidthWithFont:[UIFont boldSystemFontOfSize:titleFontSize]
                                                 height:titleFontSize];
            }
            NSMutableAttributedString *mutableAttriString = [[NSMutableAttributedString alloc] init];
            
            NSAttributedString *titleAttributeString = [self attributedString:title
                                                                     FontSize:titleFontSize
                                                                  lineSpacing:4.f];
            [mutableAttriString appendAttributedString:titleAttributeString];
            
            NSAttributedString *msgAttributeString = [self attributedString:[NSString stringWithFormat:@"\n%@",message]
                                                                   FontSize:15.f
                                                                lineSpacing:1.f];
            [mutableAttriString appendAttributedString:msgAttributeString];
            
            alerView.messageLabel.attributedText = mutableAttriString;
        }
        else {
            NSAttributedString *msgAttributeString = [self attributedString:message
                                                                   FontSize:15.f
                                                                lineSpacing:1.f];
            alerView.messageLabel.attributedText = msgAttributeString;
        }
    }
    
    NSMutableArray *dataSource = [otherButtonTitleArray mutableCopy];
    if (!cancelButtonTitle||!cancelButtonTitle.length) {
        cancelButtonTitle = @"取消";
    }
    [dataSource insertObject:cancelButtonTitle atIndex:0];
    
    [alerView createButton:dataSource];
    
    return alerView;
}

+ (NSAttributedString *)attributedString:(NSString *)string
                                FontSize:(CGFloat)fontSize
                             lineSpacing:(CGFloat)lineSpacing
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpacing;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    
    NSDictionary *attributes = @{ NSFontAttributeName:[UIFont boldSystemFontOfSize:fontSize],
                                  NSParagraphStyleAttributeName:paragraphStyle };
    
    NSAttributedString *attributeString = [[NSAttributedString alloc]
                                           initWithString:string attributes:attributes];
    return attributeString;
}

- (void)createButton:(NSArray *)dataSource
{
    _btnCount = dataSource.count;
    NSMutableArray <UIView *> *viewArray = [[NSMutableArray alloc] init];
    for (int i = 0; i<MIN(2, dataSource.count); i++) {
        UIView *view = [[UIView alloc] initForAutoLayout];
        [_btnView addSubview:view];
        
        NSString *btnStr = dataSource[dataSource.count-i-1];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = dataSource.count-i;
        [button addTarget:self action:@selector(clickbtn:) forControlEvents:UIControlEventTouchUpInside];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [button setTitle:btnStr forState:UIControlStateNormal];
        [button addTarget:self action:@selector(removeColor:) forControlEvents:UIControlEventTouchUpOutside];
        [button addTarget:self action:@selector(exchangeColor:) forControlEvents:UIControlEventTouchDown];
        
        [view addSubview:button];
        if (dataSource.count == 1) {
            button.backgroundColor = HexColor(0xa871e2);
        }
        else{
            if (i) {
                button.backgroundColor = HexColor(0xf3f3f3);
            }
            else {
                button.backgroundColor = HexColor(0xa871e2);
            }
        }
        if (dataSource.count >= 2) {
            [button setTitleColor:button.tag==2?[UIColor whiteColor]:HexColor(0x808080) forState:UIControlStateNormal];
        }
        else {
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        
        
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = 35*0.5;
        
        [button autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        
        [viewArray addObject:view];
    }
    
    for (int i = 0;i<viewArray.count;i++) {
        
        [viewArray[i] autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0];
        [viewArray[i] autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
        if (i<viewArray.count-1) {
            [viewArray[i] autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:viewArray[i+1] withOffset:5*WindowZoomScale];
        }
    }
    
    if (viewArray.count == 1) {
        UIButton *button = viewArray.firstObject.subviews.firstObject;
        CGFloat currentTitleWidth = [button.currentTitle
                                     stringWidthWithFont:button.titleLabel.font
                                     height:MAXFLOAT];
        CGFloat rightLeftInset = MAX((AlertViewWidth-(currentTitleWidth+70.f))*0.5, 20.f);
        [viewArray[0] autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:rightLeftInset];
        [viewArray[0] autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:rightLeftInset];
    }
    else {
        [viewArray[0] autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:20.f];
        [viewArray[viewArray.count-1] autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:20.f];
        [viewArray autoMatchViewsDimension:ALDimensionWidth];
    }
}

- (void)exchangeColor:(UIButton *)button{
    if (button.highlighted) {
        
        if (button.tag == 2) {
            button.backgroundColor = HexColor(0x8d58c6);
        } else {
            if (_btnCount == 2) {
                button.backgroundColor = HexColor(0xb3b3b3);
            }
            else {
                button.backgroundColor = HexColor(0x8d58c6);
                
            }
        }
    }
}

- (void)removeColor:(UIButton *)button{
    if (button.tag == 2) {
        button.backgroundColor = HexColor(0xa871e2);
    }else {
        if (_btnCount == 2) {
            button.backgroundColor = HexColor(0xf3f3f3);
        }
        else {
            button.backgroundColor = HexColor(0xa871e2);
        }
    }
}

- (void)clickbtn:(UIButton *)button
{
    [self clickedIndex:button.tag-1];
}

- (void)clickedIndex:(NSInteger)index{
    _completeBlock?_completeBlock(index):nil;
    
    [UIView animateWithDuration:.2 animations:^{
        self.contentView.transform = CGAffineTransformMakeScale(.1, .1);
        _bgView.backgroundColor =  [UIColor clearColor];
        self.contentView.alpha = 0;
    } completion:^(BOOL finished) {
        _completeBlock = nil;
        [self removeFromSuperview];
    }];
}

- (void)showWithCompletionBlock:(void (^)(NSInteger buttonIndex))completionBlock
{
    _completeBlock = completionBlock;
    
    UIWindow *topWindow = nil;
    for (UIWindow *testWindow in [[[UIApplication sharedApplication] windows] reverseObjectEnumerator]) {
        if (![[testWindow class] isEqual:[UIWindow class]]) {
            topWindow = testWindow;
            break;
        }
    }
    [topWindow?:KeyWindow addSubview:self];
    
    [self autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    
    self.contentView.transform = CGAffineTransformMakeScale(.1, .1);
    _bgView.alpha = 0;
    self.contentView.alpha =  0.5;
    
    [UIView animateWithDuration:.25 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.contentView.transform = CGAffineTransformMakeScale(1, 1);
        self.contentView.alpha = 1;
        _bgView.alpha = 1;
    } completion:nil];
}

- (void)dealloc
{
    NSLog(@"%@ dealloc",NSStringFromClass([self class]));
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [_bgView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    
    [_contentView autoSetDimensionsToSize:CGSizeMake(AlertViewWidth, AlertViewHeight)];
    [_contentView autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [_contentView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    _contentView.layer.mask = self.shapeLayer;
    
    [_iconView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:11.f*WindowZoomScale];
    [_iconView autoSetDimensionsToSize:CGSizeMake(14.f*WindowZoomScale, 14.f*WindowZoomScale)];
    [_iconView autoAlignAxisToSuperviewAxis:ALAxisVertical];
    
    [_messageView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:30.f];
    [_messageView autoSetDimensionsToSize:CGSizeMake(AlertViewWidth, AlertViewHeight-105.f)];
    [_messageView autoAlignAxisToSuperviewAxis:ALAxisVertical];
    
    [_messageLabel autoCenterInSuperview];
    [_messageLabel autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:_messageView];
    [_messageLabel autoSetDimension:ALDimensionWidth toSize:MsgLabelWidth];
    
    [_btnView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:_contentView withOffset:-35.f];
    [_btnView autoSetDimensionsToSize:CGSizeMake(AlertViewWidth, 35.f*WindowZoomScale)];
    [_btnView autoAlignAxisToSuperviewAxis:ALAxisVertical];
}

- (CGFloat)textEstimatedHeightWithFont:(UIFont *)font width:(float)width
{
    if (_messageLabel.text == nil || _messageLabel.text.length == 0) {
        return 0;
    }
    
    NSString *copyString = [NSString stringWithFormat:@"%@", _messageLabel.text];
    
    CGSize size = CGSizeZero;
    CGSize constrainedSize = CGSizeMake(width, CGFLOAT_MAX);
    
    if ([copyString respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        
        NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
        paragraph.lineBreakMode = NSLineBreakByWordWrapping; //e.g.
        paragraph.lineSpacing = 3.f;
        
        size = [copyString boundingRectWithSize:constrainedSize
                                        options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                     attributes:@{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraph }
                                        context:nil].size;
    }else{
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
        size = [copyString sizeWithFont:font constrainedToSize:constrainedSize lineBreakMode:NSLineBreakByWordWrapping];
#pragma GCC diagnostic pop
    }
    
    return ceilf(size.height);
}

- (CAShapeLayer *)shapeLayer
{
    if (!_shapeLayer) {
        _shapeLayer = [CAShapeLayer zk_createMaskLayerWithbounds:CGRectMake(0, 0, AlertViewWidth, AlertViewHeight) cornerWidth:7.f];
    }
    return _shapeLayer;
}

@end

//----------

@implementation CAShapeLayer (ZKViewMask)

+ (instancetype)zk_createMaskLayerWithbounds:(CGRect)bounds cornerWidth:(CGFloat)cornerWidth
{
    CAShapeLayer *layer = [CAShapeLayer layer];
    CGMutablePathRef maskPath = CGPathCreateMutable();
    
    CGFloat radius = 20.f*WindowZoomScale;
    CGFloat trimAngle = M_PI/20; //若调整半圆的高低 修改此值
    
    CGPathAddRoundedRect(maskPath, nil, CGRectInset(bounds, 0, radius),cornerWidth,cornerWidth);
    
    //创建Path
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, bounds.size.width*0.5-radius, radius);
    CGFloat translation = radius*tanf(trimAngle);
    CGPathAddArc(path, NULL, bounds.size.width*0.5, radius+translation, radius, -trimAngle, M_PI+trimAngle, YES);
    
    CGPathAddPath(maskPath, nil, path);
    
    layer.strokeColor = [UIColor blackColor].CGColor;
    layer.path = maskPath;
    return layer;
}

@end
