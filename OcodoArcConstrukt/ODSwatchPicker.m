//
//  ODSwatchPicker.m
//  OcodoArcConstrukt
//
//  Created by jason on 6/11/12.
//  Copyright (c) 2012 ocodo. All rights reserved.
//

#import "ODSwatchPicker.h"
#import <QuartzCore/QuartzCore.h>
#import <Foundation/Foundation.h>
#import "ODColorPalette.h"
#import "ODTransparencyPicker.h"
#import "ODViewHelpers.h"

@implementation ODSwatchPicker

- (id)initWithFrame:(CGRect)frame;
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder;
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit;
{
    CALayer *layer = self.layer;
    layer.cornerRadius  = 5.0f;
    layer.masksToBounds = YES;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGColorRef bgColor = [UIColor orangeColor].CGColor;
    CGContextSetFillColorWithColor(ctx, bgColor);
    CGContextFillRect(ctx, rect);

    NSMutableArray *colors = [ODColorPalette sharedinstance].colors;
    
    int i=0;
    int len=colors.count;
    float space=ceilf(rect.size.width/len);
    for (UIColor *color in colors) {
        CGContextSetFillColorWithColor(ctx, color.CGColor);
        CGContextFillRect(ctx, CGRectMake(space*i, 0, space, rect.size.height));
        i++;
    }

    drawInsetChrome(ctx, rect);

}

- (int)colorIndexAtPoint:(CGPoint)point {
    int len = [ODColorPalette sharedinstance].colors.count;
    int i=0;
    float space = self.frame.size.width/len;
    for(;i<len; i++)
    {
        if ( point.x > space*i)
        {
            continue;
        } else {
            break;
        }
    }    
    return MAX(i-1,0);
}

- (UIColor *)paletteColorAtPoint:(CGPoint)point {
    return [[ODColorPalette sharedinstance].colors objectAtIndex:[self colorIndexAtPoint:point]];
}

@end
