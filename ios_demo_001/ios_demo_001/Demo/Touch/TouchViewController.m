//
//  TouchViewController.m
//  ios_demo_001
//
//  Created by admin on 17/9/19.
//  Copyright © 2017年 wsl. All rights reserved.
//

#import "TouchViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>

@interface TouchViewController ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, copy) NSString *localizedReason;

@end

@implementation TouchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, KScreen_Width, KScreen_Width)];
    self.titleLabel.center = self.view.center;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.titleLabel];
    
    
    [self setupUI];
}

- (void)setupUI {
    //判断设备是否支持Touch ID
    if ([[UIDevice currentDevice].systemVersion floatValue] < 8.0) {
        [self createAlterView:@"不支持指纹识别"];
        return;
    }else{
        [self touch];
    }
}

- (void)touch{
    LAContext *ctx = [[LAContext alloc] init];
    
    //设置 输入密码 按钮的标题
    ctx.localizedFallbackTitle = @"验证登录密码";
    
    //设置 取消 按钮的标题 iOS10之后
    ctx.localizedCancelTitle = @"取消";
    
    //检测指纹数据库更改 验证成功后返回一个NSData对象，否则返回nil
    //ctx.evaluatedPolicyDomainState;
    
    // 这个属性应该是类似于支付宝的指纹开启应用，如果你打开他解锁之后，按Home键返回桌面，
    // 再次进入支付宝是不需要录入指纹的。
    // 因为这个属性可以设置一个时间间隔，在时间间隔内是不需要再次录入。默认是0秒，最长可以设置5分钟
    ctx.touchIDAuthenticationAllowableReuseDuration = 0;
    
    
    NSError * error;
    _localizedReason = @"通过Home键验证已有手机指纹";
    // 判断设备是否支持指纹识别
    if ([ctx canEvaluatePolicy:LAPolicyDeviceOwnerAuthentication error:&error]) {
        
        // 验证指纹是否匹配，需要弹出输入密码的弹框的话：
        // iOS9之后用 LAPolicyDeviceOwnerAuthentication ；
        // iOS9之前用 LAPolicyDeviceOwnerAuthenticationWithBiometrics
        [ctx evaluatePolicy:LAPolicyDeviceOwnerAuthentication localizedReason:_localizedReason reply:^(BOOL success, NSError * error) {
            if (success) {
                [self createAlterView:@"指纹验证成功"];
            }else{
                
                // 错误码 error.code
                NSLog(@"指纹识别错误描述 %@",error.description);
                
                // -1: 连续三次指纹识别错误
                // -2: 在TouchID对话框中点击了取消按钮
                // -3: 在TouchID对话框中点击了输入密码按钮
                // -4: TouchID对话框被系统取消，例如按下Home或者电源键
                // -8: 连续五次指纹识别错误，TouchID功能被锁定，下一次需要输入系统密码
                NSString * message;
                switch (error.code) {
                    case -1://LAErrorAuthenticationFailed
                        message = @"已经连续三次指纹识别错误了，请输入密码验证";
                        _localizedReason = @"指纹验证失败";
                        break;
                    case -2:
                        message = @"在TouchID对话框中点击了取消按钮";
                        break;
                    case -3:
                        message = @"在TouchID对话框中点击了输入密码按钮";
                        break;
                    case -4:
                        message = @"TouchID对话框被系统取消，例如按下Home或者电源键或者弹出密码框";
                        break;
                    case -8:
                        message = @"TouchID已经被锁定,请前往设置界面重新启用";
                        break;
                    default:
                        break;
                }
                self.titleLabel.text = message;
            }
        }];
    }else{
        
        if (error.code == -8) {
            [self createAlterView:@"由于五次识别错误TouchID已经被锁定,请前往设置界面重新启用"];
        }else{
            [self createAlterView:@"TouchID没有设置指纹,请前往设置"];
        }
    }
    
}

//提示信息
- (void)createAlterView:(NSString *)message{
    UIAlertController * vc = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:vc animated:NO completion:^(void){
        [NSThread sleepForTimeInterval:1.0];
        [vc dismissViewControllerAnimated:YES completion:nil];
    }];
}

@end
