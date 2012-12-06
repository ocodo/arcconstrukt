//
//  ODArcConstruktViewController.m
//  ArcConstrukt
//
//  Created by jason on 28/10/12.
//  Copyright (c) 2012 ocodo. All rights reserved.
//

#import "ODArcConstruktViewController.h"
#import "ODFileTools.h"
#import "PSPDFActionSheet.h"
#import "PSPDFAlertView.h"
#import "ArcConstruktAppDelegate.h"

@interface ODArcConstruktViewController ()

@end

@implementation ODArcConstruktViewController

@synthesize arcConstruktView, gridView, layerStepper, titleView, mainToolbar, swatchBar, fillStrokeSelector, transparencyPicker, transparencyButton, colorPicker, angleSelector, pinchSelector, layerOrderSelector;

#pragma mark -
#pragma mark Initialize

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    
    [(ArcConstruktAppDelegate*)[[UIApplication sharedApplication] delegate] registerViewController:@"construktView" controller:self];
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:
                                 [UIImage imageNamed:@"arabesque-tribar@2x.png"]];
    
    [self moveToolbar:0];
    [self initApplicationClipboard];
    [self initArcConstruktView];
    [self initTitleBar];
    [self initLayerStepper];
    [self initTransparencyGestures];
    [self initSwatchBarGestures];
    [self initColorPicker];
    
    NSString *bundleVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey];
    
    NSString *appFirstStartOfVersionKey = [NSString stringWithFormat:@"first_start_%@", bundleVersion];
    
    NSNumber *alreadyStartedOnVersion = [[NSUserDefaults standardUserDefaults] objectForKey:appFirstStartOfVersionKey];
    if(!alreadyStartedOnVersion || [alreadyStartedOnVersion boolValue] == NO) {
        
        // Any additional first time use stuff goes here.
        
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:appFirstStartOfVersionKey];
    }
    
    [[NSNotificationCenter defaultCenter] addObserverForName:@"selectFileToLoad" object:nil queue:nil usingBlock:^(NSNotification *note) {
        [self loadComposition:note.object];
    }];
}

- (void)initApplicationClipboard {
    appPasteboard = [UIPasteboard pasteboardWithName:@"ArcConstruktPB" create:YES];
    [appPasteboard setPersistent:YES];
}

- (void)initArcConstruktView {
    // Add gesture recognizers to comp-view.
    UIPinchGestureRecognizer *pincher = [[UIPinchGestureRecognizer alloc]
                                         initWithTarget:self
                                         action:@selector(handleConstruktPinch:)];
    [arcConstruktView addGestureRecognizer:pincher];
    
    ODFingerRotationGestureRecognizer *rotation =[[ODFingerRotationGestureRecognizer alloc]
                                                  initWithTarget:self
                                                  action:@selector(handleConstruktRotate:)];
    
    [arcConstruktView addGestureRecognizer:rotation];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                                            action:@selector(quickEditMenu:)];
    
    [arcConstruktView addGestureRecognizer:longPress];
    
    // set rotate and pinch gesture modes.
    _rotateMode = 0;
    _pinchMode = 0;
    
}

- (void)initTitleBar {
    UITapGestureRecognizer *titleTap = [[UITapGestureRecognizer alloc]
                                        initWithTarget:self
                                        action:@selector(handleTitleTap:)];
    
    [titleView setUserInteractionEnabled:YES];
    [titleView addGestureRecognizer:titleTap];
    
    UISwipeGestureRecognizer *titleSwipe = [[UISwipeGestureRecognizer alloc]
                                            initWithTarget:self
                                            action:@selector(handleTitleSwipe:)];
    
    titleSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
    
    [titleView setUserInteractionEnabled:YES];
    [titleView addGestureRecognizer:titleSwipe];
}

- (void)initLayerStepper {
    
    // style stepper button images.
    // If use again, throw into a subclass of UIStepper / init
    [layerStepper
     setIncrementImage:[UIImage imageNamed:@"up.png"]
     forState:UIControlStateNormal];
    [layerStepper
     setDecrementImage:[UIImage imageNamed:@"down.png"]
     forState:UIControlStateNormal];
    [layerStepper
     setIncrementImage:[UIImage imageNamed:@"up.png"]
     forState:UIControlStateDisabled];
    [layerStepper
     setDecrementImage:[UIImage imageNamed:@"down.png"]
     forState:UIControlStateDisabled];
    [layerStepper
     setIncrementImage:[UIImage imageNamed:@"up.png"]
     forState:UIControlStateHighlighted];
    [layerStepper
     setDecrementImage:[UIImage imageNamed:@"down.png"]
     forState:UIControlStateHighlighted];
    [layerStepper
     setIncrementImage:[UIImage imageNamed:@"up.png"]
     forState:UIControlStateSelected];
    [layerStepper
     setDecrementImage:[UIImage imageNamed:@"down.png"]
     forState:UIControlStateSelected];
}

- (void)initTransparencyGestures {
    
    // setup transparency picker.
    UIPanGestureRecognizer * panGesture = [[UIPanGestureRecognizer alloc]
                                           initWithTarget:self
                                           action:@selector(handlePanTransparencyIndicator:)];
    [transparencyPicker addGestureRecognizer:panGesture];
    
    // setup transparency toggle button.
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc]
                                          initWithTarget:self
                                          action:@selector(transparencySelectorToggle:)];
    
    [transparencyButton addGestureRecognizer:tapGesture];
}

