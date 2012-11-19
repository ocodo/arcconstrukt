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
#import "ArcConstruktAppDelegate.h"

@interface ODArcConstruktViewController ()

@end

@implementation ODArcConstruktViewController

@synthesize arcConstruktView, gridView, layerStepper, titleView, mainToolbar, swatchBar, fillStrokeSelector, transparencyPicker, transparencyButton, colorPicker, angleSelector, pinchSelector, layerOrderSelector;

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
    [self view].backgroundColor = [
                                   UIColor colorWithPatternImage:
                                   [UIImage imageNamed:@"outlets@2x.png"]];
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

        // do any first time loaded stuff. (the toolbar overlay is handled by first move.)
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:appFirstStartOfVersionKey];
    }
    
    [[NSNotificationCenter defaultCenter] addObserverForName:@"selectFileToLoad" object:nil queue:nil usingBlock:^(NSNotification *note) {
        [self loadComposition:note.object];
    }];
}

- (void)editToolsHelpOverlay:(int)mode {
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
            [self setCurrentFillFromPaletteColor:index];
            break;
            
        case 1:
            [self setCurrentStrokeFromPaletteColor:index];
            break;
            
        default:
            break;
    }
}

- (void)handleColorSwatchLongPress:(UILongPressGestureRecognizer *)recognizer {
    if(recognizer.state == UIGestureRecognizerStateBegan) {
        if(colorPicker.frame.origin.x != 10)
            [self moveColorPicker:10];
        else
            [self moveColorPicker:640];
    }
}

