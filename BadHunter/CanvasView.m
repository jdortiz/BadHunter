//
//  CanvasView.m
//  BadHunter
//
//  Created by Jorge D. Ortiz Fuentes on 14/9/15.
//  Copyright (c) 2015 PoWWaU. All rights reserved.
//


#import "CanvasView.h"


@implementation CanvasView

- (void)drawRect:(CGRect)rect {

    CGRect firstRectangle = CGRectInset(rect, 5.0, 5.0);
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRect:firstRectangle];
    [[UIColor purpleColor] setFill];
    [bezierPath fill];

    CGRect secondRect = CGRectInset(firstRectangle, 5.0, 5.0);
    bezierPath = [UIBezierPath bezierPathWithRoundedRect:secondRect cornerRadius:5.0];
    [[UIColor redColor] setFill];
    [bezierPath fill];

    CGRect thirdRect = CGRectOffset(CGRectInset(secondRect, 5.0, 5.0), 35.0, 0.0);
    bezierPath = [UIBezierPath bezierPathWithOvalInRect:thirdRect];
    [[UIColor orangeColor] setFill];
    [bezierPath fill];

    bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:CGPointMake(CGRectGetWidth(rect)/2.0, CGRectGetHeight(rect)/2.0)];
    [bezierPath addLineToPoint:CGPointMake(2.0, 2.0)];
    [bezierPath addLineToPoint:CGPointMake(CGRectGetHeight(rect)-2.0, 2.0)];
    [bezierPath addLineToPoint:CGPointMake(CGRectGetWidth(rect)/2.0, CGRectGetHeight(rect)/2.0)];
    [[UIColor blueColor] setStroke];
    [bezierPath stroke];


}

@end