- (void)initColorPicker {
    UISwipeGestureRecognizer * swipeColorPicker =
    [[UISwipeGestureRecognizer alloc]
     initWithTarget:self
     action:@selector(handleColorPickerSwipe:)];
    [colorPicker addGestureRecognizer:swipeColorPicker];
    
    [colorPicker setDelegate:self];
    
}

- (void)initSwatchBarGestures {
    UITapGestureRecognizer *colorSwatchTap =
    [[UITapGestureRecognizer alloc]
     initWithTarget:self
     action:@selector(handleColorSwatchTap:)];
    
    UIGestureRecognizer *colorSwatchLongPress =
    [[UILongPressGestureRecognizer alloc]
     initWithTarget:self
     action:@selector(handleColorSwatchLongPress:)];
    
    [swatchBar addGestureRecognizer:colorSwatchTap];
    [swatchBar addGestureRecognizer:colorSwatchLongPress];
}

- (void)handleColorSwatchTap:(UITapGestureRecognizer *)recognizer {
    CGPoint a = [recognizer locationInView:recognizer.view];
    int index = [swatchBar colorIndexAtPoint:a];
    [ODColorPalette sharedinstance].selectedIndex = index;
    switch (fillStrokeSelector.selectedSegmentIndex) {
        case 0:
            [TestFlight passCheckpoint:@"Set fill color"];
            
            [self setCurrentFillFromPaletteColor:index];
            break;
            
        case 1:
            [TestFlight passCheckpoint:@"Set stroke color "];
            
            [self setCurrentStrokeFromPaletteColor:index];
            break;
            
        default:
            break;
    }
}

- (void)handleColorSwatchLongPress:(UILongPressGestureRecognizer *)recognizer {
    if(recognizer.state == UIGestureRecognizerStateBegan) {
        if(colorPicker.frame.origin.x != 0) {
            [TestFlight passCheckpoint:@"Viewing Colour Picker"];
            
            [self moveColorPicker:0];
        }
        else {
            [TestFlight passCheckpoint:@"Color Picker closed with Palette long-press"];
            
            [self moveColorPicker:640];
        }
    }
}

- (void)handleColorPickerSwipe:(UISwipeGestureRecognizer *)recognizer {
    [TestFlight passCheckpoint:@"Color Picker closed with swipe"];
    
    [self moveColorPicker:640];
}

- (void)handleConstruktPinch:(UIPinchGestureRecognizer *)pincher {
    switch (_pinchMode) {
        case 0:
            [self pinchRadius:pincher];
            break;
            
        case 1:
            [self pinchThickness:pincher];
            break;
            
        default:
            break;
    }
}

#pragma mark -
#pragma mark Help Messages, Overlays and Navigate to Video tour

- (void)toggleHelpOverlay:(int)mode {
    BOOL showingInstructions = false;
    ODInstructionsOverlay *instructions;
    for (id v in [self view].subviews) {
        if ([v isKindOfClass:[ODInstructionsOverlay class]]) {
            instructions = (ODInstructionsOverlay*)v;
            showingInstructions = true;
        }
    }
    if(!showingInstructions) {
        ODInstructionsOverlay *instructions = [[ODInstructionsOverlay alloc] initWithFrame:CGRectMake(0, 0, 320, 640)];
        instructions.mode = _toolbarMode;
        [[self view] addSubview:instructions];
    } else {
        [instructions removeFromSuperview];
    }
}

- (void)handleTitleTap:(UITapGestureRecognizer *) recognizer {
    [TestFlight passCheckpoint:@"Viewed help overlay manually"];
    
    [self toggleHelpOverlay:_toolbarMode];
}

- (void)handleTitleSwipe:(UISwipeGestureRecognizer *) recognizer {
    [TestFlight passCheckpoint:@"Visited help page"];
    
    [self performSegueWithIdentifier:@"aboutPageSegue" sender:self];
}

- (void) showInstructionsOnceForToolbarMode:(int)mode {
    NSString *bundleVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey];
    NSString *seenToolModeInstructionsKey = [NSString stringWithFormat:@"seen_toolmode_%i_instructions_%@", mode, bundleVersion];
    NSNumber *seenModeInstruction = [[NSUserDefaults standardUserDefaults] objectForKey:seenToolModeInstructionsKey];
    if(!seenModeInstruction || [seenModeInstruction boolValue] == NO) {
        [self toggleHelpOverlay:mode];
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:seenToolModeInstructionsKey];
    }
}

- (void)showNoArcsMessage {
    [[TKAlertCenter defaultCenter] postAlertWithMessage:NSLocalizedString(@"Press + to add Arcs", nil) image:[UIImage imageNamed:@"lightBulb@2x.png"]];
}

#pragma mark -
#pragma mark Quick Edit menu

