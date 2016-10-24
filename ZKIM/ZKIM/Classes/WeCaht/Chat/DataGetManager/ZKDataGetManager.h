//
//  ZKDataGetManager.h
//  ZKIM
//
//  Created by ZK on 16/10/24.
//  Copyright © 2016年 ZK. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ZKDataGetManager;

typedef NS_ENUM(NSInteger, ZKPhotoType) {
    ZKPhotoTypeLocalAlbum,       //!< 本地图册
    ZKPhotoTypeLocalVideo,       //!< 本地视频
    ZKPhotoTypeTakePhoto,        //!< 拍摄照片
    ZKPhotoTypeTakePhotoAndVideo //!< 拍摄照片和视频
};

@protocol ZKDataGetManagerDelegate <NSObject>

@optional

- (void)dataGetManagerDidGotPhotosOrVideoData:(NSDictionary *)dict type:(ZKPhotoType)type;

@end

@interface ZKDataGetManager : NSObject

@property (nonatomic, weak) id <ZKDataGetManagerDelegate> delegate;

+ (instancetype)shareInstance;
- (void)choosePhotoDataWithType:(ZKPhotoType)photoType;

@end
