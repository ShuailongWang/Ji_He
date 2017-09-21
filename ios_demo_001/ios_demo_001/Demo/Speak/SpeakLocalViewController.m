//
//  SpeakLocalViewController.m
//  ios_demo_001
//
//  Created by admin on 17/9/21.
//  Copyright © 2017年 wsl. All rights reserved.
//

#import "SpeakLocalViewController.h"
#import <Speech/Speech.h>

@interface SpeakLocalViewController ()<SFSpeechRecognitionTaskDelegate>

@property (nonatomic, strong) SFSpeechRecognitionTask *recognitionTask;
@property (nonatomic, strong) SFSpeechRecognizer *speechRecognizer;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation SpeakLocalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"只是能够做到把一段语音转化成文字";
    
    [self setupUI];
}

- (void)setupUI {
    if (nil == _titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, KScreen_Width - 10, KScreen_Width)];
        _titleLabel.numberOfLines = 0;
        [self.view addSubview:_titleLabel];
    }
    
    //判断设备是否支持e语音识别功能
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
    }];
    
    
    //创建语音识别
    self.speechRecognizer = [[SFSpeechRecognizer alloc] initWithLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];//中文识别
    
    //创建识别请求
    NSString *parh = [[NSBundle mainBundle] pathForResource:@"Jam - 七月上.mp3" ofType:nil];
    SFSpeechURLRecognitionRequest *request = [[SFSpeechURLRecognitionRequest alloc] initWithURL:[NSURL fileURLWithPath:parh]];
    
    //开始识别任务
    self.recognitionTask = [self recognitionTaskWithStartRequest:request];
    
}

//开始识别任务
-(SFSpeechRecognitionTask*)recognitionTaskWithStartRequest:(SFSpeechURLRecognitionRequest*)request{
    return [self.speechRecognizer recognitionTaskWithRequest:request resultHandler:^(SFSpeechRecognitionResult * _Nullable result, NSError * _Nullable error) {
        if (!error) {
            self.titleLabel.text = result.bestTranscription.formattedString;
        }else {
            self.titleLabel.text = [NSString stringWithFormat:@"ERROR: %@", error];
        }
    }];
//
//    //或者 使用代理
//    return [self.speechRecognizer recognitionTaskWithRequest:request delegate:self];
}


#pragma mark- SFSpeechRecognitionTaskDelegate
//
- (void)speechRecognitionDidDetectSpeech:(SFSpeechRecognitionTask *)task{
    NSLog(@"1");
}
//
- (void)speechRecognitionTask:(SFSpeechRecognitionTask *)task didHypothesizeTranscription:(SFTranscription*)transcription{
    NSLog(@"2");
}
//解析中
- (void)speechRecognitionTask:(SFSpeechRecognitionTask *)task didFinishRecognition:(SFSpeechRecognitionResult*)recognitionResult{
    self.titleLabel.text = recognitionResult.bestTranscription.formattedString;
    NSLog(@"111");
}
//
- (void)speechRecognitionTaskFinishedReadingAudio:(SFSpeechRecognitionTask*)task{
    NSLog(@"3");
}
//取消
- (void)speechRecognitionTaskWasCancelled:(SFSpeechRecognitionTask*)task{
    NSLog(@"Cancel");
}
//解析完
- (void)speechRecognitionTask:(SFSpeechRecognitionTask*)task didFinishSuccessfully:(BOOL)successfully {
    if (successfully) {
        NSLog(@"全部解析完毕");
    }
}


-(void)dealloc{
    [self.recognitionTask cancel];
    self.recognitionTask = nil;
}

@end
