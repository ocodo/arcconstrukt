//
//  ODArcMachine.h
//  ArcConstrukt
//
//  Created by jason on 25/10/12.
//  Copyright (c) 2012 ocodo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuartzCore/QuartzCore.h"
#import "UIView+Hierarchy.h"
#import <tgmath.h>
#import "CGColor+Additions.h"
#import "ODArcDrawing.h"

@interface ODArcMachine : UIView {
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
@property BOOL selected;
@property BOOL highlighted;
@property (nonatomic, retain) UIColor *fill;
@property (nonatomic, retain) UIColor *stroke;
@property (nonatomic, retain) UIColor *savedFill;
@property (nonatomic, retain) UIColor *savedStroke;

- (void)selectArc;
- (void)deselectArc;
- (void)toggleHighlight;

- (id)initWithDictionary:(NSDictionary *)plist frame:(CGRect)frame;
- (void)dictionaryToGeometry:(NSDictionary *)plist;
- (NSDictionary *)geometryToDictionary;

- (NSString *)SVGArc;

- (id)initWithArcMachine:(ODArcMachine *)arcMachine frame:(CGRect)frame;
- (id)initRandomWithFrame:(CGRect)frame fillColor:(UIColor*)fillColor strokeColor:(UIColor*)strokeColor;

@end
