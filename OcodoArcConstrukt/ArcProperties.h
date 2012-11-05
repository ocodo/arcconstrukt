//
//  ArcProperties.h
//  TestUIViewDrawing
//
//  Created by jason on 28/10/12.
//  Copyright (c) 2012 ocodo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ArcProperties : NSObject
{
    CGFloat x;
    CGFloat y;
    CGFloat start;
    CGFloat end;
    CGFloat radius;
    CGFloat thickness;
    UIColor *fillColor;
    UIColor *strokeColor;
}

@property (readwrite) CGFloat x;
@property (readwrite) CGFloat y;
@property (readwrite) CGFloat start;
@property (readwrite) CGFloat end;
@property (readwrite) CGFloat radius;
@property (readwrite) CGFloat thickness;
@property (nonatomic, retain) UIColor *fillColor;
@property (nonatomic, retain) UIColor *strokeColor;

@end
