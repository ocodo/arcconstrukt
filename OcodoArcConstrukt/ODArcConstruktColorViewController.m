//
//  ODArcConstruktColorUIViewViewController.m
//  OcodoArcConstrukt
//
//  Created by jason on 3/11/12.
//  Copyright (c) 2012 ocodo. All rights reserved.
//

#import "ODArcConstruktColorViewController.h"
#import "ODCurrentArcObject.h"

@interface ODArcConstruktColorViewController ()

@end

@implementation ODArcConstruktColorViewController

@synthesize redSlider, greenSlider, blueSlider, alphaSlider, fillColorSwatch, strokeColorSwatch, isolationCanvas;

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
    // Do any additional setup after loading the view from its nib.

    if ([ODCurrentArcObject singleton]) {
        fillColorSwatch.backgroundColor = [ODCurrentArcObject singleton].currentArc.fill;
        strokeColorSwatch.backgroundColor = [ODCurrentArcObject singleton].currentArc.stroke;        
        
        activeSwatch = fillColorSwatch;
        
        [self updateSliders];

        for(ArcMachine *arc in isolationCanvas.subviews)
        {
            [arc removeFromSuperview];
        }
        
        ArcMachine *arc = [ODCurrentArcObject singleton].currentArc;
        t = [[ArcMachine alloc] init];
        t.stroke = arc.savedStroke;
        t.fill = arc.savedFill;
        t.start = arc.start;
        t.end = arc.end;
        t.radius = arc.radius;
        t.thickness = arc.thickness;
        
        [isolationCanvas addSubview:t];
        [t setNeedsDisplay];
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) updateSliders {
    const CGFloat *components = CGColorGetComponents([activeSwatch.backgroundColor CGColor]);
    
    redSlider.value = components[0];
    greenSlider.value = components[1];
    blueSlider.value = components[2];
    alphaSlider.value = components[3];
}

-(void) setColorSwatch {
    if(activeSwatch)
    {
        activeSwatch.backgroundColor = [UIColor colorWithRed:redSlider.value green:greenSlider.value blue:blueSlider.value alpha:alphaSlider.value ];
        
        if(activeSwatch == fillColorSwatch) {
            [ODCurrentArcObject singleton].currentArc.savedFill = activeSwatch.backgroundColor;
        }
        if(activeSwatch == strokeColorSwatch) {
            [ODCurrentArcObject singleton].currentArc.savedStroke = activeSwatch.backgroundColor;
        }

        [[ODCurrentArcObject singleton].currentArc setNeedsDisplay];
    }
}

- (IBAction)sliderChange:(UISlider *)sender {
    [self setColorSwatch];
}

- (IBAction)fillColorTouched:(id)sender {
    activeSwatch = fillColorSwatch;
    [self updateSliders];
}

- (IBAction)strokeColorTouched:(id)sender {
    activeSwatch = strokeColorSwatch;
    [self updateSliders];
}


@end