- (void)handleColorPickerSwipe:(UISwipeGestureRecognizer *)recognizer {
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

- (void)quickEditMenu:(UILongPressGestureRecognizer *)recognizer {
    [recognizer.view becomeFirstResponder];
    UIMenuController* mc = [UIMenuController sharedMenuController];
    UIMenuItem* menu_angle_a = [[UIMenuItem alloc] initWithTitle:@"A˚" action:@selector(angleAMode:)];
    UIMenuItem* menu_angle_b = [[UIMenuItem alloc] initWithTitle:@"B˚" action:@selector(angleBMode:)];
    UIMenuItem* menu_radius = [[UIMenuItem alloc] initWithTitle:@"r" action:@selector(radiusMode:)];
    UIMenuItem* menu_thickness = [[UIMenuItem alloc] initWithTitle:@"T" action:@selector(thicknessMode:)];
    UIMenuItem* menu_copy = [[UIMenuItem alloc] initWithTitle:@"Clone" action:@selector(copyArc:)];
    UIMenuItem* menu_paste = [[UIMenuItem alloc] initWithTitle:@"Paste" action:@selector(pasteArc:)];
    UIMenuItem* menu_delete = [[UIMenuItem alloc] initWithTitle:@"Delete" action:@selector(deleteButton:)];
    UIMenuItem* menu_clear = [[UIMenuItem alloc] initWithTitle:@"Clear All" action:@selector(clearButton:)];
    [[UIMenuController sharedMenuController] setMenuItems:@[menu_angle_a, menu_angle_b, menu_radius, menu_thickness, menu_copy, menu_paste, menu_delete, menu_clear]];
    CGPoint position = [recognizer locationInView:recognizer.view.superview];
    CGRect box = CGRectMake(position.x, position.y, 10, 10);
    [mc setTargetRect: box inView: recognizer.view.superview];
    [mc setMenuVisible: YES animated: YES];
}

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

- (void)handleTitleTap:(UITapGestureRecognizer *) recognizer {
    [self editToolsHelpOverlay:_toolbarMode];
}

- (void)handleTitleSwipe:(UISwipeGestureRecognizer *) recognizer {
    [self performSegueWithIdentifier:@"aboutPageSegue" sender:self];
}

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

- (void)NPColorPickerView:(NPColorPickerView *)view didSelectColor:(UIColor *)color {
    
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
    [[ODApplicationState sharedinstance].currentArc setNeedsDisplay];
}

- (void)setCurrentFillFromUIColor:(UIColor*)color {
    colorPicker.color = color;
    [ODApplicationState sharedinstance].currentArc.fill = color;
    [ODApplicationState sharedinstance].currentArc.savedFill = color;
    [[ODApplicationState sharedinstance].currentArc setNeedsDisplay];
}

- (void)addRandomArcLayer{
    [arcConstruktView addSubview:[[ODArcMachine alloc]
                                  initRandomWithFrame:CGRectMake(0, 0, 320, 320)
                                  fillColor:[self useCurrentFillColor]
                                  strokeColor:[self useCurrentStrokeColor]]];
}

- (IBAction)addButton:(id)sender {
    int max_layer = [arcConstruktView subviews].count;
    if(max_layer < kMaximumLayers) {
        [self addRandomArcLayer];
        [self syncLayerStepper];
    } else {
        [[TKAlertCenter defaultCenter]
         postAlertWithMessage:
         [NSString
          stringWithFormat:@"MAXIMUM: %d LAYERS", max_layer]];
    }
}

- (void)syncLayerStepper {
    int max_layer = [arcConstruktView subviews].count -1;
    [layerStepper setMaximumValue:max_layer];
    [layerStepper setValue:max_layer];
    [self layerSelecting:layerStepper];
}

- (IBAction)deleteButton:(id)sender {
    int index;
    if([ODApplicationState sharedinstance].currentArc) {
        index = [ODApplicationState sharedinstance].currentArc.getSubviewIndex;
        [[ODApplicationState sharedinstance].currentArc removeFromSuperview];
    }
    [layerStepper setMaximumValue:[arcConstruktView subviews].count - 1];
    [layerStepper setValue:MIN(index,[arcConstruktView subviews].count - 1)];
    [self layerSelecting:layerStepper];
}

- (IBAction)clearButton:(id)sender {
    for(ODArcMachine *arc in arcConstruktView.subviews)
    {
        [arc removeFromSuperview];
    }
    [layerStepper setMaximumValue:[arcConstruktView subviews].count - 1];
    [layerStepper setValue:0];
}

- (IBAction)deselectCurrentArc:(UIBarButtonItem *)sender {
    [self deselect];
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

- (IBAction)gridModeStep:(id)sender {
    [gridView incrementGridMode];
}

- (IBAction)actionMenu:(id)sender {
    PSPDFActionSheet *actionSheet = [[PSPDFActionSheet alloc] initWithTitle:@"Choose an Action"];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [actionSheet setDestructiveButtonWithTitle:@"Save PNG to Camera Roll" block:^{
        [self deselect];
        [self savePNGMenu:self];
    }];
    [actionSheet addButtonWithTitle:@"Import Colors" block:^{
        [self importColorsFromPasteboard:self];
    }];
    [actionSheet addButtonWithTitle:@"Export Colors" block:^{
        [self exportColorPalette:self];
    }];
    [actionSheet addButtonWithTitle:@"Save ArcMachine" block:^{
        [self saveComposition:self];
    }];
    [actionSheet addButtonWithTitle:@"My ArcMachines" block:^{
        [self performSegueWithIdentifier:@"filesViewSegue" sender:self];
    }];
    [actionSheet setCancelButtonWithTitle:@"Cancel" block:nil];
    [actionSheet showInView:[self view]];
}

- (IBAction)savePNGMenu:(id)sender {
    
    if (arcConstruktView.subviews.count < 1) {
        [[TKAlertCenter defaultCenter] postAlertWithMessage:@"Press + to add Arcs" image:[UIImage imageNamed:@"lightBulb@2x.png"]];
        return;
    }
    
    PSPDFActionSheet *actionSheet = [[PSPDFActionSheet alloc] initWithTitle:@"Save to Camera Roll\nImage Quality"];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [actionSheet addButtonWithTitle:@"PNG 640x640" block:^{
        [self savePNGImagetoPhotoAlbum:self scale:2];
    }];
    [actionSheet addButtonWithTitle:@"PNG 1280x1280" block:^{
        [self savePNGImagetoPhotoAlbum:self scale:4];
    }];
    [actionSheet addButtonWithTitle:@"PNG 1920x1920" block:^{
        [self savePNGImagetoPhotoAlbum:self scale:6];
    }];
    [actionSheet addButtonWithTitle:@"PNG 2560x2560" block:^{
        [self savePNGImagetoPhotoAlbum:self scale:8];
    }];
    [actionSheet addButtonWithTitle:@"PNG 2880x2880" block:^{
        [self savePNGImagetoPhotoAlbum:self scale:9];
    }];
    [actionSheet addButtonWithTitle:@"PNG 3200x3200" block:^{
        [self savePNGImagetoPhotoAlbum:self scale:10];
    }];
    [actionSheet setCancelButtonWithTitle:@"Cancel" block:nil];
    [actionSheet showInView:[self view]];

}

- (void)copyArc:(id)sender {
    NSDictionary *plist = [[ODApplicationState sharedinstance]
                           .currentArc geometryToDictionary];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject: plist];
    [appPasteboard setData:data forPasteboardType:@"info.ocodo.arcconstrukt"];
    [arcConstruktView addSubview:[[ODArcMachine alloc]
                                  initWithArcMachine:[ODApplicationState sharedinstance].currentArc
                                  frame:CGRectMake(0, 0, 320, 320)]];
    [self syncLayerStepper];    
}

- (void)pasteArc:(id)sender {
    NSData *data = [appPasteboard dataForPasteboardType:@"info.ocodo.arcconstrukt"];
    NSDictionary *plist = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    ODArcMachine *a = [[ODArcMachine alloc] initWithFrame:CGRectMake(0, 0, 320, 320)];
    [a geometryFromDictionary: plist];
    [arcConstruktView addSubview:a];
    [self syncLayerStepper];
}

- (void)angleAMode: (id)sender {
    [angleSelector setSelectedSegmentIndex:0];
    _rotateMode = 0;
}

- (void)angleBMode: (id)sender {
    [angleSelector setSelectedSegmentIndex:1];
    _rotateMode = 1;
}

- (void)radiusMode: (id)sender {
    [pinchSelector setSelectedSegmentIndex:0];
    _pinchMode = 0;
}

- (void)thicknessMode: (id)sender {
    [pinchSelector setSelectedSegmentIndex:1];
    _pinchMode = 1;
}

- (BOOL)canPerformAction: (SEL)action withSender: (id)sender {
    return action == @selector(copyArc: )
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

- (void)pinchRadius:(UIPinchGestureRecognizer *)pincher {
    float radius = clampf([ODApplicationState sharedinstance].currentArc.radius + pincher.scale-1, 1.0f, 160.0f);
    [ODApplicationState sharedinstance].currentArc.radius = radius;
    [[ODApplicationState sharedinstance].currentArc setNeedsDisplay];
}

- (void)pinchThickness:(UIPinchGestureRecognizer *)pincher {
    float thick = clampf([ODApplicationState sharedinstance].currentArc.thickness + pincher.scale-1, 1.0f, 160.0f);
    [ODApplicationState sharedinstance].currentArc.thickness = thick;
    [[ODApplicationState sharedinstance].currentArc setNeedsDisplay];
}

- (void)startAngleTouch:(ODFingerRotationGestureRecognizer *)rotator {
    if([ODApplicationState sharedinstance].currentArc) {
        [ODApplicationState sharedinstance].currentArc.start += rotator.rotation;
        [[ODApplicationState sharedinstance].currentArc setNeedsDisplay];
    }
}

- (void)endAngleTouch:(ODFingerRotationGestureRecognizer *)rotator {
    if([ODApplicationState sharedinstance].currentArc){
        [ODApplicationState sharedinstance].currentArc.end += rotator.rotation;
        [[ODApplicationState sharedinstance].currentArc setNeedsDisplay];
    }
}

- (void)lockedAngleTouch:(ODFingerRotationGestureRecognizer *)rotator {
    if([ODApplicationState sharedinstance].currentArc) {
        [ODApplicationState sharedinstance].currentArc.start += rotator.rotation;
        [ODApplicationState sharedinstance].currentArc.end += rotator.rotation;
        [[ODApplicationState sharedinstance].currentArc setNeedsDisplay];
    }
}


- (IBAction)layerStep:(UIStepper *)sender {
    [self layerSelecting:sender];
}

- (IBAction)changeRotateMode:(UISegmentedControl *)sender {
    _rotateMode = sender.selectedSegmentIndex;
}

- (IBAction)changePinchMode:(UISegmentedControl *)sender {
    _pinchMode = sender.selectedSegmentIndex;
}

- (IBAction)savePNGImagetoPhotoAlbum:(id)sender scale:(NSInteger)s{
    if([[arcConstruktView subviews] count] > 0) {
        // show progress HUD
        DZProgressController *HUD = [DZProgressController new];
        HUD.label.text = @"Saving to Photo Album";
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
    else {
        [[TKAlertCenter defaultCenter] postAlertWithMessage:@"Press + to add Arcs" image:[UIImage imageNamed:@"lightBulb@2x.png"]];
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void*)contextInfo {
    if (error) {
        [[TKAlertCenter defaultCenter] postAlertWithMessage:@"There was a problem saving your image, check photo album privacy settings, and make sure you have enough free memory."];
    } else {
        // saved ok.
        [[TKAlertCenter defaultCenter] postAlertWithMessage:@"Saved PNG"];
    }
}

- (IBAction)arrangeLayer:(UISegmentedControl *)sender {
    ODArcMachine *arc = [ODApplicationState sharedinstance].currentArc;
    switch (sender.selectedSegmentIndex) {
        case 0:
            [arc sendToBack];
            break;
        case 1:
            [arc sendOneLevelDown];
            break;
        case 2:
            [arc bringOneLevelUp];
            break;
        case 3:
            [arc bringToFront];
            break;
        default:
            break;
    }
}

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
                     completion:nil];
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

- (void)moveToolbar:(int)s {
    _toolbarMode = s;
    int x = s * -320;
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
                         _toolbarMode = s;
                         [self showInstructionsOnceForToolbarMode:s];
                     }
     ];
}

- (void) showInstructionsOnceForToolbarMode:(int)mode {
    NSString *bundleVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey];
    NSString *seenToolModeInstructionsKey = [NSString stringWithFormat:@"seen_toolmode_%i_instructions_%@", mode, bundleVersion];
    NSNumber *seenModeInstruction = [[NSUserDefaults standardUserDefaults] objectForKey:seenToolModeInstructionsKey];
    if(!seenModeInstruction || [seenModeInstruction boolValue] == NO) {
        [self editToolsHelpOverlay:mode];
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:seenToolModeInstructionsKey];
    }
}

