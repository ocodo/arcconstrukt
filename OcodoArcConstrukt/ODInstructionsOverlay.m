//
//  ODInstructionsOverlay.m
//  OcodoArcConstrukt
//
//  Created by jason on 17/11/12.
//  Copyright (c) 2012 ocodo. All rights reserved.
//

#import "ODInstructionsOverlay.h"

@implementation ODInstructionsOverlay

@synthesize mode;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.4]];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeInstructionsOverlay:)];
        
        [self addGestureRecognizer:tap];
        CGRect screenBounds = [[UIScreen mainScreen] bounds];
        _deviceOffsetY = screenBounds.size.height - 480;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    switch (mode) {
        case 0:
            [self drawEditOverlay];
            break;

        case 1:
            [self drawColorPaletteOverlay];
            break;

        case 2:
            [self drawLayerOrderOverlay];
            break;
            
        default:
            break;
    }
}

- (void) drawLayerOrderOverlay {
    [[UIColor whiteColor] setFill];
    
    [self drawText:@"Add Arc" x:19 y:100 w:48 h:42 size:12 align:NSTextAlignmentLeft];
    [self drawPointer:CGPointMake(22, 95) b:CGPointMake(22, 48)];

    [self drawTitleBarNote];

    [self drawText:@"Action Menu" x:244 y:89 w:88 h:23 size:12 align:NSTextAlignmentLeft];
    [self drawPointer:CGPointMake(285, 86) b:CGPointMake(285, 48)];

    [self drawQuickEditNoteOffsetX:0 offsetY:-40];
    
    [self drawBoldText:@"Layer Ordering" x:20 y:348 + _deviceOffsetY w:130 h:23 size:12 align:NSTextAlignmentLeft];
    
    CGFloat toBackX = 20;
    CGFloat backX = 90;
    CGFloat fwdX = 160;
    CGFloat toFrontX = 240;
    
    [self drawText:@"To Back" x:toBackX y:370 + _deviceOffsetY w:62 h:23 size:12 align:NSTextAlignmentLeft];
    [self drawPointer:CGPointMake(toBackX+10, 390 + _deviceOffsetY) b:CGPointMake(toBackX+10, 406+_deviceOffsetY)];
    [self drawText:@"Back One" x:backX y:370 + _deviceOffsetY w:62 h:23 size:12 align:NSTextAlignmentLeft];
    [self drawPointer:CGPointMake(backX+10, 390 + _deviceOffsetY) b:CGPointMake(backX+10, 406+_deviceOffsetY)];
    [self drawText:@"Forwards" x:fwdX y:370 + _deviceOffsetY w:62 h:23 size:12 align:NSTextAlignmentLeft];
    [self drawPointer:CGPointMake(fwdX+10, 390 + _deviceOffsetY) b:CGPointMake(fwdX+10, 406+_deviceOffsetY)];
    [self drawText:@"To Front" x:toFrontX y:370 + _deviceOffsetY w:62 h:23 size:12 align:NSTextAlignmentLeft];
    [self drawPointer:CGPointMake(toFrontX+10, 390 + _deviceOffsetY) b:CGPointMake(toFrontX+10, 406+_deviceOffsetY)];
    
    [self drawStandardLabelsOffsetY:_deviceOffsetY];
}

