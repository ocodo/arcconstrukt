//
//  DrawingCanvas.m
//  TestUIViewDrawing
//
//  Created by jason on 25/10/12.
//  Copyright (c) 2012 ocodo. All rights reserved.
//

#import "ODArcMachine.h"
#import <tgmath.h>
#import "QuartzCore/QuartzCore.h"
#import "CGColor+Additions.h"

@implementation ODArcMachine

@synthesize x, y, start, end, radius, thickness, fill, stroke, savedFill, savedStroke;

- (void) setValuesFrom: (ODArcMachine *) arcMachine {
    start = arcMachine.start;
    end = arcMachine.end;
    radius = arcMachine.radius;
    thickness = arcMachine.thickness;
    stroke = arcMachine.savedStroke;
    fill = arcMachine.savedFill;
    [self setNeedsDisplay];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [self drawArc:rect context:UIGraphicsGetCurrentContext()];
}

- (void)drawArc:(CGRect)rect context:(CGContextRef)context {
    
	CGContextTranslateCTM(context, CGRectGetMidX(rect), CGRectGetMidY(rect));
    
	CGContextSetLineWidth(context, 0.5f);
	CGContextSetLineJoin(context, kCGLineJoinRound);
	CGContextSetStrokeColorWithColor(context, stroke.CGColor);
	CGContextSetFillColorWithColor(context, fill.CGColor);
    
	CGContextBeginPath(context);
    
    CGFloat outside = radius+thickness;
    
    CGFloat ax = x + (outside * cos(start));
    CGFloat ay = y + (outside * sin(start));
    CGFloat cx = x + (radius * cos(end));
    CGFloat cy = y + (radius * sin(end));
    
    CGContextMoveToPoint(context, ax, ay);
    CGContextAddArc(context, x, y, outside, start, end, 0);
    CGContextAddLineToPoint(context, cx, cy);
    CGContextAddArc(context, x, y, radius, end, start, 1);
    CGContextAddLineToPoint(context, ax, ay);
    
	CGContextClosePath(context);
	CGContextDrawPath(context, kCGPathFillStroke);
}

-(void)selectArc {
    savedFill = fill;
    savedStroke = stroke;
    fill = [UIColor redColor];
    stroke = [UIColor redColor];
    [self setNeedsDisplay];
}

-(void)deselectArc {
    stroke = savedStroke;
    fill = savedFill;
    [self setNeedsDisplay];
}

-(void) geometryFromDictionary: (NSDictionary *) plist {
    start = [[plist valueForKey:@"start"] floatValue];
    end = [[plist valueForKey:@"end"] floatValue];
    radius = [[plist valueForKey:@"radius"] floatValue];
    thickness = [[plist valueForKey:@"thickness"] floatValue];
    
    if([[plist valueForKey:@"fill"] isKindOfClass:[NSDictionary class]]) {
        fill = [UIColor colorWithRGBADictionary:[plist valueForKey:@"fill"]];
        stroke = [UIColor colorWithRGBADictionary:[plist valueForKey:@"stroke"]];
        savedFill = [UIColor colorWithRGBADictionary:[plist valueForKey:@"fill"]];
        savedStroke = [UIColor colorWithRGBADictionary:[plist valueForKey:@"stroke"]];
    }
        
    if([[plist valueForKey:@"fill"] isKindOfClass:[UIColor class]]) {
        fill = [plist valueForKey:@"fill"];
        savedFill = [plist valueForKey:@"fill"];
        stroke = [plist valueForKey:@"stroke"];
        savedStroke = [plist valueForKey:@"stroke"];
    }
        
    [self setNeedsDisplay];
    NSLog(@"A:%f; B:%f; r:%f; Thick:%f; fill:%@; stroke:%@; ", start, end, radius, thickness, [fill RGBHexString], [stroke RGBHexString]);    
}

-(NSDictionary *) geometryToDictionary {
    return @{
    @"start" : [NSNumber numberWithFloat: start],
    @"end" : [NSNumber numberWithFloat: end],
    @"radius" : [NSNumber numberWithFloat: radius],
    @"thickness" : [NSNumber numberWithFloat: thickness],
    @"fill" : [savedFill RGBADictionary],
    @"stroke" : [savedStroke RGBADictionary] };
}

@end
