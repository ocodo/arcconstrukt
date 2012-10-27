//
//  ocodoViewController.h
//  TestUIViewDrawing
//
//  Created by jason on 25/10/12.
//  Copyright (c) 2012 ocodo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArcMachine.h"

@interface OcodoViewController : UIViewController

{
    IBOutlet ArcMachine *arcMachine;
    int rotateMode;
    int pinchMode;
}

@property(readonly) IBOutlet ArcMachine *arcMachine;

@end
