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
        
        // Any additional first time use stuff goes here.
        
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
        if(colorPicker.frame.origin.x != 10) {
            [TestFlight passCheckpoint:@"Viewing Colour Picker"];
            
            [self moveColorPicker:10];
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
    [TestFlight passCheckpoint:@"Viewed help overlay manually"];
    
    [self editToolsHelpOverlay:_toolbarMode];
}

- (void)handleTitleSwipe:(UISwipeGestureRecognizer *) recognizer {
    [TestFlight passCheckpoint:@"Visited help page"];
    
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

- (void)NPColorPickerView:(ODColorPickerView *)view didSelectColor:(UIColor *)color {
    
    int i = [ODColorPalette sharedinstance].selectedIndex;
    [ODColorPalette sharedinstance].colors[i] = color;
    [swatchBar setNeedsDisplay];
    
    switch (fillStrokeSelector.selectedSegmentIndex) {
        case 0:
            [TestFlight passCheckpoint:@"Selected Fill from Color Picker"];
            
            [self setCurrentFillFromPaletteColor:i];
            break;
            
        case 1:
            [TestFlight passCheckpoint:@"Selected Stroke from Color Picker"];
            
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
        [TestFlight passCheckpoint:@"Added arc layer"];
        [self addRandomArcLayer];
        [self syncLayerStepper];
    } else {
        [TestFlight passCheckpoint:@"Added maximum layers"];
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
        [TestFlight passCheckpoint:@"Deleted Selected Arc"];
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
    [TestFlight passCheckpoint:@"Cleared all arcs"];
}

- (IBAction)deselectCurrentArc:(UIBarButtonItem *)sender {
    [self deselect];
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

- (IBAction)gridModeStep:(id)sender {
    [gridView incrementGridMode];
}

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
        [[TKAlertCenter defaultCenter] postAlertWithMessage:NSLocalizedString(@"Press + to add Arcs", nil) image:[UIImage imageNamed:@"lightBulb@2x.png"]];
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
    [TestFlight passCheckpoint:[NSString stringWithFormat:@"Rotate mode :%i" , _rotateMode]];
}

- (IBAction)changePinchMode:(UISegmentedControl *)sender {
    _pinchMode = sender.selectedSegmentIndex;
    [TestFlight passCheckpoint:[NSString stringWithFormat:@"Pinch mode :%i" , _pinchMode]];
}

- (IBAction)savePNGImagetoPhotoAlbum:(id)sender scale:(NSInteger)s{
    if([[arcConstruktView subviews] count] < 1) {
        [[TKAlertCenter defaultCenter] postAlertWithMessage:NSLocalizedString(@"Press + to add Arcs", nil) image:[UIImage imageNamed:@"lightBulb@2x.png"]];
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

- (IBAction)arrangeLayer:(UISegmentedControl *)sender {
    ODArcMachine *arc = [ODApplicationState sharedinstance].currentArc;
    switch (sender.selectedSegmentIndex) {
        case 0:
            [TestFlight passCheckpoint:@"Arc send to back"];
            [arc sendToBack];
            break;
        case 1:
            [TestFlight passCheckpoint:@"Arc back one"];
            [arc sendOneLevelDown];
            break;
        case 2:
            [TestFlight passCheckpoint:@"Arc forward one"];
            [arc bringOneLevelUp];
            break;
        case 3:
            [TestFlight passCheckpoint:@"Arc bring to front"];
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
            [TestFlight passCheckpoint:@"Set fill transparency"];
            break;
        case 1:
            [self setCurrentStrokeFromUIColor: [UIColor
                                                colorWithRed:s[0]
                                                green:s[1]
                                                blue:s[2]
                                                alpha:[transparencyPicker transparency]]];
            [TestFlight passCheckpoint:@"Set stroke transparency"];
            break;
        default:
            break;
    }
}

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

    if([[arcConstruktView subviews] count] < 1) {
        [[TKAlertCenter defaultCenter] postAlertWithMessage:NSLocalizedString(@"Press + to add Arcs", nil) image:[UIImage imageNamed:@"lightBulb@2x.png"]];
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
        [ODFileTools save:file.filename extension:@"svg" documentsFolder:@"svg" data:[file asSVGEncoded]];
        
        [TestFlight passCheckpoint:@"Saved composition .arcmachine and SVG"];
        
        return;
    }];
}

- (void)importComposition:(NSString*)filename withFolder:(NSString *)folder {
    ODArcConstruktDocument *file = [ODFileTools load:filename documentsFolder:folder];
    [ODFileTools save:filename documentsFolder:@"arcmachines" data:[NSKeyedArchiver archivedDataWithRootObject:file]];
    [ODFileTools save:file.filename extension:@"svg" documentsFolder:@"svg" data:[file asSVGEncoded]];
    
    [TestFlight passCheckpoint:@"Import composition"];
}

- (void)loadComposition:(NSString*) filename withFolder:(NSString *)folder {
    @try {
        [[TKAlertCenter defaultCenter] postAlertWithMessage:[NSString stringWithFormat:@"%@ : %@", NSLocalizedString(@"Loaded",nil), filename]];
        [self clearButton:nil];
        ODArcConstruktDocument *file = [ODFileTools load:filename documentsFolder:folder];
        for (ODArcMachine *arc in [file layersToArcMachines]) {
            [arcConstruktView addSubview:arc];
        }
        [self resetStepper];
        [self deselect];
        [TestFlight passCheckpoint:@"Loaded composition"];
    }
    @catch (NSException *exception) {
        [[TKAlertCenter defaultCenter] postAlertWithMessage:[NSString stringWithFormat:NSLocalizedString(@"Failed to load %@", nil), filename]];
        [TestFlight passCheckpoint:@"Composition load failed"];
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

- (void)didReceiveMemoryWarning {
    [TestFlight passCheckpoint:@"Memory warning"];
    [[TKAlertCenter defaultCenter] postAlertWithMessage:NSLocalizedString(@"Memory warning: Save your work, just in case!", nil)];
    
    [super didReceiveMemoryWarning];
}

@end
