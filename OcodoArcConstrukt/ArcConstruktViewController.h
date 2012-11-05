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
#import "ArcConstruktGridView.h"
#import "NPTransparencyPicker.h"

@interface ArcConstruktViewController : UIViewController
{
    IBOutlet UIView *arcConstruktView;
    IBOutlet ArcConstruktGridView *gridView;
    UIColor *savedFill;
    UIColor *savedStroke;
    IBOutlet UIStepper *layerStepper;
    IBOutlet UIView *titleView;
    IBOutlet UIToolbar *mainToolbar;
    int rotateMode;
    int pinchMode;
}
@property (retain, nonatomic) IBOutlet UISegmentedControl *fillStrokeSelector;
@property (readonly) IBOutlet NPTransparencyPicker *transparencyPicker;

@property (retain, nonatomic) IBOutletCollection(UIBarButtonItem) NSArray *colorSwatchCollection;

@property (readonly) IBOutlet UIView *arcConstruktView;
@property (readonly) IBOutlet ArcConstruktGridView *gridView;
@property (readonly) IBOutlet UIStepper *layerStepper;
@property (readonly) IBOutlet UIView *titleView;
@property (readonly) IBOutlet UIToolbar *mainToolbar;
@property (nonatomic, retain) UIColor *savedFill;
@property (nonatomic, retain) UIColor *savedStroke;

@end
