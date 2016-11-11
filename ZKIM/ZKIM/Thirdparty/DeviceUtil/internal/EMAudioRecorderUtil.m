//
//  EMAudioRecorderUtil.m
//  ChatDemo-UI2.0
//
//  Created by dujiepeng on 5/8/15.
//  Copyright (c) 2015 dujiepeng. All rights reserved.
//

#import "EMAudioRecorderUtil.h"
#import "EMErrorCode.h"

static EMAudioRecorderUtil *audioRecorderUtil = nil;

@interface EMAudioRecorderUtil () <AVAudioRecorderDelegate> {
    NSDate *_startDate;
    NSDate *_endDate;
    
    void (^recordFinish)(NSString *recordPath);
}
@property (nonatomic, strong) AVAudioRecorder *recorder;
@property (nonatomic, strong) NSDictionary *recordSetting_low;
@property (nonatomic, strong) NSDictionary *recordSetting_medium;
@property (nonatomic, strong) NSDictionary *recordSetting_high;
@property (nonatomic, strong) NSDictionary *recordSetting_max;

@end

@implementation EMAudioRecorderUtil

#pragma mark - Public
// 当前是否正在录音
+(BOOL)isRecording {
    return [[EMAudioRecorderUtil sharedInstance] isRecording];
}

// 开始录音
+ (void)asyncStartRecordingWithPreparePath:(NSString *)aFilePath
                                completion:(void(^)(NSError *error))completion {
    
    [EMAudioRecorderUtil asyncStartRecordingWithPreparePath:aFilePath
                                                qualityType:ZKAudioRecordQualityLow
                                                 completion:completion];
}

+ (void)asyncStartRecordingWithPreparePath:(NSString *)aFilePath
                               qualityType:(ZKAudioRecordQualityType)qualityType
                                completion:(void(^)(NSError *error))completion {
    
    [[EMAudioRecorderUtil sharedInstance] asyncStartRecordingWithPreparePath:aFilePath
                                                                 qualityType:qualityType
                                                                  completion:completion];
}

// 停止录音
+(void)asyncStopRecordingWithCompletion:(void(^)(NSString *recordPath))completion {
    [[EMAudioRecorderUtil sharedInstance] asyncStopRecordingWithCompletion:completion];
}

// 取消录音
+(void)cancelCurrentRecording {
    [[EMAudioRecorderUtil sharedInstance] cancelCurrentRecording];
}

+(AVAudioRecorder *)recorder {
    return [EMAudioRecorderUtil sharedInstance].recorder;
}

- (BOOL)isRecording {
    return !!_recorder;
}

// 开始录音，文件放到aFilePath下
- (void)asyncStartRecordingWithPreparePath:(NSString *)aFilePath
                               qualityType:(ZKAudioRecordQualityType)qualityType
                                completion:(void(^)(NSError *error))completion {
    NSError *error = nil;
    NSString *wavFilePath = [[aFilePath stringByDeletingPathExtension]
                             stringByAppendingPathExtension:@"wav"];
    NSURL *wavUrl = [[NSURL alloc] initFileURLWithPath:wavFilePath];
    
    NSDictionary *setting = [self getRecordSettingWithQuality:qualityType];
    
    _recorder = [[AVAudioRecorder alloc] initWithURL:wavUrl
                                            settings:setting?:self.recordSetting_low
                                               error:&error];
    if(!_recorder || error) {
        _recorder = nil;
        if (completion) {
            error = [NSError errorWithDomain:@"Failed to initialize AVAudioRecorder"
                                        code:EMErrorGeneral
                                    userInfo:nil];
            completion(error);
        }
        return;
    }
    _startDate = [NSDate date];
    _recorder.meteringEnabled = YES;
    _recorder.delegate = self;
    
    [_recorder record];
    if (completion) {
        completion(error);
    }
}

// 停止录音
- (void)asyncStopRecordingWithCompletion:(void(^)(NSString *recordPath))completion {
    recordFinish = completion;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self->_recorder stop];
    });
}

