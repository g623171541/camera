//
//  CheckStatus.h
//  camera
//
//  Created by PaddyGu on 2018/4/25.
//  Copyright © 2018年 PaddyGu. All rights reserved.
//

// ------------  UIImagePickerController   ---------------
// 检测相机+相册+麦克风的访问权限

#import <Foundation/Foundation.h>


@interface CheckStatus : NSObject

// 检测相机是否可用
+ (BOOL)isCameraAvailable;
// 检测前置闪光灯是否可用
+ (BOOL)isCameraFrontFlashAvailable;
// 检测后置闪光灯是否可用
+ (BOOL)isCameraRearFlashAvailable;
// 检测前置摄像头是否可用
+ (BOOL)isFrontCameraAvailable;
// 检测后置摄像头是否可用
+ (BOOL)isRearCameraAvailable;
// 检测摄像头支持拍照或摄像
+ (BOOL)cameraSupportMedia:(NSString *)mediaType;


@end
