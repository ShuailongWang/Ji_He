//
//  CameraPictureViewController.m
//  ios_demo_001
//
//  Created by admin on 17/9/22.
//  Copyright © 2017年 wsl. All rights reserved.
//

#import "CameraPictureViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface CameraPictureViewController ()<AVCaptureMetadataOutputObjectsDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) AVCaptureDevice *device;      //捕获设备，通常是前置摄像头，后置摄像头，麦克风（音频输入）
@property (nonatomic, strong) AVCaptureDeviceInput *input;  //AVCaptureDeviceInput 代表输入设备，他使用AVCaptureDevice 来初始化
//当启动摄像头开始捕获输入
@property (nonatomic, strong) AVCaptureMetadataOutput *output;
@property (nonatomic, strong) AVCaptureStillImageOutput *imageOutput;   //输出图片
@property (nonatomic, strong) AVCaptureSession *session;    //session：由他把输入输出结合在一起，并开始启动捕获设备（摄像头）
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer; //图像预览层，实时显示捕获的图像


@property (nonatomic, strong) UIButton *cameraButton;   //照相
@property (nonatomic, strong) UIButton *cancelButton;   //取消
@property (nonatomic, strong) UIButton *changeButton;   //切换

@property (nonatomic, strong) UIImage *image;

@end

@implementation CameraPictureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if ([self canUserCamear]) {
        [self setupCamera];
        [self setupUI];
    }
}

#pragma mark - 检查相机权限
- (BOOL)canUserCamear{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusDenied) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"请打开相机权限" message:@"设置-隐私-相机" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        alertView.tag = 123;
        [alertView show];
        return NO;
    }
    return YES;
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0 && alertView.tag == 123) {
        NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        }
    }
}

#pragma mark - 设置相机
- (void)setupCamera{
    //默认使用后置摄像头进行初始化
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    //使用设备初始化输入
    self.input = [[AVCaptureDeviceInput alloc]initWithDevice:self.device error:nil];
    
    //生成输出对象
    self.output = [[AVCaptureMetadataOutput alloc]init];
    self.imageOutput = [[AVCaptureStillImageOutput alloc] init];
    
    //生成会话，用来结合输入输出
    self.session = [[AVCaptureSession alloc]init];
    //设置尺寸
    if ([self.session canSetSessionPreset:AVCaptureSessionPreset1280x720]) {
        self.session.sessionPreset = AVCaptureSessionPreset1280x720;
    }
    
    //添加输入输出
    if ([self.session canAddInput:self.input]) {
        [self.session addInput:self.input];
    }
    if ([self.session canAddOutput:self.imageOutput]) {
        [self.session addOutput:self.imageOutput];
    }
    
    //初始化预览层，self.session负责驱动input进行信息的采集，layer负责把图像渲染显示
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc]initWithSession:self.session];
    self.previewLayer.frame = KScreen_Bounds;
    self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer addSublayer:self.previewLayer];

    //开始启动
    [self.session startRunning];
    
    //
    if ([_device lockForConfiguration:nil]) {
        if ([_device isFlashModeSupported:AVCaptureFlashModeAuto]) {
            [_device setFlashMode:AVCaptureFlashModeAuto];
        }
        //自动白平衡
        if ([_device isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeAutoWhiteBalance]) {
            [_device setWhiteBalanceMode:AVCaptureWhiteBalanceModeAutoWhiteBalance];
        }
        [_device unlockForConfiguration];
    }
}

#pragma mark - 设置UI
- (UIButton*)creatButton:(NSString*)imageName title:(NSString*)textName{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    if (imageName.length > 0) {
        [button setImage:[UIImage imageNamed:imageName] forState: UIControlStateNormal];
        [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_Select", imageName]] forState:UIControlStateNormal];
    }
    if (textName.length > 0) {
        [button setTitle:textName forState:UIControlStateNormal];
    }
    
    return button;
}

- (void)setupUI {
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreen_Width, 64)];
    topView.backgroundColor = [UIColor blackColor];
    topView.alpha = 0.4;
    [self.view addSubview:topView];
    if (nil == _cameraButton) {
        _cameraButton = [self creatButton:@"photograph" title:nil];
        _cameraButton.frame = CGRectMake(0, KScreen_Height - 100, 60, 60);
        _cameraButton.centerX = self.view.centerX;

        [_cameraButton addTarget:self action:@selector(clickCameraButton) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_cameraButton];
    }
    if (nil == _cancelButton) {
        _cancelButton = [self creatButton:nil title:@"取消"];
        _cancelButton.frame = CGRectMake(10, 20, 50, 30);
        [_cancelButton addTarget:self action:@selector(clickCancelButton) forControlEvents:UIControlEventTouchUpInside];
        [topView addSubview:_cancelButton];
    }
    if (nil == _changeButton) {
        _changeButton = [self creatButton:nil title:@"切换"];
        _changeButton.frame = CGRectMake(KScreen_Width - 60, 20, 50, 30);
        [_changeButton addTarget:self action:@selector(clickChangeButton) forControlEvents:UIControlEventTouchUpInside];
        [topView addSubview:_changeButton];
    }
}

//切换
- (void)clickChangeButton{
    //摄像机的数量
    NSUInteger cameraCount = [[AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo] count];
    //大于1, 可以切换
    if (cameraCount > 1) {
        CATransition *animation = [CATransition animation];
        animation.duration = .5f;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        animation.type = @"oglFlip";
        
        //
        NSError *error;
        AVCaptureDevice *newCamera = nil;
        AVCaptureDeviceInput *newInput = nil;
        //获取前后摄像头
        AVCaptureDevicePosition position = [[_input device] position];
        if (position == AVCaptureDevicePositionFront){
            newCamera = [self cameraWithPosition:AVCaptureDevicePositionBack];
            animation.subtype = kCATransitionFromLeft;
        }else{
            newCamera = [self cameraWithPosition:AVCaptureDevicePositionFront];
            animation.subtype = kCATransitionFromRight;
        }

        //获取最新的输入设备
        newInput = [AVCaptureDeviceInput deviceInputWithDevice:newCamera error:nil];
        [self.previewLayer addAnimation:animation forKey:nil];
        
        //判断是否有
        if (newInput != nil) {
            [self.session beginConfiguration];
            [self.session removeInput:_input];
            //添加输入
            if ([self.session canAddInput:newInput]) {
                [self.session addInput:newInput];
                self.input = newInput;
            }else{
                [self.session addInput:self.input];
            }
            
            [self.session commitConfiguration];
            
        } else if (error) {
            NSLog(@"toggle carema failed, error = %@", error);
        }
    }
}
- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for ( AVCaptureDevice *device in devices ){
        if ( device.position == position ){
            return device;
        }
    }
    return nil;
}
//点击取消
- (void)clickCancelButton{
    if (self.myBlock) {
        self.myBlock(self.image);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
//点击拍照
- (void)clickCameraButton{
    AVCaptureConnection * videoConnection = [self.imageOutput connectionWithMediaType:AVMediaTypeVideo];
    if (!videoConnection) {
        NSLog(@"take photo failed!");
        return;
    }

    [self.imageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        if (imageDataSampleBuffer == NULL) {
            return;
        }
        
        //
        NSData * imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
        self.image = [UIImage imageWithData:imageData];
        [self.session stopRunning];
        
        
        [self clickCancelButton];
    }];
}

@end
