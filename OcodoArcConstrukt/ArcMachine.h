//
//  ArcMachine.h
//  TestUIViewDrawing
//
//  Created by jason on 25/10/12.
//  Copyright (c) 2012 ocodo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuartzCore/QuartzCore.h"
#import "ArcProperties.h"
#import "UIView+Hierarchy.h"

@interface ArcMachine : UIView {
    CGFloat x;
    CGFloat y;
    CGFloat radius;
    CGFloat start;
    CGFloat end;
    CGFloat thickness;
    UIColor *fill;
    UIColor *stroke;
    UIColor *savedFill;
    UIColor *savedStroke;
}

@property CGFloat x;
@property CGFloat y;
@property CGFloat radius;
@property CGFloat start;
@property CGFloat end;
@property CGFloat thickness;
@property (nonatomic, retain) UIColor *fill;
@property (nonatomic, retain) UIColor *stroke;
@property (nonatomic, retain) UIColor *savedFill;
@property (nonatomic, retain) UIColor *savedStroke;

-(void)selectArc;
-(void)deselectArc;

@end
