//
//  ODInstructionsOverlay.m
//  OcodoArcConstrukt
//
//  Created by jason on 17/11/12.
//  Copyright (c) 2012 ocodo. All rights reserved.
//

#import "ODInstructionsOverlay.h"

@implementation ODInstructionsOverlay

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.4]];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    
    
    [[UIColor whiteColor] setFill];

    drawText(@"Add Arc", 19, 231, 48, 18, 12);
    drawPointer(CGPointMake(21, 33), CGPointMake(21, 230));
    drawPointer(CGPointMake(24, 252), CGPointMake(24, 398));
    
    drawDashBox(CGRectMake(81, 165, 149, 48), 10);
    drawText(@"Touch Hold drawing area for quick edit menu", 100, 172, 125, 39, 12);
    
    drawPointer(CGPointMake(91, 32), CGPointMake(91, 53));
    drawPointer(CGPointMake(229, 32), CGPointMake(229, 5));
    drawText(@"Press for this page Hold for video tour", 95, 48, 125, 43, 12);

    drawPointer(CGPointMake(275, 32), CGPointMake(274, 74));
    drawText(@"Action Menu",224, 106, 88, 23, 12);
    
    drawPointer(CGPointMake(297, 252), CGPointMake(297, 396));
    drawText(@"Remove Arc",232, 230, 88, 23, 12);

    drawText(@"Finger Rotate", 39, 315, 88, 23, 12);
    
    drawPointer(CGPointMake(51, 352), CGPointMake(51, 406));
    drawText(@"A˚", 43, 331, 23, 23, 12);
    
    drawPointer(CGPointMake(87, 352), CGPointMake(87, 406));
    drawText(@"B˚", 80, 331, 23, 23, 12);
    
    drawPointer(CGPointMake(125, 352), CGPointMake(125, 406));
    drawText(@"Lock", 122, 331, 36, 23, 12);

    drawText(@"Pinch", 161, 315, 88, 23, 12);

    drawPointer(CGPointMake(173, 352), CGPointMake(173, 406));
    drawText(@"Radius", 168, 331, 47, 23, 12);

    drawPointer(CGPointMake(208, 369), CGPointMake(208, 406));
    drawText(@"Thickness", 181, 348, 62, 23, 12);
    
    //    242, 331,  36,  23 Lock - 246, 352 .. 246, 406
    drawPointer(CGPointMake(246, 352), CGPointMake(246, 406));
    drawText(@"Lock", 242, 331, 36, 23, 12);

    drawText(@"Select Arc", 28, 431, 85, 17, 11);

    drawText(@"Grid", 154, 431, 26, 17, 11);

    drawText(@"Tools Selector", 209, 431, 85, 17, 11);

    drawText(@"Deselect", 109, 463, 85, 17, 11);

    drawText(@"Edit", 199, 463, 23, 17, 11);

    drawText(@"Color", 237, 463, 30, 17, 11);

    drawText(@"Arrange", 274, 463, 46, 17, 11);
    
}

void drawText(NSString *text, float x, float y, float w, float h, float size) {
    [text
     drawInRect:CGRectMake(x, y, w, h) withFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:size]
     lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentLeft];
}

void drawDashBox(CGRect rect, float corner) {
    UIBezierPath *box = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:corner];
    [[UIColor colorWithWhite:1 alpha:0.4] setStroke];
    box.lineWidth = 1;
    CGFloat pat[] = {3,3,3,3};
    [box setLineDash:pat count:4 phase:0];
    [box stroke];
}

void drawPointer(CGPoint a, CGPoint b) {
    UIBezierPath *pointer = [UIBezierPath bezierPath];
    [pointer moveToPoint:a];
    [pointer addLineToPoint:b];
    [[UIColor colorWithWhite:1 alpha:0.7] setStroke];
    pointer.lineWidth = 1;
    [pointer stroke];
}

@end
