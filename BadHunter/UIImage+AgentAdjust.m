//
//  UIImage+AgentAdjust.m
//  BadHunter
//
//  Created by Jorge D. Ortiz Fuentes on 4/12/14.
//  Copyright (c) 2014 PoWWaU. All rights reserved.
//


#import "UIImage+AgentAdjust.h"


@implementation UIImage (AgentAdjust)

- (UIImage *) imageSquaredWithSide:(CGFloat)side {
    CGRect outputRect = CGRectMake(0, 0, side, side);
    CGImageRef inImageRef = [[self imageByCroppingToCentralSquare] CGImage];
    CGContextRef bitmap = CGBitmapContextCreate(NULL, side, side,
                                                CGImageGetBitsPerComponent(inImageRef),
                                                4*side,
                                                CGImageGetColorSpace(inImageRef),
                                                CGImageGetBitmapInfo(inImageRef));
    CGContextDrawImage(bitmap, outputRect, inImageRef);
    CGImageRef outImageRef = CGBitmapContextCreateImage(bitmap);
    CGContextRelease(bitmap);
    UIImage *outImage = [UIImage imageWithCGImage:outImageRef];
    CGImageRelease(outImageRef);
    
    return outImage;
}


- (UIImage *) imageByCroppingToCentralSquare {
    CGRect desiredRect = [self calculateCentralSquare];
    CGImageRef inImageRef = [self CGImage];
    CGImageRef outImageRef = CGImageCreateWithImageInRect(inImageRef, desiredRect);
    UIImage *croppedImage = [UIImage imageWithCGImage:outImageRef];
    CGImageRelease(outImageRef);
    
    return croppedImage;
}


- (CGRect) calculateCentralSquare {
    CGFloat width = self.size.width;
    CGFloat height = self.size.height;
    CGRect desiredRect;
    if (width > height) {
        desiredRect.size.height = height;
        desiredRect.size.width  = height;
        desiredRect.origin.y = 0;
        desiredRect.origin.x = roundf((width - desiredRect.size.width) / 2.0);
    } else {
        desiredRect.size.height = width;
        desiredRect.size.width  = width;
        desiredRect.origin.y = roundf((height - desiredRect.size.height) / 2.0);
        desiredRect.origin.x = 0;
    }
    return desiredRect;
}

@end
