//
//  GravityView.m
//  ios_demo_001
//
//  Created by admin on 17/9/20.
//  Copyright © 2017年 wsl. All rights reserved.
//

#import "GravityView.h"
#import "CoreMotion.h"

@implementation GravityView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    _imageView = [[UIImageView alloc]init];
    [self addSubview:_imageView];
}

-(void)setImage:(UIImage *)image{
    _image = image;
    
    _imageView.image = image;
    [_imageView sizeToFit];
    
    CGFloat viewHeight = self.frame.size.height;
    CGFloat width = viewHeight * (_imageView.frame.size.width / _imageView.frame.size.height);
    CGFloat height = viewHeight;
    _imageView.frame = CGRectMake(0, 0, width, height);
    _imageView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
}


//开始重力感应
-(void)startGravity{
    float scrollSpeed = (_imageView.frame.size.width - self.frame.size.width)/2/25;
    
    //时间间隔
    [CoreMotion shareInstance].timeInterval = 0.01;
    
    //开启陀螺仪
    [[CoreMotion shareInstance] openDeviceMotion:^(float x, float y, float z) {
        //动画设置
        [UIView animateKeyframesWithDuration:0.3 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeDiscrete animations:^{
            //判断图片超出左边 并且图片大于等于屏幕宽-图片宽
            if (_imageView.frame.origin.x <= 0 && _imageView.frame.origin.x >= (self.frame.size.width - _imageView.frame.size.width)) {
                float invertedYRotationRate = y * 0.1;
                
                float interpretedXoffset = _imageView.frame.origin.x + invertedYRotationRate * (_imageView.frame.size.width/[UIScreen mainScreen].bounds.size.width) * scrollSpeed+_imageView.frame.size.width/2;
                
                
                _imageView.center = CGPointMake(interpretedXoffset, _imageView.center.y);
            }
            
            //图片在右边
            if (_imageView.frame.origin.x > 0) {
                _imageView.frame = CGRectMake(0, _imageView.frame.origin.y, _imageView.frame.size.width, _imageView.frame.size.height);
            }
            if (_imageView.frame.origin.x < self.frame.size.width - _imageView.frame.size.width) {
                _imageView.frame = CGRectMake(self.frame.size.width - _imageView.frame.size.width, _imageView.frame.origin.y, _imageView.frame.size.width, _imageView.frame.size.height);
            }
        } completion:nil];
    }];
}

//停止重力感应
-(void)stopGravity{
    [[CoreMotion shareInstance]stop];
}
















@end
