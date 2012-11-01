//
//  ocodoArcMachineCompositionViewController.h
//  TestUIViewDrawing
//
//  Created by jason on 28/10/12.
//  Copyright (c) 2012 ocodo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArcMachine.h"
#import "DZProgressController.h"

@interface CompositionViewController : UIViewController
{
    NSMutableArray *arcLayersData;
    IBOutlet UIView *compositionView;
    ArcMachine *currentArc;
    UIColor *savedFillColor;
    UIColor *savedStrokeColor;
    IBOutlet UIStepper *layerStepper;
    int rotateMode;
    int pinchMode;
}

@property (nonatomic, retain) NSMutableArray *arcLayersData;
@property (readonly) IBOutlet UIView *compositionView;
@property (readonly) IBOutlet UIView *layerStepper;
@property (readwrite, retain) ArcMachine *currentArc;
@property (nonatomic,retain) UIColor *savedFillColor;
@property (nonatomic,retain) UIColor *savedStrokeColor;

@end
