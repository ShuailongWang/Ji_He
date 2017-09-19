//
//  ListenViewController.m
//  ios_demo_001
//
//  Created by admin on 17/9/19.
//  Copyright © 2017年 wsl. All rights reserved.
//

#import "ListenViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <ImageIO/ImageIO.h>

@interface ListenViewController ()<AVCaptureVideoDataOutputSampleBufferDelegate>
{
    AVCaptureSession * _session;
}

@property (assign, nonatomic) BOOL isLight;

@end

@implementation ListenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.isLight = NO;
    //
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, KScreen_Width, KScreen_Width)];
    label.center = self.view.center;
    label.numberOfLines =  0;
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"环境变暗后就自动提示是否打开闪光灯，打开之后，环境变亮后会自动提示是否关闭闪光灯。";
    [self.view addSubview:label];
    
    [self setupUI];
}

- (void)setupUI {
    //获取硬件设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (device == nil) {
        NSLog(@"该设备不支持, 你该换肾了");
        return;
    }
    
    //创建输入流
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    
    //创建设备输出流
    AVCaptureVideoDataOutput *output = [[AVCaptureVideoDataOutput alloc] init];
    [output setSampleBufferDelegate:self queue:dispatch_get_main_queue()];
    
    //AVCaptureSession属性
    _session = [AVCaptureSession new];

    // 设置为高质量采集率
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    
    // 添加会话输入和输出
    if ([_session canAddInput:input]) {
        [_session addInput:input];
    }
    if ([_session canAddOutput:output]) {
        [_session addOutput:output];
    }

    //启动会话
    [_session startRunning];
}


#pragma mark- AVCaptureVideoDataOutputSampleBufferDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection{
    
    CFDictionaryRef metadataDict = CMCopyDictionaryOfAttachments(NULL,sampleBuffer, kCMAttachmentMode_ShouldPropagate);
    NSDictionary *metadata = [[NSMutableDictionary alloc] initWithDictionary:(__bridge NSDictionary*)metadataDict];
    CFRelease(metadataDict);
    NSDictionary *exifMetadata = [[metadata objectForKey:(NSString *)kCGImagePropertyExifDictionary] mutableCopy];
    float brightnessValue = [[exifMetadata objectForKey:(NSString *)kCGImagePropertyExifBrightnessValue] floatValue];
    
    NSLog(@"环境光感 ： %f",brightnessValue);

    // 根据brightnessValue的值来打开和关闭闪光灯
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // 判断设备是否有闪光灯
    BOOL result = [device hasTorch];
    
    // 打开闪光灯
    if ((brightnessValue < 0) && result) {

        if(device.torchMode == AVCaptureTorchModeOn){
            return;
        }
        //判断当打开的时候, 不走下面
        if (self.isLight) {
            return;
        }
        self.isLight = YES;
        UIAlertController * alertVC  = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否要打开闪光灯？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * openAction = [UIAlertAction actionWithTitle:@"打开" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [device lockForConfiguration:nil];
            
            [device setTorchMode: AVCaptureTorchModeOn];//开
            
            [device unlockForConfiguration];
            
        }];
        [alertVC addAction:openAction];
        UIAlertAction * cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertVC addAction:cancleAction];
        
        [self presentViewController:alertVC animated:NO completion:nil];

    }else if((brightnessValue > 0) && result) {// 关闭闪光灯
        
        if(device.torchMode == AVCaptureTorchModeOn){
            //判断当没有打开的时候, 不走下面
            if (!self.isLight) {
                return;
            }
            self.isLight = NO;
            UIAlertController * alertVC  = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否要关闭闪光灯？" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * openAction = [UIAlertAction actionWithTitle:@"关闭" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [device lockForConfiguration:nil];
                
                //关
                [device setTorchMode: AVCaptureTorchModeOff];
                [device unlockForConfiguration];
                
                
            }];
            [alertVC addAction:openAction];
            UIAlertAction * cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alertVC addAction:cancleAction];
            
            [self presentViewController:alertVC animated:NO completion:nil];
        }
    }
}



- (void)dealloc{
    [_session stopRunning];
    _session = nil;
}




@end
