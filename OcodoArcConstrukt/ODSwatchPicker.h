//
//  ODSwatchPicker.h
//  OcodoArcConstrukt
//
//  Created by jason on 6/11/12.
//  Copyright (c) 2012 ocodo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ODSwatchPicker : UIView

- (int)colorIndexAtPoint:(CGPoint)point;
- (UIColor*)paletteColorAtPoint:(CGPoint)point;

@end
