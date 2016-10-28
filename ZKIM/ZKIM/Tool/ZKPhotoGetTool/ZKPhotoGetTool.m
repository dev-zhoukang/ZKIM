//
//  ZKPhotoGetTool.m
//  ZKIM
//
//  Created by ZK on 16/10/24.
//  Copyright © 2016年 ZK. All rights reserved.
//

#import "ZKPhotoGetTool.h"
#import <ImageIO/ImageIO.h>
#import "ImagePickerSheetController.h"
#import "USImagePickerController.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface ZKPhotoGetTool () <USImagePickerControllerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
//图片数据
@property (nonatomic, strong) NSMutableArray *largeImages;
@property (nonatomic, strong) NSMutableArray *largeImageDatas;
@property (nonatomic, strong) NSMutableArray *smallImageDatas;

//视频数据
@property (nonatomic, strong) NSData *videoSmallImgData;
@property (nonatomic, strong) NSData *videoData;
@property (nonatomic, copy)   NSString *videoTime;
@property (nonatomic, strong) UIImage *videoImage;

@end

@implementation ZKPhotoGetTool

+ (instancetype)shareInstance
{
    static ZKPhotoGetTool *mgr = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mgr = [[ZKPhotoGetTool alloc] init];
    });
    return mgr;
}

#pragma mark - Init

- (instancetype)init
{
    if (self = [super init]) {
        [self initData];
    }
    return self;
}

- (void)initData
{
    _largeImages = [NSMutableArray new];
    _largeImageDatas = [NSMutableArray new];
    _smallImageDatas = [NSMutableArray new];
}

- (void)choosePhotoDataWithType:(ZKPhotoType)poContentType
{
    switch (poContentType) {
        case ZKPhotoTypeTakePhoto: {
            if (![HLTool cameraGranted]) return;
            [self startTakePhoto];
        } break;
        case ZKPhotoTypeLocalAlbum: {
            if (![HLTool photoAlbumGranted]) return;
            [self startOpenLocalAlbum];
        } break;
            
        case ZKPhotoTypeLocalAlbumSheet: {
            if (![HLTool cameraGranted]) return;
            [self startPopupImageSheet];
        } break;
            
        case ZKPhotoTypeTakePhotoAndVideo: {
            if (![HLTool cameraGranted]) return;
            [self startTakePhotoOrVideo];
        } break;
        
        case ZKPhotoTypeLocalVideo: {
            if (![HLTool photoAlbumGranted]) return;
            [self startOpenLocalVideo];
        } break;
    }
}

- (void)startOpenLocalVideo
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.mediaTypes =  @[(NSString *)kUTTypeMovie];
    imagePicker.navigationBar.barTintColor = ThemColor;
    
    NSShadow *shadow = [NSShadow new];
    [shadow setShadowColor: [UIColor clearColor]];
    NSDictionary * dict = @{NSForegroundColorAttributeName:[UIColor whiteColor],NSShadowAttributeName:shadow};
    imagePicker.navigationBar.titleTextAttributes = dict;
    imagePicker.navigationBar.tintColor = [UIColor whiteColor];
    imagePicker.navigationBar.translucent = NO;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [_applicationContext.rootViewController presentViewController:imagePicker animated:YES completion:nil];
}

- (void)startTakePhotoOrVideo
{
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        NSArray *temp_MediaTypes = [UIImagePickerController availableMediaTypesForSourceType:picker.sourceType];
        picker.mediaTypes = temp_MediaTypes;
        /**
         picker.mediaTypes = [[NSArray alloc] initWithObjects:(NSString *) kUTTypeMovie, nil];
         */
        
        picker.delegate = self;
        picker.allowsEditing = NO;
        picker.videoMaximumDuration = 180;
        [_applicationContext.rootViewController presentViewController:picker animated:YES completion:nil];
    }
}

- (void)startPopupImageSheet
{
    ImagePickerSheetController *sheetController = [[ImagePickerSheetController alloc] init];
    sheetController.maximumSelection = 8;
    sheetController.displaySelectMaxLimit = YES;
    
    ImageAction *action = [[ImageAction alloc] init];
    action.title = @"照片图库";
    action.style = ImageActionStyleDefault;
    [action setSecondaryTitle:^NSString *(NSInteger num) {
        return [NSString stringWithFormat:@"发送 %@ 张照片",@(num)];
    }];
    [action setHandler:^(ImageAction *action) {
        [self choosePhotoDataWithType:ZKPhotoTypeLocalAlbum];
    }];
    [action setSecondaryHandler:^(ImageAction *action, NSInteger num) {
        if ([self respondsToSelector:@selector(imagePickerController:didFinishPickingMediaWithAssets:)]){
            [self imagePickerController:nil didFinishPickingMediaWithAssets:sheetController.selectedImageAssets];
        }
    }];
    [sheetController addAction:action];
    
    action = [[ImageAction alloc] init];
    action.title = @"取消";
    action.style = ImageActionStyleCancel;
    [sheetController addAction:action];
    
    [_applicationContext.rootViewController presentViewController:sheetController animated:YES completion:nil];
}

