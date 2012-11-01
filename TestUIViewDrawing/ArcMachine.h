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

@interface ArcMachine : UIView {
    ArcProperties *settings;
}

@property (nonatomic, retain) ArcProperties *settings;

@end
