//
//  CheckStatus.h
//  camera
//
//  Created by PaddyGu on 2018/4/25.
//  Copyright © 2018年 PaddyGu. All rights reserved.
//


// 检测相机+相册+麦克风的访问权限

#import <Foundation/Foundation.h>
#import<AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>
#import<AssetsLibrary/AssetsLibrary.h>
#import<CoreLocation/CoreLocation.h>
#import <Photos/PHPhotoLibrary.h>

@interface CheckStatus : NSObject

//检查相机权限
+(void)checkVideoStatus;
//检查麦克风权限
+(void)checkAudioStatus;
//检查相册权限
+(void)checkPhotoStatus;

@end
