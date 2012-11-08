//
//  ODColorPalette.m
//  OcodoArcConstrukt
//
//  Created by jason on 6/11/12.
//  Copyright (c) 2012 ocodo. All rights reserved.
//

#import "ODColorPalette.h"

@implementation ODColorPalette

+(ODColorPalette *)singleton {
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
                  
                  [UIColor colorWithRed:0.658824 green:0.639216 blue:0.556863 alpha:1.0f],
                  [UIColor colorWithRed:0.513726 green:0.486275 blue:0.403922 alpha:1.0f],
                  [UIColor colorWithRed:0.913725 green:0.709804 blue:0.254902 alpha:1.0f],
                  [UIColor colorWithRed:0.792157 green:0.768627 blue:0.709804 alpha:1.0f],
                  [UIColor colorWithRed:0.901961 green:0.886275 blue:0.847059 alpha:1.0f],
                  [UIColor colorWithRed:0.254902 green:0.227451 blue:0.180392 alpha:1.0f]
                  
                  ]];
    }
    
    return self;
}

@end
