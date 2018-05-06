//
//  TakeMovieViewController.m
//  UIImagePickerController
//
//  Created by PaddyGu on 2018/5/6.
//  Copyright © 2018年 PaddyGu. All rights reserved.
//

#import "TakeMovieViewController.h"

#import <MobileCoreServices/MobileCoreServices.h>
#import <MediaPlayer/MPMoviePlayerViewController.h>
#import <MediaPlayer/MPMoviePlayerController.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface TakeMovieViewController ()

@end

@implementation TakeMovieViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 1. 检测当前Camera是否可用
    // 2. 配置UIImagePickerController
    [self configImagePickerController];

}

-(void)configImagePickerController{
    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    
    controller.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    NSString *mediaType = (__bridge NSString*)kUTTypeMovie;
    controller.mediaTypes = [NSArray arrayWithObjects:mediaType, nil];
    
    controller.delegate = self;
    
    // 视频质量
    controller.videoQuality = UIImagePickerControllerQualityTypeHigh;
    
    // 最大拍摄时间
    controller.videoMaximumDuration = 30.0;
    
    // 模态显示出来
    [self.navigationController presentViewController:controller animated:true completion:nil];
}

// 代理方法
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:true completion:nil];
}
// info : 1.type 2. Image/ Video 3. 附加信息
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    // 创建视频播放的类
    __block MPMoviePlayerController *movieController;
    
    NSString * type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:(__bridge NSString *)kUTTypeMovie]) {
        // 可以取到附加信息
        NSDictionary *metaData = [info objectForKey:UIImagePickerControllerMediaMetadata];
        NSLog(@"%@",metaData);
        // 视频播放需要视频地址，从info中取url
        NSURL *videoUrl = [info objectForKey:UIImagePickerControllerMediaURL];
        NSLog(@"视频URL：%@",videoUrl);
        
        //以下是直接播放视频的
        
        movieController = [[MPMoviePlayerController alloc] initWithContentURL:videoUrl];
        // 设置视频缩放模式
        movieController.scalingMode = MPMovieScalingModeFill;
        //控制模式：嵌入式
        movieController.controlStyle = MPMovieControlStyleEmbedded;
        
        //将拍摄的视频界面隐藏起来
        [picker dismissViewControllerAnimated:true completion:^{
            //添加播放
            [self presentMoviePlayerViewControllerAnimated:movieController];
        }];
        
        // 以下是直接保存视频的
//        [self saveMovie:videoUrl];
        
        
        
    }
}

-(void)saveMovie:(NSURL*)url{
    // 以下是直接保存视频的
    ALAssetsLibrary *lib = [[ALAssetsLibrary alloc] init];
    [lib writeVideoAtPathToSavedPhotosAlbum:url completionBlock:^(NSURL *assetURL, NSError *error) {
        if (error == nil) {
            NSLog(@"视频保存成功");
        }else{
            NSLog(@"视频保存不成功：%@",error);
        }
    }];
}

@end
