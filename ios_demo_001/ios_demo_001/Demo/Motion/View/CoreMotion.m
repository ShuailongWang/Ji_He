//
//  CoreMotion.m
//  ios_demo_001
//
//  Created by admin on 17/9/20.
//  Copyright © 2017年 wsl. All rights reserved.
//

#import "CoreMotion.h"

@implementation CoreMotion
{
    NSOperationQueue *_queue;//开启线程
    
    void (^_openAcceleratedGravityUpBlock)(float x,float y,float z);
    void (^_openGravityUpBlock)(float x,float y,float z);
    void (^_openDeviceMotionUpBlock)(float x,float y,float z);
}

+ (CoreMotion*)shareInstance{
    static CoreMotion *coreMotin = nil;
    static dispatch_once_t one;
    dispatch_once(&one, ^{
        coreMotin = [[self alloc]init];
    });
    return coreMotin;
}
- (instancetype)init{
    if (self = [super init]) {
        [self setupUI];
    }
    return self;
}


//设置
- (void)setupUI{
    _manager = [[CMMotionManager alloc]init];
    
    //添加线程队列
    _queue = [[NSOperationQueue alloc]init];
}


//开启重力加速度 使用block 返回xyz
- (void)openAccelerteGravity:(openAcceleratedGravityUpBlock)block{
    //加速度
    if (_manager.accelerometerAvailable) {
        //更新速度
        _manager.accelerometerUpdateInterval = _timeInterval;
        
        //开始
        [_manager startAccelerometerUpdatesToQueue:_queue withHandler:^(CMAccelerometerData * _Nullable accelerometerData, NSError * _Nullable error) {
            _openAcceleratedGravityUpBlock = block;
            if (error) {
                [_manager stopAccelerometerUpdates];
                NSLog(@"%@",error.localizedDescription);
            }
            else{
                [self performSelectorOnMainThread:@selector(accelerometerUpdate:) withObject:accelerometerData waitUntilDone:NO];
            }
        }];
        
    }else{
        NSLog(@"设备没有加速器");
    }
}
- (void)accelerometerUpdate:(CMAccelerometerData*)accelerometerData{
    //重力加速度三维
    _openAcceleratedGravityUpBlock(accelerometerData.acceleration.x, accelerometerData.acceleration.y, accelerometerData.acceleration.z);
}

//开启重力感应
- (void)openGravity:(openGravityUpBlock)block{
    //重力感应
    if (_manager.gyroAvailable) {
        //更新速度
        _manager.gyroUpdateInterval = _timeInterval;
        
        
        [_manager startGyroUpdatesToQueue:_queue withHandler:^(CMGyroData * _Nullable gyroData, NSError * _Nullable error) {
            if (error) {
                //停止重力感应更新
                [_manager stopGyroUpdates];
                NSLog(@"%@",[NSString stringWithFormat:@"gryerror:%@",error]);
            }else{
                
                _openGravityUpBlock = block;
                //回主线程
                [self performSelectorOnMainThread:@selector(gyroUpdate:) withObject:gyroData waitUntilDone:NO];
                
            }
            
        }];
        
    }else{
        NSLog(@"该设备没有重力感应");
    }
}

- (void)gyroUpdate:(CMGyroData *)gyroData{
    //三维
    _openGravityUpBlock(gyroData.rotationRate.x, gyroData.rotationRate.y, gyroData.rotationRate.z);
}

//开启陀螺仪
- (void)openDeviceMotion:(openDeviceMotionUpBlock)block{
    //判断陀螺仪
    if (_manager.deviceMotionAvailable) {
        //更新
        _manager.deviceMotionUpdateInterval = _timeInterval;
        
        //
        [_manager startDeviceMotionUpdatesToQueue:_queue withHandler:^(CMDeviceMotion * _Nullable motion, NSError * _Nullable error) {
            _openDeviceMotionUpBlock  = block;
            if (error) {
                [_manager stopDeviceMotionUpdates];
                NSLog(@"%@",error.localizedDescription);
            }else{
                [self performSelectorOnMainThread:@selector(deviceMotionUpdate:) withObject:motion waitUntilDone:NO];
            }
            
        }];
    }else{
        NSLog(@"设备没有陀螺仪");
    }
}

-(void)deviceMotionUpdate:(CMDeviceMotion *)motionData{
    //三维
    _openDeviceMotionUpBlock(motionData.rotationRate.x, motionData.rotationRate.y, motionData.rotationRate.z);
}

//停止
- (void)stop{
    [_manager stopGyroUpdates];
    [_manager stopDeviceMotionUpdates];
    [_manager stopAccelerometerUpdates];
}

@end
