//
//  ZKRecordHelper.m
//  ZKIM
//
//  Created by ZK on 16/10/31.
//  Copyright © 2016年 ZK. All rights reserved.
//

#import "ZKRecordHelper.h"
#import "ZKRecordView.h"
#import "EMCDDeviceManager.h"

@interface ZKRecordHelper ()

@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) ZKRecordView *recordView;
@property (nonatomic, assign) BOOL btnIsOutside;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSTimeInterval remainSections;

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
    _remainSections = 0;
    
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
    [_button addTarget:self action:@selector(cancelRecord) forControlEvents:UIControlEventTouchUpOutside];
    [_button addTarget:self action:@selector(cancelRecord) forControlEvents:UIControlEventTouchCancel];
}

#pragma mark - Actions

- (void)startRecord
{
    [_recordView show];
    DLog(@"开始录音");
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 block:^(NSTimer * _Nonnull timer) {
        _remainSections += 1;
        if (_remainSections >= 3) {
            [timer invalidate];
        }
    } repeats:YES];
    
    NSString *dateStr = [[NSDate date] timestamp];
    NSString *pathStr = [NSString stringWithFormat:@"%@%zd", dateStr, Random(0, 100000)];
    
    [[EMCDDeviceManager sharedInstance] asyncStartRecordingWithFileName:pathStr completion:^(NSError *error) {
        if (error) {
            DLog(@"%@", error.description);
        }
    }];
    
    if ([self.delegate respondsToSelector:@selector(recordHelperDidStartRecord)]) {
        [self.delegate recordHelperDidStartRecord];
    }
}

- (void)endRecord
{
    DLog(@"结束录音");
    
    if (_remainSections <= 2) {
        DLog(@"录音时间太短!");
        [_recordView showTooShort];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            _remainSections = 0;
            [self cancelRecord];
        });
        
        return;
    }
    [_recordView hide];
    
    [[EMCDDeviceManager sharedInstance] asyncStopRecordingWithCompletion:^(NSString *recordPath, NSInteger aDuration, NSError *error) {
        DLog(@"路径 == %@  时长 == %zd", recordPath, aDuration);
        if (error) {
            DLog(@"录音失败 == %@", error);
            return;
        }
        _remainSections = 0;
        // 结束录音后 将录音信息传给代理
        ZKMediaModel *model = [ZKMediaModel new];
        model.audioPath = recordPath.copy;
        model.audioDuration = aDuration;
        
        if ([self.delegate respondsToSelector:@selector(recordHelperDidEndRecordMediaModel:mediaType:)]) {
            [self.delegate recordHelperDidEndRecordMediaModel:model mediaType:MediaType_Audio];
        }
    }];
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

- (void)cancelRecord
{
    [_recordView hide];
    [[EMCDDeviceManager sharedInstance] cancelCurrentRecording];
    DLog(@"取消录音");
    if ([self.delegate respondsToSelector:@selector(recordHelperDidCancelRecord)]) {
        [self.delegate recordHelperDidCancelRecord];
    }
}

@end
