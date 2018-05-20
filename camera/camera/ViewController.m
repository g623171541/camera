//
//  ViewController.m
//  camera
//
//  Created by PaddyGu on 2018/4/25.
//  Copyright © 2018年 PaddyGu. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/MobileCoreServices.h>

#import "CameraPreviewView.h"
#import "CheckStatus.h"

@interface ViewController ()

// 录制按钮
@property (weak, nonatomic) IBOutlet UIButton *recordButton;
// 预览视图
@property (weak, nonatomic) IBOutlet CameraPreviewView *previewView;

// 配置信息
typedef NS_ENUM(NSInteger,CameraSetupResult){
    CameraSetupResultSuccess,
    CameraSetupResultCameraNotAuthorized,
    CameraSetupResultSessionConfigurationFailed
};
@property (nonatomic) CameraSetupResult setupResult;

// session
@property (nonatomic) AVCaptureDeviceDiscoverySession *videoDeviceDiscoverySession;
@property (nonatomic) dispatch_queue_t sessionQueue;    // 用于创建串行队列
@property (nonatomic) AVCaptureSession *session;        // 负责输入和输出设备之间的连接会话，数据流的管理控制
@property (nonatomic) AVCaptureDevice *videoDevice;     //
@property (nonatomic) AVCaptureDeviceInput *videoDeviceInput;   // 输入设备
@property (nonatomic) AVCaptureMovieFileOutput *movieFileOutput;    // 视频输出流

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *deviceTypes = @[AVCaptureDeviceTypeBuiltInWideAngleCamera,AVCaptureDeviceTypeBuiltInTelephotoCamera,AVCaptureDeviceTypeBuiltInDuoCamera];
    self.videoDeviceDiscoverySession = [AVCaptureDeviceDiscoverySession discoverySessionWithDeviceTypes:deviceTypes mediaType:AVMediaTypeVideo position:AVCaptureDevicePositionBack];
    
    // 创建 AVCaptureSession
    self.session = [[AVCaptureSession alloc] init];
    
    // 设置预览视图
    self.previewView.session = self.session;
    
    // 创建串行队列用于session之间的通信
    self.sessionQueue = dispatch_queue_create("session queue", DISPATCH_QUEUE_SERIAL);
    
    // 初始化默认值
    self.setupResult = CameraSetupResultSuccess;
    // 检查相机的权限
    AVAuthorizationStatus videoStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    switch (videoStatus) {
        case AVAuthorizationStatusAuthorized:       // 已授权
            NSLog(@"已授权");
            break;
        case AVAuthorizationStatusNotDetermined:    // 还没询问是否开启
        {   // TODO:没搞明白此处为什么一定要加括号作为一个代码块
            NSLog(@"没有询问是否开启");
            // 此时需要将串行队列上的任务挂起
            dispatch_suspend(self.sessionQueue);
            // 请求权限
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (!granted) {// 如果没有准许
                    self.setupResult = CameraSetupResultCameraNotAuthorized;
                }
                // 队列上的任务恢复执行
                dispatch_resume(self.sessionQueue);
            }];
            break;
        }
            
        default:
            NSLog(@"未授权或家长控制");
            if (![self canUserCamear]) {
               self.setupResult = CameraSetupResultCameraNotAuthorized;
            }
            break;
    }

    // 在子线程中配置 AVCaptureSession，因为 [AVCaptureSession startRunning] 是一个 blocking call 将会花费大量时间，不能在主线程中造成线程阻塞
    dispatch_async(self.sessionQueue, ^{
        [self configAVCaptureSession];
    });
    
}

// 配置AVCaptureSession
-(void)configAVCaptureSession{
    if (self.setupResult != CameraSetupResultSuccess) {
        return;
    }
    
    NSError *error = nil;
    // 改变会话的配置前一定要先开启配置，配置完成后提交配置改变
    [self.session beginConfiguration];
    // 设置分辨率
    if ([self.session canSetSessionPreset:AVCaptureSessionPreset3840x2160]) {
        self.session.sessionPreset = AVCaptureSessionPreset3840x2160;
    }else{
        self.session.sessionPreset = AVCaptureSessionPreset1920x1080;
    }
    
    //
    AVCaptureDevice *videoDevice = [AVCaptureDevice defaultDeviceWithDeviceType:AVCaptureDeviceTypeBuiltInWideAngleCamera mediaType:AVMediaTypeVideo position:AVCaptureDevicePositionBack];
    AVCaptureDeviceInput *videoDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:&error];
    if (!videoDeviceInput) {
        NSLog(@"无法创建 video 输入设备:%@",error);
        self.setupResult = CameraSetupResultSessionConfigurationFailed;
        [self.session commitConfiguration];
        return;
    }

    // Add video input
    if ([self.session canAddInput:videoDeviceInput]) {
        NSLog(@"设备向session中添加 video 输入设备");
        [self.session addInput:videoDeviceInput];
        self.videoDeviceInput = videoDeviceInput;
        self.videoDevice = videoDevice;
        
        // 在主线程中更新UI的预览视图
        dispatch_async(dispatch_get_main_queue(), ^{
            //判断设备方向
            UIInterfaceOrientation statusBarOrientation = [UIApplication sharedApplication].statusBarOrientation;
            AVCaptureVideoOrientation initialVIdeoOrientation = AVCaptureVideoOrientationLandscapeLeft;
            if (statusBarOrientation != UIInterfaceOrientationUnknown) {
                initialVIdeoOrientation = (AVCaptureVideoOrientation)statusBarOrientation;
            }
            //
            AVCaptureVideoPreviewLayer *previewLayer = (AVCaptureVideoPreviewLayer *)self.previewView.layer;
            previewLayer.connection.videoOrientation = initialVIdeoOrientation;
            
        });
    }else{
        NSLog(@"设备判断无法向session中添加 video 输入设备");
        self.setupResult = CameraSetupResultSessionConfigurationFailed;
        [self.session commitConfiguration];
        return;
    }
    
    // Add audio input
    AVCaptureDevice *audioDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
    AVCaptureDeviceInput *audioDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:audioDevice error:&error];
    if (!audioDeviceInput) {
        NSLog(@"无法创建 audio 输入设备:%@",error);
    }
    if ([self.session canAddInput:audioDeviceInput]) {
        NSLog(@"设备向session中添加 audio 输入设备");
        [self.session addInput:audioDeviceInput];
    }else{
        NSLog(@"设备判断无法向session中添加 audio 输入设备");
    }
    
    // Add movieFile output
    self.movieFileOutput = [[AVCaptureMovieFileOutput alloc] init];
    if ([self.session canAddOutput:self.movieFileOutput]) {
        NSLog(@"session 添加视频输出流 movieFileOutput");
        [self.session addOutput:self.movieFileOutput];
    }else{
        NSLog(@"session 无法添加视频输出流");
    }
    
    [self.session commitConfiguration];
    
}

// 视图将要出现时
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
}



#pragma mark - 检查相机权限
- (BOOL)canUserCamear{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusDenied || authStatus == AVAuthorizationStatusRestricted) {
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

// ------------------  重写方法 ---------------------
//点击确定直接打开设置界面
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0 && alertView.tag == 100) {
        NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        }
    }
}


@end
