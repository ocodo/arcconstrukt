//
//  ODArcConstruktAboutViewController.m
//  OcodoArcConstrukt
//
//  Created by jason on 2/11/12.
//  Copyright (c) 2012 ocodo. All rights reserved.
//

#import "ODArcConstruktAboutViewController.h"

@interface ODArcConstruktAboutViewController ()

@end

@implementation ODArcConstruktAboutViewController

@synthesize webView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // ...
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"about" ofType:@"html"]isDirectory:NO]]];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
