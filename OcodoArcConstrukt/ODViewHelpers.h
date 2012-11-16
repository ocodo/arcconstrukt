//
//  ODViewHelpers.h
//  OcodoArcConstrukt
//
//  Created by jason on 16/11/12.
//  Copyright (c) 2012 ocodo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ODViewHelpers : NSObject

void drawGradient(NSArray *colors, CGContextRef ctx, CGFloat* locations, CGPoint startPoint, CGPoint endPoint, CGRect rect);

void drawCheckerBoard (void *info, CGContextRef ctx);

void drawInsetChrome (CGContextRef ctx, CGRect rect);

@end

