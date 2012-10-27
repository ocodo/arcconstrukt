//
//  DrawingCanvas.m
//  TestUIViewDrawing
//
//  Created by jason on 25/10/12.
//  Copyright (c) 2012 ocodo. All rights reserved.
//

#import "ArcMachine.h"
#import <tgmath.h>
#import "QuartzCore/QuartzCore.h"

@implementation ArcMachine

@synthesize startAngle, endAngle, innerRadius, thickness, rotationAngle, arcSizeAngle;

- (id)initWithFrame:(CGRect)frame
{   
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}
- (void)drawRect:(CGRect)rect {

    UIColor *fillColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.800];
	UIColor *strokeColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.800];
    
    [self
     drawArc:rect
     context:UIGraphicsGetCurrentContext()
     x:0
     y:0
     startAngle:startAngle
     endAngle:endAngle
     radius:innerRadius
     thickness:thickness
     fill:fillColor
     stroke:strokeColor
     ];
    
}

- (void)drawArc:(CGRect)_rect
        context:(CGContextRef)_context
              x:(CGFloat)_x
              y:(CGFloat)_y
     startAngle:(CGFloat)_startAngle
       endAngle:(CGFloat)_endAngle
         radius:(CGFloat)_radius
      thickness:(CGFloat)_thickness
           fill:(UIColor*)_fillColor
         stroke:(UIColor*)_strokeColor {
    
	CGContextTranslateCTM(_context, CGRectGetMidX(_rect), CGRectGetMidY(_rect));
    
	CGContextSetLineWidth(_context, 0.5f);
	CGContextSetLineJoin(_context, kCGLineJoinRound);
	CGContextSetStrokeColorWithColor(_context, _strokeColor.CGColor);
	CGContextSetFillColorWithColor(_context, _fillColor.CGColor);
    
	CGContextBeginPath(_context);
    
    CGFloat iRadius = _radius;
    CGFloat oRadius = _radius+thickness;
    
    CGFloat sAngle = DEGREES_TO_RADIANS(fmodf(_startAngle, 361));
    CGFloat eAngle = DEGREES_TO_RADIANS(fmodf(_startAngle + _endAngle, 361));
    
    CGFloat ax = _x + (oRadius * cos(sAngle));
    CGFloat ay = _y + (oRadius * sin(sAngle));
    CGFloat cx = _x + (iRadius * cos(eAngle));
    CGFloat cy = _y + (iRadius * sin(eAngle));
    
    CGContextMoveToPoint(_context, ax, ay);
    CGContextAddArc(_context, _x, _y, oRadius, sAngle, eAngle, 0);
    CGContextAddLineToPoint(_context, cx, cy);
    CGContextAddArc(_context, _x, _y, iRadius, eAngle, sAngle, 1);
    CGContextAddLineToPoint(_context, ax, ay);

	CGContextClosePath(_context);
	CGContextDrawPath(_context, kCGPathFillStroke);
}



@end
