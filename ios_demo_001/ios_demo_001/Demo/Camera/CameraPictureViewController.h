//
//  CameraPictureViewController.h
//  ios_demo_001
//
//  Created by admin on 17/9/22.
//  Copyright © 2017年 wsl. All rights reserved.
//

#import "BaseViewController.h"

@interface CameraPictureViewController : BaseViewController

@property (copy, nonatomic) void(^myBlock)(UIImage *image);

@end
