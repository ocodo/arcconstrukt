//
//  ODArcConstruktColorUIViewViewController.h
//  OcodoArcConstrukt
//
//  Created by jason on 3/11/12.
//  Copyright (c) 2012 ocodo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArcMachine.h"

@interface ODArcConstruktColorViewController : UIViewController

{
    IBOutlet UISlider *redSlider;
    IBOutlet UISlider *greenSlider;
    IBOutlet UISlider *blueSlider;
    IBOutlet UISlider *alphaSlider;
    UIView *activeSwatch;
    ArcMachine *t;
    IBOutlet UIView *fillColorSwatch;
    IBOutlet UIView *strokeColorSwatch;
    IBOutlet UIView *isolationCanvas;
}

@property IBOutlet UIView *isolationCanvas;
@property IBOutlet UISlider *redSlider;
@property IBOutlet UISlider *blueSlider;
@property IBOutlet UISlider *greenSlider;
@property IBOutlet UISlider *alphaSlider;
@property IBOutlet UIView *fillColorSwatch;
@property IBOutlet UIView *strokeColorSwatch;

@end
