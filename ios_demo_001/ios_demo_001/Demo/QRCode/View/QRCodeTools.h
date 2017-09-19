//
//  QRCodeTools.h
//  ios_demo_001
//
//  Created by admin on 17/9/19.
//  Copyright © 2017年 wsl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QRCodeTools : NSObject

/** 生成普通的二维码 */
+ (UIImage *)generateCustomQRCode:(NSString *)data WithImageWidth:(CGFloat)width;


/**
 生成带logo的二维码

 @param data          <#data description#>
 @param imageWidth    宽
 @param logoImageName logo图片的名字
 @param logoScale     缩放度

 */
+ (UIImage *)generateLogoQRCode:(NSString *)data imageWidth:(CGFloat)imageWidth logoImageName:(NSString *)logoImageName logoScaleToSuperView:(CGFloat)logoScale;

@end
