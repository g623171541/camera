//
//  ViewController.m
//  camera
//
//  Created by PaddyGu on 2018/4/25.
//  Copyright © 2018年 PaddyGu. All rights reserved.
//

#import "ViewController.h"
#import "CheckStatus.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [CheckStatus checkVideoStatus];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
