//
//  ArcConstruktAppDelegate.h
//  ArcConstrukt
//
//  Created by jason on 25/10/12.
//  Copyright (c) 2012 ocodo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ODColorPalette.h"
#import "ODArcConstruktViewController.h"
#import "ODArcConstruktNavigationController.h"
#import "ODApplicationState.h"

@interface ArcConstruktAppDelegate : UIResponder <UIApplicationDelegate>
{
    NSMutableDictionary *_viewControllers;
}

@property (strong, nonatomic) UIWindow *window;

- (void)registerViewController:(NSString *)name controller:(UIViewController *)controller;

@end
