//
//  ODArcConstruktViewController.h
//  ArcConstrukt
//
//  Created by jason on 28/10/12.
//  Copyright (c) 2012 ocodo. All rights reserved.
//

#define kMaximumLayers 150
#define kEditToolbarMode 0
#define kColorToolbarMode 1
#define kOrderToolbarMode 2

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "ODFingerRotationGestureRecognizer.h"
#import "DZProgressController.h"
#import "TKAlertCenter.h"
#import "UIView+Hierarchy.h"
#import "ODTransparencyPicker.h"
#import "ODColorPalette.h"
#import "ODApplicationState.h"
#import "ODArcMachine.h"
#import "ODGridView.h"
#import "ODColorPickerView.h"
#import "ODSwatchPicker.h"
#import "ODTransparencyPicker.h"
#import "ODTransparencyButton.h"
#import "CGColor+Additions.h"
#import "ODFilesCollectionViewController.h"
#import "ODArcConstruktDocument.h"
#import "ODInstructionsOverlay.h"

#import "extra_math.h"

@interface ODArcConstruktViewController : UIViewController <NPColorPickerViewDelegate>
{
    UIPasteboard *appPasteboard;
    int _rotateMode;
    int _pinchMode;
    int _toolbarMode;
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
@property (readonly) IBOutlet ODColorPickerView *colorPicker;

@property (readonly) IBOutlet UIView *arcConstruktView;
@property (readonly) IBOutlet ODGridView *gridView;

- (void)loadComposition:(NSString*)filename;
- (void)loadComposition:(NSString*)filename withFolder:(NSString*)folder;
- (void)importComposition:(NSString*)filename withFolder:(NSString*)folder;

@end
