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

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // 用 UIImagePickerController
    [self useUIImagePickerController];

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
