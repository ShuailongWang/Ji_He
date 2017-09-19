//
//  GyroscopeViewController.m
//  ios_demo_001
//
//  Created by admin on 17/9/19.
//  Copyright © 2017年 wsl. All rights reserved.
//

#import "GyroscopeViewController.h"
#import <CoreMotion/CoreMotion.h>

@interface GyroscopeViewController ()

@property (nonatomic, strong) CMPedometer *stepCounter;         //计步器
@property (nonatomic, strong) UILabel *label;

@end

@implementation GyroscopeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, KScreen_Width, KScreen_Width)];
    label.center = self.view.center;
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"您一共走了 0 步 0 米";
    [self.view addSubview:label];
    self.label = label;
    
    
    [self setupUI];
}

- (void)setupUI {
    //判断计步器是否可用
    if (![CMPedometer isStepCountingAvailable] && ![CMPedometer isDistanceAvailable]) {
        NSLog(@"记步功能不可用");
        return;
    }
    
    //创建计步器对象
    self.stepCounter = [[CMPedometer alloc] init];
    
    //开始计步(走多少步之后调用一次该方法)
    //FromDate : 从什么时间开始计步
    NSDate *date = [NSDate date];
    [self.stepCounter startPedometerUpdatesFromDate:date withHandler:^(CMPedometerData * _Nullable pedometerData, NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@", error);
            return;
        }
        
        self.label.text = [NSString stringWithFormat:@"您一共走了%@步  %@米", pedometerData.numberOfSteps, pedometerData.distance];
        
    }];
}



@end
