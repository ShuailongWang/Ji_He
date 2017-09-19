//
//  QRCodeTools.m
//  ios_demo_001
//
//  Created by admin on 17/9/19.
//  Copyright © 2017年 wsl. All rights reserved.
//

#import "QRCodeTools.h"

@implementation QRCodeTools

//生成普通的二维码
+ (UIImage *)generateCustomQRCode:(NSString *)data WithImageWidth:(CGFloat)width{
    
    //创建滤镜对象
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    //恢复滤镜的默认属性
    [filter setDefaults];
    
    NSData *infoData = [data dataUsingEncoding:NSUTF8StringEncoding];
    
    //设置filter的InputMessages数据
    [filter setValue:infoData forKeyPath:@"inputMessage"];
    
    CIImage *outputImage = [filter outputImage];
    
    //根据CIImage生成指定大小的UIImage
    UIImage *image = [self createUIImageFromCIImage:outputImage withWidth:width];
    
    return image;
}

//根据CIImage生成指定大小的UIImage
+ (UIImage *)createUIImageFromCIImage:(CIImage *)CIImage withWidth:(CGFloat)imageWidth{
    
    CGRect extent = CGRectIntegral(CIImage.extent);
    CGFloat scale = MIN(imageWidth / CGRectGetWidth(extent), imageWidth / CGRectGetHeight(extent));
    
    //创建bitMap
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, colorSpaceRef, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    
    CGImageRef bitmapImage = [context createCGImage:CIImage fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    
    return [UIImage imageWithCGImage:scaledImage];
}

//生成带logo的二维码
+ (UIImage *)generateLogoQRCode:(NSString *)data imageWidth:(CGFloat)imageWidth logoImageName:(NSString *)logoImageName logoScaleToSuperView:(CGFloat)logoScale{
    
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    //恢复滤镜的默认属性
    [filter setDefaults];
    
    NSData *infoData = [data dataUsingEncoding:NSUTF8StringEncoding];
    
    //设置filter的InputMessages数据
    [filter setValue:infoData forKeyPath:@"inputMessage"];
    CIImage *outputImage = [filter outputImage];
    
    //    outputImage = [outputImage imageByApplyingTransform:CGAffineTransformMakeScale(20, 20)];
    //将CIImage转化为UIImage类型
    UIImage *start_image = [self createUIImageFromCIImage:outputImage withWidth:imageWidth];
    
    //添加logo
    UIGraphicsBeginImageContext(start_image.size);
    [start_image drawInRect:CGRectMake(0, 0, start_image.size.width, start_image.size.height)];
    
    //画logo
    UIImage *logoImage = [UIImage imageNamed:logoImageName];
    CGFloat logoWidth = start_image.size.width * logoScale;
    CGFloat logoHeight = start_image.size.height * logoScale;
    CGFloat logoX = (start_image.size.width - logoWidth) / 2;
    CGFloat logoY = (start_image.size.width - logoHeight) / 2;
    [logoImage drawInRect:CGRectMake(logoX, logoY, logoWidth, logoHeight)];
    
    //获取最后的图片
    UIImage *finalImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return finalImage;
}


@end
