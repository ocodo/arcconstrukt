//
//  ODGridView.m
//  ArcConstrukt
//
//  Created by jason on 2/11/12.
//  Copyright (c) 2012 ocodo. All rights reserved.
//

#import "ODGridView.h"
#import <math.h>
#import "extra_math.h"

@implementation ODGridView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        gridMode = 0;
    }
    return self;
}

-(void) drawNumGrid:(int)n rect:(CGRect)rect context:(CGContextRef)ctx {
	CGContextSetLineWidth(ctx, 0.1f);
	CGContextSetStrokeColorWithColor(ctx, [UIColor whiteColor].CGColor);
	CGContextBeginPath(ctx);

    for (int i=0; i<=n; i++) {
        float v = i*(rect.size.width/n);
        CGContextMoveToPoint(ctx, v, 0);
        CGContextAddLineToPoint(ctx, v, rect.size.width);
        CGContextMoveToPoint(ctx, 0, v);
        CGContextAddLineToPoint(ctx, rect.size.width, v);
    }
   	CGContextDrawPath(ctx, kCGPathStroke);
}

-(void) drawPolarGrid:(float)angle rect:(CGRect)rect context:(CGContextRef)ctx {
    
    [self drawNumGrid:1 rect:rect context:ctx];
    
    CGContextTranslateCTM(ctx, CGRectGetMidX(rect), CGRectGetMidY(rect));
    CGContextRotateCTM(ctx, DEGREES_TO_RADIANS(270));
    CGContextSetLineWidth(ctx, 0.1f);
	CGContextSetStrokeColorWithColor(ctx, [UIColor colorWithWhite:1 alpha:0.7].CGColor);
	CGContextBeginPath(ctx);
    
    float radius = sqrtf( powf(rect.size.width, 2.0f) + powf(rect.size.height, 2.0f) );
    float spin = 0;
    
    while(spin < M_PI*2) {
        CGFloat ax = radius * cos(spin);
        CGFloat ay = radius * sin(spin);
        CGContextMoveToPoint(ctx, 0, 0);
        CGContextAddLineToPoint(ctx, ax, ay);
        spin += angle;
    }
    
    CGContextDrawPath(ctx, kCGPathStroke);
}

//*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    switch (gridMode) {
        case 1:
            [self drawPolarGrid:DEGREES_TO_RADIANS(10) rect:rect context:ctx];
            break;
        case 2:
            [self drawPolarGrid:DEGREES_TO_RADIANS(15) rect:rect context:ctx];
            break;
        case 3:
            [self drawPolarGrid:DEGREES_TO_RADIANS(20) rect:rect context:ctx];
            break;
        case 4:
            [self drawPolarGrid:DEGREES_TO_RADIANS(30) rect:rect context:ctx];
            break;
        case 5:
            [self drawPolarGrid:DEGREES_TO_RADIANS(45) rect:rect context:ctx];
            break;
        case 6:
            [self drawPolarGrid:DEGREES_TO_RADIANS(60) rect:rect context:ctx];
            break;
        case 7:
            [self drawPolarGrid:DEGREES_TO_RADIANS(120) rect:rect context:ctx];
            break;
            
        default:
            [self drawNumGrid:1 rect:rect context:ctx];

            break;
    }
}
//*/

- (void) incrementGridMode {
    gridMode++;
    gridMode = gridMode % 8;
    [self setNeedsDisplay];
}

@end
