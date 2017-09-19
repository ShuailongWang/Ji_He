//
//  SaoViewController.m
//  ios_demo_001
//
//  Created by admin on 17/9/19.
//  Copyright © 2017年 wsl. All rights reserved.
//

#import "SaoViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "SaoView.h"
#import "SaoSuccessViewController.h"

@interface SaoViewController ()<AVCaptureMetadataOutputObjectsDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic,strong) AVCaptureSession *session;                 //会话对象
@property (nonatomic,strong) AVCaptureVideoPreviewLayer *previewLayer;  //previewLayer
@property (nonatomic,strong) SaoView *saoView;

@end

@implementation SaoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"相册" style:(UIBarButtonItemStyleDone) target:self action:@selector(rightBarButtonItemAction)];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self.saoView removeTimer];
    [self.saoView removeFromSuperview];
    
    self.saoView = nil;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self setupUI];
    [self.view addSubview:self.saoView];
}


#pragma mark - 扫描二维码
- (void)setupUI {
    
    //获取摄像设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //创建输入流
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    //创建输出流
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
    //设置代理，在主线程中刷新
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    //设置扫描范围（取值范围0-1，一屏幕右上角为坐标原点）
    output.rectOfInterest = CGRectMake(0.2, 0.2, 0.6, 0.6);
    
    _session = [[AVCaptureSession alloc] init];
    //设置采集率
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    
    //添加会话输入输出
    [_session addInput:input];
    [_session addOutput:output];
    
    //设置输出数据类型，需要将元数据输出添加到会话中，才能指定元数据类型
    //设置扫码支持的编码格式
    output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN8Code,AVMetadataObjectTypeEAN13Code,AVMetadataObjectTypeCode128Code];
    
    //初始化previewLayer，传递给session将要显示什么
    _previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _previewLayer.frame = self.view.layer.bounds;
    
    //将图层插入当前视图
    [self.view.layer insertSublayer:_previewLayer atIndex:0];
    //启动会话
    [_session startRunning];
}


#pragma mark - Delegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    
    //播放音效
    [self playSoundEffectWithName:@"QRCode.bundle/sound.caf"];
    
    //扫描完成，停止会话
    [self.session stopRunning];
    
    //删除预览层
    [self.previewLayer removeFromSuperlayer];
    
    if (metadataObjects.count > 0) {
        
        AVMetadataMachineReadableCodeObject *obj = metadataObjects[0];
        NSString *saoStr = obj.stringValue;
        
        //扫描成功, 跳转
        SaoSuccessViewController *successVC = [[SaoSuccessViewController alloc]init];
        successVC.saoStr = saoStr;
        [self.navigationController pushViewController:successVC animated:YES];
    }
    
}

//播放音效文件
- (void)playSoundEffectWithName:(NSString *)name{
    
    //获取音效
    NSString *audioFile = [[NSBundle mainBundle] pathForResource:name ofType:nil];
    NSURL *fileUrl = [NSURL fileURLWithPath:audioFile];
    
    //获得系统声音ID
    SystemSoundID soundID = 0;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)fileUrl, &soundID);
    AudioServicesAddSystemSoundCompletion(soundID, NULL, NULL, soundCompleteCallback, NULL);
    
    //震动
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    //播放音效
    AudioServicesPlaySystemSound(soundID);
}

//播放完毕回调函数
void soundCompleteCallback(SystemSoundID soundID, void *clientData){
    
    
}


#pragma mark - 识别相册中的二维码
- (void)rightBarButtonItemAction{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
        
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        //设置允许编辑
        imagePicker.allowsEditing = NO;
        [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        [self presentViewController:imagePicker animated:YES completion:nil];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"访问相册失败" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }
}
#pragma mark - imagePickerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    [picker dismissViewControllerAnimated:YES completion:^{
        //选择的照片
        UIImage *selectedImage = info[UIImagePickerControllerOriginalImage];
        [self scanQRCodeFromPhotoAlbum:selectedImage];
    }];
}
//从相册中识别二维码
- (void)scanQRCodeFromPhotoAlbum:(UIImage *)image{
    
    //CIDeterctor可用于人脸识别，进行图片解析
    //声明CIDeterctor,设定type为QRCode
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{CIDetectorAccuracy : CIDetectorAccuracyHigh}];
    
    NSArray *features = [detector featuresInImage:[CIImage imageWithCGImage:image.CGImage]];
    for (CIQRCodeFeature *result in features) {
        
        NSString *saoStr = result.messageString;

        //识别成功, 跳转
        SaoSuccessViewController *successVC = [[SaoSuccessViewController alloc]init];
        successVC.saoStr = saoStr;
        successVC.image = image;
        [self.navigationController pushViewController:successVC animated:YES];
    }
    
    if (features.count == 0) {
        //识别成功, 跳转
        SaoSuccessViewController *successVC = [[SaoSuccessViewController alloc]init];
        successVC.saoStr = @"识别失败";
        [self.navigationController pushViewController:successVC animated:YES];
    }
}

#pragma mark - 懒加载
- (SaoView *)saoView{
    if (nil == _saoView) {
        _saoView = [[SaoView alloc] initWithFrame:self.view.bounds layer:self.view.layer];
    }
    return _saoView;
}

@end
