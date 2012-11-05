//
//  ocodoArcMachineCompositionViewController.m
//  TestUIViewDrawing
//
//  Created by jason on 28/10/12.
//  Copyright (c) 2012 ocodo. All rights reserved.
//

#define MAXIMUM_LAYERS 150

#import "ArcConstruktViewController.h"
#import "OCFingerRotationGestureRecognizer.h"
#import "ODArcConstruktColorViewController.h"
#import "DZProgressController.h"
#import "TKAlertCenter.h"
#import "UIView+Hierarchy.h"
#import "NPTransparencyPicker.h"

#import "ODCurrentArcObject.h"
#import "ArcMachine.h"
#import "extra_math.h"

#import <QuartzCore/QuartzCore.h>

@interface ArcConstruktViewController ()

@end

@implementation ArcConstruktViewController

@synthesize arcConstruktView, gridView, savedFill, savedStroke, layerStepper, titleView, mainToolbar, colorSwatchCollection, fillStrokeSelector, transparencyPicker;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    NSLog(@"ArcConstrukt start:");
    
    [super viewDidLoad];
    
	// Do any additional setup after loading the view.

    // Add gesture recognizers to comp-view.
    UIPinchGestureRecognizer *pincher = [[UIPinchGestureRecognizer alloc]
                                         initWithTarget:self
                                         action:@selector(handlePinch:)];
    [arcConstruktView addGestureRecognizer:pincher];
    
    OCFingerRotationGestureRecognizer *rotation =[[OCFingerRotationGestureRecognizer alloc]
                                                  initWithTarget:self
                                                  action:@selector(handleRotate:)];
    
    [arcConstruktView addGestureRecognizer:rotation];

    UITapGestureRecognizer *titleTap = [[UITapGestureRecognizer alloc]
                                        initWithTarget:self                                                                               action:@selector(handleTitleTap:)];
   
    [titleView setUserInteractionEnabled:YES];
    [titleView addGestureRecognizer:titleTap];
    
    // set comp-view style
    arcConstruktView.opaque = YES;
    arcConstruktView.backgroundColor = [UIColor colorWithWhite:0.1 alpha:.8];
    
    // set rotate and pinch gesture modes.
    rotateMode = 0;
    pinchMode = 0;
 
    // set tiled background.
    [self view].backgroundColor = [
                                   UIColor colorWithPatternImage:
                                   [UIImage imageNamed:@"outlets@2x.png"]];
    

    UIPanGestureRecognizer * panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onMoveTransparencyIndicator:)];
    [transparencyPicker addGestureRecognizer:panGesture];
    [transparencyPicker setNeedsDisplay];

    // style stepper button images.
    //
    [layerStepper
     setIncrementImage:[UIImage imageNamed:@"up.png"]
     forState:UIControlStateNormal];
    [layerStepper
     setDecrementImage:[UIImage imageNamed:@"down.png"]
     forState:UIControlStateNormal];
    [layerStepper
     setIncrementImage:[UIImage imageNamed:@"up.png"]
     forState:UIControlStateDisabled];
    [layerStepper
     setDecrementImage:[UIImage imageNamed:@"down.png"]
     forState:UIControlStateDisabled];
    [layerStepper
     setIncrementImage:[UIImage imageNamed:@"up.png"]
     forState:UIControlStateHighlighted];
    [layerStepper
     setDecrementImage:[UIImage imageNamed:@"down.png"]
     forState:UIControlStateHighlighted];
    [layerStepper
     setIncrementImage:[UIImage imageNamed:@"up.png"]
     forState:UIControlStateSelected];
    [layerStepper
     setDecrementImage:[UIImage imageNamed:@"down.png"]
     forState:UIControlStateSelected];
    
    [self moveToolbar:0];
}

- (void)addRandomLayer{
    ArcMachine *a = [[ArcMachine alloc] initWithFrame:CGRectMake(0, 0, 320, 320)];
    a.backgroundColor = [UIColor clearColor];
    a.start = DEGREES_TO_RADIANS(arc4random()%360);
    a.end = DEGREES_TO_RADIANS(MAX(arc4random()%360,10));
    int r = MAX(arc4random()%159, 20);
    a.radius = r;
    int m = MIN(60,160-r);
    a.thickness = MAX(arc4random() % m, 1);
    
    if([ODCurrentArcObject singleton].currentArc.savedFill) {
        a.fill = [ODCurrentArcObject singleton].currentArc.savedFill;
    } else {
        a.fill = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    }

    if([ODCurrentArcObject singleton].currentArc.savedStroke) {
        a.stroke = [ODCurrentArcObject singleton].currentArc.savedStroke;
    } else {
        a.stroke = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
    }

    [arcConstruktView addSubview:a];
}

- (void)removeArcLayer{
    if([ODCurrentArcObject singleton].currentArc) {
        [[ODCurrentArcObject singleton].currentArc removeFromSuperview];
    }
}