// 取消录音
- (void)cancelCurrentRecording {
    _recorder.delegate = nil;
    if (_recorder.recording) {
        [_recorder stop];
    }
    _recorder = nil;
    recordFinish = nil;
}

#pragma mark - AVAudioRecorderDelegate
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder
                           successfully:(BOOL)flag {
    NSString *recordPath = [[_recorder url] path];
    if (recordFinish) {
        if (!flag) {
            recordPath = nil;
        }
        recordFinish(recordPath);
    }
    _recorder = nil;
    recordFinish = nil;
}

- (void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder
                                   error:(NSError *)error {
    NSLog(@"audioRecorderEncodeErrorDidOccur");
}

#pragma mark - Private
+(EMAudioRecorderUtil *)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        audioRecorderUtil = [[self alloc] init];
    });
    
    return audioRecorderUtil;
}

- (instancetype)init {
    if (self = [super init]) {
        
    }
    
    return self;
}

- (NSDictionary *)getRecordSettingWithQuality:(ZKAudioRecordQualityType)qualityType
{
    switch (qualityType) {
        case ZKAudioRecordQualityLow: {
            return self.recordSetting_low;
        } break;
        case ZKAudioRecordQualityMedium: {
            return self.recordSetting_medium;
        } break;
        case ZKAudioRecordQualityHigh: {
            return self.recordSetting_high;
        } break;
        case ZKAudioRecordQualityMax: {
            return self.recordSetting_max;
        } break;
    }
}

- (void)dealloc {
    if (_recorder) {
        _recorder.delegate = nil;
        [_recorder stop];
        [_recorder deleteRecording];
        _recorder = nil;
    }
    recordFinish = nil;
}

#pragma mark - getter

- (NSDictionary *)recordSetting_low {
    if (!_recordSetting_low) {
        _recordSetting_low = @{ AVSampleRateKey:@(8000.f), //采样率
                                AVFormatIDKey:@(kAudioFormatLinearPCM),
                                AVLinearPCMBitDepthKey:@(16), //采样位数 默认 16
                                AVNumberOfChannelsKey:@(1) };
    }
    
    return _recordSetting_low;
}

- (NSDictionary *)recordSetting_medium
{
    if (!_recordSetting_medium) {
        _recordSetting_medium = @{ /**
                                    采样率 44.1kHZ和标准的CD Audio是相同的, 32KHZ, 24KHZ, 16KHZ, 12KHZ, 8KHZ是电话采样率，对一般的录音已经足够了
                                    */
                                  AVSampleRateKey:@(16000.f), //采样率
                                  AVFormatIDKey:@(kAudioFormatLinearPCM),
                                  AVLinearPCMBitDepthKey:@(16), //采样位数 默认 16
                                  AVNumberOfChannelsKey:@(1), //通道的数目, iphone 只有一个声道
                                  AVEncoderAudioQualityKey:@(AVAudioQualityMedium) };
    }
    return _recordSetting_medium;
}

- (NSDictionary *)recordSetting_high
{
    if (!_recordSetting_high) {
        _recordSetting_high = @{ AVSampleRateKey:@(32000.f), //采样率
                                 AVFormatIDKey:@(kAudioFormatLinearPCM),
                                 AVLinearPCMBitDepthKey:@(16), //采样位数 默认 16
                                 AVNumberOfChannelsKey:@(1), //通道的数目
                                 AVEncoderAudioQualityKey:@(AVAudioQualityHigh) };
    }
    return _recordSetting_high;
}

- (NSDictionary *)recordSetting_max
{
    if (!_recordSetting_max) {
        _recordSetting_max = @{ AVSampleRateKey:@(40000.f), //采样率
                                AVFormatIDKey:@(kAudioFormatLinearPCM),
                                AVLinearPCMBitDepthKey:@(16), //采样位数 默认 16
                                AVNumberOfChannelsKey:@(1), //通道的数目
                                AVEncoderAudioQualityKey:@(AVAudioQualityMax) };
    }
    return _recordSetting_max;
}

@end
