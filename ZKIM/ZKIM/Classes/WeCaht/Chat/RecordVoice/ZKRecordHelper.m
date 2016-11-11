//
//  ZKRecordHelper.m
//  ZKIM
//
//  Created by ZK on 16/10/31.
//  Copyright © 2016年 ZK. All rights reserved.
//

#import "ZKRecordHelper.h"
#import "ZKRecordView.h"

@interface ZKRecordHelper ()

@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) ZKRecordView *recordView;
@property (nonatomic, assign) BOOL btnIsOutside;

@end

@implementation ZKRecordHelper

- (instancetype)init
{
    if (self = [super init]) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    _btnIsOutside = NO;
    
    _recordView = [ZKRecordView shareRecordView];
    [KeyWindow addSubview:_recordView];
    [_recordView hide];
}

+ (ZKRecordHelper *)recordHelperWithButton:(UIButton *)button
{
    ZKRecordHelper *helper = [[ZKRecordHelper alloc] init];
    helper.button = button;
    return helper;
}

#pragma mark - Setter

- (void)setButton:(UIButton *)button
{
    _button = button;
    
    [_button addTarget:self action:@selector(startRecord) forControlEvents:UIControlEventTouchDown];
    [_button addTarget:self action:@selector(endRecord) forControlEvents:UIControlEventTouchUpInside];
    [_button addTarget:self action:@selector(dragInside) forControlEvents:UIControlEventTouchDragInside];
    [_button addTarget:self action:@selector(dragOutside) forControlEvents:UIControlEventTouchDragOutside];
    [_button addTarget:self action:@selector(cancleRecord) forControlEvents:UIControlEventTouchUpOutside];
    [_button addTarget:self action:@selector(cancleRecord) forControlEvents:UIControlEventTouchCancel];
}

#pragma mark - Actions

- (void)startRecord
{
    [_recordView show];
    if ([self.delegate respondsToSelector:@selector(recordHelperDidStartRecord)]) {
        [self.delegate recordHelperDidStartRecord];
    }
}

- (void)endRecord
{
    [_recordView hide];
    if ([self.delegate respondsToSelector:@selector(recordHelperDidEndRecordWithData:duration:)]) {
        [self.delegate recordHelperDidEndRecordWithData:nil duration:0];
    }
}

- (void)dragInside
{
    if (_btnIsOutside) {
        [_recordView hideCancelBtn];
    }
    _btnIsOutside = NO;
}

- (void)dragOutside
{
    if (!_btnIsOutside) {
        [_recordView showCancelBtn];
    }
    _btnIsOutside = YES;
}

- (void)cancleRecord
{
    [_recordView hide];
    if ([self.delegate respondsToSelector:@selector(recordHelperDidCancelRecord)]) {
        [self.delegate recordHelperDidCancelRecord];
    }
}

@end
