//
//  ImageMapper.h
//  BadHunter
//
//  Created by Jorge D. Ortiz Fuentes on 3/12/14.
//  Copyright (c) 2014 PoWWaU. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface ImageMapper : NSObject

- (void) storeImage:(UIImage *)image withUUID:(NSString *)uuid;
- (void) deleteImageWithUUID:(NSString *)uuid;
- (UIImage *) retrieveImageWithUUID:(NSString *)uuid;

@end
