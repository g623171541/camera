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

// info: 1.获取媒体类型，2.image图片本身，3.媒体附加信息
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
        // 声明一个select 下面还要实现
        SEL saveImage = @selector(image:didFinishSavingWithError:contextInfo:);
        UIImageWriteToSavedPhotosAlbum(image, self, saveImage, nil);
        
        // 通过info还可以拿到图片附加信息***
        NSDictionary *dic = [info objectForKey:UIImagePickerControllerMediaMetadata];
        NSLog(@"%@",dic);
        /*
        "{Exif}" =     {
             ApertureValue = "1.6959938131099";
             BrightnessValue = "-0.6656020644474478";
             ColorSpace = 65535;
             DateTimeDigitized = "2018:05:06 00:12:59";
             DateTimeOriginal = "2018:05:06 00:12:59";
             ExposureBiasValue = 0;
             ExposureMode = 0;
             ExposureProgram = 2;
             ExposureTime = "0.25";
             FNumber = "1.8";
             Flash = 24;
             FocalLenIn35mmFilm = 28;
             FocalLength = "3.99";
             ISOSpeedRatings =         (
                100
             );
             LensMake = Apple;
             LensModel = "iPhone 7 back camera 3.99mm f/1.8";
             LensSpecification =         (
                 "3.99",
                 "3.99",
                 "1.8",
                 "1.8"
             );
             MeteringMode = 5;
             PixelXDimension = 4032;
             PixelYDimension = 3024;
             SceneType = 1;
             SensingMethod = 2;
             ShutterSpeedValue = "2.059368654346855";
             SubjectArea =         (
                 2015,
                 1511,
                 2217,
                 1330
             );
             SubsecTimeDigitized = 960;
             SubsecTimeOriginal = 960;
             WhiteBalance = 0;
        };
        "{MakerApple}" =     {
             1 = 9;
             12 =         (
                 "0.296875",
                 "0.3046875"
             );
             13 = 12;
             14 = 0;
             15 = 2;
             16 = 1;
             2 = <3901b501 d401d601 2d018e00 99009c00 92005d00 25001900 36008900 9700d600 4e00ae00 4801bb01 a9003200 78008600 8d007800 20001900 67008a00 9f002d01 2e002100 2c007f00 a3006a00 39006800 78004900 1a001c00 7b008a00 b8007201 21002500 21001d00 22003d00 4d002f00 52002400 1c002c00 7b008d00 e4007301 2a002800 23002000 1d001b00 1c002900 26001c00 1d004900 77009e00 0b015701 32002d00 29002200 1e001e00 1e001d00 1b001900 1d004500 6a00b800 19013701 35002b00 2a009600 96007200 5a004400 31002400 1c001b00 4800ba00 0e011d01 39006f00 95001701 f600d100 bd00b200 a5009800 81004e00 5e007800 e4000e01 ad009001 5c013701 1901f000 ca00b700 ae00a100 94008500 79007000 9300eb00 ac01a201 73015201 35011001 eb00c700 b100a700 9b008e00 7c007d00 69008f00 af01a401 8b016b01 4c012d01 0c01e500 c000ac00 a1009000 89008000 83005900 9c01a401 9f018701 69014501 28010201 dd00b900 a3009500 9300a000 b400b600 9101a401 ad01a301 84016001 46012101 fe00d600 ac00a200 a500fb00 ed00a101 8a019a01 aa01a801 a2018101 5d014001 1e01f100 cb00b400 04012c01 ba01c401 88019301 9e01ab01 a4018801 74015b01 39010801 ee00f200 4a019c01 11025601 91019501 9a019c01 97019101 88017101 3f012d01 0f014601 7d013402 a801fc00>;
             20 = 5;
             23 = 0;
             25 = 0;
             3 =         {
                 epoch = 0;
                 flags = 1;
                 timescale = 1000000000;
                 value = 121090686489500;
             };
             31 = 0;
             4 = 1;
             5 = 189;
             6 = 183;
             7 = 1;
             8 =         (
                 "0.04747698083519936",
                 "-0.4126344919204712",
                 "-0.9071507453918457"
             );
             };
        "{TIFF}" =     {
             DateTime = "2018:05:06 00:12:59";
             Make = Apple;
             Model = "iPhone 7";
             ResolutionUnit = 2;
             Software = "11.3.1";
             XResolution = 72;
             YResolution = 72;
        };
         */
        
    }
    
    // 隐藏拍照模式，展示图片
    [picker dismissViewControllerAnimated:true completion:nil];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    // 点击cancel把展示出来的相机页面关闭掉
    [picker dismissViewControllerAnimated:true completion:nil];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if(error == nil){
        NSLog(@"图片保存成功");
    }else{
        NSLog(@"图片保存不成功");
    }
    NSLog(@"%@",contextInfo);
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
