//
//  ViewController.m
//  UIImagePickerController
//
//  Created by PaddyGu on 2018/5/4.
//  Copyright © 2018年 PaddyGu. All rights reserved.
//

#import "ViewController.h"
#import "CheckStatus.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // 用 UIImagePickerController
    [self useUIImagePickerController];
    
    // 1. 检测当前相机是否可用
    if (![CheckStatus isCameraAvailable]) {
        return;
    }
    
    // 2. 配置UIImagePickerController
    [self configImagePickerController];

}

// 2. 配置UIImagePickerController
-(void)configImagePickerController{
    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    /*
     配置照片源是从哪里获取的
     typedef NS_ENUM(NSInteger, UIImagePickerControllerSourceType) {
         UIImagePickerControllerSourceTypePhotoLibrary,         来自图库
         UIImagePickerControllerSourceTypeCamera,               从相机获取图片
         UIImagePickerControllerSourceTypeSavedPhotosAlbum      来自相册
     } __TVOS_PROHIBITED;
     */
    controller.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    /*** 检查支持的媒体类型
     ** UIImagePickerControllerMediaType 包含着KUTTypeImage 和KUTTypeMovie
     ** kUTTypeImage 静态图片
     * KUTTypeImage 包含：
         const CFStringRef  kUTTypeImage ;抽象的图片类型
         const CFStringRef  kUTTypeJPEG ;
         const CFStringRef  kUTTypeJPEG2000 ;
         const CFStringRef  kUTTypeTIFF ;
         const CFStringRef  kUTTypePICT ;
         const CFStringRef  kUTTypeGIF ;
         const CFStringRef  kUTTypePNG ;
         const CFStringRef  kUTTypeQuickTimeImage ;
         const CFStringRef  kUTTypeAppleICNS
         const CFStringRef kUTTypeBMP;
         const CFStringRef  kUTTypeICO;
     ** @prama kUTTypeMovie 视频   (这两个字符串常量定义在MobileCoreServices框架中)
     * KUTTypeMovie 包含：
         const CFStringRef  kUTTypeAudiovisualContent ;抽象的声音视频
         const CFStringRef  kUTTypeMovie ;抽象的媒体格式（声音和视频）
         const CFStringRef  kUTTypeVideo ;只有视频没有声音
         const CFStringRef  kUTTypeAudio ;只有声音没有视频
         const CFStringRef  kUTTypeQuickTimeMovie ;
         const CFStringRef  kUTTypeMPEG ;
         const CFStringRef  kUTTypeMPEG4 ;
         const CFStringRef  kUTTypeMP3 ;
         const CFStringRef  kUTTypeMPEG4Audio ;
         const CFStringRef  kUTTypeAppleProtectedMPEG4Audio;
     */
    NSString *requireMediaType = (__bridge NSString*) kUTTypeImage;
    controller.mediaTypes = [[NSArray alloc] initWithObjects:requireMediaType, nil];
    
    // 配置图片是否可以编辑
    controller.allowsEditing = false;
    
    //设置代理
    controller.delegate = self;
    
    // 配置闪光灯模式:打开
    controller.cameraFlashMode = UIImagePickerControllerCameraFlashModeAuto;
    
    // 配置摄像头
//    controller.cameraDevice = UIImagePickerControllerCameraDeviceRear;
    
    //模态展示controller
    [self.navigationController presentViewController:controller animated:true completion:nil];
}

// UIImagePickerControllerDelegate 代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    // 拍摄完成之后的代理方法
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    // 判断媒体类型是图片还是视频
    if ([mediaType isEqualToString:(__bridge NSString*)kUTTypeImage]) {
        // 拿出info中的图片数据
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        self.imageView.image = image;
        self.imageView.contentMode = UIViewContentModeScaleToFill;
        
        // 保存图片
        
    }
    
    // 隐藏拍照模式，展示图片
    [picker dismissViewControllerAnimated:true completion:nil];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    // 点击cancel把展示出来的相机页面关闭掉
    [picker dismissViewControllerAnimated:true completion:nil];
}


// ------------  UIImagePickerController   ---------------
-(void)useUIImagePickerController{
    //如果使用 kUTTypeImage 必须导入 #import <MobileCoreServices/MobileCoreServices.h> 这个库
    if ([CheckStatus cameraSupportMedia:(__bridge NSString *) kUTTypeImage]) {
        NSLog(@"支持 拍照");
    }else{
        NSLog(@"不支持 拍照");
    };
    if ([CheckStatus cameraSupportMedia:(__bridge NSString *) kUTTypeMovie]) {
        NSLog(@"支持 录像");
    }else{
        NSLog(@"不支持 录像");
    };
    
}


@end
