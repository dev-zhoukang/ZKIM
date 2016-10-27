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
@property (nonatomic, strong) NSMutableArray *imageArr;
@property (nonatomic, strong) NSMutableArray *imageDataArr;
@property (nonatomic, strong) NSMutableArray *smallImageDataArr;

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
    _imageArr = [NSMutableArray new];
    _imageDataArr = [NSMutableArray new];
    _smallImageDataArr = [NSMutableArray new];
}

- (void)choosePhotoDataWithType:(ZKPhotoType)poContentType
{
    switch (poContentType) {
        case ZKPhotoTypeTakePhotoAndVideo: {
            if (![HLTool cameraGranted]) {
                return;
            }
            
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
                [_applicationContext presentViewController:picker animated:YES completion:nil];
            }
        } break;
        case ZKPhotoTypeTakePhoto: {
            if (![HLTool cameraGranted]) {
                return;
            }
            
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                imagePicker.delegate = self;
                imagePicker.allowsEditing = NO;
                [_applicationContext presentViewController:imagePicker animated:YES completion:nil];
            }
        } break;
        case ZKPhotoTypeLocalAlbum: {
            if (![HLTool photoAlbumGranted]) {
                return;
            }
        
            ImagePickerSheetController *controller = [[ImagePickerSheetController alloc] init];
            controller.maximumSelection = 8;
            controller.displaySelectMaxLimit = YES;
            
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
                    [self imagePickerController:nil didFinishPickingMediaWithAssets:controller.selectedImageAssets];
                }
            }];
            [controller addAction:action];
            
            action = [[ImageAction alloc] init];
            action.title = @"取消";
            action.style = ImageActionStyleCancel;
            [controller addAction:action];
            
            [_applicationContext presentViewController:controller animated:YES completion:nil];
            
            USImagePickerController *imagePicker = [[USImagePickerController alloc] init];
            imagePicker.delegate = self;
            imagePicker.allowsMultipleSelection = YES;
            imagePicker.maxSelectNumber = 10;
            imagePicker.tintColor = ThemColor;
            imagePicker.hideOriginalImageCheckbox = YES;
            
            imagePicker.navigationBar.tintColor = [UIColor whiteColor];
            imagePicker.navigationBar.barTintColor = ThemColor;
            imagePicker.navigationBar.translucent = NO;
            
            NSShadow *shadow = [NSShadow new];
            [shadow setShadowColor: [UIColor clearColor]];
            NSDictionary * dict = @{NSForegroundColorAttributeName:[UIColor whiteColor], NSShadowAttributeName:shadow};
            imagePicker.navigationBar.titleTextAttributes = dict;
            [_applicationContext presentViewController:imagePicker animated:YES completion:nil];
        } break;
        case ZKPhotoTypeLocalVideo: {
            if (![HLTool photoAlbumGranted]) {
                return;
            }
            
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
            
            [_applicationContext presentViewController:imagePicker animated:YES completion:nil];
        } break;
    }
}

#pragma mark - <USImagePickerControllerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

- (void)imagePickerController:(USImagePickerController *)picker didFinishPickingMediaWithAssets:(NSArray *)assets
{
    [self getimageWithAssets:assets picker:picker];
}

- (void)getimageWithAssets:(NSArray *)assets picker:(USImagePickerController *)picker
{
    NSMutableArray *chatImageArr = [[NSMutableArray alloc] init];
    
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
                [self.imageArr addObject:largeImg];
                //图片
                [self.imageDataArr addObject:imageData];
                //小图
                [self.smallImageDataArr addObject:smallData];
                
                NSString *imageName = [UIMedia storeImageToCache:largeImg];
                [chatImageArr addObject:imageName];
            }
        }
    }
    
    //结束停止用户事件
    dispatch_async(dispatch_get_main_queue(), ^{
        [_applicationContext dismissViewControllerAnimated:YES completion:nil];
//        [picker.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    });
}

@end
