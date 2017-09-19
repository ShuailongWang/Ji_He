//
//  DistanceViewController.m
//  ios_demo_001
//
//  Created by admin on 17/9/19.
//  Copyright © 2017年 wsl. All rights reserved.
//

#import "DistanceViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <ImageIO/ImageIO.h>

@interface DistanceViewController ()

@property (nonatomic, strong) AVPlayer *player;

@end

@implementation DistanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, KScreen_Width, KScreen_Width)];
    label.center = self.view.center;
    label.numberOfLines = 0;
    label.text = @"当前默认用扬声器播放音乐，如果有物体靠近手机的听筒附近(距离传感器),音乐将从听筒播放，离开后用扬声器播放";
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    
    [self setupUI];
}

- (void)setupUI {
    // 打开距离传感器
    [UIDevice currentDevice].proximityMonitoringEnabled = YES;
    
    // 通过通知监听有物品靠近还是离开
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(proximityStateDidChange:) name:UIDeviceProximityStateDidChangeNotification object:nil];
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    //默认情况下扬声器播放
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    [audioSession setActive:YES error:nil];
    
    NSString * path = [[NSBundle mainBundle] pathForResource:@"SeeYouAgain" ofType:@"mp3"];
    if(path == nil){
        return;
    }
    self.player = [[AVPlayer alloc] initWithURL:[NSURL fileURLWithPath:path]];
    
    //播放
    [self.player play];
}

#pragma mark - 通知
- (void)proximityStateDidChange:(NSNotification *)note{
    //判断是否有物品靠近
    if ([UIDevice currentDevice].proximityState) {
        NSLog(@"有东西靠近");
        //听筒播放
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    } else {
        NSLog(@"有物体离开");
        //扬声器播放
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    }
}


#pragma mark - Dealloc
- (void)dealloc{
    [self.player pause];
    self.player = nil;
    //关闭距离传感器
    [UIDevice currentDevice].proximityMonitoringEnabled = NO;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceProximityStateDidChangeNotification object:nil];
}


@end
