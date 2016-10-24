//
//  HLTool.m
//  HLMagic
//
//  Created by FredHoolai on 3/5/14.
//  Copyright (c) 2014 chen ying. All rights reserved.
//

#import "HLTool.h"
#import "AppDelegate.h"
#import <Photos/Photos.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreLocation/CoreLocation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Contacts/Contacts.h>
#import <AddressBook/AddressBook.h>
#import "PHPhotoLibrary+ImagePicker.h"
#import "ALAssetsLibrary+ImagePicker.h"
#import "UIDevice+Common.h"

static NSString *const HTAlbumName = @"HTAlbumName";

@implementation NSString (ImageURL)

- (NSString *)fullImageURL
{
    return @"test";
}

- (NSString *)fullMiniImageURL
{
    return [self fullThumbImageURLWithMinPixel:50];
}

- (NSString *)fullSmallImageURL
{
    return [self fullThumbImageURLWithMinPixel:200];
}

- (NSString *)fullThumbImageURLWithMinPixel:(NSInteger)minPixel
{
    if (!self.length) return self;
    
    NSString *fullUrl = [self fullImageURL];
    
    NSString *lastComponent = [NSString stringWithFormat:@"_%@x.jpg", @(minPixel)];
    
    return [fullUrl stringByReplacingOccurrencesOfString:@".jpg" withString:lastComponent];
}

- (NSString *)fullThumbImageURLWithSize:(CGSize)size
{
    if (!self.length) return self;
    
    NSString *fullUrl = [self fullImageURL];
    
    NSString *lastComponent = [NSString stringWithFormat:@"_%dx%d.jpg", (int)size.width, (int)size.height];
    
    return [fullUrl stringByReplacingOccurrencesOfString:@".jpg" withString:lastComponent];
}

@end

@implementation HLTool


// 保存照片到相册
+ (void)writeImageToHTAlbum:(UIImage *)image
{
    if(NSClassFromString(@"PHPhotoLibrary")){
        [PHPhotoLibrary writeImage:image toAlbum:HTAlbumName completionHandler:^(PHAsset *asset, NSError *error) {
            if (error) {
                [USSuspensionView showWithMessage:@"保存失败"];
            } else {
                [USSuspensionView showWithMessage:@"已保存到相册"];
            }
        }];
        
        return;
    }
    
    [ALAssetsLibrary writeImage:image toAlbum:HTAlbumName completionHandler:^(ALAsset *asset, NSError *error) {
        if (error) {
            [USSuspensionView showWithMessage:@"保存失败"];
        } else {
            [USSuspensionView showWithMessage:@"已保存到相册"];
        }
    }];
}

// 通用的通过远程数据推送进行页面跳转，如：推送通知、banner、广告位
+ (void)remotePushViewWithPayload:(NSDictionary *)payload
{
}

+ (BOOL)cameraGranted
{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted ||
        authStatus == AVAuthorizationStatusDenied)
    {
        if (&UIApplicationOpenSettingsURLString) {
            USAlertView *alert = [USAlertView initWithTitle:@"您的相机访问权限被禁止" message:@"请在设置-胡桃钱包-相机权限中开启" cancelButtonTitle:@"取消" otherButtonTitles:@"去开启", nil];
            [alert showWithCompletionBlock:^(NSInteger buttonIndex) {
                if (buttonIndex == 1) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                }
            }];
        } else {
            [USAlertView showWithMessage:@"请在设备的\"设置-隐私-相机\"中允许访问相机。"];
        }
        
        return NO;
    } else {
        return YES;
    }
}

+ (BOOL)contactsGranted{
    
    BOOL hasGetAuth = NO;
    
    void (^failAlertBlock)() = ^(){
        
        if (&UIApplicationOpenSettingsURLString) {
            USAlertView *alert = [USAlertView initWithTitle:@"您的相机访问权限被禁止" message:@"请在设置-胡桃钱包-通信录权限中开启" cancelButtonTitle:@"取消" otherButtonTitles:@"去开启", nil];
            [alert showWithCompletionBlock:^(NSInteger buttonIndex) {
                if (buttonIndex == 1) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                }
            }];
        } else {
            [USAlertView showWithMessage:@"请在设备的\"设置-隐私-通信录\"中允许访问通信录。"];
        }
    };
    
    
    if (NSClassFromString(@"CNContact") && [[[UIDevice currentDevice] systemVersion] floatValue] > 9.0) {
        
        CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
        if (status == CNAuthorizationStatusAuthorized) {
            hasGetAuth = YES;
        }else{
            failAlertBlock();
        }
    }else{
        
        ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
        if (status == kABAuthorizationStatusAuthorized) {
            hasGetAuth = YES;
        }else{
            failAlertBlock();
        }
    }
    
    return hasGetAuth;
}

