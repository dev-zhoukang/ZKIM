//
//  ZKPhotoGetTool.h
//  ZKIM
//
//  Created by ZK on 16/10/24.
//  Copyright © 2016年 ZK. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ZKPhotoGetTool;

typedef NS_ENUM(NSInteger, ZKPhotoType) {
    ZKPhotoTypeLocalAlbum,       //!< 本地图册
    ZKPhotoTypeLocalAlbumSheet,  //!< ActionSheet样式展示本地图册
    ZKPhotoTypeLocalVideo,       //!< 本地视频
    ZKPhotoTypeTakePhoto,        //!< 拍摄照片
    ZKPhotoTypeTakePhotoAndVideo //!< 拍摄照片和视频
};

@protocol ZKPhotoGetToolDelegate <NSObject>

@optional
- (void)photoGetToolDidGotPhotosOrVideoDict:(NSDictionary *)dict type:(MediaType)type;

@end

@interface ZKPhotoGetTool : NSObject

@property (nonatomic, weak) id <ZKPhotoGetToolDelegate> delegate;

+ (instancetype)shareInstance;
- (void)choosePhotoDataWithType:(ZKPhotoType)photoType;

@end
