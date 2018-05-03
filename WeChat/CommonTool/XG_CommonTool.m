//
//  XG_CommonTool.m
//  WeChat
//
//  Created by Xiaogang on 2018/5/1.
//  Copyright © 2018年 Xiaogang. All rights reserved.
//

#import "XG_CommonTool.h"

@implementation XG_CommonTool
+(UIImage*) createImageWithColor:(UIColor*) color andSize:(CGSize)imageSize
{
    CGRect rect=CGRectMake(0.0f, 0.0f, imageSize.width, imageSize.height);
    UIGraphicsBeginImageContext(imageSize);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}
@end
