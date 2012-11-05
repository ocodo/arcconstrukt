//
//  ODCurrentArcObject.m
//  OcodoArcConstrukt
//
//  Created by jason on 3/11/12.
//  Copyright (c) 2012 ocodo. All rights reserved.
//

#import "ODCurrentArcObject.h"

@implementation ODCurrentArcObject

+(ODCurrentArcObject *)singleton {
    static dispatch_once_t pred;
    static ODCurrentArcObject *shared = nil;
    
    dispatch_once(&pred, ^{
        shared = [[ODCurrentArcObject alloc] init];
    });
    return shared;
}

@synthesize currentArc;

@end
