//
//  ODFilesTitleView.m
//  OcodoArcConstrukt
//
//  Created by jason on 1/12/12.
//  Copyright (c) 2012 ocodo. All rights reserved.
//

#import "ODFilesTitleView.h"

@implementation ODFilesTitleView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [self drawBoldText:NSLocalizedString(@"My ArcMachines",nil) x:0 y:0 w:rect.size.width h:35 size:20 align:NSTextAlignmentCenter];
}

- (void) drawBoldText:(NSString*) text x:(CGFloat) x y:(CGFloat) y  w:(CGFloat) w h:(CGFloat)h size:(CGFloat)size align:(int)alignment {
    alignment = (alignment) ? alignment : NSTextAlignmentLeft;
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSaveGState(ctx);
    [[UIColor whiteColor] setFill];
    [text
     drawInRect:CGRectMake(x, y, w, h) withFont:[UIFont fontWithName:@"Avenir-Black" size:size]
     lineBreakMode:NSLineBreakByWordWrapping alignment:alignment];
    CGContextRestoreGState(ctx);
}

@end