- (void)quickEditMenu:(UILongPressGestureRecognizer *)recognizer {
    [recognizer.view becomeFirstResponder];
    UIMenuController* mc = [UIMenuController sharedMenuController];
    UIMenuItem* menu_angle_a = [[UIMenuItem alloc] initWithTitle:NSLocalizedString(@"A˚", nil) action:@selector(angleAMode:)];
    UIMenuItem* menu_angle_b = [[UIMenuItem alloc] initWithTitle:NSLocalizedString(@"B˚", nil) action:@selector(angleBMode:)];
    UIMenuItem* menu_radius = [[UIMenuItem alloc] initWithTitle:NSLocalizedString(@"r", nil) action:@selector(radiusMode:)];
    UIMenuItem* menu_thickness = [[UIMenuItem alloc] initWithTitle:NSLocalizedString(@"T", nil) action:@selector(thicknessMode:)];
    UIMenuItem* menu_copy = [[UIMenuItem alloc] initWithTitle:NSLocalizedString(@"Clone", nil) action:@selector(cloneArc:)];
    UIMenuItem* menu_paste = [[UIMenuItem alloc] initWithTitle:NSLocalizedString(@"Paste", nil) action:@selector(pasteArc:)];
    UIMenuItem* menu_delete = [[UIMenuItem alloc] initWithTitle:NSLocalizedString(@"Delete", nil) action:@selector(deleteButton:)];
    UIMenuItem* menu_clear = [[UIMenuItem alloc] initWithTitle:NSLocalizedString(@"Clear All", nil) action:@selector(clearButton:)];
    [[UIMenuController sharedMenuController] setMenuItems:@[menu_angle_a, menu_angle_b, menu_radius, menu_thickness, menu_copy, menu_paste, menu_delete, menu_clear]];
    CGPoint position = [recognizer locationInView:recognizer.view.superview];
    CGRect box = CGRectMake(position.x, position.y, 10, 10);
    [mc setTargetRect: box inView: recognizer.view.superview];
    [mc setMenuVisible: YES animated: YES];
}

- (BOOL)canPerformAction: (SEL)action withSender: (id)sender {
    return action == @selector(cloneArc: )
    || action == @selector(pasteArc: )
    || action == @selector(deleteButton: )
    || action == @selector(clearButton: )
    || action == @selector(angleAMode: )
    || action == @selector(angleBMode: )
    || action == @selector(radiusMode: )
    || action == @selector(thicknessMode: );
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}


- (void)cloneArc:(id)sender {
    NSDictionary *plist = [[ODApplicationState sharedinstance]
                           .currentArc geometryToDictionary];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject: plist];
    [appPasteboard setData:data forPasteboardType:@"info.ocodo.arcconstrukt"];
    [arcConstruktView addSubview:[[ODArcMachine alloc]
                                  initWithArcMachine:[ODApplicationState sharedinstance].currentArc
                                  frame:CGRectMake(0, 0, 320, 320)]];
    [self syncLayerStepper];
    [TestFlight passCheckpoint:@"Cloned arc"];
}

- (void)pasteArc:(id)sender {
    NSData *data = [appPasteboard dataForPasteboardType:@"info.ocodo.arcconstrukt"];
    NSDictionary *plist = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    ODArcMachine *a = [[ODArcMachine alloc] initWithFrame:CGRectMake(0, 0, 320, 320)];
    [a dictionaryToGeometry: plist];
    [arcConstruktView addSubview:a];
    [self syncLayerStepper];
    [TestFlight passCheckpoint:@"Pasted arc"];
}

#pragma mark -
#pragma mark Drawing control gesture handlers

- (void)handleConstruktRotate:(ODFingerRotationGestureRecognizer *)rotator {
    switch (_rotateMode) {
        case 0:
            [self startAngleTouch:rotator];
            break;
        case 1:
            [self endAngleTouch:rotator];
            break;
        case 2:
            [self lockedAngleTouch:rotator];
            break;
        default:
            break;
    }
}

- (void)angleAMode: (id)sender {
    [angleSelector setSelectedSegmentIndex:0];
    _rotateMode = 0;
    [TestFlight passCheckpoint:@"Set angle A rotate mode from quick edit menu"];
}

- (void)angleBMode: (id)sender {
    [angleSelector setSelectedSegmentIndex:1];
    _rotateMode = 1;
    [TestFlight passCheckpoint:@"Set angle B rotate mode from quick edit menu"];
}

- (IBAction)changeRotateMode:(UISegmentedControl *)sender {
    _rotateMode = sender.selectedSegmentIndex;
    [TestFlight passCheckpoint:[NSString stringWithFormat:@"Rotate mode :%i" , _rotateMode]];
}

- (void)radiusMode: (id)sender {
    [pinchSelector setSelectedSegmentIndex:0];
    _pinchMode = 0;
    [TestFlight passCheckpoint:@"Set radius pinch mode from quick edit menu"];
}

- (void)thicknessMode: (id)sender {
    [pinchSelector setSelectedSegmentIndex:1];
    _pinchMode = 1;
    [TestFlight passCheckpoint:@"Set thickness pinch mode from quick edit menu"];
}

- (IBAction)changePinchMode:(UISegmentedControl *)sender {
    _pinchMode = sender.selectedSegmentIndex;
    [TestFlight passCheckpoint:[NSString stringWithFormat:@"Pinch mode :%i" , _pinchMode]];
}

- (void)pinchRadius:(UIPinchGestureRecognizer *)pincher {
    if([ODApplicationState sharedinstance].currentArc) {
        float radius = clampf([ODApplicationState sharedinstance].currentArc.radius + pincher.scale-1, 0.0f, 160.0f);
        [ODApplicationState sharedinstance].currentArc.radius = radius;
        [[ODApplicationState sharedinstance].currentArc setNeedsDisplay];
        [ODApplicationState sharedinstance].dirty = YES;
    }
}

