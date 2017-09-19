//
//  MotionViewController.m
//  ios_demo_001
//
//  Created by admin on 17/9/19.
//  Copyright © 2017年 wsl. All rights reserved.
//

#import "MotionViewController.h"
#import <CoreMotion/CoreMotion.h>

@interface MotionViewController ()

@property (nonatomic, strong) CMMotionManager *motionManager;

@end

@implementation MotionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupUI];
}

- (void)setupUI {
    UIImageView * imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, KScreen_Width/2, 250)];
    imageView1.center = self.view.center;
    imageView1.image = [UIImage imageNamed:@"qiaoba.jpeg"];
    [self.view addSubview:imageView1];
    
    
    //
    self.motionManager= [[CMMotionManager alloc] init];
    
    //判断设备运动传感器是否可用
    if(!self.motionManager.isDeviceMotionAvailable){
        NSLog(@"手机没有此功能，换肾吧");
        
        return;
    }
    
    //更新速率是100Hz
    self.motionManager.deviceMotionUpdateInterval = 0.1;
    
    //开始更新采集数据
    
    //1, 需要时采集数据
    //[motionManager startDeviceMotionUpdates];
    
    //2, 实时获取数据
    [self.motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMDeviceMotion * _Nullable motion, NSError * _Nullable error) {
        //获取X的值
        //double x = motion.gravity.x;
        
        //手机水平位置测试
        //判断y是否小于0，大于等于-1.0
        if(motion.gravity.y < 0.0 && motion.gravity.y >= -1.0){
            //设置旋转
            [self setRotation:80 * motion.gravity.y image:imageView1];
        }else if (motion.gravity.z * -1 > 0 && motion.gravity.z * -1 <= 1.0){
            [self setRotation:80 - (80 * motion.gravity.z * -1) image:imageView1];
        }

//        //X、Y方向上的夹角
//        double rotation = atan2(motion.gravity.x, motion.gravity.y) - M_PI;
//        NSLog(@"%.2f",rotation);
//        //图片始终保持垂直方向
//        imageView2.transform = CGAffineTransformMakeRotation(rotation);
    }];
}

- (void)setRotation:(CGFloat)degress image:(UIImageView*)imageView{
    CATransform3D tranform = CATransform3DIdentity;
    tranform.m34 = 1.0 / 100;
    CGFloat radiants = degress / 360 * M_PI;
    //旋转
    tranform = CATransform3DRotate(tranform, radiants, 1.0f, 0.0f, 0.0f);
    
    //锚点
    CALayer * layer = imageView.layer;
    layer.anchorPoint = CGPointMake(0.5, 0.5);
    layer.transform = tranform;
}

@end
