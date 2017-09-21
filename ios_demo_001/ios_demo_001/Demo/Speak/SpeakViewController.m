//
//  SpeakViewController.m
//  ios_demo_001
//
//  Created by admin on 17/9/21.
//  Copyright © 2017年 wsl. All rights reserved.
//

#import "SpeakViewController.h"
#import <Speech/Speech.h>

@interface SpeakViewController ()<SFSpeechRecognizerDelegate>

@property (strong, nonatomic) UIButton *button;
@property (strong, nonatomic) UILabel *titleLab;
@property (nonatomic, strong) SFSpeechRecognizer *recognizer;


//语音识别功能
@property (nonatomic,strong) SFSpeechAudioBufferRecognitionRequest *recognitionRequest;
@property (nonatomic,strong) SFSpeechRecognitionTask *recognitionTask;
@property (nonatomic,strong) AVAudioEngine *audioEngine;

@end

@implementation SpeakViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"语音转文字";
    
    [self setupUI];
}

- (void)setupUI {
    if (nil == _button) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.frame = CGRectMake(0, 0, 50, 50);
        _button.enabled = NO;
        [_button setTitle:@"开始" forState:UIControlStateNormal];
        [_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_button];
    }
    if (nil == _titleLab) {
        _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, KScreen_Width - 10, KScreen_Width)];
        _titleLab.numberOfLines = 0;
        [self.view addSubview:_titleLab];
    }
    
    
    //设备设置成中文
    NSLocale *cale = [[NSLocale alloc]initWithLocaleIdentifier:@"zh-CN"];
    self.recognizer = [[SFSpeechRecognizer alloc]initWithLocale:cale];
    self.recognizer.delegate = self;
    
    //创建录音
    self.audioEngine = [[AVAudioEngine alloc]init];
    
    //判断设备是否支持语音识别功能
    [SFSpeechRecognizer requestAuthorization:^(SFSpeechRecognizerAuthorizationStatus status) {
        bool isButtonEnabled = false;
        switch (status) {
            case SFSpeechRecognizerAuthorizationStatusAuthorized:
                isButtonEnabled = true;
                NSLog(@"可以语音识别");
                break;
            case SFSpeechRecognizerAuthorizationStatusDenied:
                isButtonEnabled = false;
                NSLog(@"用户被拒绝访问语音识别");
                break;
            case SFSpeechRecognizerAuthorizationStatusRestricted:
                isButtonEnabled = false;
                NSLog(@"不能在该设备上进行语音识别");
                break;
            case SFSpeechRecognizerAuthorizationStatusNotDetermined:
                isButtonEnabled = false;
                NSLog(@"没有授权语音识别");
                break;
            default:
                break;
        }
        self.button.enabled = isButtonEnabled;
    }];

}


//点击按钮
- (void)clickButton:(UIButton*)sender{
    if ([self.audioEngine isRunning]) {
        [self.audioEngine stop];
        [self.recognitionRequest endAudio];
        sender.enabled = YES;
        [sender setTitle:@"开始" forState:UIControlStateNormal];
    }else{
        self.titleLab.text = @"waiting...";
        [self startRecording];
        [sender setTitle:@"停止" forState:UIControlStateNormal];
    }
}

//即时语音录入
- (void)startRecording{
    
    
    //把所有的任务取消掉
    if (self.recognitionTask) {
        [self.recognitionTask cancel];
        self.recognitionTask = nil;
    }
    
    //创建session控制你的app的音频行为
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    //除了来电铃声，闹钟或日历提醒之外的其它系统声音都不会被播放
    bool audioBool = [audioSession setCategory:AVAudioSessionCategoryRecord error:nil];
    //设置最小系统
    bool audioBool1 = [audioSession setMode:AVAudioSessionModeMeasurement error:nil];
    //激活这个唯一的AVAudioSession
    bool audioBool2 = [audioSession setActive:true withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:nil];
    
    //
    if (audioBool || audioBool1||  audioBool2) {
        NSLog(@"可以使用");
    }else{
        NSLog(@"这里说明有的功能不支持");
    }
    
    //创建对象
    self.recognitionRequest = [[SFSpeechAudioBufferRecognitionRequest alloc]init];
    self.recognitionRequest.shouldReportPartialResults = true;
    AVAudioInputNode *inputNode = self.audioEngine.inputNode;

    //初始化语音处理器的输入模式
    AVAudioFormat *recordingFormat = [inputNode outputFormatForBus:0];
    [inputNode installTapOnBus:0 bufferSize:1024 format:recordingFormat block:^(AVAudioPCMBuffer * _Nonnull buffer, AVAudioTime * _Nonnull when) {
        [self.recognitionRequest appendAudioPCMBuffer:buffer];
    }];

    //准备
    [self.audioEngine prepare];
    bool audioEngineBool = [self.audioEngine startAndReturnError:nil];
    NSLog(@"%d",audioEngineBool);
    
    //开始识别任务
    self.recognitionTask = [self.recognizer recognitionTaskWithRequest:self.recognitionRequest resultHandler:^(SFSpeechRecognitionResult * _Nullable result, NSError * _Nullable error) {
        //
        bool isFinal = false;
        //有结果
        if (result) {
            //语音转文本
            self.titleLab.text = [[result bestTranscription] formattedString];
            isFinal = [result isFinal];
        }
        //没有结果
        if (error || isFinal) {
            self.titleLab.text = [NSString stringWithFormat:@"ERROR: %@", error]       ;
            [self.audioEngine stop];
            [inputNode removeTapOnBus:0];
            self.recognitionRequest = nil;
            self.recognitionTask = nil;
            self.button.enabled = true;
        }
    }];
}

- (void)speechRecognizer:(SFSpeechRecognizer *)speechRecognizer availabilityDidChange:(BOOL)available{
    if (available) {
        self.button.enabled = YES;
    }else{
        self.button.enabled = NO;
    }
}

@end