- (void)pinchThickness:(UIPinchGestureRecognizer *)pincher {
    if([ODApplicationState sharedinstance].currentArc) {
        float thick = clampf([ODApplicationState sharedinstance].currentArc.thickness + pincher.scale-1, 1.0f, 160.0f);
        [ODApplicationState sharedinstance].currentArc.thickness = thick;
        [[ODApplicationState sharedinstance].currentArc setNeedsDisplay];
        [ODApplicationState sharedinstance].dirty = YES;
    }
}

- (void)startAngleTouch:(ODFingerRotationGestureRecognizer *)rotator {
    if([ODApplicationState sharedinstance].currentArc) {
        [ODApplicationState sharedinstance].currentArc.start += rotator.rotation;
        [[ODApplicationState sharedinstance].currentArc setNeedsDisplay];
        [ODApplicationState sharedinstance].dirty = YES;
    }
}

- (void)endAngleTouch:(ODFingerRotationGestureRecognizer *)rotator {
    if([ODApplicationState sharedinstance].currentArc){
        [ODApplicationState sharedinstance].currentArc.end += rotator.rotation;
        [[ODApplicationState sharedinstance].currentArc setNeedsDisplay];
        [ODApplicationState sharedinstance].dirty = YES;
    }
}

- (void)lockedAngleTouch:(ODFingerRotationGestureRecognizer *)rotator {
    if([ODApplicationState sharedinstance].currentArc) {
        [ODApplicationState sharedinstance].currentArc.start += rotator.rotation;
        [ODApplicationState sharedinstance].currentArc.end += rotator.rotation;
        [[ODApplicationState sharedinstance].currentArc setNeedsDisplay];
        [ODApplicationState sharedinstance].dirty = YES;
    }
}

#pragma mark -
#pragma mark Color picker and palette

- (void)moveColorPicker:(int)move_to_x {
    [UIView animateWithDuration:0.5
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         colorPicker.frame = CGRectMake(move_to_x,
                                                        colorPicker.frame.origin.y,
                                                        colorPicker.frame.size.width,
                                                        colorPicker.frame.size.height);
                     }
                     completion:nil];
}

- (UIColor*)useCurrentFillColor {
    if([ODApplicationState sharedinstance].currentArc.savedFill) {
        return [ODApplicationState sharedinstance].currentArc.savedFill;
    } else {
        return [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    }
}

- (UIColor*)useCurrentStrokeColor {
    if([ODApplicationState sharedinstance].currentArc.savedStroke) {
        return [ODApplicationState sharedinstance].currentArc.savedStroke;
    } else {
        return [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
    }
}

- (void)NPColorPickerView:(ODColorPickerView *)view didSelectColor:(UIColor *)color {
    
    int i = [ODColorPalette sharedinstance].selectedIndex;
    [ODColorPalette sharedinstance].colors[i] = color;
    [swatchBar setNeedsDisplay];
    
    switch (fillStrokeSelector.selectedSegmentIndex) {
        case 0:
            
            [self setCurrentFillFromPaletteColor:i];
            break;
            
        case 1:
          
            [self setCurrentStrokeFromPaletteColor:i];
            break;
            
        default:
            break;
    }
}

- (void)setCurrentStrokeFromPaletteColor:(int)index {
    UIColor *color = [[ODColorPalette sharedinstance].colors objectAtIndex:index];
    [self setCurrentStrokeFromUIColor:color];
}

- (void)setCurrentFillFromPaletteColor:(int)index {
    UIColor *color = [[ODColorPalette sharedinstance].colors objectAtIndex:index];
    [self setCurrentFillFromUIColor:color];
}

- (void)setCurrentStrokeFromUIColor:(UIColor*)color {
    colorPicker.color = color;
    [ODApplicationState sharedinstance].currentArc.stroke = color;
    [ODApplicationState sharedinstance].currentArc.savedStroke = color;
    [ODApplicationState sharedinstance].dirty = YES;
    [[ODApplicationState sharedinstance].currentArc setNeedsDisplay];
}

- (void)setCurrentFillFromUIColor:(UIColor*)color {
    colorPicker.color = color;
    [ODApplicationState sharedinstance].currentArc.fill = color;
    [ODApplicationState sharedinstance].currentArc.savedFill = color;
    [ODApplicationState sharedinstance].dirty = YES;
    [[ODApplicationState sharedinstance].currentArc setNeedsDisplay];
}

#pragma mark -
#pragma mark Color export/import

- (void)exportColorPalette:(id)sender {
    NSMutableArray * hexColors = [[NSMutableArray alloc] initWithArray:@[@"ArcConstrukt Color Palette:"]];
    for (UIColor *color in [[ODColorPalette sharedinstance] colors]) {
        [hexColors addObject:[color RGBHexString]];
    }
    [[UIPasteboard generalPasteboard] setString:[hexColors componentsJoinedByString:@"\n"]];
    [[TKAlertCenter defaultCenter] postAlertWithMessage:NSLocalizedString(@"Color Palette exported to the Clipboard", nil)];
    [TestFlight passCheckpoint:@"Exported Color Palette"];
}

- (IBAction)importColorsFromPasteboard:(id)sender {
    NSString *import = [[UIPasteboard generalPasteboard] string];
    
    if(import.length < 1){
        [[TKAlertCenter defaultCenter] postAlertWithMessage:NSLocalizedString(@"Copy some Hex colors into the clipboard, ArcConstrukt will find and use the first 6", nil)];
        return;
    }
    
    NSError *error = NULL;
    
    NSRegularExpression *hexColor = [NSRegularExpression
                                     regularExpressionWithPattern:@"#?(([a-f]|[A-F]|[0-9]){6})" options:0 error:&error];
    __block int i=0;
    [hexColor enumerateMatchesInString:import options:0 range:NSMakeRange(0, [import length])
                            usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop)
     {
         NSString *hex = [[import substringWithRange:result.range] stringByReplacingOccurrencesOfString:@"#" withString:@""];
         if (i<6) {
             [ODColorPalette sharedinstance].colors[i] =
             [UIColor colorWithRGBHexString:hex];
             [swatchBar setNeedsDisplay];
         }
         i++;
     }];
    
    if(i>0) {
        [[TKAlertCenter defaultCenter] postAlertWithMessage:[NSString stringWithFormat:NSLocalizedString(@"Imported %i colors from the Clipboard", nil), i]];
        [TestFlight passCheckpoint:@"Imported Color Palette (success)"];
        
    } else {
        [[TKAlertCenter defaultCenter] postAlertWithMessage:NSLocalizedString(@"Copy some Hex colors into the clipboard, ArcConstrukt will find and use the first 6", nil)];
        [TestFlight passCheckpoint:@"Imported Color Palette (no colors)"];
    }
}

#pragma mark -
#pragma mark Transparency

- (IBAction)transparencySelectorToggle:(id)sender {
    int pos = transparencyPicker.frame.origin.x;
    int move_to_x = (pos != 10) ? 10 : -310;
    [UIView animateWithDuration:0.5
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.transparencyPicker.frame = CGRectMake(move_to_x,
                                                                    transparencyPicker.frame.origin.y,
                                                                    transparencyPicker.frame.size.width,
                                                                    transparencyPicker.frame.size.height);
                     }
                     completion:^(BOOL finished) {
                         [TestFlight passCheckpoint:@"Toggle Transparency Picker"];
                     }];
}

