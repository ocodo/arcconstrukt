//
//  ODCurrentArcObject.h
//  OcodoArcConstrukt
//
//  Created by jason on 3/11/12.
//  Copyright (c) 2012 ocodo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ODArcMachine.h"

@interface ODCurrentArcObject : NSObject
{
    ODArcMachine *currentArc;
}

@property ODArcMachine *currentArc;

+(ODCurrentArcObject *)singleton;

@end

