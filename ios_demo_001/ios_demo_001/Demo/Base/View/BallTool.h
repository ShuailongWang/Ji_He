//
//  BallTool.h
//  ios_demo_001
//
//  Created by admin on 17/9/19.
//  Copyright © 2017年 wsl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BallTool : NSObject

//参照视图，设置仿真范围）
@property (nonatomic, weak) UIView * referenceView;

+ (instancetype)shareBallTool;

//添加
- (void)addAimView:(UIView *)ballView referenceView:(UIView *)referenceView;

//停止
- (void)stopMotionUpdates;

@end