- (void)handlePanTransparencyIndicator:(UIPanGestureRecognizer *)recognizer {
    [transparencyPicker setPickerPoint:[recognizer locationInView:transparencyPicker]];
    [transparencyPicker setNeedsDisplay];
    if([ODApplicationState sharedinstance].currentArc == NULL) {
        return;
    }
    const CGFloat *f = CGColorGetComponents([ODApplicationState sharedinstance].currentArc.savedFill.CGColor);
    const CGFloat *s = CGColorGetComponents([ODApplicationState sharedinstance].currentArc.savedStroke.CGColor);
    switch (fillStrokeSelector.selectedSegmentIndex) {
        case 0:
            [self setCurrentFillFromUIColor: [UIColor
                                              colorWithRed:f[0]
                                              green:f[1]
                                              blue:f[2]
                                              alpha:[transparencyPicker transparency]]];
            break;
        case 1:
            [self setCurrentStrokeFromUIColor: [UIColor
                                                colorWithRed:s[0]
                                                green:s[1]
                                                blue:s[2]
                                                alpha:[transparencyPicker transparency]]];
            break;
        default:
            break;
    }
}

#pragma mark -
#pragma mark Add arc layer

- (void)addRandomArcLayer{
    [arcConstruktView addSubview:[[ODArcMachine alloc]
                                  initRandomWithFrame:CGRectMake(0, 0, 320, 320)
                                  fillColor:[self useCurrentFillColor]
                                  strokeColor:[self useCurrentStrokeColor]]];
}

- (IBAction)addButton:(id)sender {
    int max_layer = [arcConstruktView subviews].count;
    if(max_layer < kMaximumLayers) {
        [TestFlight passCheckpoint:@"Added arc layer"];
        [self addRandomArcLayer];
        [self syncLayerStepper];
        [ODApplicationState sharedinstance].dirty = YES;
    } else {
        [TestFlight passCheckpoint:@"Added maximum layers"];
        [[TKAlertCenter defaultCenter]
         postAlertWithMessage:
         [NSString
          stringWithFormat:@"MAXIMUM: %d LAYERS", max_layer]];
    }
}

#pragma mark -
#pragma mark Delete and Clear

- (IBAction)deleteButton:(id)sender {
    
    void (^deleteBlock)(void);
    deleteBlock = ^{
        int index;
        if([ODApplicationState sharedinstance].currentArc) {
            index = [ODApplicationState sharedinstance].currentArc.getSubviewIndex;
            [[ODApplicationState sharedinstance].currentArc removeFromSuperview];
            [TestFlight passCheckpoint:@"Deleted Selected Arc"];
        }
        [layerStepper setMaximumValue:[arcConstruktView subviews].count - 1];
        [layerStepper setValue:MIN(index,[arcConstruktView subviews].count - 1)];
        [self layerSelecting:layerStepper];
        [ODApplicationState sharedinstance].dirty = [arcConstruktView.subviews count] > 0;
    };
    
    if([arcConstruktView subviews].count > 0) {
        NSString* title = NSLocalizedString(@"Warning", nil);
        NSString* message = NSLocalizedString(@"Are you sure?", nil);
        NSString* cancel = NSLocalizedString(@"Cancel", nil);
        NSString* ok = NSLocalizedString(@"Delete", nil);
        
        PSPDFAlertView *confirmDelete = [[PSPDFAlertView alloc] initWithTitle:title];
        [confirmDelete setMessage:message];
        [confirmDelete addButtonWithTitle:ok block:deleteBlock];
        [confirmDelete setCancelButtonWithTitle:cancel block:nil];
        [confirmDelete show];
    } else {
        [self showNoArcsMessage];
    }
}

