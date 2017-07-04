//
//  UIImage+JMImage.m
//  Sina-微博
//
//  Created by ZhaoJM on 16/3/19.
//  Copyright © 2016年 ZhaoJM. All rights reserved.
//

#import "UIImage+JMImage.h"
#import <AVFoundation/AVFoundation.h>

@implementation UIImage (JMImage)

+ (UIImage *)imageWithRenderingName:(NSString *)name{
    
    UIImage *selImage = [UIImage imageNamed:name];
    selImage = [selImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    return selImage;
}

+ (UIImage *)imageWithTemplateName:(NSString *)name{
    
    UIImage *selImage = [UIImage imageNamed:name];
    selImage = [selImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    return selImage;
}

+ (UIImage *)imageWithStretchableName:(NSString *)imageName
{
    UIImage *image = [UIImage imageNamed:imageName];
    return [image stretchableImageWithLeftCapWidth:image.size.width * 0.5 topCapHeight:image.size.height * 0.5];
}

+ (UIImage *)imageWithCaptureView:(UIView *)view rect:(CGRect)rect
{
    // 开启上下文
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, 0.0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:ctx];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    CGImageRef imagRef = CGImageCreateWithImageInRect([newImage CGImage], CGRectMake(0, 37, rect.size.width, rect.size.height)); // 需要乘以屏幕分辨率
    UIImage *nImage = [UIImage imageWithCGImage:imagRef];
    CGImageRelease(imagRef);
    UIGraphicsEndImageContext();
    
    return nImage;
}

+ (UIImage *)imageWithName:(NSString *)name border:(CGFloat)border borderColor:(UIColor *)color
{
    // 圆环的宽度
    CGFloat borderW = border;
    UIImage *oldImage =  [UIImage imageNamed:name];
    
    // 新的图片尺寸
    CGFloat imageW = oldImage.size.width + 2 * borderW;
    CGFloat imageH = oldImage.size.height + 2 * borderW;
    
    // 设置新的图片尺寸
    CGFloat circirW = imageW > imageH ? imageH : imageW;
    
    // 开启上下文
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(circirW, circirW), NO, 0.0);
    
    // 画大圆
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, circirW, circirW)];
    
    // 获取当前上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // 添加到上下文
    CGContextAddPath(ctx, path.CGPath);
    
    // 设置颜色
    [color set];
    
    // 渲染
    CGContextFillPath(ctx);
    
    CGRect clipR = CGRectMake(borderW, borderW, oldImage.size.width, oldImage.size.height);
    
    // 画圆：正切于旧图片的圆
    UIBezierPath *clipPath = [UIBezierPath bezierPathWithOvalInRect:clipR];
    
    // 设置裁剪区域
    [clipPath addClip];
    
    // 画图片
    [oldImage drawAtPoint:CGPointMake(borderW, borderW)];
    
    // 获取新的图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 关闭上下文
    UIGraphicsEndImageContext();
    
    return newImage;
}

+ (UIImage *)ellipseImage:(UIImage *)image withInset:(CGFloat)inset borderWidth:(CGFloat)width borderColor:(UIColor *)color
{
    UIGraphicsBeginImageContext(image.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect rect = CGRectMake(inset, inset, image.size.width-inset*2.0f, image.size.height-inset*2.0f);
    CGContextAddEllipseInRect(context, rect);
    CGContextClip(context);
    [image drawInRect:rect];
    
    if (width > 0) {
        
        CGContextSetStrokeColorWithColor(context, color.CGColor);
        CGContextSetLineCap(context, kCGLineCapButt);
        CGContextSetLineWidth(context, width);
        CGContextAddEllipseInRect(context, CGRectMake(inset+width/2, inset+width/2, image.size.width-width-inset*2.0f,image.size.height-width-inset*2.0f));
        CGContextStrokePath(context);
    }
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

// 图片拉伸
+ (UIImage *)resizeImageWithName:(NSString *)name
{
    UIImage *normal = [UIImage imageNamed:name];
    CGFloat w = normal.size.width*0.5f - 1;
    CGFloat h = normal.size.height*0.5f - 1;
    return [normal resizableImageWithCapInsets:UIEdgeInsetsMake(h, w, h, w)];
}

// 图片拉伸
- (UIImage *)resizeImageWithName
{
    CGFloat w = self.size.width*0.5f - 1;
    CGFloat h = self.size.height*0.5f - 1;
    return [self resizableImageWithCapInsets:UIEdgeInsetsMake(h, w, h, w)];
}

#pragma mark -- 对象方法
- (UIImage *)scaleAndClipToFillSize:(CGSize)destSize
{
    CGFloat showWidth = destSize.width;
    CGFloat showHeight = destSize.height;
    CGFloat scaleWidth = showWidth;
    CGFloat scaleHeight = showHeight;
    
    scaleWidth = ceilf(scaleHeight/self.size.height*self.size.width);
    if (scaleWidth < destSize.width) {
        scaleWidth = destSize.width;
        scaleHeight = ceilf(scaleWidth/self.size.width*self.size.height);
    }
    
    // scale
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(scaleWidth, scaleHeight), NO, 0.0f);
    [self drawInRect:CGRectMake(0, 0, scaleWidth, scaleHeight)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // clip
    CGFloat originX = ceilf((scaleWidth-showWidth)/2);
    CGFloat originY = ceilf((scaleHeight-showHeight)/2);
    
    CGRect cropRect = CGRectMake(ceilf(originX*scaledImage.scale), ceilf(originY*scaledImage.scale), ceilf(showWidth*scaledImage.scale), ceilf(showHeight*scaledImage.scale));
    return [scaledImage cropImageInRect:cropRect];
}

- (UIImage *)cropImageInRect:(CGRect)rect
{
    CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], rect);
    UIImage *cropImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return cropImage;
}

