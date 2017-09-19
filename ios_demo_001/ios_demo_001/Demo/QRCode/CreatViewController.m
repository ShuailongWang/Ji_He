//
//  CreatViewController.m
//  ios_demo_001
//
//  Created by admin on 17/9/19.
//  Copyright © 2017年 wsl. All rights reserved.
//

#import "CreatViewController.h"
#import "QRCodeTools.h"

@interface CreatViewController ()

@end

@implementation CreatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self setupUI];
}

- (void)setupUI {
    //生成普通的二维码
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(80, 80, self.view.frame.size.width - 160, self.view.frame.size.width - 160)];
    imageView.image = [QRCodeTools generateCustomQRCode:@"http://www.baidu.com" WithImageWidth:self.view.frame.size.width - 160];
    [self.view addSubview:imageView];
    
    
    //生成带logo的二维码
    UIImageView *imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(80, imageView.bounds.size.width + 100, imageView.bounds.size.width, imageView.bounds.size.width)];
    imageView2.image = [QRCodeTools generateLogoQRCode:@"www.baidu.com" imageWidth:imageView2.bounds.size.width logoImageName:@"qiaoba" logoScaleToSuperView:0.2];
    [self.view addSubview:imageView2];
    
}

@end
