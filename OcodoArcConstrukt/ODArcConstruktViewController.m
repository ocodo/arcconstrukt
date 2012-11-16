//
//  ODArcConstruktViewController.m
//  ArcConstrukt
//
//  Created by jason on 28/10/12.
//  Copyright (c) 2012 ocodo. All rights reserved.
//

#define MAXIMUM_LAYERS 150

#import "ODArcConstruktViewController.h"
#import "ODFileTools.h"
#import "PSPDFActionSheet.h"

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
    NSLog(@"ArcConstrukt start:");
    
    [super viewDidLoad];
    
    // set tiled background.
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
        [self firstStartCode];
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:appFirstStartOfVersionKey];
    }
    
    [[NSNotificationCenter defaultCenter] addObserverForName:@"selectFileToLoad" object:nil queue:nil usingBlock:^(NSNotification *note) {
        [self loadComposition:note.object];
    }];
}

- (void)firstStartCode {
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Welcome to ArcConstrukt"
                                                      message:@"Tap the title bar for Help."
                                                     delegate:nil
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
    [message show];
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
                                                                                            action:@selector(handleConstruktLongPress:)];
    
    [arcConstruktView addGestureRecognizer:longPress];
    
    // set rotate and pinch gesture modes.
    rotateMode = 0;
    pinchMode = 0;
    
}

