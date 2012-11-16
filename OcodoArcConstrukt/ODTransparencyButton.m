//
//  ODTransparencyButton.m
//  OcodoArcConstrukt
//
//  Created by jason on 16/11/12.
//  Copyright (c) 2012 ocodo. All rights reserved.
//

#import "ODTransparencyButton.h"
#import "ODViewHelpers.h"
#import <QuartzCore/QuartzCore.h>


@implementation ODTransparencyButton

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

- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();    
    CGColorRef bgColor = [UIColor grayColor].CGColor;
    CGContextSetFillColorWithColor(ctx, bgColor);
    CGContextFillRect(ctx, rect);
    static const CGPatternCallbacks callbacks = { 0, &smallCheckerBoard, NULL };
    CGContextSaveGState(ctx);
    CGColorSpaceRef patternSpace = CGColorSpaceCreatePattern(NULL);
    CGContextSetFillColorSpace(ctx, patternSpace);
    CGColorSpaceRelease(patternSpace);
    CGPatternRef pattern = CGPatternCreate(NULL, rect, CGAffineTransformIdentity,
                                           17, 17, kCGPatternTilingConstantSpacing, true, &callbacks);
    CGFloat alpha = 1.0;
    CGContextSetFillPattern(ctx, pattern, &alpha);
    CGPatternRelease(pattern);
    CGContextFillRect(ctx, self.bounds);
    
    drawInsetChrome(ctx, rect);
}

void smallCheckerBoard (void *info, CGContextRef ctx){
    CGContextSetFillColorWithColor(ctx, [UIColor whiteColor].CGColor);
    CGContextAddRect(ctx, CGRectMake(0, 0, 8, 8));
    CGContextAddRect(ctx, CGRectMake(8, 8, 8, 8));
    CGContextFillPath(ctx);
}



@end
