//
//  ViewController.m
//  camera
//
//  Created by PaddyGu on 2018/4/25.
//  Copyright © 2018年 PaddyGu. All rights reserved.
//

#import "ViewController.h"
#import "CheckStatus.h"
#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/MobileCoreServices.h>
@interface ViewController ()

// 录制按钮
@property (weak, nonatomic) IBOutlet UIButton *recordButton;


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

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"viewDidLoad" message:@"viewDidLoad" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    [alertView show];
    
    
    NSArray *deviceTypes = @[AVCaptureDeviceTypeBuiltInWideAngleCamera,AVCaptureDeviceTypeBuiltInTelephotoCamera,AVCaptureDeviceTypeBuiltInDuoCamera];
    self.videoDeviceDiscoverySession = [AVCaptureDeviceDiscoverySession discoverySessionWithDeviceTypes:deviceTypes mediaType:AVMediaTypeVideo position:AVCaptureDevicePositionBack];
    
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
            self.setupResult = CameraSetupResultCameraNotAuthorized;
            //下次进入进行检查，没有授权就进入设置页面
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url];
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
}

// 视图将要出现时
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
}




@end