- (IBAction)addButton:(UIBarButtonItem *)sender {
    int max_layer = [arcConstruktView subviews].count;
    if(max_layer < MAXIMUM_LAYERS) {
        [self addRandomLayer];
        [layerStepper setMaximumValue:max_layer];
        [layerStepper setValue:max_layer];
        [self layerSelecting:layerStepper];
    } else {
        [[TKAlertCenter defaultCenter]
         postAlertWithMessage:
         [NSString
          stringWithFormat:@"MAXIMUM: %d LAYERS", max_layer]];
    }
}

- (IBAction)deleteButton:(id)sender {
    [self removeArcLayer];
    [layerStepper setMaximumValue:[arcConstruktView subviews].count - 1];
    [layerStepper setValue:0];
    [self layerSelecting:layerStepper];
}

- (IBAction)clearButton:(UIBarButtonItem *)sender {
    for(ArcMachine *arc in arcConstruktView.subviews)
    {
        [arc removeFromSuperview];
    }

    [layerStepper setMaximumValue:[arcConstruktView subviews].count - 1];
    [layerStepper setValue:0];
}

- (IBAction)swatchSelect:(UIBarButtonItem *)sender {
    switch (fillStrokeSelector.selectedSegmentIndex) {
        case 0:
            [ODCurrentArcObject singleton].currentArc.savedFill = sender.tintColor;
            [ODCurrentArcObject singleton].currentArc.fill = sender.tintColor;
            break;

        case 1:
            [ODCurrentArcObject singleton].currentArc.savedStroke = sender.tintColor;
            [ODCurrentArcObject singleton].currentArc.stroke = sender.tintColor;
            break;
        default:
            break;
    }
    [[ODCurrentArcObject singleton].currentArc setNeedsDisplay];
}

- (IBAction)deselectCurrentArc:(UIBarButtonItem *)sender {
    [self deselect];
}

- (void) deselect {
    [[ODCurrentArcObject singleton].currentArc deselectArc];
}

- (void) resetStepper {
    [layerStepper setMaximumValue:[arcConstruktView subviews].count - 1];
    [layerStepper setValue:0];
    [self layerSelecting:layerStepper];
}

- (void) layerSelecting:(UIStepper *)sender {

    if ([ODCurrentArcObject singleton].currentArc) {
        [[ODCurrentArcObject singleton].currentArc deselectArc];
    }
    
    if ([arcConstruktView subviews].count > 0) {
        [ODCurrentArcObject singleton].currentArc = [[arcConstruktView subviews] objectAtIndex:sender.value];
        [[ODCurrentArcObject singleton].currentArc selectArc];
    }
}

- (IBAction)gridModeStep:(id)sender {
    [gridView incrementGridMode];
}

- (void)handlePinch:(UIPinchGestureRecognizer *)pincher {
    switch (pinchMode) {
        case 0:
            [self pinchRadius:pincher];
            break;
            
        case 1:
            [self pinchThickness:pincher];
            
        default:
            break;
    }
}

- (void)pinchRadius:(UIPinchGestureRecognizer *)pincher {
    float radius = clampf([ODCurrentArcObject singleton].currentArc.radius + pincher.scale-1, 1.0f, 160.0f);
    [ODCurrentArcObject singleton].currentArc.radius = radius;
    [[ODCurrentArcObject singleton].currentArc setNeedsDisplay];
}

- (void)pinchThickness:(UIPinchGestureRecognizer *)pincher {
    float thick = clampf([ODCurrentArcObject singleton].currentArc.thickness + pincher.scale-1, 1.0f, 160.0f);
    [ODCurrentArcObject singleton].currentArc.thickness = thick;
    [[ODCurrentArcObject singleton].currentArc setNeedsDisplay];
}

- (void)handleRotate:(OCFingerRotationGestureRecognizer *)rotator {
    switch (rotateMode) {
        case 0:
            [self startAngleTouch:rotator];
            break;
        case 1:
            [self endAngleTouch:rotator];
            break;
        default:
            break;
    }
}

- (void)startAngleTouch:(OCFingerRotationGestureRecognizer *)rotator {
    if([ODCurrentArcObject singleton].currentArc) {
        [ODCurrentArcObject singleton].currentArc.start += rotator.rotation;
        [[ODCurrentArcObject singleton].currentArc setNeedsDisplay];
    }
}

- (void)endAngleTouch:(OCFingerRotationGestureRecognizer *)rotator {
    if([ODCurrentArcObject singleton].currentArc){
        [ODCurrentArcObject singleton].currentArc.end += rotator.rotation;
        [[ODCurrentArcObject singleton].currentArc setNeedsDisplay];
    }
}

- (IBAction)layerStep:(UIStepper *)sender {
    [self layerSelecting:sender];
}

- (IBAction)changeRotateMode:(UISegmentedControl *)sender {
    rotateMode = sender.selectedSegmentIndex;
}

- (IBAction)changePinchMode:(UISegmentedControl *)sender {
    pinchMode = sender.selectedSegmentIndex;
}

