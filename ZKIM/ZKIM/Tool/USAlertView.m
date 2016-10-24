//
//  USAlertView.m
//  USEvent
//
//  Created by marujun on 15/10/23.
//  Copyright © 2015年 MaRuJun. All rights reserved.
//

#import "USAlertView.h"

#define MsgLabelWidth   (210.f*WindowZoomScale)

@interface USAlertView ()
{
    UILabel *_bgView;
    UIView *_btnView;
    UIView *_messageView;
    NSInteger _btnCount;
}

@property (nonatomic, copy) void (^completeBlock)(NSInteger buttonIndex);
@property (nonatomic, strong) NSString *cancelButtonTitle;
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) NSMutableArray *viewArray;

@end

@implementation USAlertView

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
    [_bgView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    
    _contentView = [[UIView alloc] initForAutoLayout];
    _contentView.backgroundColor = [UIColor clearColor];
    [_contentView autoSetDimensionsToSize:CGSizeMake(245*WindowZoomScale, 162*WindowZoomScale)];
    [self addSubview:_contentView];
    
    [_contentView autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [_contentView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    
    _messageView = [[UIView alloc] initForAutoLayout];
    _messageView.backgroundColor = [UIColor whiteColor];
    _messageView.layer.cornerRadius = 7*WindowZoomScale;
    _messageView.layer.masksToBounds = YES;
    [_contentView addSubview:_messageView];
    
    [_messageView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
    [_messageView autoSetDimension:ALDimensionHeight toSize:120*WindowZoomScale];
    
    _messageLabel = [[UILabel alloc] initForAutoLayout];
    _messageLabel.numberOfLines = 3;
    _messageLabel.font = [UIFont systemFontOfSize:15];
    [_messageView addSubview:_messageLabel];
    [_messageLabel autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [_messageLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [_messageLabel autoSetDimensionsToSize:CGSizeMake(MsgLabelWidth, 120*WindowZoomScale)];
    
    _btnView = [[UIView alloc] initForAutoLayout];
    _btnView.backgroundColor = [UIColor clearColor];
    [_contentView addSubview:_btnView];
    [_btnView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
    [_btnView autoSetDimension:ALDimensionHeight toSize:35*WindowZoomScale];
}

+ (instancetype)showWithMessage:(NSString *)message
{
    USAlertView *alertView = [self initWithTitle:nil message:message cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alertView showWithCompletionBlock:nil];
    
    return alertView;
}

+ (instancetype)showWithTitle:(NSString *)title message:(NSString *)message
{
    USAlertView *alertView = [self initWithTitle:title message:message cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alertView showWithCompletionBlock:nil];
    
    return alertView;
}


+ (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
            cancelButtonTitle:(NSString *)cancelButtonTitle
{
    return [self initWithTitle:title message:message cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil];
}

+ (instancetype)initWithMessage:(NSString *)message
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
    
    return [self initWithTitle:nil message:message cancelButtonTitle:cancelButtonTitle otherButtonTitleArray:otherTitleArray];
}

+ (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
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
    
    return [self initWithTitle:title message:message cancelButtonTitle:cancelButtonTitle otherButtonTitleArray:otherTitleArray];
}

+ (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
            cancelButtonTitle:(NSString *)cancelButtonTitle
        otherButtonTitleArray:(NSArray *)otherButtonTitleArray
{
    id class = NSClassFromString(@"MCAlertView");
    return (id)[class initWithTitle:title
                            message:message
                  cancelButtonTitle:cancelButtonTitle
              otherButtonTitleArray:otherButtonTitleArray];
    
//    USAlertView *alerView = [[USAlertView alloc] init];
//    
//    if (message) {
//        
//        if (title) {
//            CGFloat titleFontSize = 16.f;
//            UIFont *titleFont = [UIFont systemFontOfSize:titleFontSize];
//            CGFloat titleWidth = [title stringWidthWithFont:titleFont height:titleFontSize];
//            
//            // title只能显示一行
//            while (titleWidth > MsgLabelWidth) {
//                titleFontSize --;
//                titleWidth = [title stringWidthWithFont:[UIFont systemFontOfSize:titleFontSize]
//                                                 height:titleFontSize];
//            }
//            NSMutableAttributedString *mutableAttriString = [[NSMutableAttributedString alloc] init];
//            
//            NSAttributedString *titleAttributeString = [self attributedString:title
//                                                                     FontSize:titleFontSize
//                                                                  lineSpacing:8.f];
//            [mutableAttriString appendAttributedString:titleAttributeString];
//            
//            NSAttributedString *msgAttributeString = [self attributedString:[NSString stringWithFormat:@"\n%@",message]
//                                                                   FontSize:13.f
//                                                                lineSpacing:3.f];
//            [mutableAttriString appendAttributedString:msgAttributeString];
//    
//            alerView.messageLabel.attributedText = mutableAttriString;
//            
//            
//        }
//        else {
//            NSAttributedString *msgAttributeString = [self attributedString:message
//                                                                   FontSize:14.f
//                                                                lineSpacing:8.f];
//            alerView.messageLabel.attributedText = msgAttributeString;
//        }
//    }
//    
//    NSMutableArray *dataSource = [otherButtonTitleArray mutableCopy];
//    if (!cancelButtonTitle||!cancelButtonTitle.length) {
//        cancelButtonTitle = @"取消";
//    }
//    [dataSource insertObject:cancelButtonTitle atIndex:0];
//    
//    [alerView createButton:dataSource];
//    
//    return alerView;
}

+ (NSAttributedString *)attributedString:(NSString *)string FontSize:(CGFloat)fontSize lineSpacing:(CGFloat)lineSpacing
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpacing;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    
    NSDictionary *attributes = @{ NSFontAttributeName:[UIFont systemFontOfSize:fontSize],
                                NSParagraphStyleAttributeName:paragraphStyle
                                };
    
    NSAttributedString *attributeString = [[NSAttributedString alloc]
                                           initWithString:string attributes:attributes];
    return attributeString;
}

- (void)createButton:(NSArray *)dataSource
{
    _btnCount = dataSource.count;
    NSMutableArray *viewArray = [[NSMutableArray alloc] init];
    for (int i = 0; i<MIN(2, dataSource.count); i++) {
        UIView *view = [[UIView alloc] initForAutoLayout];
        [_btnView addSubview:view];
        
        NSString *btnStr = dataSource[dataSource.count-i-1];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = dataSource.count-i;
        [button addTarget:self action:@selector(clickbtn:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button setTitle:btnStr forState:UIControlStateNormal];
        [button addTarget:self action:@selector(removeColor:) forControlEvents:UIControlEventTouchUpOutside];
        [button addTarget:self action:@selector(exchangeColor:) forControlEvents:UIControlEventTouchDown];
        
        [view addSubview:button];
        if (dataSource.count == 1) {
            button.backgroundColor = KB_TINT_COLOR;
        }else{
            if (i) {
                button.backgroundColor = HexColor(0xd7d7d7);
            }else {
                button.backgroundColor = KB_TINT_COLOR;
            }
        }
        
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = 7*WindowZoomScale;
        [button autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        
        [viewArray addObject:view];
    }
    
    for (int i = 0;i<viewArray.count;i++) {
        
        [viewArray[i] autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0];
        [viewArray[i] autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
        if (i<viewArray.count-1) {
            [viewArray[i] autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:viewArray[i+1]];
            [viewArray[i] autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:viewArray[i+1] withOffset:5*WindowZoomScale];
        }
    }
    
    [viewArray[0] autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
    [viewArray[viewArray.count-1] autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    
    if (viewArray.count>1) {
        [viewArray autoMatchViewsDimension:ALDimensionWidth];
    }
}

- (void)exchangeColor:(UIButton *)button{
    if (button.highlighted) {
        
        if (button.tag == 2) {
            button.backgroundColor = KB_TINT_HIGHLIGHT_COLOR;
        } else {
            if (_btnCount == 2) {
                button.backgroundColor = HexColor(0xb3b3b3);
            } else {
                button.backgroundColor = KB_TINT_HIGHLIGHT_COLOR;

            }
        }
    }
}

- (void)removeColor:(UIButton *)button{
    if (button.tag == 2) {
        button.backgroundColor = KB_TINT_COLOR;
    }else {
        if (_btnCount == 2) {
            button.backgroundColor = HexColor(0xd7d7d7);
        } else {
            button.backgroundColor = KB_TINT_COLOR;
        }
    }
}

- (void)clickbtn:(UIButton *)button
{
    [self clickedIndex:button.tag-1];
}

- (void)clickedIndex:(NSInteger)index{
    _completeBlock?_completeBlock(index):nil;
    
    [UIView animateWithDuration:.25 animations:^{
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
    for (UIWindow *testWindow in [[UIApplication sharedApplication] windows])
    {
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
    
    [UIView animateWithDuration:.25 animations:^{
        self.contentView.transform = CGAffineTransformMakeScale(1, 1);
        self.contentView.alpha = 1;
        _bgView.alpha = 1;
    }];
}

- (void)dealloc
{
    NSLog(@"%@ dealloc",NSStringFromClass([self class]));
}

@end
