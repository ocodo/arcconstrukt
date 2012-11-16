//
//  ODArcConstruktViewController.h
//  ArcConstrukt
//
//  Created by jason on 28/10/12.
//  Copyright (c) 2012 ocodo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "ODFingerRotationGestureRecognizer.h"
#import "DZProgressController.h"
#import "TKAlertCenter.h"
#import "UIView+Hierarchy.h"
#import "ODTransparencyPicker.h"
#import "ODColorPalette.h"
#import "ODCurrentArcObject.h"
#import "ODArcMachine.h"
#import "ODGridView.h"
#import "NPColorPickerView.h"
#import "ODSwatchPicker.h"
#import "ODTransparencyPicker.h"
#import "ODTransparencyButton.h"
#import "CGColor+Additions.h"
#import "ODFilesCollectionViewController.h"
#import "ODArcConstruktFile.h"

#import "extra_math.h"

@interface ODArcConstruktViewController : UIViewController <NPColorPickerViewDelegate>
{
    UIPasteboard *appPasteboard;
    int rotateMode;
    int pinchMode;
}

@property (readonly) IBOutlet UIView *titleView;

@property (readonly) IBOutlet UIToolbar *mainToolbar;

@property (readonly) IBOutlet UISegmentedControl *fillStrokeSelector;
@property (readonly) IBOutlet UISegmentedControl *toolbarModeSelector;
@property (readonly) IBOutlet UISegmentedControl *layerOrderSelector;
@property (readonly) IBOutlet UISegmentedControl *angleSelector;
@property (readonly) IBOutlet UISegmentedControl *pinchSelector;

@property (readonly) IBOutlet UIStepper *layerStepper;

@property (readonly) IBOutlet ODTransparencyPicker *transparencyPicker;
@property (readonly) IBOutlet ODTransparencyButton *transparencyButton;

@property (readonly) IBOutlet ODSwatchPicker *swatchBar;
@property (readonly) IBOutlet NPColorPickerView *colorPicker;

@property (readonly) IBOutlet UIView *arcConstruktView;
@property (readonly) IBOutlet ODGridView *gridView;

@end
