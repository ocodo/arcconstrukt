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
    [self setPrompt:NSLocalizedString(@"Tap once to Load, Hold to Share or Delete",nil)];
    [self setTitle:NSLocalizedString(@"My ArcMachines",nil)];
    [self setTitleView:[[ODFilesTitleView alloc] initWithFrame:CGRectMake(0, 0, 320, 35) ]];
    NSLog(@"Title view = %@", [self titleView]);
}

@end