- (void) handleTitleTap:(UITapGestureRecognizer *) tap {
    [self performSegueWithIdentifier:@"aboutPageSegue" sender:self];
}

- (IBAction)savePNGImagetoPhotoAlbum:(id)sender {
    if([[arcConstruktView subviews] count] > 0) {
    
    [self deselect];
    // show progress HUD
    DZProgressController *HUD = [DZProgressController new];
    HUD.label.text = @"Saving";
    [HUD showWhileExecuting:^{
        // style comp-view (make it transparent for png saving.)
        arcConstruktView.opaque = NO;
        arcConstruktView.backgroundColor = [UIColor clearColor];
        
        UIGraphicsBeginImageContextWithOptions(arcConstruktView.bounds.size, NO, 6.0);
        [arcConstruktView.layer renderInContext:UIGraphicsGetCurrentContext()];
        
        UIImage* pngImage = [UIImage
                             imageWithData:UIImagePNGRepresentation(UIGraphicsGetImageFromCurrentImageContext())];
        
        UIGraphicsEndImageContext();
        
        UIImageWriteToSavedPhotosAlbum(pngImage, self,  @selector(image:didFinishSavingWithError:contextInfo:), NULL);
        
        arcConstruktView.opaque = YES;
        arcConstruktView.backgroundColor = [UIColor colorWithWhite:0.1 alpha:1];
    }];
    }
    else {
        [[TKAlertCenter defaultCenter] postAlertWithMessage:@"Press + to add Arcs" image:[UIImage imageNamed:@"lightBulb@2x.png"]];
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void*)contextInfo {
    if (error) {
        [[TKAlertCenter defaultCenter] postAlertWithMessage:@"There was a problem saving your image, check photo album privacy settings, and make sure you have enough free memory."];
    } else {
        // saved ok.
    }
}

- (IBAction)arrangeLayer:(UISegmentedControl *)sender {
    
    NSLog(@"Arranging Layer %i", sender.selectedSegmentIndex);

    ArcMachine *arc = [ODCurrentArcObject singleton].currentArc;
    
    switch (sender.selectedSegmentIndex) {
        case 0:
            [arc sendToBack];
            break;
            
        case 1:
            [arc sendOneLevelDown];
            break;
            
        case 2:
            [arc bringOneLevelUp];
            break;
            
        case 3:
            [arc bringToFront];
            break;
            
        default:
            break;
    }

}

- (IBAction)transparencySelectorToggle:(id)sender {
    int pos = transparencyPicker.frame.origin.x;
    int move_to_x = (pos != 10) ? 10 : -400;
    [UIView animateWithDuration:0.5
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.transparencyPicker.frame = CGRectMake(move_to_x,
                                                                    self.transparencyPicker.frame.origin.y,
                                                                    self.transparencyPicker.frame.size.width,
                                                                    self.transparencyPicker.frame.size.height);
                     }
                     completion:nil];
}

- (void)onMoveTransparencyIndicator:(UIPanGestureRecognizer *)recognizer {
    [transparencyPicker setPickerPoint:[recognizer locationInView:transparencyPicker]];
    [transparencyPicker setNeedsDisplay];
    
    if([ODCurrentArcObject singleton].currentArc == NULL)
        return;

    const CGFloat *f = CGColorGetComponents([ODCurrentArcObject singleton].currentArc.savedFill.CGColor);
    const CGFloat *s = CGColorGetComponents([ODCurrentArcObject singleton].currentArc.savedStroke.CGColor);
 
    switch (fillStrokeSelector.selectedSegmentIndex) {
        case 0:
            [ODCurrentArcObject singleton].currentArc.savedFill = [UIColor colorWithRed:f[0] green:f[1] blue:f[2] alpha:[transparencyPicker transparency]];
            [ODCurrentArcObject singleton].currentArc.fill = [UIColor colorWithRed:f[0] green:f[1] blue:f[2] alpha:[transparencyPicker transparency]];
            break;
            
        case 1:
            [ODCurrentArcObject singleton].currentArc.savedStroke = [UIColor colorWithRed:s[0] green:s[1] blue:s[2] alpha:[transparencyPicker transparency]];
            [ODCurrentArcObject singleton].currentArc.stroke = [UIColor colorWithRed:s[0] green:s[1] blue:s[2] alpha:[transparencyPicker transparency]];
            break;

        default:
            break;
    }
    [[ODCurrentArcObject singleton].currentArc setNeedsDisplay];
    
}

- (void) moveToolbar:(int)s {
    int x = s * -320;
    [UIView animateWithDuration:0.5
                          delay:0
                        options: UIViewAnimationOptionCurveEaseOut
                     animations:^{
        self.mainToolbar.frame = CGRectMake(x,
                                            self.mainToolbar.frame.origin.y,
                                            self.mainToolbar.frame.size.width,
                                            self.mainToolbar.frame.size.height);
    }
                     completion:nil
     ];
}

- (IBAction)toolbarModeSelector:(UISegmentedControl*)sender {
    [self moveToolbar:sender.selectedSegmentIndex];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
