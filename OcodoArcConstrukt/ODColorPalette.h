//
//  ODColorPalette.h
//  OcodoArcConstrukt
//
//  Created by jason on 6/11/12.
//  Copyright (c) 2012 ocodo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ODColorPalette : NSObject
{
    NSMutableArray *colors;
    int selectedIndex;
}

@property int selectedIndex;
@property NSMutableArray *colors;

+ (ODColorPalette *)sharedinstance;

@end