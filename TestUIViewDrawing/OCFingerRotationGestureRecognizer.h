//
//  OCODOOneFingerRotationGestureRecognizer.h
//  TestUIViewDrawing
//
//  Created by jason on 28/10/12.
//  Copyright (c) 2012 ocodo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OCFingerRotationGestureRecognizer : UIGestureRecognizer

/**
 The rotation of the gesture in radians since its last change.
 */
@property (nonatomic, assign) CGFloat rotation;

@end
