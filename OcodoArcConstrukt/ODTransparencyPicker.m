//
//  NPTransparencyPicker.m
//  NPColorPicker
//
//  Created by jason on 5/11/12.
//
//

static inline double radians (double degrees) { return degrees * M_PI/180; }

#import "ODTransparencyPicker.h"
#import <QuartzCore/QuartzCore.h>
#import <Foundation/Foundation.h>

@implementation ODTransparencyPicker

@synthesize pickerPoint;

- (id)initWithFrame:(CGRect)frame;
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder;
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit;
{
    CALayer *layer = self.layer;
    layer.cornerRadius  = 5.0f;
    layer.masksToBounds = YES;
}

- (CGFloat) transparency{
    return 1-fmin(fmax(0,pickerPoint.x/[self frame].size.width),1);
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGColorRef bgColor = [UIColor grayColor].CGColor;
    CGContextSetFillColorWithColor(context, bgColor);
    CGContextFillRect(context, rect);
    
    static const CGPatternCallbacks callbacks = { 0, &drawCheckerBoard, NULL };
    
    CGContextSaveGState(context);
    CGColorSpaceRef patternSpace = CGColorSpaceCreatePattern(NULL);
    CGContextSetFillColorSpace(context, patternSpace);
    CGColorSpaceRelease(patternSpace);
    
    CGPatternRef pattern = CGPatternCreate(NULL,
                                           rect,
                                           CGAffineTransformIdentity,
                                           20,
                                           20,
                                           kCGPatternTilingConstantSpacing,
                                           true,
                                           &callbacks);
    CGFloat alpha = 1.0;
    CGContextSetFillPattern(context, pattern, &alpha);
    CGPatternRelease(pattern);
    CGContextFillRect(context, self.bounds);
    
    CGFloat darkColors [] = {
        0.0, 0.0, 0.0, 1.0,
        0.0, 0.0, 0.0, 0.0
    };
    
    [self drawGradient:darkColors context:context rect:rect];

    CGContextSetFillColorWithColor(context, [UIColor colorWithWhite:0 alpha:0.8].CGColor);
    CGContextFillRect(context, CGRectMake(pickerPoint.x, 0, 9, rect.size.height));
}

- (void)drawGradient:(CGFloat*)colors context:(CGContextRef)context rect:(CGRect)rect
{
    CGColorSpaceRef baseSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColorComponents(baseSpace, colors, NULL, 2);
    CGColorSpaceRelease(baseSpace), baseSpace = NULL;
    
    CGContextSaveGState(context);
    CGContextAddRect(context, rect);
    CGContextClip(context);
    
    CGPoint startPoint = CGPointMake(CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGPoint endPoint = CGPointMake(CGRectGetMaxX(rect), CGRectGetMinY(rect));
    
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGGradientRelease(gradient), gradient = NULL;
    CGContextRestoreGState(context);
    
}

void drawCheckerBoard (void *info, CGContextRef context){

    CGColorRef lightColor = [UIColor whiteColor].CGColor;
    
    CGContextSetFillColorWithColor(context, lightColor);
    
    CGContextAddRect(context, CGRectMake(0, 0, 10, 10));
    CGContextAddRect(context, CGRectMake(10, 10, 10, 10));
    
    CGContextFillPath(context);
}

@end