- (void)clearComposition {
    for(ODArcMachine *arc in arcConstruktView.subviews)
    {
        [arc removeFromSuperview];
    }
    [layerStepper setMaximumValue:[arcConstruktView subviews].count - 1];
    [layerStepper setValue:0];
    [TestFlight passCheckpoint:@"Cleared all arcs"];
    [ODApplicationState sharedinstance].dirty = NO;
}

- (IBAction)clearButton:(id)sender {
    
    void (^clearBlock)(void);
    clearBlock = ^{
        [self clearComposition];
    };
    
    if([arcConstruktView subviews].count > 0)  {
        NSString* title = NSLocalizedString(@"Warning", nil);
        NSString* message = NSLocalizedString(@"Are you sure?", nil);
        NSString* cancel = NSLocalizedString(@"Cancel", nil);
        NSString* ok = NSLocalizedString(@"Clear All", nil);
        
        PSPDFAlertView *confirmClearAll = [[PSPDFAlertView alloc] initWithTitle:title];
        [confirmClearAll setMessage:message];
        [confirmClearAll addButtonWithTitle:ok block:clearBlock];
        [confirmClearAll setCancelButtonWithTitle:cancel block:nil];
        [confirmClearAll show];
    } else {
        [self showNoArcsMessage];
    }
}

#pragma mark -
#pragma mark Arc select/deselect & highlight

- (IBAction)deselectCurrentArc:(UIBarButtonItem *)sender {
    // [self deselect];
    [[ODApplicationState sharedinstance].currentArc toggleHighlight];
    [TestFlight passCheckpoint:@"Manually Deselected arc"];
}

- (void)deselect {
    [[ODApplicationState sharedinstance].currentArc deselectArc];
}

- (void)resetStepper {
    [layerStepper setMaximumValue:[arcConstruktView subviews].count - 1];
    [layerStepper setValue:0];
    [self layerSelecting:layerStepper];
}

- (void)layerSelecting:(UIStepper *)sender {
    if ([ODApplicationState sharedinstance].currentArc) {
        [[ODApplicationState sharedinstance].currentArc deselectArc];
    }
    if ([arcConstruktView subviews].count > 0) {
        [ODApplicationState sharedinstance].currentArc = [[arcConstruktView subviews] objectAtIndex:sender.value];
        [[ODApplicationState sharedinstance].currentArc selectArc];
    }
}

- (void)syncLayerStepper {
    int max_layer = [arcConstruktView subviews].count -1;
    [layerStepper setMaximumValue:max_layer];
    [layerStepper setValue:max_layer];
    [self layerSelecting:layerStepper];
}

- (IBAction)layerStep:(UIStepper *)sender {
    [self layerSelecting:sender];
}

#pragma mark -
#pragma mark Grid

- (IBAction)gridModeStep:(id)sender {
    [gridView incrementGridMode];
}

#pragma mark -
#pragma mark Action Menu

- (IBAction)actionMenu:(id)sender {
    PSPDFActionSheet *actionSheet = [[PSPDFActionSheet alloc] initWithTitle:NSLocalizedString(@"Choose an Action", nil)];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [actionSheet setDestructiveButtonWithTitle:NSLocalizedString(@"Save PNG to Camera Roll", nil) block:^{
        [self deselect];
        [self savePNGMenu:self];
        [TestFlight passCheckpoint:@"Save PNG to Camera Roll"];
    }];
    [actionSheet addButtonWithTitle:NSLocalizedString(@"Import Colors", nil) block:^{
        [self importColorsFromPasteboard:self];
    }];
    [actionSheet addButtonWithTitle:NSLocalizedString(@"Export Colors", nil) block:^{
        [self exportColorPalette:self];
    }];
    [actionSheet addButtonWithTitle:NSLocalizedString(@"Save ArcMachine", nil) block:^{
        [self saveComposition:self];
    }];
    [actionSheet addButtonWithTitle:NSLocalizedString(@"My ArcMachines", nil) block:^{
        [self performSegueWithIdentifier:@"filesViewSegue" sender:self];
    }];
    [actionSheet setCancelButtonWithTitle:NSLocalizedString(@"Cancel", nil) block:nil];
    [actionSheet showInView:[self view]];
}

