#import "QuartzCore/QuartzCore.h"

@interface ODArcDrawing

void drawArc(CGRect rect, CGContextRef ctx, CGFloat x, CGFloat y, CGFloat start, CGFloat end, CGFloat radius, CGFloat thickness, UIColor *fill, UIColor *stroke);

@end
