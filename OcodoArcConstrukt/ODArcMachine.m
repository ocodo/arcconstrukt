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

- (id) initWithArcMachine:(ODArcMachine *)arcMachine frame:(CGRect)frame {
    self = [self initWithFrame:frame];
    if(self) {
        self.x = arcMachine.x;
        self.y = arcMachine.y;
        self.start = arcMachine.start;
        self.end = arcMachine.end;
        self.radius = arcMachine.radius;
        self.thickness = arcMachine.thickness;
        self.stroke = arcMachine.savedStroke;
        self.fill = arcMachine.savedFill;
        [self commonInit];
    }
    return self;
}

- (id)initRandomWithFrame:(CGRect)frame fillColor:(UIColor*)fillColor strokeColor:(UIColor*)strokeColor
{
    self = [self initWithFrame:frame];
    if (self) {
        start = arc4random()%360 * M_PI/180;
        end = MAX(arc4random()%360,10) * M_PI/180;
        int r = MAX(arc4random()%159, 20);
        radius = r;
        int m = MIN(40,160-r);
        thickness = MAX(arc4random() % m, 1);
        fill = fillColor;
        stroke = strokeColor;
        savedFill = fillColor;
        savedStroke = strokeColor;
        [self commonInit];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self commonInit];
    }
    return self;
}

- (id)initWithDictionary:(NSDictionary *)plist frame:(CGRect)frame {
    self = [self initWithFrame:frame];
    if(self) {
        [self dictionaryToGeometry:plist];
        [self commonInit];
    }
    return self;
}

-(void) commonInit {
}

- (void)drawRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    drawArc(self.bounds, ctx, x, y, start, end, radius, thickness, fill, stroke);
}

- (void)setNeedsDisplay {
    [super setNeedsDisplay];
}

- (void)selectArc {
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

-(void) dictionaryToGeometry: (NSDictionary *) plist {
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
    
    // NSLog(@"%f, %f, %f, %f, %@, %@", start, end, radius, thickness, [savedFill RGBHexString], [savedStroke RGBHexString]);
    
    return @{
    @"start" : [NSNumber numberWithFloat: start],
    @"end" : [NSNumber numberWithFloat: end],
    @"radius" : [NSNumber numberWithFloat: radius],
    @"thickness" : [NSNumber numberWithFloat: thickness],
    @"fill" : [savedFill RGBADictionary],
    @"stroke" : [savedStroke RGBADictionary]
    };
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

@implementation ODArcDrawing

void drawArc(CGRect rect, CGContextRef ctx, CGFloat x, CGFloat y, CGFloat start, CGFloat end, CGFloat radius, CGFloat thickness, UIColor *fill, UIColor *stroke) {

    CGContextClearRect(ctx, rect);
    
	CGContextTranslateCTM(ctx, CGRectGetMidX(rect), CGRectGetMidY(rect));
    
	CGContextSetLineWidth(ctx, 0.5f);
	CGContextSetLineJoin(ctx, kCGLineJoinRound);
	CGContextSetStrokeColorWithColor(ctx, stroke.CGColor);
	CGContextSetFillColorWithColor(ctx, fill.CGColor);
    
	CGContextBeginPath(ctx);
    
    CGFloat outside = radius+thickness;
    
    CGFloat ax = x + (outside * cos(start));
    CGFloat ay = y + (outside * sin(start));
    CGFloat cx = x + (radius * cos(end));
    CGFloat cy = y + (radius * sin(end));
    
    CGContextMoveToPoint(ctx, ax, ay);
    CGContextAddArc(ctx, x, y, outside, start, end, 0);
    CGContextAddLineToPoint(ctx, cx, cy);
    CGContextAddArc(ctx, x, y, radius, end, start, 1);
    CGContextAddLineToPoint(ctx, ax, ay);
    
	CGContextClosePath(ctx);
	CGContextDrawPath(ctx, kCGPathFillStroke);
}

@end