//是否开启相册权限
+ (BOOL)photoAlbumGranted
{
    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
    if (author == kCLAuthorizationStatusRestricted || author == kCLAuthorizationStatusDenied) {
        //无权限
        if (&UIApplicationOpenSettingsURLString) {
            USAlertView *alert = [USAlertView initWithTitle:@"您的照片访问权限被禁止" message:@"请在设置-快乐印-照片权限中开启" cancelButtonTitle:@"取消" otherButtonTitles:@"去开启", nil];
            [alert showWithCompletionBlock:^(NSInteger buttonIndex) {
                if (buttonIndex == 1) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                }
            }];
        } else {
            [USAlertView showWithMessage:@"请在设备的\"设置-隐私-照片\"中允许访问相册。"];
        }
        
        return NO;
    } else {
        return YES;
    }
}

//迁移老数据
+ (void)migrateOldVersionData
{
    
}

//+ (void)updateSystemDomain:(void (^)(void))complete
//{
//    [NetManager getCacheToUrl:url_system_domain params:nil complete:^(BOOL successed, HttpResponse *response) {
//        
//        if (successed && !response.is_cache) {
//            NSDictionary *result = response.payload[@"domain"];
//            
//            //API接口
//            NSString *apiDomain = result[@"initDomain"];
//            if (apiDomain && apiDomain.length) {
//                [userDefaults setObject:apiDomain forKey:UserDefaultKey_ApiDomain];
//            }
//            
//            //上传文件
//            NSString *uploadIp = result[@"uploadDomain"];
//            if (uploadIp && uploadIp.length) {
//                [userDefaults setObject:uploadIp forKey:UserDefaultKey_UploadDomain];
//            }
//            
//            //下载文件
//            NSString *downloadIp = result[@"downloadDomain"];
//            if (downloadIp && downloadIp.length) {
//                [userDefaults setObject:downloadIp forKey:UserDefaultKey_DownloadDomain];
//            }
//            
//            //设置日志级别
//            if (result[@"logLevel"]) {
//                [USLogger setLogLevel:[result[@"logLevel"] intValue]];
//            }
//            
//            //Spread推送
//            NSArray *spread_service =  result[@"spread_service"];
//            if (spread_service && [spread_service isKindOfClass:[NSArray class]] && spread_service.count) {
//                [userDefaults setObject:[spread_service componentsJoinedByString:@","] forKey:UserDefaultKey_SpreadDomain];
//            }
//            
//            //Tube消息
//            NSArray *tube_service =  result[@"tube_service"];
//            if (tube_service && [tube_service isKindOfClass:[NSArray class]] && tube_service.count) {
//                [userDefaults setObject:[tube_service componentsJoinedByString:@","] forKey:UserDefaultKey_TubeDomain];
//            }
//            
//            //系统配置
//            if (result[@"flags"]) {
//                [userDefaults setObject:result[@"flags"] forKey:UserDefaultKey_ConfigFlags];
//            }
//            
//            //JS补丁
//            if (result[@"js_patch"]) {
//                //清除本地已经下载的Patch文件
//                NSString *filePath = [NSData diskCachePathWithURL:result[@"js_patch"]];
//                [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
//                
//                [NSData dataWithURL:result[@"js_patch"] completed:^(NSData *data) {
//                    if(data) {
//                        NSString *script = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//                        [userDefaults setObject:script forKey:UserDefaultKey_JSPatchScript];
//                        [userDefaults synchronize];
//                        
//                        [JPEngine evaluateScript:script];
//                    }
//                }];
//            }
//            else {
//                [JPCleaner cleanAll];
//                [userDefaults removeObjectForKey:UserDefaultKey_JSPatchScript];
//            }
//            
//            [[NoticeManager defaultManager] handleSystemInfo:response.payload];
//            
//            [userDefaults synchronize];
//            
////            //JSPatch补丁测试代码
////            NSString *sourcePath = [[NSBundle mainBundle] pathForResource:@"patch" ofType:@"js"];
////            NSString *script = [NSString stringWithContentsOfFile:sourcePath encoding:NSUTF8StringEncoding error:nil];
////            [JPEngine evaluateScript:script];
//            
////            [self submitAppActive]; //自动注册所以不需要激活接口了
//        }
//        
//        [self requestUpdateHosptitalData];
//        
//        complete?complete():nil;
//    }];
//}


//检测内存状态，如果是内存占用过多则关闭应用
+ (void)detectionMemoryPressureLevel
{
    BOOL levelWarning = [UIDevice usedMemoryInBytes] > 200.0*1024*1024;
    
    DLog(@"%@", [UIDevice freeMemory]);
    
    UIApplication *application = [UIApplication sharedApplication];
    if (levelWarning && application.applicationState == UIApplicationStateBackground && !_applicationContext.hasSwitchToOtherApp) {
        [(AppDelegate *)application.delegate applicationWillTerminate:application];
        
        DLog(@"t应用即将退出！！！");
        exit(0);
    }
}

@end