- (IBAction)toolbarModeSelector:(UISegmentedControl*)sender {
    [self moveToolbar:sender.selectedSegmentIndex];
}

- (void)saveComposition:(id)sender {
    DZProgressController *HUD = [DZProgressController new];
    HUD.label.text = @"Saving ArcConstrukt";
    [HUD showWhileExecuting:^{
        ODArcConstruktFile *file = [[ODArcConstruktFile alloc] initWithArcMachineSubviews:arcConstruktView.subviews];
        
        UIGraphicsBeginImageContextWithOptions(arcConstruktView.bounds.size, NO, 0.5);
        [arcConstruktView.layer renderInContext:UIGraphicsGetCurrentContext()];
        
        file.thumbnail = [UIImage imageWithData:
                          UIImagePNGRepresentation(UIGraphicsGetImageFromCurrentImageContext())];
        
        int ti = [[NSDate date] timeIntervalSince1970];
        file.filename = [NSString stringWithFormat:@"ArcConstrukt-%X.arcmachine", ti];
        [ODFileTools save:file.filename documentsFolder:@"arcmachines" data:[NSKeyedArchiver archivedDataWithRootObject: file]];
        [ODFileTools save:file.filename extension:@"svg" documentsFolder:@"svg" data:[file asSVGEncoded]];
        return;
    }];
}