- (UIImage *)scaleImageToSize:(CGSize)size
{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(size.width, size.height), NO, 0.0f);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

- (UIImage *)gaussianBlurWithRadius:(CGFloat)radius
{
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage = [CIImage imageWithCGImage:self.CGImage];
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:inputImage forKey:kCIInputImageKey];
    [filter setValue:[NSNumber numberWithFloat:radius] forKey:@"inputRadius"];
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    CGImageRef cgImage = [context createCGImage:result fromRect:[inputImage extent]];
    return [UIImage imageWithCGImage:cgImage];
}

- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees
{
    
    CGFloat width = CGImageGetWidth(self.CGImage);
    CGFloat height = CGImageGetHeight(self.CGImage);
    CGSize rotatedSize;
    
    rotatedSize.width = width;
    rotatedSize.height = height;
    
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
    CGContextRotateCTM(bitmap, degrees * M_PI / 180);
    CGContextRotateCTM(bitmap, M_PI);
    CGContextScaleCTM(bitmap, -1.0, 1.0);
    CGContextDrawImage(bitmap, CGRectMake(-rotatedSize.width/2, -rotatedSize.height/2, rotatedSize.width, rotatedSize.height), self.CGImage);
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

/**
 *  压缩图片到指定文件大小
 *
 *  @param image 目标图片
 *  @param size  目标大小（最大值）
 *
 *  @return 返回的图片文件
 */
- (NSData *)compressOriginalImage:(UIImage *)image toMaxDataSizeKBytes:(CGFloat)size
{
    NSData *data = UIImageJPEGRepresentation(image, 1.0);
    CGFloat dataKBytes = data.length/1000.0;
    CGFloat maxQuality = 0.9f;
    CGFloat lastData = dataKBytes;
    while (dataKBytes > size && maxQuality > 0.01f) {
        maxQuality = maxQuality - 0.01f;
        data = UIImageJPEGRepresentation(image, maxQuality);
        dataKBytes = data.length / 1000.0;
        if (lastData == dataKBytes) {
            break;
        }else{
            lastData = dataKBytes;
        }
    }
    
    return data;
}

/**
 *  压缩图片到指定尺寸大小
 *
 *  @param image 原始图片
 *  @param size  目标大小
 *
 *  @return 生成图片
 */
- (UIImage *)compressOriginalImage:(UIImage *)image toSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage *)getNewImageSize:(CGSize)size
{
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    
    CGRect clipR = CGRectMake(0, 64, self.size.width, self.size.height-64);
    UIBezierPath *clipPath = [UIBezierPath bezierPathWithRect:clipR];
    [clipPath addClip];
    
    [self drawAtPoint:CGPointMake(size.width, size.height)];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

// 修改照片透明度
- (UIImage *)imageByApplyingAlpha:(CGFloat)alpha
{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect area = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -area.size.height);
    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
    CGContextSetAlpha(ctx, alpha);
    CGContextDrawImage(ctx, area, self.CGImage);
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

// 缩略图
- (UIImage *)imageCompressForSize:(UIImage *)sourceImage targetSize:(CGSize)size
{    
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = size.width;
    CGFloat targetHeight = size.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    
    if(CGSizeEqualToSize(imageSize, size) == NO){
        
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if(widthFactor > heightFactor){
            
            scaleFactor = widthFactor;
            
        }else{
            
            scaleFactor = heightFactor;
        }
        
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        if(widthFactor > heightFactor){
            
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
            
        }else if(widthFactor < heightFactor){
            
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 3.0);
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    [sourceImage drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    if(newImage == nil){
        
        NSLog(@"scale image fail");
    }
    
    UIGraphicsEndImageContext();
    return newImage;
    
}

+ (UIImage*)getVideoPreViewImage:(NSString *)videoPath
{
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath:videoPath] options:nil];
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    gen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *img = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    return img;
}

@end
