//
//  ScanPhotoViewController.m
//  UIImagePickerController
//
//  Created by PaddyGu on 2018/5/6.
//  Copyright © 2018年 PaddyGu. All rights reserved.
//

#import "ScanPhotoViewController.h"

#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface ScanPhotoViewController ()

@end

@implementation ScanPhotoViewController


// 主要目的是扫描照片库，将扫描出来的照片显示出来

// 来自慕课网教程


- (void)viewDidLoad {
    [super viewDidLoad];

    // 1. 获取lib
    ALAssetsLibrary *assetLib = [[ALAssetsLibrary alloc] init]; // ios9后，这个类被弃用了
    // 2. 创建子线程来处理比较耗时的扫描工作
    dispatch_queue_t q = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(q, ^{
        NSLog(@"currentThread = %@",[NSThread currentThread]);
        // 3. 扫描媒体库：对媒体库所有资源进行遍历
        [assetLib enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
            // 扫描成功的时候执行的
            // 遍历到第一张的时候停止遍历，将结果显示出来
            [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                //主要业务逻辑
                // 通过一个字符串标示我们获取到的到底是什么资源类型
                NSString *assetType = [result valueForKey:ALAssetPropertyType];
                if ([assetType isEqualToString:ALAssetTypePhoto]) {
                    *stop = false; // 停止扫描
                    // 将图片解析出来
                    ALAssetRepresentation *assetRepresentation = [result defaultRepresentation];//拿到图片的类型
                    CGFloat imageScale = [assetRepresentation scale];//图片缩放信息
                    UIImageOrientation imageOrientation = (UIImageOrientation)[assetRepresentation orientation];
                    
                    // 主线程更新UI
                    dispatch_async(dispatch_get_main_queue(), ^{
                        CGImageRef imageRef = [assetRepresentation fullResolutionImage];
                        UIImage *image = [UIImage imageWithCGImage:imageRef scale:imageScale orientation:imageOrientation];
                        if (image != nil) {
                            //显示到界面上
//                            self.imageView.image = image;
                        }
                    });
                }
            }];
        } failureBlock:^(NSError *error) {
            // 扫描失败的时候执行的
            NSLog(@"%@",error);
        }];
    });
    
    
}


@end
