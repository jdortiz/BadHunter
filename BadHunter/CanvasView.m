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

- (instancetype) initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setBackgroundColor:[UIColor clearColor]];
    }

    return self;
}

#pragma mark - Drawing

- (void)drawRect:(CGRect)rect {

    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClearRect(context, rect);
    [self drawInvertedPentagonsInContext:context rect:rect];
    [self drawCharacterInContext:context];

//    [self drawToPDF:rect];
}


- (void) drawToPDF:(CGRect)rect {
    NSMutableData *pdfData = [NSMutableData new];
    CGDataConsumerRef dataConsumer = CGDataConsumerCreateWithCFData((CFMutableDataRef)pdfData);

    const CGRect mediaBox = CGRectMake(0.0f, 0.0f, self.bounds.size.width, self.bounds.size.height);
    CGContextRef pdfContext = CGPDFContextCreate(dataConsumer, &mediaBox, NULL);

    UIGraphicsPushContext(pdfContext);

    CGContextBeginPage(pdfContext, &mediaBox);

    [self drawInvertedPentagonsInContext:pdfContext rect:rect];
    [self drawCharacterInContext:pdfContext];

    CGContextEndPage(pdfContext);
    CGPDFContextClose(pdfContext);

    UIGraphicsPopContext();

    CGContextRelease(pdfContext);
    CGDataConsumerRelease(dataConsumer);

    NSURL *pdfURL = [[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] firstObject] URLByAppendingPathComponent:@"icon.pdf"];
    [pdfData writeToURL:pdfURL atomically:YES];
}


- (void)drawInvertedPentagonsInContext:(CGContextRef)context rect:(CGRect)rect {
    CGContextSaveGState(context);
    [self drawPentagonInContext:context rect:rect];
    CGContextTranslateCTM(context, CGRectGetWidth(rect)/2.0, CGRectGetHeight(rect)/2.0);
    CGContextRotateCTM(context, M_PI);
    CGContextTranslateCTM(context, -CGRectGetWidth(rect)/2.0, -CGRectGetHeight(rect)/2.0);
    [self drawPentagonInContext:context rect:rect];
    CGContextRestoreGState(context);
}


- (void) drawPentagonInContext:(CGContextRef)context rect:(CGRect)rect {
    CGContextSaveGState(context);
    CGMutablePathRef pentagon = CGPathCreateMutable();
    CGPoint initialPoint = [self calculatePolygonPoint:0 totalPoints:pointsPentagon radius:(CGRectGetWidth(rect)/2.0 - 1.0)];
    CGPathMoveToPoint(pentagon, NULL, initialPoint.x, initialPoint.y);
    for (NSUInteger i = 1; i <= pointsPentagon; i++) {
        CGPoint corner = [self calculatePolygonPoint:i totalPoints:pointsPentagon radius:(CGRectGetWidth(rect)/2.0 - 1.0)];
        [self drawCircleInContext:context atPoint:corner];
        CGPathAddLineToPoint(pentagon, NULL, corner.x, corner.y);
    }
    CGContextAddPath(context, pentagon);
    CGPathRelease(pentagon);
    CGContextSetLineWidth(context, 2.0);
    CGContextSetStrokeColorWithColor(context, [[UIColor colorWithHue:352.0/360.0 saturation:1.0 brightness:0.77 alpha:1.0] CGColor]);

    CGContextStrokePath(context);
    CGContextRestoreGState(context);
}


- (void) drawCircleInContext:(CGContextRef)context atPoint:(CGPoint)corner {
    CGContextSaveGState(context);
    CGRect circleRect = CGRectMake(corner.x-2.0, corner.y-2.0, 4.0, 4.0);
    CGMutablePathRef circle = CGPathCreateMutable();
    CGPathAddEllipseInRect(circle, NULL, circleRect);
    CGContextAddPath(context, circle);
    CGContextSetStrokeColorWithColor(context, [[UIColor darkGrayColor] CGColor]);
    CGContextFillPath(context);
    CGContextRestoreGState(context);
}


- (void) drawCharacterInContext:(CGContextRef)context {
    [self drawHeadAndEyesInContext:context];
    [self drawTeethInContext:context];
}


- (void) drawHeadAndEyesInContext:(CGContextRef)context {
    CGContextSaveGState(context);
    CGMutablePathRef head = CGPathCreateMutable();
    CGPathAddEllipseInRect(head, NULL, CGRectMake(25.0, 40.0, 150.0, 100.0));
    CGAffineTransform rotationEye1 = CGAffineTransformTranslate(CGAffineTransformRotate(CGAffineTransformMakeTranslation(134.0, 80), -2.0*M_PI_4/9.0), -134.0, -80.0);
    CGPathAddEllipseInRect(head, &rotationEye1, CGRectMake(104.0, 70.0, 60.0, 20.0));
    CGAffineTransform rotationEye2 = CGAffineTransformTranslate(CGAffineTransformRotate(CGAffineTransformMakeTranslation(71, 80), 2.0*M_PI_4/9.0), -71.0, -80.0);
    CGPathAddEllipseInRect(head, &rotationEye2, CGRectMake(41.0, 70.0, 60.0, 20.0));
    CGContextAddPath(context, head);
    CGPathRelease(head);
    CGContextSetFillColorWithColor(context, [[UIColor blackColor] CGColor]);
    CGContextDrawPath(context, kCGPathEOFill);
    CGContextRestoreGState(context);
}

- (void) drawTeethInContext:(CGContextRef)context {
    CGContextSaveGState(context);
    CGMutablePathRef teeth = CGPathCreateMutable();
    CGPathAddRect(teeth, NULL, CGRectMake(36.0, 120.0, 20.0, 30.0));
    CGPathAddRect(teeth, NULL, CGRectMake(72.0, 128.0, 20.0, 30.0));
    CGPathAddRect(teeth, NULL, CGRectMake(108.0, 128.0, 20.0, 30.0));
    CGPathAddRect(teeth, NULL, CGRectMake(144.0, 120.0, 20.0, 30.0));
    CGContextAddPath(context, teeth);
    CGPathRelease(teeth);
    CGContextSetFillColorWithColor(context, [[UIColor blackColor] CGColor]);
    CGContextFillPath(context);
    CGContextRestoreGState(context);
}


#pragma mark - Auxiliary Calculations

- (CGPoint) calculatePolygonPoint:(NSUInteger)pointNumber totalPoints:(NSUInteger)totalPoints radius:(CGFloat)radius {
    double arcFraction = M_PI * (2.0 * pointNumber - 0.5) / totalPoints;
    return CGPointMake(radius*(cos(arcFraction) + 1.0), radius * (sin(arcFraction) + 1.0));
}

@end
