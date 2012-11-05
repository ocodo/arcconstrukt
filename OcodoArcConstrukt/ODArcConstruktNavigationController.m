//
//  ODArcConstruktNavigationControllerViewController.m
//  OcodoArcConstrukt
//
//  Created by jason on 2/11/12.
//  Copyright (c) 2012 ocodo. All rights reserved.
//

#import "ODArcConstruktNavigationController.h"

@interface ODArcConstruktNavigationController ()

@end

@implementation ODArcConstruktNavigationController

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
    self.navigationBar.barStyle = UIBarStyleBlackTranslucent;
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
