//
//  ODArcMachine.m
//  ArcConstrukt
//
//  Created by jason on 25/10/12.
//  Copyright (c) 2012 ocodo. All rights reserved.
//

#import "ODArcMachine.h"


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

- (NSString*) SVGArc {
    
    CGFloat _end = (end < start) ? (M_PI*2) + end : end;
    
    CGFloat r2 = radius + thickness;
    CGFloat r1 = radius;
    CGPoint p1 = CGPointMake(x + r2 * cos(start), y + r2 * sin(start));
    CGPoint p2 = CGPointMake(x + r2 * cos(_end), y + r2 * sin(_end));
    CGPoint p3 = CGPointMake(x + r1 * cos(_end), y + r1 * sin(_end));
    CGPoint p4 = CGPointMake(x + r1 * cos(start), y + r1 * sin(start));
    
    CGFloat angleDiff = _end - start;
    BOOL largeArc = (fmod(angleDiff, (M_PI*2))) > M_PI ? 1 : 0;
    
    NSString *path = [NSString
                      stringWithFormat:
                      @"M%f %f A%f %f 0 %i 1 %f %f L%f %f A%f %f 0 %i 0 %f %f z",
                      p1.x, p1.y,
                      r2, r2, largeArc, p2.x, p2.y,
                      p3.x, p3.y,
                      r1, r1, largeArc, p4.x, p4.y];
    
    NSString *node = [NSString
                      stringWithFormat:
                      @"<path style=\"stroke:#%@; stroke-opacity:%f; fill:#%@; fill-opacity:%f;\" d=\"%@\"></path>\n",
                      [stroke RGBHexString],
                      [stroke alphaValue],
                      [fill RGBHexString],
                      [fill alphaValue], path];
    
    
    return node;
}

@end
