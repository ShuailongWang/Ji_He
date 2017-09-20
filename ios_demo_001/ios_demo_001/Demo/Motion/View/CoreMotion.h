//
//  CoreMotion.h
//  ios_demo_001
//
//  Created by admin on 17/9/20.
//  Copyright © 2017年 wsl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMotion/CoreMotion.h>

typedef void (^openAcceleratedGravityUpBlock)(float x,float y,float z);
typedef void (^openGravityUpBlock)(float x,float y,float z);
typedef void (^openDeviceMotionUpBlock)(float x,float y,float z);

@interface CoreMotion : NSObject

@property (nonatomic, strong) CMMotionManager *manager;                     //管理
@property (nonatomic ,assign) float timeInterval;                           //时间间隔
@property (nonatomic ,copy)   openAcceleratedGravityUpBlock block;          //重力加速度
@property (nonatomic ,copy)   openGravityUpBlock gravityblock;              //重力感应
@property (nonatomic ,copy)   openDeviceMotionUpBlock deviceMotionblock;    //陀螺仪

+ (CoreMotion*)shareInstance;


/**
 *  开启重力加速度 使用block 返回xyz
 */
- (void)openAccelerteGravity:(openAcceleratedGravityUpBlock)block;

/**
 *  开启重力感应
 */
- (void)openGravity:(openGravityUpBlock)block;

/**
 *  开启陀螺仪
 */
- (void)openDeviceMotion:(openDeviceMotionUpBlock)block;

/**
 *  停止
 */
- (void)stop;

@end
