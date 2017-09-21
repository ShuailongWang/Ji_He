//
//  WordsViewController.m
//  ios_demo_001
//
//  Created by admin on 17/9/21.
//  Copyright © 2017年 wsl. All rights reserved.
//

#import "WordsViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface WordsViewController ()<AVSpeechSynthesizerDelegate>
{
    AVSpeechSynthesizer *avSpeech;
}

@property (nonatomic, strong) UITextView *textView;

@end

@implementation WordsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"文字转语音";
    
    [self setupUI];
}

- (void)setupUI {
    self.textView = [[UITextView alloc]initWithFrame:CGRectMake(10, 65, KScreen_Width - 20, KScreen_Width)];
    self.textView.font = [UIFont systemFontOfSize:15];
    self.textView.text = @"锦瑟无端五十弦，一弦一柱思华年。庄生晓梦迷蝴蝶，望帝春心托杜鹃。沧海月明珠有泪，蓝田日暖玉生烟。此情可待成追忆，只是当时已惘然。";
    self.textView.layer.borderColor = [UIColor blackColor].CGColor;
    self.textView.layer.borderWidth = 1;
    [self.view addSubview:self.textView];

    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0,0,50,50);
    [button setTitle:@"讲"forState:UIControlStateNormal];
    [button setTitle:@"停"forState:UIControlStateSelected];
    [button setTitleColor:[UIColor blueColor]forState:UIControlStateNormal];
    button.showsTouchWhenHighlighted = YES;
    [button addTarget:self action:@selector(start:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

//点击按钮
- (void)start:(UIButton*)sender{
    
    if(sender.selected == NO) {
        //判断是否暂停
        if([avSpeech isPaused]) {
            
            //如果暂停则恢复，会从暂停的地方继续
            [avSpeech continueSpeaking];
            
            sender.selected = !sender.selected;
            
        }else{
            //创建
            avSpeech = [[AVSpeechSynthesizer alloc]init];
            avSpeech.delegate = self;
            
            //需要转换的文字
            AVSpeechUtterance *utterance = [[AVSpeechUtterance alloc]initWithString:self.textView.text];
            
            // 设置语速，范围0-1，注意0最慢，1最快；
            // AVSpeechUtteranceMinimumSpeechRate最慢，AVSpeechUtteranceMaximumSpeechRate最快
            utterance.rate = 0.5;
            
            //设置发音，这是中文普通话
            AVSpeechSynthesisVoice *voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"zh-CN"];
            utterance.voice = voice;
            
            //开始
            [avSpeech speakUtterance:utterance];
            
            sender.selected = !sender.selected;
        }
        
        //感觉效果一样，对应代理>>>取消
        //[avSpeech stopSpeakingAtBoundary:AVSpeechBoundaryWord];
        
        //暂停
        [avSpeech pauseSpeakingAtBoundary:AVSpeechBoundaryWord];
        
        sender.selected = !sender.selected;
    }
}


#pragma mark - AVSpeechSynthesizerDelegate
//开始播放
-(void)speechSynthesizer:(AVSpeechSynthesizer*)synthesizer didStartSpeechUtterance:(AVSpeechUtterance*)utterance{
    NSLog(@"---开始播放");
}
//播放完毕
-(void)speechSynthesizer:(AVSpeechSynthesizer*)synthesizer didFinishSpeechUtterance:(AVSpeechUtterance*)utterance{
    NSLog(@"---完成播放");
}
//停止播放
-(void)speechSynthesizer:(AVSpeechSynthesizer*)synthesizer didPauseSpeechUtterance:(AVSpeechUtterance*)utterance{
    NSLog(@"---播放中止");
}
//恢复播放
- (void)speechSynthesizer:(AVSpeechSynthesizer*)synthesizer didContinueSpeechUtterance:(AVSpeechUtterance*)utterance{
    NSLog(@"---恢复播放");
}
//取消播放
-(void)speechSynthesizer:(AVSpeechSynthesizer*)synthesizer didCancelSpeechUtterance:(AVSpeechUtterance*)utterance{
    NSLog(@"---播放取消");
}







@end
