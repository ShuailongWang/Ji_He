//
//  BallViewController.m
//  ios_demo_001
//
//  Created by admin on 17/9/19.
//  Copyright © 2017年 wsl. All rights reserved.
//

#import "BallViewController.h"
#import "BezierPathView.h"
#import "BallView.h"

@interface BallViewController ()

@end

@implementation BallViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupUI];
}

- (void)setupUI {

    BezierPathView * referenceView = [[BezierPathView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64)];
    referenceView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:referenceView];
    
    
    BallView * ellipseBallView1 = [[BallView alloc] initWithFrame:CGRectMake(30, 300, 30, 30) AndImageName:@"eyes.png"];
    [referenceView addSubview:ellipseBallView1];
    [ellipseBallView1 starMotion];
    
    BallView * ellipseBallView2 = [[BallView alloc] initWithFrame:CGRectMake(230, 300, 30, 30) AndImageName:@"eyes.png"];
    [referenceView addSubview:ellipseBallView2];
    [ellipseBallView2 starMotion];

}

- (void)dealloc{
    for (BezierPathView *referenceView in self.view.subviews) {
        for (BallView *ballView in referenceView.subviews) {
            [ballView stopMotion];
        }
    }
}
@end
