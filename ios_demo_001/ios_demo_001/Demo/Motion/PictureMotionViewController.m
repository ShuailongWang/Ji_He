//
//  PictureMotionViewController.m
//  ios_demo_001
//
//  Created by admin on 17/9/20.
//  Copyright © 2017年 wsl. All rights reserved.
//

#import "PictureMotionViewController.h"
#import "GravityView.h"

@interface PictureMotionViewController ()

@property (nonatomic, strong) GravityView *gravityView;

@end

@implementation PictureMotionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupUI];
}

- (void)setupUI {
    if (nil == _gravityView) {
        _gravityView = [[GravityView alloc]initWithFrame:self.view.bounds];
        _gravityView.image = [UIImage imageNamed:@"bgImage_001"];
        [self.view addSubview:_gravityView];
    }
    
    [_gravityView startGravity];
}

-(void)dealloc{
    [self.gravityView stopGravity];
}

@end
