//
//  ODCurrentArcObject.m
//  OcodoArcConstrukt
//
//  Created by jason on 3/11/12.
//  Copyright (c) 2012 ocodo. All rights reserved.
//

#import "ODApplicationState.h"

@implementation ODApplicationState

+(ODApplicationState *)sharedinstance {
    static dispatch_once_t pred;
    static ODApplicationState *shared = nil;
    
    dispatch_once(&pred, ^{
        shared = [ODApplicationState new];
    });
    return shared;
}

@synthesize currentArc, startUrl;

@end

