//
//  GravityView.h
//  ios_demo_001
//
//  Created by admin on 17/9/20.
//  Copyright © 2017年 wsl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GravityView : UIView

@property (nonatomic, strong, readonly) UIImageView *imageView;
@property (nonatomic, strong) UIImage *image;

/**
 *  开始重力感应
 */

-(void)startGravity;

/**
 *  停止重力感应
 */
-(void)stopGravity;

@end
