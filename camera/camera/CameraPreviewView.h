//
//  CameraPreviewView.h
//  camera
//
//  Created by PaddyGu on 2018/5/19.
//  Copyright © 2018年 PaddyGu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AVCaptureSession;

@interface CameraPreviewView : UIView

@property (nonatomic) AVCaptureSession *session;

@end
