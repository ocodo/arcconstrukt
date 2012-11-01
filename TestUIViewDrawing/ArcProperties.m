//
//  ArcProperties.m
//  TestUIViewDrawing
//
//  Created by jason on 28/10/12.
//  Copyright (c) 2012 ocodo. All rights reserved.
//

#import "ArcProperties.h"

@implementation ArcProperties

@synthesize x, y, start, end, radius, thickness, fillColor, strokeColor;

- (ArcProperties*)init {
    if(self = [super init])
    {
        self.x = 0;
        self.y = 0;
        self.start = 0;
        self.end = 0;
        self.radius = 30;
        self.thickness = 30;
        self.fillColor = [UIColor colorWithCGColor:[UIColor whiteColor].CGColor];
        self.strokeColor = [UIColor colorWithCGColor:[UIColor blackColor].CGColor];
    }
    return self;
}

@end