- (IBAction)savePNGMenu:(id)sender {
    
    if (arcConstruktView.subviews.count < 1) {
        [self showNoArcsMessage];
        return;
    }
    
    PSPDFActionSheet *actionSheet = [[PSPDFActionSheet alloc] initWithTitle:NSLocalizedString(@"Save to Camera Roll\nImage Quality", nil)];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [actionSheet addButtonWithTitle:NSLocalizedString(@"PNG 640x640", nil) block:^{
        [TestFlight passCheckpoint:@"Saved PNG 640x"];
        [self savePNGImagetoPhotoAlbum:self scale:2];
    }];
    [actionSheet addButtonWithTitle:NSLocalizedString(@"PNG 1280x1280", nil) block:^{
        [TestFlight passCheckpoint:@"Saved PNG 1280x"];
        [self savePNGImagetoPhotoAlbum:self scale:4];
    }];
    [actionSheet addButtonWithTitle:NSLocalizedString(@"PNG 1920x1920", nil) block:^{
        [TestFlight passCheckpoint:@"Saved PNG 1920x"];
        [self savePNGImagetoPhotoAlbum:self scale:6];
    }];
    [actionSheet addButtonWithTitle:NSLocalizedString(@"PNG 2560x2560", nil) block:^{
        [TestFlight passCheckpoint:@"Saved PNG 2560x"];
        [self savePNGImagetoPhotoAlbum:self scale:8];
    }];
    [actionSheet addButtonWithTitle:NSLocalizedString(@"PNG 2880x2880", nil) block:^{
        [TestFlight passCheckpoint:@"Saved PNG 2800x"];
        [self savePNGImagetoPhotoAlbum:self scale:9];
    }];
    [actionSheet addButtonWithTitle:NSLocalizedString(@"PNG 3200x3200", nil) block:^{
        [TestFlight passCheckpoint:@"Saved PNG 3200x"];
        [self savePNGImagetoPhotoAlbum:self scale:10];
    }];
    [actionSheet setCancelButtonWithTitle:NSLocalizedString(@"Cancel", nil) block:nil];
    [actionSheet showInView:[self view]];
    
}

- (IBAction)savePNGImagetoPhotoAlbum:(id)sender scale:(NSInteger)s{
    if([[arcConstruktView subviews] count] < 1) {
        [self showNoArcsMessage];
        [TestFlight passCheckpoint:@"No Arcs for Save to PNG"];
        return;
    }
    // show progress HUD
    DZProgressController *HUD = [DZProgressController new];
    HUD.label.text = NSLocalizedString(@"Save PNG to Camera Roll", nil);
    [HUD showWhileExecuting:^{
        UIGraphicsBeginImageContextWithOptions(arcConstruktView.bounds.size, NO, s);
        [arcConstruktView.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage* pngImage = [UIImage
                             imageWithData:
                             UIImagePNGRepresentation(UIGraphicsGetImageFromCurrentImageContext())];
        UIGraphicsEndImageContext();
        UIImageWriteToSavedPhotosAlbum(pngImage, self,  @selector(image:didFinishSavingWithError:contextInfo:), NULL);
        return;
    }];
    
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void*)contextInfo {
    if (error) {
        [[TKAlertCenter defaultCenter] postAlertWithMessage:NSLocalizedString(@"There was a problem saving your image, check photo album privacy settings, and make sure you have enough free memory.", nil)];
        [TestFlight passCheckpoint:@"Problem Saving PNG"];
        
    } else {
        // saved ok.
        [[TKAlertCenter defaultCenter] postAlertWithMessage:NSLocalizedString(@"Saved PNG", nil)];
        [TestFlight passCheckpoint:@"Saved PNG Success"];
    }
}

#pragma mark -
#pragma mark Order Layers

- (IBAction)arrangeLayer:(UISegmentedControl *)sender {
    ODArcMachine *arc = [ODApplicationState sharedinstance].currentArc;
    switch (sender.selectedSegmentIndex) {
        case 0:
            [TestFlight passCheckpoint:@"Arc send to back"];
            [arc sendToBack];
            [ODApplicationState sharedinstance].dirty = YES;
            break;
        case 1:
            [TestFlight passCheckpoint:@"Arc back one"];
            [arc sendOneLevelDown];
            [ODApplicationState sharedinstance].dirty = YES;
            break;
        case 2:
            [TestFlight passCheckpoint:@"Arc forward one"];
            [arc bringOneLevelUp];
            [ODApplicationState sharedinstance].dirty = YES;
            break;
        case 3:
            [TestFlight passCheckpoint:@"Arc bring to front"];
            [arc bringToFront];
            [ODApplicationState sharedinstance].dirty = YES;
            break;
        default:
            break;
    }
}

#pragma mark -
#pragma Toolbar

- (void)moveToolbar:(int)mode {
    _toolbarMode = mode;
    int x = mode * -320;
    [UIView animateWithDuration:0.5
                          delay:0
                        options: UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         if(x != -320) {
                             transparencyPicker.frame = CGRectMake(-310,
                                                                   transparencyPicker.frame.origin.y,
                                                                   transparencyPicker.frame.size.width,
                                                                   transparencyPicker.frame.size.height);
                             colorPicker.frame = CGRectMake(640,
                                                            colorPicker.frame.origin.y,
                                                            colorPicker.frame.size.width,
                                                            colorPicker.frame.size.height);
                         }
                         mainToolbar.frame = CGRectMake(x,
                                                        mainToolbar.frame.origin.y,
                                                        mainToolbar.frame.size.width,
                                                        mainToolbar.frame.size.height);
                     }completion:^(BOOL finished) {
                         _toolbarMode = mode;
                         [self showInstructionsOnceForToolbarMode:mode];
                         [TestFlight passCheckpoint:[NSString stringWithFormat:@"Toolbar mode %i selected", mode]];
                     }
     ];
}

- (IBAction)toolbarModeSelector:(UISegmentedControl*)sender {
    [self moveToolbar:sender.selectedSegmentIndex];
}

#pragma mark -
#pragma mark Save / Load

