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
