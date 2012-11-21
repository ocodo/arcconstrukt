//
//  ODCurrentArcObject.h
//  OcodoArcConstrukt
//
//  Created by jason on 3/11/12.
//  Copyright (c) 2012 ocodo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ODArcMachine.h"
#import "ODArcConstruktDocument.h"

@interface ODApplicationState : NSObject
{
    ODArcMachine *currentArc;
    NSURL *startUrl;
}

@property ODArcMachine *currentArc;
@property NSURL *startUrl;

+(ODApplicationState *)sharedinstance;

@end

