//
//  ODFilesCollectionViewCell.m
//  OcodoArcConstrukt
//
//  Created by jason on 10/11/12.
//  Copyright (c) 2012 ocodo. All rights reserved.
//

#import "ODFilesCollectionViewCell.h"

@implementation ODFilesCollectionViewCell

@synthesize imageView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    UIBezierPath *rectangle = [UIBezierPath bezierPathWithRect: rect];
    [[UIColor colorWithWhite:0 alpha:0.4] setFill];
    [rectangle fill];
    [[UIColor colorWithWhite:1 alpha:0.3] setStroke];
    rectangle.lineJoinStyle = kCGLineJoinMiter;
    rectangle.lineWidth = 0.5;
    [rectangle stroke];
}

@end
