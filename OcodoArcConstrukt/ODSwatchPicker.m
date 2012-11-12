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
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGColorRef bgColor = [UIColor orangeColor].CGColor;
    CGContextSetFillColorWithColor(context, bgColor);
    CGContextFillRect(context, rect);

    NSMutableArray *colors = [ODColorPalette singleton].colors;
    
    int i=0;
    int len=colors.count;
    float space=rect.size.width/len;
    for (UIColor *color in colors) {
        CGContextSetFillColorWithColor(context, color.CGColor);
        CGContextFillRect(context, CGRectMake(space*i, 0, space, rect.size.height));
        i++;
    }
}

- (int)colorIndexAtPoint:(CGPoint)point {
    int len = [ODColorPalette singleton].colors.count;
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
    return [[ODColorPalette singleton].colors objectAtIndex:[self colorIndexAtPoint:point]];
}

@end
