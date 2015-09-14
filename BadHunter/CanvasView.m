//
//  CanvasView.m
//  BadHunter
//
//  Created by Jorge D. Ortiz Fuentes on 14/9/15.
//  Copyright (c) 2015 PoWWaU. All rights reserved.
//


#import "CanvasView.h"


@implementation CanvasView

#pragma mark - Constants & Parameters

static const NSUInteger pointsPentagon = 5;

#pragma mark - Drawing

- (void)drawRect:(CGRect)rect {

    CGContextRef context = UIGraphicsGetCurrentContext();

    CGMutablePathRef pentagon = CGPathCreateMutable();
    CGPoint initialPoint = [self calculatePolygonPoint:0 totalPoints:pointsPentagon radius:(CGRectGetWidth(rect)/2.0 - 1.0)];
    CGPathMoveToPoint(pentagon, NULL, initialPoint.x, initialPoint.y);
    for (NSUInteger i = 1; i <= pointsPentagon; i++) {
        CGPoint corner = [self calculatePolygonPoint:i totalPoints:pointsPentagon radius:(CGRectGetWidth(rect)/2.0 - 1.0)];
        CGPathAddLineToPoint(pentagon, NULL, corner.x, corner.y);
    }
    CGContextAddPath(context, pentagon);
    CGPathRelease(pentagon);
    CGContextSetLineWidth(context, 2.0);
    CGContextSetStrokeColorWithColor(context, [[UIColor colorWithHue:352.0/360.0 saturation:1.0 brightness:0.77 alpha:1.0] CGColor]);

    CGContextStrokePath(context);


//    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
//    UIBezierPath *circle;
//    [bezierPath moveToPoint:];
//    [[UIColor darkGrayColor] setFill];
//    for (NSUInteger i = 1; i <= pointsPentagon; i++) {
//        CGPoint corner = [self calculatePolygonPoint:i totalPoints:pointsPentagon radius:(CGRectGetWidth(rect)/2.0 - 1.0)];
//        [bezierPath addLineToPoint:corner];
//        circle = [UIBezierPath bezierPathWithArcCenter:corner radius:4.0 startAngle:0.0 endAngle:2.0*M_PI clockwise:YES];
//        [circle fill];
//    }
//    [[UIColor colorWithHue:352.0/360.0 saturation:1.0 brightness:0.77 alpha:1.0] setStroke];
//    [bezierPath stroke];
}


#pragma mark - Auxiliary Calculations

- (CGPoint) calculatePolygonPoint:(NSUInteger)pointNumber totalPoints:(NSUInteger)totalPoints radius:(CGFloat)radius {
    double arcFraction = M_PI * (2.0 * pointNumber - 0.5) / totalPoints;
    return CGPointMake(radius*(cos(arcFraction) + 1.0), radius * (sin(arcFraction) + 1.0));
}

@end
