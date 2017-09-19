//
//  SaoView.h
//  ios_demo_001
//
//  Created by admin on 17/9/19.
//  Copyright © 2017年 wsl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SaoView : UIView

/**
 *  对象方法初始化
 */
- (instancetype)initWithFrame:(CGRect)frame layer:(CALayer *)layer;

/**
 *  用类方法初始化
 */
+ (instancetype)scanViewWithFrame:(CGRect)frame layer:(CALayer *)layer;

/*
 *  移除定时器
 */
- (void)removeTimer;

@end
