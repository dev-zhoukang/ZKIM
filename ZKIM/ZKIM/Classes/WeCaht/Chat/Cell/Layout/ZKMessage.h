//
//  ZKMessage.h
//  ZKIM
//
//  Created by ZK on 16/10/27.
//  Copyright © 2016年 ZK. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ZKMessageBodyType) {
    ZKMessageBodyTypeText = EMMessageBodyTypeText,
    ZKMessageBodyTypeImage = EMMessageBodyTypeImage,
    ZKMessageBodyTypeAudio = EMMessageBodyTypeVoice,
    ZKMessageBodyTypeVideo = EMMessageBodyTypeVideo,
    ZKMessageBodyTypeLocation = EMMessageBodyTypeLocation
};

typedef NS_ENUM(NSInteger, ZKMessageStatus) {
    ZKMessageStatusPending  = 0,    /*! \~chinese 发送未开始 \~english Pending */
    ZKMessageStatusDelivering,      /*! \~chinese 正在发送 \~english Delivering */
    ZKMessageStatusSuccessed,       /*! \~chinese 发送成功 \~english Successed */
    ZKMessageStatusFailed,          /*! \~chinese 发送失败 \~english Failed */
};

@interface ZKMessage : NSObject

@property (nonatomic, strong, readonly) EMMessage *emmsg; //!< 环信msg模型
@property (nonatomic, assign, readonly) ZKMessageBodyType type;

@property (nonatomic, copy, readonly) NSString *messageId; //!< 消息的唯一标识
@property (nonatomic, copy, readonly) NSString *contentText; //!< 聊天文本

// 图片信息
@property (nonatomic, assign, readonly) CGSize imageSize;
@property (nonatomic, strong, readonly) UIImage *largeImage;
@property (nonatomic, copy, readonly) NSString *largeImageRemotePath;
@property (nonatomic, strong, readonly) UIImage *thumbnailImage;
@property (nonatomic, copy, readonly) NSString *thumbnailRemotePath;
@property (nonatomic, copy, readonly) NSString *localPath;//!< 图片本地路径

// 语音信息
@property (nonatomic, copy, readonly) NSString *audioPath;
@property (nonatomic, assign, readonly) NSInteger audioDuration;

@property (nonatomic, assign, readonly) NSTimeInterval timestamp; //!< 本条消息时间戳
@property (nonatomic, assign) NSTimeInterval preTimestamp; //!< 上条信息时间戳

@property (nonatomic, assign, readonly) ZKMessageStatus messageStatus; //!< 消息状态
@property (nonatomic, assign, readonly) BOOL isMine; //!< 我的消息
@property (nonatomic, assign, readonly) BOOL needShowTime; //!< 需要展示时间

- (instancetype)initWithEMMessage:(EMMessage *)emmsg;

@end