- (void)drawEditOverlay
{
    [[UIColor whiteColor] setFill];
    
    [self drawText:@"Add Arc" x:19 y:231 + _deviceOffsetY w:48 h:42 size:12 align:NSTextAlignmentLeft];
    [self drawPointer:CGPointMake(22, 227 + _deviceOffsetY) b:CGPointMake(22, 48)];
    [self drawPointer:CGPointMake(22, 252 + _deviceOffsetY) b:CGPointMake(22, 398 + _deviceOffsetY)];
    
    [self drawQuickEditNoteOffsetX:0 offsetY:0];
    
    [self drawTitleBarNote];
    
    [self drawText:@"Action Menu" x:244 y:89 w:88 h:23 size:12 align:NSTextAlignmentLeft];
    [self drawPointer:CGPointMake(285, 86) b:CGPointMake(285, 48)];
    
    [self drawText:@"Remove Arc" x:245 y:230 + _deviceOffsetY w:88 h:23 size:12 align:NSTextAlignmentLeft];
    [self drawPointer:CGPointMake(297, 248 + _deviceOffsetY) b:CGPointMake(297, 398 + _deviceOffsetY)];
    
    [self drawBoldText:@"Finger Rotate" x:45 y:310 + _deviceOffsetY w:130 h:23 size:15 align:NSTextAlignmentLeft];
    
    [self drawText:@"A˚" x:45 y:331 + _deviceOffsetY w:23 h:23 size:12 align:NSTextAlignmentLeft];
    [self drawPointer:CGPointMake(51, 352 + _deviceOffsetY) b:CGPointMake(51, 406+_deviceOffsetY)];
    
    [self drawText:@"B˚" x:80 y:331 + _deviceOffsetY w:23 h:23 size:12 align:NSTextAlignmentLeft];
    [self drawPointer:CGPointMake(87, 352 + _deviceOffsetY) b:CGPointMake(87, 406+_deviceOffsetY)];
    
    [self drawText:@"Lock" x:122 y:331 + _deviceOffsetY w:36 h:23 size:12 align:NSTextAlignmentLeft];
    [self drawPointer:CGPointMake(125, 352 + _deviceOffsetY) b:CGPointMake(125, 406+_deviceOffsetY)];
    
    [self drawBoldText:@"Pinch" x:168 y:310 + _deviceOffsetY w:88 h:23 size:15 align:NSTextAlignmentLeft];
    
    [self drawText:@"Radius" x:168 y:331 + _deviceOffsetY w:47 h:23 size:12 align:NSTextAlignmentLeft];
    [self drawPointer:CGPointMake(173, 352 + _deviceOffsetY) b:CGPointMake(173, 406+_deviceOffsetY)];
    
    [self drawText:@"Thickness" x:181 y:348 + _deviceOffsetY w:62 h:23 size:12 align:NSTextAlignmentLeft];
    [self drawPointer:CGPointMake(208, 369 + _deviceOffsetY) b:CGPointMake(208, 406+_deviceOffsetY)];
    
    [self drawText:@"Lock" x:242 y:331 + _deviceOffsetY w:36 h:23 size:12 align:NSTextAlignmentLeft];
    [self drawPointer:CGPointMake(246, 352 + _deviceOffsetY) b:CGPointMake(246, 406+_deviceOffsetY)];
    
    [self drawStandardLabelsOffsetY:_deviceOffsetY];
    
}

- (void)drawTitleBarNote {
    [self drawText:@"Press Title for this page, Swipe Title to watch the video tour" x:88 y:58 w:145 h:70 size:12 align:NSTextAlignmentCenter];
    [self drawPointer:CGPointMake(91, 57) b:CGPointMake(91, 48)];
    [self drawPointer:CGPointMake(229, 57) b:CGPointMake(229, 48)];
}

- (void)drawQuickEditNoteOffsetX:(CGFloat)offsetx offsetY:(CGFloat)offsety {
    [self drawDashBox:CGRectMake(81 + offsetx, 160 + offsety, 149, 58) corner:6];
    [self drawText:@"Touch Hold drawing area for quick edit menu" x:93 + offsetx y:172 + offsety w:125 h:39 size:12 align:NSTextAlignmentCenter];
}

- (void)drawStandardLabelsOffsetY:(CGFloat)offsety {
    [self drawText:@"Select Arc" x:28 y:431 + offsety w:85 h:17 size:11 align:NSTextAlignmentLeft];
    [self drawText:@"Grid" x:154 y:431 + offsety w:26 h:17 size:11 align:NSTextAlignmentLeft];
    [self drawText:@"Tools Selector" x:209 y:431 + offsety w:85 h:17 size:11 align:NSTextAlignmentLeft];
    [self drawText:@"Deselect" x:109 y:467 + offsety w:85 h:17 size:11 align:NSTextAlignmentLeft];
    [self drawText:@"Edit" x:198 y:467 + offsety w:23 h:17 size:11 align:NSTextAlignmentLeft];
    [self drawText:@"Color" x:236 y:467 + offsety w:30 h:17 size:11 align:NSTextAlignmentLeft];
    [self drawText:@"Order" x:277 y:467 + offsety w:46 h:17 size:11 align:NSTextAlignmentLeft];
}