- (void)initTitleBar {
    UITapGestureRecognizer *titleTap = [[UITapGestureRecognizer alloc]
                                        initWithTarget:self
                                        action:@selector(handleTitleTap:)];
    
    [titleView setUserInteractionEnabled:YES];
    [titleView addGestureRecognizer:titleTap];
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
    [ODColorPalette singleton].selectedIndex = index;
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
    if([ODCurrentArcObject singleton].currentArc.savedFill) {
        return [ODCurrentArcObject singleton].currentArc.savedFill;
    } else {
        return [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    }
}

- (UIColor*)useCurrentStrokeColor {
    if([ODCurrentArcObject singleton].currentArc.savedStroke) {
        return [ODCurrentArcObject singleton].currentArc.savedStroke;
    } else {
        return [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
    }
}

-(void)NPColorPickerView:(NPColorPickerView *)view didSelectColor:(UIColor *)color {
    
    int i = [ODColorPalette singleton].selectedIndex;
    [ODColorPalette singleton].colors[i] = color;
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
    UIColor *color = [[ODColorPalette singleton].colors objectAtIndex:index];
    [self setCurrentStrokeFromUIColor:color];
}

- (void)setCurrentFillFromPaletteColor:(int)index {
    UIColor *color = [[ODColorPalette singleton].colors objectAtIndex:index];
    [self setCurrentFillFromUIColor:color];
}

- (void)setCurrentStrokeFromUIColor:(UIColor*)color {
    colorPicker.color = color;
    [ODCurrentArcObject singleton].currentArc.stroke = color;
    [ODCurrentArcObject singleton].currentArc.savedStroke = color;
    [[ODCurrentArcObject singleton].currentArc setNeedsDisplay];
}

- (void)setCurrentFillFromUIColor:(UIColor*)color {
    colorPicker.color = color;
    [ODCurrentArcObject singleton].currentArc.fill = color;
    [ODCurrentArcObject singleton].currentArc.savedFill = color;
    [[ODCurrentArcObject singleton].currentArc setNeedsDisplay];
}

- (void)addRandomArcLayer{
    [arcConstruktView addSubview:[[ODArcMachine alloc]
             initRandomWithFrame:CGRectMake(0, 0, 320, 320)
                       fillColor:[self useCurrentFillColor]
                     strokeColor:[self useCurrentStrokeColor]]];
}

- (IBAction)addButton:(id)sender {
    int max_layer = [arcConstruktView subviews].count;
    if(max_layer < MAXIMUM_LAYERS) {
        [self addRandomArcLayer];
        [self syncLayerStepper];
    } else {
        [[TKAlertCenter defaultCenter]
         postAlertWithMessage:
         [NSString
          stringWithFormat:@"MAXIMUM: %d LAYERS", max_layer]];
    }
}

- (void) syncLayerStepper {
    int max_layer = [arcConstruktView subviews].count -1;
    [layerStepper setMaximumValue:max_layer];
    [layerStepper setValue:max_layer];
    [self layerSelecting:layerStepper];
}

- (IBAction)deleteButton:(id)sender {
    int index;
    if([ODCurrentArcObject singleton].currentArc) {
        index = [ODCurrentArcObject singleton].currentArc.getSubviewIndex;
        [[ODCurrentArcObject singleton].currentArc removeFromSuperview];
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
    [[ODCurrentArcObject singleton].currentArc deselectArc];
}

- (void)resetStepper {
    [layerStepper setMaximumValue:[arcConstruktView subviews].count - 1];
    [layerStepper setValue:0];
    [self layerSelecting:layerStepper];
}

- (void)layerSelecting:(UIStepper *)sender {
    if ([ODCurrentArcObject singleton].currentArc) {
        [[ODCurrentArcObject singleton].currentArc deselectArc];
    }
    if ([arcConstruktView subviews].count > 0) {
        [ODCurrentArcObject singleton].currentArc = [[arcConstruktView subviews] objectAtIndex:sender.value];
        [[ODCurrentArcObject singleton].currentArc selectArc];
    }
}

- (IBAction)gridModeStep:(id)sender {
    [gridView incrementGridMode];
}

- (IBAction)actionMenu:(id)sender {
    PSPDFActionSheet *actionSheet = [[PSPDFActionSheet alloc] initWithTitle:@"Choose an Action"];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [actionSheet setDestructiveButtonWithTitle:@"Save PNG to Camera Roll" block:^{
        [self savePNGImagetoPhotoAlbum:self];
    }];
    [actionSheet addButtonWithTitle:@"Import Colors" block:^{
        [self importColorsFromPasteboard:self];
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

- (void)handleConstruktLongPress:(UILongPressGestureRecognizer *)recognizer {
    [recognizer.view becomeFirstResponder];
    UIMenuController* mc = [UIMenuController sharedMenuController];
    UIMenuItem* menu_angle_a = [[UIMenuItem alloc] initWithTitle:@"A˚" action:@selector(angleAMode:)];
    UIMenuItem* menu_angle_b = [[UIMenuItem alloc] initWithTitle:@"B˚" action:@selector(angleBMode:)];
    UIMenuItem* menu_radius = [[UIMenuItem alloc] initWithTitle:@"r" action:@selector(radiusMode:)];
    UIMenuItem* menu_thickness = [[UIMenuItem alloc] initWithTitle:@"T" action:@selector(thicknessMode:)];
    UIMenuItem* menu_copy = [[UIMenuItem alloc] initWithTitle:@"Copy" action:@selector(copyArc:)];
    UIMenuItem* menu_paste = [[UIMenuItem alloc] initWithTitle:@"Paste" action:@selector(pasteArc:)];
    UIMenuItem* menu_delete = [[UIMenuItem alloc] initWithTitle:@"Delete" action:@selector(deleteButton:)];
    UIMenuItem* menu_clear = [[UIMenuItem alloc] initWithTitle:@"Clear All" action:@selector(clearButton:)];
    [[UIMenuController sharedMenuController] setMenuItems:@[menu_angle_a, menu_angle_b, menu_radius, menu_thickness, menu_copy, menu_paste, menu_delete, menu_clear]];
    CGPoint position = [recognizer locationInView:recognizer.view.superview];
    CGRect box = CGRectMake(position.x, position.y, 10, 10);
    [mc setTargetRect: box inView: recognizer.view.superview];
    [mc setMenuVisible: YES animated: YES];
}

- (void) copyArc:(id)sender {
    NSDictionary *plist = [[ODCurrentArcObject singleton]
                           .currentArc geometryToDictionary];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject: plist];
    [appPasteboard setData:data forPasteboardType:@"info.ocodo.arcconstrukt"];
}
- (void) pasteArc:(id)sender {
    NSData *data = [appPasteboard dataForPasteboardType:@"info.ocodo.arcconstrukt"];
    NSDictionary *plist = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    ODArcMachine *a = [[ODArcMachine alloc] initWithFrame:CGRectMake(0, 0, 320, 320)];
    [a geometryFromDictionary: plist];
    [arcConstruktView addSubview:a];
    [self syncLayerStepper];
}

- (void)angleAMode: (id)sender {
    [angleSelector setSelectedSegmentIndex:0];
    rotateMode = 0;
}

- (void)angleBMode: (id)sender {
    [angleSelector setSelectedSegmentIndex:1];
    rotateMode = 1;
}

- (void)radiusMode: (id)sender {
    [pinchSelector setSelectedSegmentIndex:0];
    pinchMode = 0;
}

- (void)thicknessMode: (id)sender {
    [pinchSelector setSelectedSegmentIndex:1];
    pinchMode = 1;
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

- (void)handleConstruktPinch:(UIPinchGestureRecognizer *)pincher {
    switch (pinchMode) {
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

- (void)pinchRadius:(UIPinchGestureRecognizer *)pincher {
    float radius = clampf([ODCurrentArcObject singleton].currentArc.radius + pincher.scale-1, 1.0f, 160.0f);
    [ODCurrentArcObject singleton].currentArc.radius = radius;
    [[ODCurrentArcObject singleton].currentArc setNeedsDisplay];
}

- (void)pinchThickness:(UIPinchGestureRecognizer *)pincher {
    float thick = clampf([ODCurrentArcObject singleton].currentArc.thickness + pincher.scale-1, 1.0f, 160.0f);
    [ODCurrentArcObject singleton].currentArc.thickness = thick;
    [[ODCurrentArcObject singleton].currentArc setNeedsDisplay];
}

- (void)handleConstruktRotate:(ODFingerRotationGestureRecognizer *)rotator {
    switch (rotateMode) {
        case 0:
            [self startAngleTouch:rotator];
            break;
        case 1:
            [self endAngleTouch:rotator];
            break;
        default:
            break;
    }
}

- (void)startAngleTouch:(ODFingerRotationGestureRecognizer *)rotator {
    if([ODCurrentArcObject singleton].currentArc) {
        [ODCurrentArcObject singleton].currentArc.start += rotator.rotation;
        [[ODCurrentArcObject singleton].currentArc setNeedsDisplay];
    }
}

- (void)endAngleTouch:(ODFingerRotationGestureRecognizer *)rotator {
    if([ODCurrentArcObject singleton].currentArc){
        [ODCurrentArcObject singleton].currentArc.end += rotator.rotation;
        [[ODCurrentArcObject singleton].currentArc setNeedsDisplay];
    }
}

- (IBAction)layerStep:(UIStepper *)sender {
    [self layerSelecting:sender];
}

- (IBAction)changeRotateMode:(UISegmentedControl *)sender {
    rotateMode = sender.selectedSegmentIndex;
}

- (IBAction)changePinchMode:(UISegmentedControl *)sender {
    pinchMode = sender.selectedSegmentIndex;
}

- (void)handleTitleTap:(UITapGestureRecognizer *) tap {
    [self performSegueWithIdentifier:@"aboutPageSegue" sender:self];
}

- (IBAction)savePNGImagetoPhotoAlbum:(id)sender {
    if([[arcConstruktView subviews] count] > 0) {
        [self deselect];
        // show progress HUD
        DZProgressController *HUD = [DZProgressController new];
        HUD.label.text = @"Saving to Photo Album";
        [HUD showWhileExecuting:^{
            UIGraphicsBeginImageContextWithOptions(arcConstruktView.bounds.size, NO, 6.0);
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
    }
}

- (IBAction)arrangeLayer:(UISegmentedControl *)sender {
    ODArcMachine *arc = [ODCurrentArcObject singleton].currentArc;
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
    if([ODCurrentArcObject singleton].currentArc == NULL) {
        return;
    }
    const CGFloat *f = CGColorGetComponents([ODCurrentArcObject singleton].currentArc.savedFill.CGColor);
    const CGFloat *s = CGColorGetComponents([ODCurrentArcObject singleton].currentArc.savedStroke.CGColor);
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
                     }
                     completion:nil
     ];
}

- (IBAction)toolbarModeSelector:(UISegmentedControl*)sender {
    [self moveToolbar:sender.selectedSegmentIndex];
}

- (void)saveComposition:(id)sender {
    if (arcConstruktView.subviews.count < 1) {
        [[TKAlertCenter defaultCenter] postAlertWithMessage:@"Press + to add Arcs"];
        return;
    }
    
    DZProgressController *HUD = [DZProgressController new];
    HUD.label.text = @"Saving ArcConstrukt";
    [HUD showWhileExecuting:^{
        ODArcConstruktFile *file = [[ODArcConstruktFile alloc] initWithArcMachineSubviews:arcConstruktView.subviews];

        UIGraphicsBeginImageContextWithOptions(arcConstruktView.bounds.size, NO, 0.5);
        [arcConstruktView.layer renderInContext:UIGraphicsGetCurrentContext()];

        file.thumbnail = [UIImage imageWithData:
                          UIImagePNGRepresentation(UIGraphicsGetImageFromCurrentImageContext())];

        int ti = [[NSDate date] timeIntervalSince1970];
        file.filename = [NSString stringWithFormat:@"ArcConstrukt-%X", ti];

        [ODFileTools save:file.filename documentsFolder:@"arcmachines" data:[NSKeyedArchiver archivedDataWithRootObject: file]];
        
        [ODFileTools save:file.filename extension:@"svg" documentsFolder:@"svg" data:[file asSVGEncoded]];
        
        return;
    }];
}

- (void)loadComposition:(NSString*) filename {
    @try {
        [[TKAlertCenter defaultCenter] postAlertWithMessage:[NSString stringWithFormat:@"Loaded %@", filename]];
        [self clearButton:nil];
        ODArcConstruktFile *file = [ODFileTools load:filename documentsFolder:@"arcmachines"];
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
             [ODColorPalette singleton].colors[i] =
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
