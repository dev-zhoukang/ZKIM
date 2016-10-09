//
//  ZKChatRefreshHeader.m
//  ZKIM
//
//  Created by ZK on 16/10/9.
//  Copyright © 2016年 ZK. All rights reserved.
//

#import "ZKChatRefreshHeader.h"

@interface ZKChatRefreshHeader ()

@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;
@property (nonatomic, weak) UITableView *targetTableView;
@property (nonatomic, copy) void(^refreshBlock)();
@property (nonatomic, assign) BOOL isRefreshing;
@property (nonatomic, strong) UILabel *hintLabel;

@end

@implementation ZKChatRefreshHeader

#pragma mark - Init

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    _isRefreshing = NO;
    
    _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [_indicatorView startAnimating];
    [self addSubview:_indicatorView];
    
    _hintLabel = [[UILabel alloc] init];
    _hintLabel.font = [UIFont systemFontOfSize:12.f];
    _hintLabel.textAlignment = NSTextAlignmentCenter;
    _hintLabel.textColor = [UIColor grayColor];
    [self addSubview:_hintLabel];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.frame = (CGRect){CGPointZero, SCREEN_WIDTH, 50.f};
    _indicatorView.center = (CGPoint){self.center.x, self.center.y+15.f};
    
    _hintLabel.frame = (CGRect){0, self.center.y-8.f, self.width, 30.f};
}

#pragma mark - Public

+ (instancetype)headerWithTableView:(UITableView *)tableView refreshBlock:(void (^)())block
{
    ZKChatRefreshHeader *header = [[ZKChatRefreshHeader alloc] init];
    header.targetTableView = tableView;
    header.refreshBlock = block;
    [header.targetTableView setTableHeaderView:header];
    // 监听contentOffset
    [tableView addObserver:header forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    
    return header;
}

- (void)endRefresh
{
    DLog(@"------endRefresh");
    _isRefreshing = NO;
}

- (void)noMoreData
{
    [_indicatorView stopAnimating];
    _hintLabel.text = @"---- 已经加载全部数据 ----";
}

#pragma mark 监听UIScrollView的contentOffset属性
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (![@"contentOffset" isEqualToString:keyPath]){
        return;
    }
    
    [self scrollViewDidScroll:_targetTableView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.hidden) {
        return;
    }
    
    CGFloat offset_y = scrollView.contentOffset.y;
    
    if (offset_y < 0 && !_isRefreshing) {
        !_refreshBlock?:_refreshBlock();
        
        _isRefreshing = YES;
    }
}

- (void)free
{
    [_targetTableView removeObserver:self forKeyPath:@"contentOffset"];
}

@end
