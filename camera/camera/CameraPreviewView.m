//
//  CameraPreviewView.m
//  camera
//
//  Created by PaddyGu on 2018/5/19.
//  Copyright © 2018年 PaddyGu. All rights reserved.
//

#import "CameraPreviewView.h"
#import <AVFoundation/AVFoundation.h>

@implementation CameraPreviewView

// 重写 layerClass 方法
+(Class)layerClass
{
    return [AVCaptureVideoPreviewLayer class];
}

- (AVCaptureSession *)session{
    AVCaptureVideoPreviewLayer *previewLayer = (AVCaptureVideoPreviewLayer *)self.layer;
    return previewLayer.session;
}

-(void)setSession:(AVCaptureSession *)session
{
    AVCaptureVideoPreviewLayer *previewLayer = (AVCaptureVideoPreviewLayer *)self.layer;
    previewLayer.session = session;
}

@end
