//
//  YaoViewController.m
//  ios_demo_001
//
//  Created by admin on 17/9/19.
//  Copyright © 2017年 wsl. All rights reserved.
//

#import "YaoViewController.h"
#import <CoreMotion/CoreMotion.h>

@interface YaoViewController ()

@property (nonatomic, strong) CMMotionManager * motionManager;

@end

@implementation YaoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self setupUI];
}


- (void)setupUI {
    // 设置允许摇一摇功能
    [UIApplication sharedApplication].applicationSupportsShakeToEdit = YES;
    
    // 并让自己成为第一响应者
    [self becomeFirstResponder];
    
    
    UIImageView * imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, KScreen_Width/2, 250)];
    imageView2.center = self.view.center;
    imageView2.image = [UIImage imageNamed:@"qiaoba.jpeg"];
    [self.view addSubview:imageView2];
    
    
    //初始化全局管理对象
    self.motionManager = [[CMMotionManager alloc] init];
    
    //判断陀螺仪是否可用和开启&& [self.motionManager isGyroActive]
    if ([self.motionManager isGyroAvailable] ){
        //更新频率是100Hz
        self.motionManager.gyroUpdateInterval = 0.1;
        //Push方式获取和处理数据
        [self.motionManager startGyroUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMGyroData *gyroData, NSError *error) {
            //设备在X、Y、Z轴上所旋转的角速度
//             NSLog(@"Gyro Rotation x = %.04f", gyroData.rotationRate.x);
//             NSLog(@"Gyro Rotation y = %.04f", gyroData.rotationRate.y);
//             NSLog(@"Gyro Rotation z = %.04f", gyroData.rotationRate.z);
             
         }];
    }
}

#pragma maerk -- 摇一摇
- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    NSLog(@"开始摇了，坐稳咯");
}
- (void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    NSLog(@"不摇了，你走吧");
}
- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    NSLog(@"摇完了，下车吧");
}

@end
