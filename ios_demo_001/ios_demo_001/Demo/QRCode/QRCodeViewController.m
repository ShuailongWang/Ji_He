//
//  QRCodeViewController.m
//  ios_demo_001
//
//  Created by admin on 17/9/19.
//  Copyright © 2017年 wsl. All rights reserved.
//

#import "QRCodeViewController.h"
#import "CreatViewController.h"
#import "SaoViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface QRCodeViewController ()

@end

@implementation QRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self setupUI];
}

- (UIButton*)creatButton:(NSString*)name{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:name forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.layer.borderWidth = 1;
    button.layer.borderColor = [[UIColor blueColor] CGColor];
    return button;
}

- (void)setupUI {
    CGFloat wh = KScreen_Width/3;
    CGFloat y = self.view.center.y - wh/2;
    CGFloat button1X = wh/2 - 10;
    UIButton *button = [self creatButton:@"生成二维码"];
    button.frame = CGRectMake(button1X, y, wh, wh);
    [button addTarget:self action:@selector(clickCreatButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    CGFloat button2X = CGRectGetMaxX(button.frame) + 20;
    UIButton *button2 = [self creatButton:@"扫描二维码"];
    button2.frame = CGRectMake(button2X, y, wh, wh);
    [button2 addTarget:self action:@selector(clickSaoButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button2];
}

//生
- (void)clickCreatButton{
    CreatViewController *creatVC = [[CreatViewController alloc]init];
    [self.navigationController pushViewController:creatVC animated:YES];
}

//扫
- (void)clickSaoButton{
    //获取摄像设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (device) {
        
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (status == AVAuthorizationStatusNotDetermined) {
            
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                
                if (granted) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        SaoViewController *saoVC = [[SaoViewController alloc]init];
                        [self.navigationController pushViewController:saoVC animated:YES];
                    });
                }else{
                    
                    NSLog(@"用户拒绝了访问相机权限");
                }
            }];
        } else if (status == AVAuthorizationStatusAuthorized){
            
            SaoViewController *saoVC = [[SaoViewController alloc]init];
            [self.navigationController pushViewController:saoVC animated:YES];
        } else if (status == AVAuthorizationStatusDenied){
            
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"⚠️ 警告" message:@"请去-> [设置 - 隐私 - 相机 - SGQRCodeExample] 打开访问开关" preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            [alertC addAction:alertA];
            [self presentViewController:alertC animated:YES completion:nil];
        } else if (status == AVAuthorizationStatusRestricted){
            
            NSLog(@"系统原因,无法访问相册");
        }
        
    }else{
        
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"未检测到您的摄像头" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alert1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertVC addAction:alert1];
        [self presentViewController:alertVC animated:YES completion:nil];
    }
}

@end
