//
//  CameraViewController.m
//  ios_demo_001
//
//  Created by admin on 17/9/22.
//  Copyright © 2017年 wsl. All rights reserved.
//

#import "CameraViewController.h"
#import "CameraPictureViewController.h"

@interface CameraViewController ()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation CameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupUI];
}

- (void)setupUI {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"拍照" style:UIBarButtonItemStyleDone target:self action:@selector(clickRightButton)];
    
    if (nil == _imageView) {
        _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 0, KScreen_Width - 20, KScreen_Width)];
        _imageView.center = self.view.center;
        [self.view addSubview:_imageView];
    }
}


- (void)clickRightButton{
    CameraPictureViewController *cameraVC = [[CameraPictureViewController alloc]init];
    __weak typeof(self) weakSelf = self;
    cameraVC.myBlock = ^(UIImage *image){
        weakSelf.imageView.image = image;
    };
    [self presentViewController:cameraVC animated:YES completion:nil];
}


@end
