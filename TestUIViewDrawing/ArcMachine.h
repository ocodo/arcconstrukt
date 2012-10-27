//
//  ArcMachine.h
//  TestUIViewDrawing
//
//  Created by jason on 25/10/12.
//  Copyright (c) 2012 ocodo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuartzCore/QuartzCore.h"

#define DEGREES_TO_RADIANS(angle)( ( angle ) / 180.0 * M_PI )
#define RADIANS_TO_DEGREES( radians ) ( ( radians ) * ( 180.0 / M_PI ) )

@interface ArcMachine : UIView {
@private CGFloat startAngle;
@private CGFloat endAngle;
@private CGFloat innerRadius;
@private CGFloat thickness;
@private CGFloat rotationAngle;
@private CGFloat arcSizeAngle;
}

@property (readwrite,assign) CGFloat startAngle;
@property (readwrite,assign) CGFloat endAngle;
@property (readwrite,assign) CGFloat innerRadius;
@property (readwrite,assign) CGFloat thickness;
@property (readwrite,assign) CGFloat rotationAngle;
@property (readwrite,assign) CGFloat arcSizeAngle;
@end
