//
//  ODColorPalette.m
//  OcodoArcConstrukt
//
//  Created by jason on 6/11/12.
//  Copyright (c) 2012 ocodo. All rights reserved.
//

#import "ODColorPalette.h"
#import "CGColor+Additions.h"

@implementation ODColorPalette

+(ODColorPalette *)sharedinstance {
    static dispatch_once_t pred;
    static ODColorPalette *shared = nil;
    
    dispatch_once(&pred, ^{
        shared = [ODColorPalette new];
    });
    return shared;
}

@synthesize colors, selectedIndex;

- (id) init {
    
    self = [super init];
    if (self) {
        
        colors = [[NSMutableArray alloc] initWithArray:@[
                  
                  [UIColor colorWithRGBHexString:@"343838"],
                  [UIColor colorWithRGBHexString:@"005F6B"],
                  [UIColor colorWithRGBHexString:@"008C9E"],
                  [UIColor colorWithRGBHexString:@"00B4CC"],
                  [UIColor colorWithRGBHexString:@"E4844A"],
                  [UIColor colorWithRGBHexString:@"EDF6EE"]
                  
                  ]];
    }
    
    return self;
}

@end
