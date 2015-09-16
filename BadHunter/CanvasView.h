//
//  CanvasView.h
//  BadHunter
//
//  Created by Jorge D. Ortiz Fuentes on 14/9/15.
//  Copyright (c) 2015 PoWWaU. All rights reserved.
//


#import <UIKit/UIKit.h>


IB_DESIGNABLE
@interface CanvasView : UIView

@property (strong, nonatomic) IBInspectable UIColor *lineColor;
@property (assign, nonatomic) IBInspectable NSUInteger lineWidth;

@end
