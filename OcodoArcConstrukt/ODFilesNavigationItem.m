//
//  ODFilesNavigationItem.m
//  OcodoArcConstrukt
//
//  Created by jason on 20/11/12.
//  Copyright (c) 2012 ocodo. All rights reserved.
//

#import "ODFilesNavigationItem.h"

@implementation ODFilesNavigationItem

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if(self) {
        [self commonInit];
    }
    return self;
}

- (id)initWithTitle:(NSString *)title {
    self = [super initWithTitle:title];
    if(self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    /* I have no choice (?!) but to hard 
     code the title and prompt, (well, 
     until I find out why this is sporadic
     when set from the UIViewController */
    
    [self setPrompt:NSLocalizedString(@"Tap once to Load, Hold to Share or Delete",nil)];

    [self setTitle:NSLocalizedString(@"My ArcMachines",nil)];
}

@end
