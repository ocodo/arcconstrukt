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

-(void) drawNumGrid:(int)n rect:(CGRect)rect context:(CGContextRef)context {
	CGContextSetLineWidth(context, 0.1f);
	CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
	CGContextBeginPath(context);

    for (int i=0; i<=n; i++) {
        float v = i*(rect.size.width/n);
        CGContextMoveToPoint(context, v, 0);
        CGContextAddLineToPoint(context, v, rect.size.width);
        CGContextMoveToPoint(context, 0, v);
        CGContextAddLineToPoint(context, rect.size.width, v);
    }
   	CGContextDrawPath(context, kCGPathStroke);
}

-(void) drawPolarGrid:(float)angle rect:(CGRect)rect context:(CGContextRef)context {
    
    [self drawNumGrid:1 rect:rect context:context];
    
    CGContextTranslateCTM(context, CGRectGetMidX(rect), CGRectGetMidY(rect));
    CGContextRotateCTM(context, DEGREES_TO_RADIANS(270));
    CGContextSetLineWidth(context, 0.1f);
	CGContextSetStrokeColorWithColor(context, [UIColor colorWithWhite:1 alpha:0.7].CGColor);
	CGContextBeginPath(context);
    
    float radius = sqrtf( powf(rect.size.width, 2.0f) + powf(rect.size.height, 2.0f) );
    float spin = 0;
    
    while(spin < M_PI*2) {
        CGFloat ax = radius * cos(spin);
        CGFloat ay = radius * sin(spin);
        CGContextMoveToPoint(context, 0, 0);
        CGContextAddLineToPoint(context, ax, ay);
        spin += angle;
    }
    
    CGContextDrawPath(context, kCGPathStroke);
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
