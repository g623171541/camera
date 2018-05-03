//
//  CheckStatus.m
//  camera
//
//  Created by PaddyGu on 2018/4/25.
//  Copyright © 2018年 PaddyGu. All rights reserved.
//

#import "CheckStatus.h"
#import <UIKit/UIKit.h>

@implementation CheckStatus

+(void)checkVideoStatus{
    //检查相机权限
    AVAuthorizationStatus videoStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    switch (videoStatus) {
        case AVAuthorizationStatusNotDetermined:
            //没有询问是否开启相机
            NSLog(@"AVAuthorizationStatusNotDetermined");
            break;
        case AVAuthorizationStatusRestricted:
            //未授权，家长限制
            NSLog(@"AVAuthorizationStatusRestricted");
            break;
        case AVAuthorizationStatusDenied:
            //未授权
            NSLog(@"AVAuthorizationStatusDenied");
            break;
        case AVAuthorizationStatusAuthorized:
            //已授权
            NSLog(@"AVAuthorizationStatusAuthorized");
            break;
        default:
            break;
    }
    //下次进入进行检查，没有授权就引导用户进入设置修改
    if (videoStatus == AVAuthorizationStatusDenied || videoStatus == AVAuthorizationStatusRestricted) {
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        }
    }
    
    //弹框相机授权
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
        NSLog(@"%@",granted ? @"相机准许":@"相机不准许");
    }];
}

+(void)checkAudioStatus{
    //检查麦克风权限
    AVAuthorizationStatus audioStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    switch (audioStatus) {
        case AVAuthorizationStatusNotDetermined:
            //没有询问是否开启麦克风
            NSLog(@"AVAuthorizationStatusNotDetermined");
            break;
        case AVAuthorizationStatusRestricted:
            //未授权，家长限制
            NSLog(@"AVAuthorizationStatusRestricted");
            break;
        case AVAuthorizationStatusDenied:
            //未授权
            NSLog(@"AVAuthorizationStatusDenied");
            break;
        case AVAuthorizationStatusAuthorized:
            //已授权
            NSLog(@"AVAuthorizationStatusAuthorized");
            break;
        default:
            break;
    }
    //弹框麦克风授权
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
        NSLog(@"%@",granted ? @"麦克风准许":@"麦克风不准许");
    }];
}


+(void)checkPhotoStatus{
    //检查相册权限 6.0 - 9.0
    // #import <AssetsLibrary/AssetsLibrary.h> ALAuthorizationStatus
    
    // 8.0 - 10.0
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    switch (status) {
        case PHAuthorizationStatusNotDetermined:
            // 用户还没有关于这个应用程序做出了选择
            NSLog(@"PHAuthorizationStatusNotDetermined");
            break;
        case PHAuthorizationStatusRestricted:
            // 这个应用程序未被授权访问图片数据。用户不能更改该应用程序的状态,可能是由于活动的限制,如家长控制到位。
            NSLog(@"PHAuthorizationStatusRestricted");
            break;
        case PHAuthorizationStatusDenied:
            // 用户已经明确否认了这个应用程序访问图片数据
            NSLog(@"PHAuthorizationStatusDenied");
            break;
        case PHAuthorizationStatusAuthorized:
            // 用户授权此应用程序访问图片数据
            NSLog(@"PHAuthorizationStatusAuthorized");
            break;
        default:
            break;
    }
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        if (status == PHAuthorizationStatusAuthorized) {
            NSLog(@"相册允许");
        }else{
            NSLog(@"相册不允许");
        }
    }];
}


#pragma mark - 检查相机权限
+ (BOOL)canUserCamear{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusDenied) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"请打开相机权限" message:@"设置-隐私-相机" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        alertView.tag = 100;
        [alertView show];
        return NO;
    }
    else{
        return YES;
    }
    return YES;
}


// ------------  UIImagePickerController   ---------------
// 检测相机是否可用
+ (BOOL)isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

// 检测前置闪光灯是否可用
+ (BOOL)isCameraFrontFlashAvailable{
    return [UIImagePickerController isFlashAvailableForCameraDevice:UIImagePickerControllerCameraDeviceFront];
}

// 检测后置闪光灯是否可用
+ (BOOL)isCameraRearFlashAvailable{
    return [UIImagePickerController isFlashAvailableForCameraDevice:UIImagePickerControllerCameraDeviceRear];
}

// 检测前置摄像头是否可用
+ (BOOL)isFrontCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

// 检测后置摄像头是否可用
+ (BOOL)isRearCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

// 检测摄像头支持拍照或摄像
+ (BOOL)cameraSupportMedia:(NSString *)mediaType{
    // returns array of available media types
    NSArray * availMediaType = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
    NSLog(@"可用的媒体类型为：%@",availMediaType);
    for (NSString *item in availMediaType) {
        if ([item isEqualToString:mediaType]) {
            return true;
        }
    }
    return false;
}

@end