- (void)saveComposition:(id)sender {
    
    if([[arcConstruktView subviews] count] < 1) {
        [self showNoArcsMessage];
        [TestFlight passCheckpoint:@"No Arcs for Save composition"];
        return;
    }
    
    DZProgressController *HUD = [DZProgressController new];
    HUD.label.text = NSLocalizedString(@"Saving ArcMachine", nil);
    [HUD showWhileExecuting:^{
        ODArcConstruktDocument *file = [[ODArcConstruktDocument alloc] initWithArcMachineSubviews:arcConstruktView.subviews];
        
        UIGraphicsBeginImageContextWithOptions(arcConstruktView.bounds.size, NO, 0.5);
        [arcConstruktView.layer renderInContext:UIGraphicsGetCurrentContext()];
        
        file.thumbnail = [UIImage imageWithData:
                          UIImagePNGRepresentation(UIGraphicsGetImageFromCurrentImageContext())];
        
        int ti = [[NSDate date] timeIntervalSince1970];
        file.filename = [NSString stringWithFormat:@"ArcConstrukt-%X.arcmachine", ti];
        [ODFileTools save:file.filename documentsFolder:@"arcmachines" data:[NSKeyedArchiver archivedDataWithRootObject: file]];
        
        [ODApplicationState sharedinstance].dirty = NO;
        
        [ODFileTools save:file.filename extension:@"svg" documentsFolder:@"svg" data:[file asSVGEncoded]];
        [ODFileTools save:file.filename documentsFolder:@"json" data:[file asJSONEncoded]];
        [TestFlight passCheckpoint:@"Saved composition .arcmachine and SVG"];
    }];
}

- (void)importComposition:(NSString*)filename withFolder:(NSString *)folder {
    ODArcConstruktDocument *file = [ODFileTools loadArchive:filename documentsFolder:folder];
    [ODFileTools save:filename documentsFolder:@"arcmachines" data:[NSKeyedArchiver archivedDataWithRootObject:file]];
    [ODFileTools save:file.filename extension:@"svg" documentsFolder:@"svg" data:[file asSVGEncoded]];
    [TestFlight passCheckpoint:@"Import composition"];
}

- (void)loadJSONComposition:(NSString*)filename withFolder:(NSString*)folder {
    @try {
        [self clearComposition];
        ODArcConstruktDocument *file = [[ODArcConstruktDocument alloc] initWithJSONData:[ODFileTools loadNSData:filename documentsFolder:folder]];
        file.filename = filename;
        
        for (ODArcMachine *arc in [file layersToArcMachines]) {
            [arcConstruktView addSubview:arc];
        }
        [self resetStepper];
        [self deselect];
        [[TKAlertCenter defaultCenter] postAlertWithMessage:[NSString stringWithFormat:@"%@ : %@", NSLocalizedString(@"Loaded",nil), filename]];
        [TestFlight passCheckpoint:@"Loaded composition"];
    }
    @catch (NSException *exception) {
        [[TKAlertCenter defaultCenter] postAlertWithMessage:[NSString stringWithFormat:NSLocalizedString(@"Failed to load %@", nil), filename]];
        [TestFlight passCheckpoint:@"Composition load failed"];
    }
    [arcConstruktView setNeedsDisplay];
}

- (void)loadComposition:(NSString*) filename withFolder:(NSString *)folder {
    
    void (^loadBlock)(void);
    loadBlock = ^(void){
        @try {
            [self clearComposition];
            id loaded = [ODFileTools loadArchive:filename documentsFolder:folder];
            
            ODArcConstruktFile *oldfile;
            ODArcConstruktDocument *file;
            
            // Backwards compatibility hack
            if( [loaded isKindOfClass:[ODArcConstruktFile class]] ) {
                oldfile = (ODArcConstruktFile*)loaded;
                for (ODArcMachine *arc in [oldfile layersToArcMachines]) {
                    [arcConstruktView addSubview:arc];
                }
            } else {
                file = (ODArcConstruktDocument*)loaded;
                for (ODArcMachine *arc in [file layersToArcMachines]) {
                    [arcConstruktView addSubview:arc];
                }
            }
            
            [self resetStepper];
            [self deselect];
            [TestFlight passCheckpoint:@"Loaded composition"];
            [[TKAlertCenter defaultCenter] postAlertWithMessage:[NSString stringWithFormat:@"%@ : %@", NSLocalizedString(@"Loaded",nil), filename]];
        }
        @catch (NSException *exception) {
            @try {
                [self loadJSONComposition:filename withFolder:folder];
            }
            @catch (NSException *exception) {
            }
        }
        [arcConstruktView setNeedsDisplay];
    };
    
    if(arcConstruktView.subviews > 0 && [ODApplicationState sharedinstance].dirty ) {

        NSString* title = NSLocalizedString(@"Warning", nil);
        NSString* message = NSLocalizedString(@"Loading will overwrite unsaved work", nil);
        NSString* cancel = NSLocalizedString(@"Cancel", nil);
        NSString* load = NSLocalizedString(@"Load", nil);
        
        PSPDFAlertView *confirmLoad = [[PSPDFAlertView alloc] initWithTitle:title];
        [confirmLoad setMessage:message];
        [confirmLoad addButtonWithTitle:load block:loadBlock];
        [confirmLoad setCancelButtonWithTitle:cancel block:nil];
        [confirmLoad show];
    }
    else {
        loadBlock();
    }
}

- (void)loadComposition:(NSString*) filename {
    [self loadComposition:filename withFolder:@"arcmachines"];
}

#pragma mark -
#pragma mark Handle Memory warning

- (void)didReceiveMemoryWarning {
    [TestFlight passCheckpoint:@"Memory warning"];
    [super didReceiveMemoryWarning];
}

@end
