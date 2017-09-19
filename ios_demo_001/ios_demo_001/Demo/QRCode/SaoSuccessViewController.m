//
//  SaoSuccessViewController.m
//  ios_demo_001
//
//  Created by admin on 17/9/19.
//  Copyright © 2017年 wsl. All rights reserved.
//

#import "SaoSuccessViewController.h"

@interface SaoSuccessViewController ()

@end

@implementation SaoSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"成功";
}


-(void)setSaoStr:(NSString *)saoStr{
    _saoStr = saoStr;
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, KScreen_Width, KScreen_Width)];
    label.center = self.view.center;
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentCenter;
    label.text = saoStr;
    [self.view addSubview:label];
    
}

-(void)setImage:(UIImage *)image{
    _image = image;
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 100, 80, 80)];
    imageView.image = image;
    [self.view addSubview:imageView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
