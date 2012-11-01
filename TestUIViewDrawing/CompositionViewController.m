//
//  ocodoArcMachineCompositionViewController.m
//  TestUIViewDrawing
//
//  Created by jason on 28/10/12.
//  Copyright (c) 2012 ocodo. All rights reserved.
//

#import "CompositionViewController.h"
#import "OCFingerRotationGestureRecognizer.h"
#import "DZProgressController.h"

#import "ArcMachine.h"
#import "extra_math.h"

#import <QuartzCore/QuartzCore.h>

@interface CompositionViewController ()

@end

@implementation CompositionViewController

@synthesize arcLayersData, compositionView, currentArc, savedFillColor, savedStrokeColor, layerStepper;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.arcLayersData =  [[NSMutableArray alloc] init];
    
    UIPinchGestureRecognizer *pincher = [[UIPinchGestureRecognizer alloc]
                                         initWithTarget:self
                                         action:@selector(handlePinch:)];
    
    [compositionView addGestureRecognizer:pincher];
    
    OCFingerRotationGestureRecognizer *rotation = [[OCFingerRotationGestureRecognizer alloc]
                                                   initWithTarget:self
                                                   action:@selector(handleRotate:)];
    
    [compositionView addGestureRecognizer:rotation];
    
    rotateMode = 0;
    pinchMode = 0;
    
    [self view].backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"escheresque.png"]];
    
    compositionView.opaque = NO;
    compositionView.backgroundColor = [UIColor clearColor];
}

- (void)addRandomLayer{
    ArcMachine *a = [[ArcMachine alloc] initWithFrame:CGRectMake(0, 0, 320, 320)];
    a.backgroundColor = [UIColor clearColor];
    a.settings.start = DEGREES_TO_RADIANS(arc4random()%360);
    a.settings.end = DEGREES_TO_RADIANS(MAX(arc4random()%360,10));
    a.settings.radius = MAX(arc4random()%160, 20);
    a.settings.thickness = MAX(arc4random()%60, 10);
    a.settings.fillColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.7];
    a.settings.strokeColor = [UIColor blackColor];
    [compositionView addSubview:a];
}

- (void)removeArcLayer{
    if(currentArc) {
        [currentArc removeFromSuperview];
    }
}

- (IBAction)addButton:(UIBarButtonItem *)sender {
    [self addRandomLayer];
    int max = [compositionView subviews].count - 1;
    [layerStepper setMaximumValue:max];
    [layerStepper setValue:max];
    [self layerStepping:layerStepper];
}

- (IBAction)deleteButton:(id)sender {
    [self removeArcLayer];
    [layerStepper setMaximumValue:[compositionView subviews].count - 1];
    [layerStepper setValue:0];
    [self layerStepping:layerStepper];
}

- (IBAction)clearButton:(UIBarButtonItem *)sender {
    int l = [compositionView subviews].count;
    for(int i=0; i<l; i++)
    {
        if([compositionView subviews][i])
        {
            [[compositionView subviews][i] removeFromSuperview];
        }
    }
    [layerStepper setMaximumValue:[compositionView subviews].count - 1];
    [layerStepper setValue:0];
}

- (IBAction)deselectCurrentArc:(UIBarButtonItem *)sender {
    currentArc.settings.fillColor = savedFillColor;
    currentArc.settings.strokeColor = savedStrokeColor;
    [currentArc setNeedsDisplay];
}

-(void) resetStepper {
    [layerStepper setMaximumValue:[compositionView subviews].count - 1];
    [layerStepper setValue:0];
    [self layerStepping:layerStepper];
}

-(void) layerStepping:(UIStepper *)sender {
    NSLog(@"Step Selecting: %f ", sender.value);
    
    if (currentArc) {
        currentArc.settings.strokeColor = savedStrokeColor;
        currentArc.settings.fillColor = savedFillColor;
        [currentArc setNeedsDisplay];
    }
    
    if ([compositionView subviews].count > 0) {
        currentArc = [[compositionView subviews] objectAtIndex:sender.value];
        NSLog(@"Selecting subview %f : %@", sender.value, currentArc);
        savedFillColor = currentArc.settings.fillColor;
        savedStrokeColor = currentArc.settings.strokeColor;
        currentArc.settings.fillColor = [UIColor redColor];
        currentArc.settings.strokeColor = [UIColor redColor];
        [currentArc setNeedsDisplay];
    }
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
    float radius = clampf(currentArc.settings.radius + pincher.scale-1, 1.0f, 160.0f);
    currentArc.settings.radius = radius;
    [currentArc setNeedsDisplay];
}

- (void)pinchThickness:(UIPinchGestureRecognizer *)pincher {
    float thick = clampf(currentArc.settings.thickness + pincher.scale-1, 1.0f, 160.0f);
    currentArc.settings.thickness = thick;
    [currentArc setNeedsDisplay];
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

- (void)startAngleTouch:(OCFingerRotationGestureRecognizer *)rotator
{
    if(currentArc) {
        currentArc.settings.start += rotator.rotation;
        [currentArc setNeedsDisplay];
    }
}

- (void)endAngleTouch:(OCFingerRotationGestureRecognizer *)rotator
{
    if(currentArc){
        currentArc.settings.end += rotator.rotation;
        [currentArc setNeedsDisplay];
    }
}

- (IBAction)layerStep:(UIStepper *)sender {
    [self layerStepping:sender];
}

- (IBAction)changeRotateMode:(UISegmentedControl *)sender {
    rotateMode = sender.selectedSegmentIndex;
}

- (IBAction)changePinchMode:(UISegmentedControl *)sender {
    pinchMode = sender.selectedSegmentIndex;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)savePNGImagetoPhotoAlbum:(id)sender
{
    // show progress HUD
    DZProgressController *HUD = [DZProgressController new];
    HUD.label.text = @"Saving";
    [HUD showWhileExecuting:^{
        UIGraphicsBeginImageContextWithOptions(compositionView.bounds.size, NO, 6.0);
        [compositionView.layer renderInContext:UIGraphicsGetCurrentContext()];
        
        UIImage* pngImage = [UIImage
                             imageWithData:UIImagePNGRepresentation(UIGraphicsGetImageFromCurrentImageContext())];
        
        UIGraphicsEndImageContext();
        
        UIImageWriteToSavedPhotosAlbum(pngImage, self,  @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    }];
}


-(void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void*)contextInfo
{
    if (error) {
        // show an alert
    } else {
        // clear HUD
    }
}

@end
