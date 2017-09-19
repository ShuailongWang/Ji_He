//
//  SaoView.m
//  ios_demo_001
//
//  Created by admin on 17/9/19.
//  Copyright © 2017年 wsl. All rights reserved.
//

#import "SaoView.h"


#define ScanContentX                [UIScreen mainScreen].bounds.size.width * 0.15
#define ScanContentY                [UIScreen mainScreen].bounds.size.height * 0.24

static CGFloat const outsideViewAlpha = 0.6;                //扫描框外面的alpha
static CGFloat const QRCodeScanningLineAnimation = 0.05;    //二维码冲击波动画时间

@interface SaoView()

@property (nonatomic,strong) CALayer *tempLayer;            //临时赋值layer
@property (nonatomic,strong) UIImageView *scanLineImgView;  //扫描线
@property (nonatomic,strong) NSTimer *timer;                //动画计时器

@end

@implementation SaoView

- (instancetype)initWithFrame:(CGRect)frame layer:(CALayer *)layer{
    if (self = [super initWithFrame:frame]) {
        self.tempLayer = layer;

        [self setupUI];
        
        [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
        
        [self addSubview:self.scanLineImgView];
    }
    return self;
}

+ (instancetype)scanViewWithFrame:(CGRect)frame layer:(CALayer *)layer{
    return [[self alloc] initWithFrame:frame layer:layer];
}

- (void)setupUI{
    
    CALayer *scanContentLayer = [[CALayer alloc] init];
    CGFloat scanContentWidth = self.bounds.size.width - ScanContentX * 2;
    scanContentLayer.frame = CGRectMake(ScanContentX, ScanContentY, scanContentWidth, scanContentWidth);
    scanContentLayer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6].CGColor;
    scanContentLayer.borderWidth = 0.7;
    scanContentLayer.backgroundColor = [UIColor clearColor].CGColor;
    [self.tempLayer addSublayer:scanContentLayer];
    
    //创建扫描框以外的layer
    CALayer *topLayer = [[CALayer alloc] init];
    topLayer.frame = CGRectMake(0, 0, self.bounds.size.width, ScanContentY);
    topLayer.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:outsideViewAlpha].CGColor;
    [self.tempLayer addSublayer:topLayer];
    
    CALayer *leftLayer = [[CALayer alloc] init];
    leftLayer.frame = CGRectMake(0, ScanContentY, ScanContentX, scanContentWidth);
    leftLayer.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:outsideViewAlpha].CGColor;
    [self.tempLayer addSublayer:leftLayer];
    
    CALayer *rightLayer = [[CALayer alloc] init];
    rightLayer.frame = CGRectMake(ScanContentX + scanContentWidth, ScanContentY, ScanContentX, scanContentWidth);
    rightLayer.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:outsideViewAlpha].CGColor;
    [self.tempLayer addSublayer:rightLayer];
    
    CALayer *bottomLayer = [[CALayer alloc] init];
    bottomLayer.frame = CGRectMake(0, ScanContentY + scanContentWidth, self.bounds.size.width, self.bounds.size.height - ScanContentY - scanContentWidth);
    bottomLayer.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:outsideViewAlpha].CGColor;
    [self.tempLayer addSublayer:bottomLayer];
    
    //创建四个角的image
    //左
    UIImage *leftImage = [UIImage imageNamed:@"QRCode.bundle/QRCodeLeftTop"];
    UIImageView *leftImgView = [[UIImageView alloc] initWithFrame:CGRectMake(ScanContentX, ScanContentY, leftImage.size.width, leftImage.size.height)];
    leftImgView.image = leftImage;
    [self.tempLayer addSublayer:leftImgView.layer];
    
    //右
    UIImage *rightImage = [UIImage imageNamed:@"QRCode.bundle/QRCodeRightTop"];
    UIImageView *rightImgView = [[UIImageView alloc] initWithFrame:CGRectMake(ScanContentX + scanContentWidth - rightImage.size.width, ScanContentY, rightImage.size.width, rightImage.size.height)];
    rightImgView.image = rightImage;
    [self.tempLayer addSublayer:rightImgView.layer];
    
    //左下
    UIImage *leftBottomImage = [UIImage imageNamed:@"QRCode.bundle/QRCodeLeftBottom"];
    UIImageView *leftBottomImgView = [[UIImageView alloc] initWithFrame:CGRectMake(ScanContentX, ScanContentY + scanContentWidth - leftBottomImage.size.height, leftBottomImage.size.width, leftBottomImage.size.height)];
    leftBottomImgView.image = leftBottomImage;
    [self.tempLayer addSublayer:leftBottomImgView.layer];
    
    //右下
    UIImage *rightBottomImage = [UIImage imageNamed:@"QRCode.bundle/QRCodeRightBottom"];
    UIImageView *rightBottomImgView = [[UIImageView alloc] initWithFrame:CGRectMake(ScanContentX + scanContentWidth - rightBottomImage.size.width, ScanContentY + scanContentWidth - rightBottomImage.size.height, rightBottomImage.size.width, rightBottomImage.size.height)];
    rightBottomImgView.image = rightBottomImage;
    [self.tempLayer addSublayer:rightBottomImgView.layer];
}


#pragma mark - 懒加载
- (CALayer *)tempLayer{
    if (nil == _tempLayer) {
        _tempLayer = [[CALayer alloc] init];
    }
    return _tempLayer;
}

- (UIImageView *)scanLineImgView{
    
    if (!_scanLineImgView) {
        CGFloat scanContentWidth = self.bounds.size.width - ScanContentX * 2;
        _scanLineImgView = [[UIImageView alloc] initWithFrame:CGRectMake(ScanContentX , ScanContentY, scanContentWidth , 12)];
        _scanLineImgView.image = [UIImage imageNamed:@"QRCode.bundle/QRCodeScanningLine"];
    }
    return _scanLineImgView;
}

- (NSTimer *)timer{
    if (nil == _timer) {
        
        _timer = [NSTimer scheduledTimerWithTimeInterval:QRCodeScanningLineAnimation target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    }
    return _timer;
}

- (void)timerAction{
    __block CGRect lineFrame = _scanLineImgView.frame;
    CGFloat scanContentWidth = self.bounds.size.width - ScanContentX * 2;
    
    if (_scanLineImgView.frame.origin.y >= ScanContentY) {
        
        if (_scanLineImgView.frame.origin.y >= ScanContentY + scanContentWidth - 12) {
            
            lineFrame.origin.y = ScanContentY;
            _scanLineImgView.frame = lineFrame;
        }else{
            [UIView animateWithDuration:QRCodeScanningLineAnimation animations:^{
                lineFrame.origin.y += 5;
                _scanLineImgView.frame = lineFrame;
            }];
        }
    }else{
        lineFrame.origin.y = ScanContentY;
        _scanLineImgView.frame = lineFrame;
    }
}

- (void)removeTimer{
    
    [self.timer invalidate];
    self.timer = nil;
    
    [self.scanLineImgView removeFromSuperview];
    self.scanLineImgView = nil;
}

@end
