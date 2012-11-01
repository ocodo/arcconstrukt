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

@synthesize settings;

- (id)initWithFrame:(CGRect)frame
{   
    self = [super initWithFrame:frame];
    if (self) {
        settings = [[ArcProperties alloc]init];
    }
    return self;
}
- (void)drawRect:(CGRect)rect {
    
    [self
     drawArc:rect
     context:UIGraphicsGetCurrentContext()
     x:0
     y:0
     start:settings.start
     end:settings.end
     radius:settings.radius
     thickness:settings.thickness
     fill:settings.fillColor
     stroke:settings.strokeColor
     ];
    
}

- (void)drawArc:(CGRect)_rect
        context:(CGContextRef)_context
              x:(CGFloat)_x
              y:(CGFloat)_y
          start:(CGFloat)_start
            end:(CGFloat)_end
         radius:(CGFloat)_radius
      thickness:(CGFloat)_thickness
           fill:(UIColor*)_fillColor
         stroke:(UIColor*)_strokeColor {
    
    NSLog(@"ArcMachine drawing... %@ | %@ | %@", _context, _fillColor, _strokeColor );
    
	CGContextTranslateCTM(_context, CGRectGetMidX(_rect), CGRectGetMidY(_rect));
    
	CGContextSetLineWidth(_context, 0.5f);
	CGContextSetLineJoin(_context, kCGLineJoinRound);
	CGContextSetStrokeColorWithColor(_context, _strokeColor.CGColor);
	CGContextSetFillColorWithColor(_context, _fillColor.CGColor);
    
	CGContextBeginPath(_context);
    
    CGFloat _outside = _radius+_thickness;
        
    CGFloat ax = _x + (_outside * cos(_start));
    CGFloat ay = _y + (_outside * sin(_start));
    CGFloat cx = _x + (_radius * cos(_end));
    CGFloat cy = _y + (_radius * sin(_end));
    
    CGContextMoveToPoint(_context, ax, ay);
    CGContextAddArc(_context, _x, _y, _outside, _start, _end, 0);
    CGContextAddLineToPoint(_context, cx, cy);
    CGContextAddArc(_context, _x, _y, _radius, _end, _start, 1);
    CGContextAddLineToPoint(_context, ax, ay);

	CGContextClosePath(_context);
	CGContextDrawPath(_context, kCGPathFillStroke);
}

@end