- (void)drawColorPaletteOverlay
{
    [[UIColor whiteColor] setFill];
    
    [self drawText:@"Add Arc" x:19 y:100 w:48 h:42 size:12 align:NSTextAlignmentLeft];
    [self drawPointer:CGPointMake(22, 95) b:CGPointMake(22, 48)];
    
    NSString* actionMenuNotes = @"Action Menu:\nSave PNG to\nCamera Roll,\nImport Color Palette*,\nSave ArcMachine,\nMy ArcMachines\n(+Email & Dropbox sharing)";
    CGRect actionMenuNotesFrame = CGRectMake(199, 80, 121, 124);
    CGRect actionMenuNotesRect = CGRectMake(CGRectGetMinX(actionMenuNotesFrame) + 4, CGRectGetMinY(actionMenuNotesFrame) + 4, 121, 124);
    
    [actionMenuNotes drawInRect: actionMenuNotesRect withFont: [UIFont fontWithName: @"Avenir" size: 10] lineBreakMode: NSLineBreakByWordWrapping alignment: NSTextAlignmentCenter];
    
    [self drawPointer:CGPointMake(285, 80) b:CGPointMake(285, 48)];
    
    [self drawQuickEditNoteOffsetX:-40 offsetY:0];
    
    [self drawTitleBarNote];
    
    [self drawPaletteImportToActionMenuConnectorLineOffsetY:_deviceOffsetY];

    CGRect paletteNotesFrame = CGRectMake(60, 276 + _deviceOffsetY, 185, 105);
    
    CGRect importColorRect = CGRectMake(CGRectGetMinX(paletteNotesFrame) + 1, CGRectGetMinY(paletteNotesFrame), 220, 44);
    
    NSString* importColorNotes = @"* Import Color Palette from the Action Menu, (up to 6 hex colors will be found in text from the Clipboard)";
    [importColorNotes drawInRect: importColorRect withFont: [UIFont fontWithName: @"Avenir" size: 11] lineBreakMode: NSLineBreakByWordWrapping alignment: NSTextAlignmentCenter];
    
    CGRect palettePickNotesRect = CGRectMake(CGRectGetMinX(paletteNotesFrame) + 57, CGRectGetMinY(paletteNotesFrame) + 58, 105, 48);[[UIColor whiteColor] setFill];
    
    NSString* palettePickNotes = @"Color Palette: Touch to pick a color, Long touch to edit a color";
    [palettePickNotes drawInRect: palettePickNotesRect withFont: [UIFont fontWithName: @"Avenir" size: 11] lineBreakMode: NSLineBreakByWordWrapping alignment: NSTextAlignmentCenter];
    
    [self drawPointer:CGPointMake( 166, 382 + _deviceOffsetY) b:CGPointMake(166, 398 + _deviceOffsetY)];

    [self drawPalettePickerBracketOffsetY:_deviceOffsetY];

    NSString* fillLabel = @"Fill";
    CGRect fillRect = CGRectMake(15, 347 + _deviceOffsetY, 18, 17);
    
    [fillLabel drawInRect: fillRect withFont: [UIFont fontWithName: @"Avenir" size: 12] lineBreakMode: NSLineBreakByWordWrapping alignment: NSTextAlignmentLeft];

    [self drawPointer:CGPointMake( 23, 363 + _deviceOffsetY) b:CGPointMake(23, 398 + _deviceOffsetY)];
    
    NSString* outlineLabel = @"Outline";
    CGRect outlineRect = CGRectMake(48, 347 + _deviceOffsetY, 47, 17);
    
    [outlineLabel drawInRect: outlineRect withFont: [UIFont fontWithName: @"Avenir" size: 12] lineBreakMode: NSLineBreakByWordWrapping alignment: NSTextAlignmentLeft];

    [self drawPointer:CGPointMake( 62, 363 + _deviceOffsetY) b:CGPointMake(62, 398 + _deviceOffsetY)];
    
    NSString* transparencyLabel = @"Transparency";
    CGRect transparencyRect = CGRectMake(240, 347 + _deviceOffsetY, 80, 17);

    [self drawPointer:CGPointMake( 300, 363 + _deviceOffsetY) b:CGPointMake(300, 398 + _deviceOffsetY)];
    
    [transparencyLabel drawInRect: transparencyRect withFont: [UIFont fontWithName: @"Avenir" size: 12] lineBreakMode: NSLineBreakByWordWrapping alignment: NSTextAlignmentLeft];
    
    [self drawStandardLabelsOffsetY:_deviceOffsetY];
}

- (void)removeInstructionsOverlay:(UITapGestureRecognizer*)recognizer {
    [[recognizer view] removeFromSuperview];
}

- (void) drawText:(NSString*) text x:(CGFloat) x y:(CGFloat) y  w:(CGFloat) w h:(CGFloat)h size:(CGFloat)size align:(int)alignment
{
    alignment = (alignment) ? alignment : NSTextAlignmentLeft;
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSaveGState(ctx);
    CGContextSetShadowWithColor(ctx, CGSizeMake(0, 0.5), 1,
                                [UIColor blackColor].CGColor);
    [text
     drawInRect:CGRectMake(x, y, w, h) withFont:[UIFont fontWithName:@"Avenir" size:size]
     lineBreakMode:NSLineBreakByWordWrapping alignment:alignment];
    CGContextRestoreGState(ctx);
}