- (void)startOpenLocalAlbum
{
    USImagePickerController *imagePicker = [[USImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.allowsMultipleSelection = YES;
    imagePicker.maxSelectNumber = 10;
    /**
     imagePicker.tintColor = ThemColor;
     */
    imagePicker.hideOriginalImageCheckbox = YES;
    
    imagePicker.navigationBar.tintColor = [UIColor whiteColor];
    /**
     imagePicker.navigationBar.barTintColor = ThemColor;
     */
    imagePicker.navigationBar.translucent = NO;
    
    NSShadow *shadow = [NSShadow new];
    [shadow setShadowColor: [UIColor clearColor]];
    NSDictionary * dict = @{NSForegroundColorAttributeName:[UIColor whiteColor], NSShadowAttributeName:shadow};
    imagePicker.navigationBar.titleTextAttributes = dict;
    [_applicationContext.rootViewController presentViewController:imagePicker animated:YES completion:nil];
}

- (void)startTakePhoto
{
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.delegate = self;
        imagePicker.allowsEditing = NO;
        [_applicationContext.rootViewController presentViewController:imagePicker animated:YES completion:nil];
    }
}

#pragma mark - <USImagePickerControllerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

- (void)imagePickerController:(USImagePickerController *)picker didFinishPickingMediaWithAssets:(NSArray *)assets
{
    [self getimageWithAssets:assets picker:picker];
}

- (void)getimageWithAssets:(NSArray *)assets picker:(USImagePickerController *)picker
{
    NSMutableArray <NSString *> *chatImageUrls = [NSMutableArray array];
    [_largeImages removeAllObjects];
    [_largeImageDatas removeAllObjects];
    [_smallImageDatas removeAllObjects];
    
    
    for (int i=0; i<assets.count; i++) {
        @autoreleasepool {
            id asset = assets[i];
            
            CGFloat maxPixelSize = 1200.f;
            
            //适配截屏拼接的长图或者全景图
            CGFloat maxImgLength = MAX([asset dimensions].width, [asset dimensions].height);
            CGFloat minImgLength = MIN([asset dimensions].width, [asset dimensions].height);
            if (minImgLength <= 1080.f && maxImgLength/minImgLength > 2.f) {
                CGFloat minScreenLength = MIN(SCREEN_WIDTH, SCREEN_HEIGHT) * [UIScreen mainScreen].scale;
                CGFloat lastImgMaxLength = 3000.f * 1080.f / minImgLength;
                CGFloat lastImgMinLength = minImgLength / maxImgLength * lastImgMaxLength;
                if (lastImgMinLength > minScreenLength) {
                    lastImgMaxLength = minScreenLength / lastImgMinLength * lastImgMaxLength;
                }
                maxPixelSize = MAX(maxPixelSize, lastImgMaxLength);
            }
            
            //对照片进行压缩
            UIImage *largeImg = [asset thumbnailImageWithMaxPixelSize:maxPixelSize];
            
            //小图
            UIImage *smallImage = [asset thumbnailImageWithMaxPixelSize:400.f];
            
            NSData *imageData = UIImageJPEGRepresentation(largeImg, 0.5);
            NSData *smallData = UIImageJPEGRepresentation(smallImage, 0.5);
            
            if (largeImg) {
                [_largeImages addObject:largeImg];
                //图片
                [_largeImageDatas addObject:imageData];
                //小图
                [_smallImageDatas addObject:smallData];
                
                NSString *imageName = [UIMedia storeImageToCache:largeImg];
                [chatImageUrls addObject:imageName];
            }
        }
    }
    
    // 通知代理
    NSDictionary *dict = @{ @"images":_largeImages,
                            @"imageDatas":_largeImageDatas,
                            @"imageUrls":chatImageUrls };
    if ([self.delegate respondsToSelector:@selector(photoGetToolDidGotPhotosOrVideoDict:type:)]) {
        [self.delegate photoGetToolDidGotPhotosOrVideoDict:dict type:MediaType_Image];
    }
    
    //结束停止用户事件
    dispatch_async(dispatch_get_main_queue(), ^{
        [picker.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    });
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
