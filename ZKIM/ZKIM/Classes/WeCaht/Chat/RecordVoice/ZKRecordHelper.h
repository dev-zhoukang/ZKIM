//
//  ZKRecordHelper.h
//  ZKIM
//
//  Created by ZK on 16/10/31.
//  Copyright © 2016年 ZK. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ZKRecordHelper;

@protocol ZKRecordHelperDelegate <NSObject>

@optional
- (void)recordHelperDidStartRecord;
- (void)recordHelperDidCancelRecord;
- (void)recordHelperDidEndRecordMediaModel:(ZKMediaModel *)mediaModel mediaType:(MediaType)mediaType;

@end

@interface ZKRecordHelper : NSObject

+ (ZKRecordHelper *)recordHelperWithButton:(UIButton *)button;

@property (nonatomic, weak) id <ZKRecordHelperDelegate> delegate;

@end