- (void) drawBoldText:(NSString*) text x:(CGFloat) x y:(CGFloat) y  w:(CGFloat) w h:(CGFloat)h size:(CGFloat)size align:(int)alignment {
    alignment = (alignment) ? alignment : NSTextAlignmentLeft;
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSaveGState(ctx);
    CGContextSetShadowWithColor(ctx, CGSizeMake(0, 0.5), 1,
                                [UIColor blackColor].CGColor);
    [text
     drawInRect:CGRectMake(x, y, w, h) withFont:[UIFont fontWithName:@"Avenir-Black" size:size]
     lineBreakMode:NSLineBreakByWordWrapping alignment:alignment];
    CGContextRestoreGState(ctx);
}

- (void) drawDashBox:(CGRect)rect corner:(CGFloat)corner {
    UIBezierPath *box = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:corner];
    [[UIColor colorWithWhite:1 alpha:0.4] setStroke];
    box.lineWidth = 1;
    CGFloat pat[] = {3,3,3,3};
    [box setLineDash:pat count:4 phase:0];
    [box stroke];
}

- (void) drawPointer:(CGPoint) a b:(CGPoint) b {
    UIBezierPath *pointer = [UIBezierPath bezierPath];
    [pointer moveToPoint:a];
    [pointer addLineToPoint:b];
    [[UIColor colorWithWhite:1 alpha:0.7] setStroke];
    pointer.lineWidth = 0.5;
    [pointer stroke];
    UIBezierPath *dot = [UIBezierPath bezierPathWithArcCenter:b radius:1.5 startAngle:0 endAngle:360 clockwise:YES];
    [dot fill];
}

- (void) drawPaletteImportToActionMenuConnectorLineOffsetY:(CGFloat)offsety {
    // Dash pattern
    UIColor* white30Percent = [UIColor colorWithWhite:1 alpha: 0.5];
    CGFloat bezierPattern[] = {3, 3, 3, 3};
    
    // Curved line joining palette import notes to action menu
    UIBezierPath* bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint: CGPointMake(263.5, 197.5)];
    [bezierPath addLineToPoint: CGPointMake(263.5, 215.5)];
    [bezierPath addCurveToPoint: CGPointMake(232.5, 241.5) controlPoint1: CGPointMake(263.5, 215.5) controlPoint2: CGPointMake(259.89, 241.5)];
    [bezierPath addCurveToPoint: CGPointMake(195.5, 241.5) controlPoint1: CGPointMake(205.11, 241.5) controlPoint2: CGPointMake(195.5, 241.5)];
    [bezierPath addCurveToPoint: CGPointMake(168.5, 270.5) controlPoint1: CGPointMake(195.5, 241.5) controlPoint2: CGPointMake(168.5, 242)];
    [bezierPath addLineToPoint: CGPointMake(168.5, 275 + offsety)];
    [white30Percent setStroke];
    bezierPath.lineWidth = 1;
    [bezierPath setLineDash: bezierPattern count: 4 phase: 0];
    [bezierPath stroke];
    
}

- (void) drawPalettePickerBracketOffsetY:(CGFloat)offsetY {
    // Bracket around palette picker (must modify for iPhone 5)
    CGFloat bezierPattern[] = {3, 3, 3, 3};
    UIColor* white30Percent = [UIColor colorWithWhite:1 alpha: 0.5];
    UIBezierPath* dashBracePath = [UIBezierPath bezierPath];
    [dashBracePath moveToPoint: CGPointMake(275.5, 427.5 + offsetY)];
    [dashBracePath addLineToPoint: CGPointMake(275.5, 398.5 + offsetY)];
    [dashBracePath addCurveToPoint: CGPointMake(271.5, 394.5 + offsetY) controlPoint1: CGPointMake(275.5, 396.29 + offsetY) controlPoint2: CGPointMake(273.71, 394.5 + offsetY)];
    [dashBracePath addLineToPoint: CGPointMake(99.5, 394.5 + offsetY)];
    [dashBracePath addCurveToPoint: CGPointMake(95.5, 398.5 + offsetY) controlPoint1: CGPointMake(97.29, 394.5 + offsetY) controlPoint2: CGPointMake(95.5, 396.29 + offsetY)];
    [dashBracePath addLineToPoint: CGPointMake(95.5, 427.5 + offsetY)];
    [white30Percent setStroke];
    dashBracePath.lineWidth = 1;
    [dashBracePath setLineDash: bezierPattern count: 4 phase: 0];
    [dashBracePath stroke];
}

@end
