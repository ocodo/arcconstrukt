//
//  ocodoViewController.m
//  TestUIViewDrawing
//
//  Created by jason on 25/10/12.
//  Copyright (c) 2012 ocodo. All rights reserved.
//

#import "OcodoViewController.h"

@interface OcodoViewController ()

@end

@implementation OcodoViewController

@synthesize arcMachine;

- (void)viewDidLoad
{
    [super viewDidLoad];
    arcMachine.innerRadius = 40;// innerRadiusSlider.value;
    arcMachine.thickness = 35; // thicknessSlider.value;
    arcMachine.startAngle = 0; // startAngleSlider.value;
    arcMachine.endAngle = 120; // endAngleSlider.value;
    arcMachine.arcSizeAngle = DEGREES_TO_RADIANS(120);
    
    UIRotationGestureRecognizer *rotator = [[UIRotationGestureRecognizer alloc]
                                                initWithTarget:self
                                                action:@selector(handleRotate:)];
	[arcMachine addGestureRecognizer:rotator];
    
    UIPinchGestureRecognizer *pincher = [[UIPinchGestureRecognizer alloc]
                                            initWithTarget:self
                                            action:@selector(handlePinch:)];
    
    [arcMachine addGestureRecognizer:pincher];
    
    rotateMode = 0;
    pinchMode = 0;
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

float clampf( float v, float min, float max )
{
    if( v < min ) v = min;
    if( v > max ) v = max;
    
    return v;
}

- (void)pinchRadius:(UIPinchGestureRecognizer *)pincher {
    float radius = clampf(arcMachine.innerRadius + pincher.scale-1, 1.0f, 160.0f);
    arcMachine.innerRadius = radius;
    [arcMachine setNeedsDisplay];
}

- (void)pinchThickness:(UIPinchGestureRecognizer *)pincher {
    float thick = clampf(arcMachine.thickness + pincher.scale-1, 1.0f, 160.0f);
    arcMachine.thickness = thick;
    [arcMachine setNeedsDisplay];
}

- (void)handleRotate:(UIRotationGestureRecognizer *)rotator {    
    switch (rotateMode) {
        case 0:
            [self rotateArc:rotator];
            break;
            
        case 1:
            [self sizeArc:rotator];
            
        default:
            break;
    }
}

- (void)sizeArc:(UIRotationGestureRecognizer *)rotator {
    float size = arcMachine.arcSizeAngle + -rotator.rotation;
    arcMachine.endAngle = RADIANS_TO_DEGREES(-size);
    [arcMachine setNeedsDisplay];
    if( rotator.state == UIGestureRecognizerStateEnded) {
        arcMachine.arcSizeAngle = size;
    }
}

- (void)rotateArc:(UIRotationGestureRecognizer *)rotator {
    float rotation = arcMachine.rotationAngle + -rotator.rotation;
	arcMachine.startAngle = RADIANS_TO_DEGREES(-rotation);
	[arcMachine setNeedsDisplay];
	if (rotator.state == UIGestureRecognizerStateEnded) {
		arcMachine.rotationAngle = rotation;
	}
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(IBAction)saveToPhotoAlbum{
    CGRect rect = CGRectMake(0,0,1200,1200);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();

    [arcMachine.layer renderInContext:context];
    UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    UIImageWriteToSavedPhotosAlbum(screenshot, self,  @selector(thisImage:hasBeenSavedInPhotoAlbumWithError:usingContextInfo:), NULL);
}

-(void)thisImage:(UIImage *)image hasBeenSavedInPhotoAlbumWithError:(NSError *)error usingContextInfo:(void*)ctxInfo {
    if (error) {
        // Do anything needed to handle the error or display it to the user
    } else {
        // .... do anything you want here to handle
        // .... when the image has been saved in the photo album
    }
}

- (IBAction)changeRotationMode:(UISegmentedControl *)sender {
    rotateMode = sender.selectedSegmentIndex;
}

- (IBAction)changePinchMode:(UISegmentedControl *)sender {
    pinchMode = sender.selectedSegmentIndex;
}

@end