- (void)importComposition:(NSString*)filename withFolder:(NSString *)folder {
    ODArcConstruktFile *file = [ODFileTools load:filename documentsFolder:folder];
    [ODFileTools save:filename documentsFolder:@"arcmachines" data:[NSKeyedArchiver archivedDataWithRootObject:file]];
    [ODFileTools save:file.filename extension:@"svg" documentsFolder:@"svg" data:[file asSVGEncoded]];
}

- (void)loadComposition:(NSString*) filename withFolder:(NSString *)folder {
    @try {
        [[TKAlertCenter defaultCenter] postAlertWithMessage:[NSString stringWithFormat:@"Loaded %@", filename]];
        [self clearButton:nil];
        ODArcConstruktFile *file = [ODFileTools load:filename documentsFolder:folder];
        for (ODArcMachine *arc in [file layersToArcMachines]) {
            [arcConstruktView addSubview:arc];
        }
        [self resetStepper];
        [self deselect];
    }
    @catch (NSException *exception) {
        [[TKAlertCenter defaultCenter] postAlertWithMessage:[NSString stringWithFormat:@"Failed to load %@", filename]];
    }
    [arcConstruktView setNeedsDisplay];
}

- (void)loadComposition:(NSString*) filename {
    [self loadComposition:filename withFolder:@"arcmachines"];
}

- (void)exportColorPalette:(id)sender {
    NSMutableArray * hexColors = [[NSMutableArray alloc] initWithArray:@[@"ArcConstrukt Color Palette:"]];
    for (UIColor *color in [[ODColorPalette sharedinstance] colors]) {
        [hexColors addObject:[color RGBHexString]];
    }
    [[UIPasteboard generalPasteboard] setString:[hexColors componentsJoinedByString:@"\n"]];
    [[TKAlertCenter defaultCenter] postAlertWithMessage:@"Color Palette exported to the Clipboard"];
}

- (IBAction)importColorsFromPasteboard:(id)sender {
    NSString *import = [[UIPasteboard generalPasteboard] string];
    
    if(import.length < 1){
        [[TKAlertCenter defaultCenter] postAlertWithMessage:@"Copy some Hex colors into the clipboard, ArcConstrukt will find and use the first 6"];
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
        [[TKAlertCenter defaultCenter] postAlertWithMessage:[NSString stringWithFormat:@"Imported %i colors from the Clipboard", i]];
    } else {
        [[TKAlertCenter defaultCenter] postAlertWithMessage:@"Copy some Hex colors into the clipboard, ArcConstrukt will find and use the first 6"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
