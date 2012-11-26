#import "ODArcDrawing.h"

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
    
    start = fmod(start, M_PI*2);
    end = fmod(end, M_PI*2);
    
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
