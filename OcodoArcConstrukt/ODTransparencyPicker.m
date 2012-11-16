//
//  NPTransparencyPicker.m
//  NPColorPicker
//
//  Created by jason on 5/11/12.
//
//

static inline double radians (double degrees) { return degrees * M_PI/180; }

#import "ODTransparencyPicker.h"
#import "ODViewHelpers.h"
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
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGColorRef bgColor = [UIColor grayColor].CGColor;
    CGContextSetFillColorWithColor(ctx, bgColor);
    CGContextFillRect(ctx, rect);
    
    static const CGPatternCallbacks callbacks = { 0, &drawCheckerBoard, NULL };
    
    CGContextSaveGState(ctx);
    CGColorSpaceRef patternSpace = CGColorSpaceCreatePattern(NULL);
    CGContextSetFillColorSpace(ctx, patternSpace);
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
    CGContextSetFillPattern(ctx, pattern, &alpha);
    CGPatternRelease(pattern);
    CGContextFillRect(ctx, self.bounds);
    
    NSArray *darkColors = @[(id)[UIColor colorWithWhite:0 alpha:1].CGColor, (id)[UIColor colorWithWhite:0 alpha:0].CGColor];
    
    CGPoint startPoint = CGPointMake(CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGPoint endPoint = CGPointMake(CGRectGetMaxX(rect), CGRectGetMinY(rect));

    drawGradient(darkColors, ctx, NULL, startPoint, endPoint, rect);

    CGContextSetFillColorWithColor(ctx, [UIColor colorWithWhite:0 alpha:0.8].CGColor);
    CGContextFillRect(ctx, CGRectMake(pickerPoint.x, 0, 9, rect.size.height));
}

@end
