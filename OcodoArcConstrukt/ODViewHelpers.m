//
//  ODViewHelpers.m
//  OcodoArcConstrukt
//
//  A few C helper functions for CG drawing.
//
//  Created by jason on 16/11/12.
//  Copyright (c) 2012 ocodo. All rights reserved.
//

#import "ODViewHelpers.h"

@implementation ODViewHelpers

void drawGradient(NSArray *colors, CGContextRef ctx, CGFloat* locations, CGPoint startPoint, CGPoint endPoint, CGRect rect)
{
    CGColorSpaceRef baseSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColors(baseSpace, (CFArrayRef)CFBridgingRetain(colors), locations);
    CGColorSpaceRelease(baseSpace), baseSpace = NULL;
    CGContextSaveGState(ctx);
    CGContextAddRect(ctx, rect);
    CGContextClip(ctx);
    CGContextDrawLinearGradient(ctx, gradient, startPoint, endPoint, 0);
    CGGradientRelease(gradient), gradient = NULL;
    CGContextRestoreGState(ctx);
    colors = nil;
}

void drawCheckerBoard (void *info, CGContextRef ctx) {
    CGContextSetFillColorWithColor(ctx, [UIColor whiteColor].CGColor);
    CGContextAddRect(ctx, CGRectMake(0, 0, 10, 10));
    CGContextAddRect(ctx, CGRectMake(10, 10, 10, 10));
    CGContextFillPath(ctx);
}

void drawInsetChrome (CGContextRef ctx, CGRect rect) {
    CGPoint startPoint = CGPointMake(0, 0);
    CGPoint endPoint = CGPointMake(0, rect.size.height);
    CGFloat locations[4] = { 0.0, 0.1, 0.8, 1.0 };
    
    drawGradient(@[
                 (id)[UIColor colorWithWhite:0 alpha:1].CGColor,
                 (id)[UIColor colorWithWhite:0 alpha:0].CGColor,
                 (id)[UIColor colorWithWhite:1 alpha:0.3].CGColor,
                 (id)[UIColor colorWithWhite:0 alpha:0].CGColor
                 ], ctx, locations, startPoint, endPoint, rect);
}

@end

