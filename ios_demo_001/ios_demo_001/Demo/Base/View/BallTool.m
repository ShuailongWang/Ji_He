//
//  BallTool.m
//  ios_demo_001
//
//  Created by admin on 17/9/19.
//  Copyright © 2017年 wsl. All rights reserved.
//

#import "BallTool.h"
#import <CoreMotion/CoreMotion.h>

@interface BallTool()

@property (nonatomic, strong) CMMotionManager *manager;        //行为管理
@property (nonatomic, strong) UIGravityBehavior *gravity;      //重力行为
@property (nonatomic, strong) UIDynamicAnimator *animator;     //物理仿真器
@property (nonatomic, strong) UICollisionBehavior *collision;  //碰撞行为
@property (nonatomic, strong) UIDynamicItemBehavior *dynamic;  //运动行为

/*
 UIAttachmentBehavior *attach; 吸附
 UISnapBehavior *snap;  振动
 UIPushBehavior *push;  推
 */

@end

@implementation BallTool

static dispatch_once_t onceToken;

+ (instancetype)shareBallTool {
    static BallTool * ball;
    dispatch_once(&onceToken, ^{
        ball = [[BallTool alloc] init];
    });
    return ball;
}

- (void)addAimView:(UIView *)ballView referenceView:(UIView *)referenceView{
    _referenceView = referenceView;
    
    [self.dynamic addItem:ballView];
    [self.collision addItem:ballView];
    [self.gravity addItem:ballView];
    
    [self run];
}

//开始
- (void)run {
    if (!self.manager.accelerometerAvailable) {
        NSLog(@"手机没有加速计，换肾吧");
        return;
    }
    
    //采集频率
    self.manager.accelerometerUpdateInterval = 0.01;
    
    __weak typeof(self) weakSelf = self;
    
    //开始采集数据
    [self.manager startAccelerometerUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMAccelerometerData * _Nullable accelerometerData, NSError * _Nullable error) {
        
        if (error != nil) {
            NSLog(@"出错了 %@",error);
            return;
        }
        
        weakSelf.gravity.gravityDirection = CGVectorMake(accelerometerData.acceleration.x * 3, -accelerometerData.acceleration.y * 3);
    }];
}

- (void)stopMotionUpdates{
    if (self.manager.isAccelerometerActive) {
        [self.manager stopAccelerometerUpdates];
        [self.animator removeAllBehaviors];
        [self.collision removeAllBoundaries];
        onceToken = 0;
    }
}


#pragma mark - lan
- (CMMotionManager *)manager{
    if (nil == _manager) {
        _manager = [[CMMotionManager alloc]init];
    }
    return _manager;
}
//行为
-  (UIDynamicAnimator *)animator {
    if (_animator == nil) {
        // 设置参考边界
        _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.referenceView];
    }
    return _animator;
}
//重力
-(UIGravityBehavior *)gravity{
    if (nil == _gravity) {
        _gravity = [[UIGravityBehavior alloc]init];
        //重力加速度的倍数
        //_gravity.magnitude = 1.0;
        
        //方向 弧度
        //_gravity.angle = M_PI;
        
        //方向和速度大小的矢量
        _gravity.gravityDirection = CGVectorMake(0.1, 0.3);
        
        [self.animator addBehavior:_gravity];
    }
    return _gravity;
}
//碰撞
-(UICollisionBehavior *)collision{
    if (nil == _collision) {
        _collision = [[UICollisionBehavior alloc]init];
        //参考边界
        _collision.translatesReferenceBoundsIntoBoundary = YES;
        //碰撞 内容
        _collision.collisionMode = UICollisionBehaviorModeEverything;
        
        
        //绘制边界
        UIBezierPath * ellipsePath1 = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(30, 300, 130, 80)];
        UIBezierPath * ellipsePath2= [UIBezierPath bezierPathWithOvalInRect:CGRectMake(210, 300, 130, 80)];
        
        UIBezierPath* nosePath1 = [UIBezierPath bezierPath];
        [nosePath1 moveToPoint:CGPointMake(160, 340)];
        // 给定终点和控制点绘制贝塞尔曲线
        [nosePath1 addQuadCurveToPoint:CGPointMake(210, 340) controlPoint:CGPointMake(185, 320)];
        
        UIBezierPath* nosePath2 = [UIBezierPath bezierPath];
        [nosePath2 moveToPoint:CGPointMake(180, 420)];
        [nosePath2 addQuadCurveToPoint:CGPointMake(180, 470) controlPoint:CGPointMake(130, 470)];
        
        UIBezierPath* mouthPath = [UIBezierPath bezierPath];
        [mouthPath moveToPoint:CGPointMake(100, 550)];
        [mouthPath addQuadCurveToPoint:CGPointMake(280, 550) controlPoint:CGPointMake(140, 620)];
        
        UIBezierPath* legPath1 = [UIBezierPath bezierPath];
        [legPath1 moveToPoint:CGPointMake(30, 340)];
        [legPath1 addQuadCurveToPoint:CGPointMake(100, 100) controlPoint:CGPointMake(40, 100)];
        
        UIBezierPath* legPath2= [UIBezierPath bezierPath];
        [legPath2 moveToPoint:CGPointMake(340, 340)];
        [legPath2 addQuadCurveToPoint:CGPointMake(410, 100) controlPoint:CGPointMake(350, 100)];
        
        //添加边界
        [_collision addBoundaryWithIdentifier:@"ellipsePath1" forPath:ellipsePath1];
        [_collision addBoundaryWithIdentifier:@"ellipsePath2" forPath:ellipsePath2];
        [_collision addBoundaryWithIdentifier:@"nosePath1" forPath:nosePath1];
        [_collision addBoundaryWithIdentifier:@"nosePath2" forPath:nosePath2];
        [_collision addBoundaryWithIdentifier:@"legPath1" forPath:legPath1];
        [_collision addBoundaryWithIdentifier:@"legPath2" forPath:legPath2];
        [_collision addBoundaryWithIdentifier:@"mouthPath" forPath:mouthPath];
        
        //添加
        [self.animator addBehavior:_collision];
    }
    return _collision;
}
//
- (UIDynamicItemBehavior *)dynamic {
    if (nil == _dynamic) {
        _dynamic = [[UIDynamicItemBehavior alloc] init];
        _dynamic.friction = 0.2; //摩擦
        _dynamic.elasticity = 0.8; //弹性
        _dynamic.density = 0.2; //密度
        _dynamic.allowsRotation = YES; //允许旋转
        _dynamic.resistance = 0; //阻力
        [self.animator addBehavior:_dynamic];
    }
    return _dynamic;
}


- (void)dealloc{
    //remove
    //self.collision.boundaryIdentifiers;
    [self.collision removeAllBoundaries];
}






@end
