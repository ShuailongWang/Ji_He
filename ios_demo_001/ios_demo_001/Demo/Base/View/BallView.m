//
//  BallView.m
//  ios_demo_001
//
//  Created by admin on 17/9/19.
//  Copyright © 2017年 wsl. All rights reserved.
//

#import "BallView.h"
#import "BallTool.h"

@interface BallView()

@property (nonatomic, assign) UIDynamicItemCollisionBoundsType collisionType;
@property (nonatomic, strong) BallTool * ball;

@end

@implementation BallView
@synthesize collisionType;

- (instancetype)initWithFrame:(CGRect)frame AndImageName:(NSString *)imageName {
    if (self = [super initWithFrame:frame]) {
        
        self.image = [UIImage imageNamed:imageName];
        self.layer.cornerRadius = frame.size.width * 0.5;
        self.layer.masksToBounds = YES;
        self.collisionType = UIDynamicItemCollisionBoundsTypeEllipse;
    }
    return self;
}

- (void)starMotion {
    BallTool * ball = [BallTool shareBallTool];
    [ball addAimView:self referenceView:self.superview];
}

- (void)stopMotion{
    BallTool * ball = [BallTool shareBallTool];
    [ball stopMotionUpdates];
}

@end
