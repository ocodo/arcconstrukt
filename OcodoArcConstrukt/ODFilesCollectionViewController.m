//
//  ODFilesCollectionViewController.m
//  OcodoArcConstrukt
//
//  Created by jason on 10/11/12.
//  Copyright (c) 2012 ocodo. All rights reserved.
//

#import "ODFilesCollectionViewController.h"

@interface ODFilesCollectionViewController ()

@end

@implementation ODFilesCollectionViewController

@synthesize currentIndexPath, fileList, titleNavigationItem;

#pragma mark -
#pragma mark Initialize
#pragma mark -

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark -
#pragma mark View Loaded
#pragma mark -

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [TestFlight passCheckpoint:@"Files View"];
    
    if([[self listFiles] count] < 1) {
      [[TKAlertCenter defaultCenter] postAlertWithMessage:NSLocalizedString(@"No ArcMachines saved yet", nil)];
        [TestFlight passCheckpoint:@"Files View Empty"];

        return;
    }
    
    // set tiled background.
    self.collectionView.backgroundColor = [
                                   UIColor colorWithPatternImage:
                                 [UIImage imageNamed:@"arabesque-tribar@2x.png"]];
    
    fileList = [[NSMutableArray alloc] initWithArray:[self listFiles]];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(fileViewActions:)];
    [self.collectionView addGestureRecognizer:longPress];
    
    [self.collectionView scrollToItemAtIndexPath:[self lastIndexPath] atScrollPosition:UICollectionViewScrollPositionBottom animated:NO];
    
    UITapGestureRecognizer *titleBarTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(titleTapHandler:)];
    
    [titleNavigationItem.titleView addGestureRecognizer:titleBarTap];
}

- (void)titleTapHandler:(UITapGestureRecognizer*)recognizer {
    NSLog(@"Tap Title");
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionBottom animated:YES];
}


#pragma mark -
#pragma mark Sharing to Dropbox and Email
#pragma mark -

- (void)fileViewActions:(UILongPressGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateBegan) {
        NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:[gesture locationInView:self.collectionView]];
        if (indexPath != nil) {
            self.currentIndexPath = indexPath;
            
            [TestFlight passCheckpoint:@"File View Action Sheet"];
            
            UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                          initWithTitle:nil
                                          delegate:self
                                           cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                           destructiveButtonTitle:NSLocalizedString(@"Delete", nil)
                                           otherButtonTitles:NSLocalizedString(@"Share to Dropbox", nil), NSLocalizedString(@"Share as Email", nil), nil];
            
            actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
            UICollectionViewCell *itemCell = [self.collectionView cellForItemAtIndexPath:indexPath];
            [actionSheet showFromRect:CGRectMake(0, 0, itemCell.frame.size.width, itemCell.frame.size.height) inView:itemCell animated:YES];
        }
    }
}

#pragma mark -
#pragma mark UIActionSheetDelegate
#pragma mark -

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            [self delete:self];
            break;
        case 1:
            [self shareToDropbox];
            break;
        case 2:
            [self shareAsEmail];
            break;
    default:
        break;
    }
}

#pragma mark -
#pragma mark Dropbox share
#pragma mark -

- (void)shareToDropbox {
    if (![[DBSession sharedSession] isLinked]) {
        [TestFlight passCheckpoint:@"Linking to Dropbox"];

        [[DBSession sharedSession] linkFromController:[self.navigationController.viewControllers objectAtIndex:0]];
    } else {
        [TestFlight passCheckpoint:@"Linked to Dropbox & Sharing"];

        DZProgressController *hud = [[DZProgressController alloc] init];
        [hud setMode:DZProgressControllerModeDeterminate];
        [hud show];
        [self uploadCompositionToDropbox:hud];
    }
}

- (void)uploadCompositionToDropbox:(DZProgressController*)hud {
    NSString *filename = [[self listFiles] objectAtIndex:currentIndexPath.item];
    NSString *svgFilename = [[[self listFiles] objectAtIndex:currentIndexPath.item] stringByAppendingPathExtension:@"svg"];
    
    BOOL hasArcMachine = [[NSFileManager defaultManager] fileExistsAtPath:[ODFileTools fullPath:filename documentsFolder:@"arcmachines"]];
    BOOL hasSvg = [[NSFileManager defaultManager] fileExistsAtPath:[ODFileTools fullPath:svgFilename documentsFolder:@"svg"]];
    
    if (hasArcMachine) {
        [DropBlocks uploadFile:filename toPath:@"/"
                 withParentRev:nil fromPath:[ODFileTools fullPath:filename documentsFolder:@"arcmachines"]
               completionBlock:^(DBMetadata *metadata, NSError *error) {
                   if(hasSvg) {
                       [self uploadSvgToDropbox:hud];
                   } else {
                       [hud hide];
                       [TestFlight passCheckpoint:@"Shared as .arcmachine to Dropbox"];
                   }
               } progressBlock:^(CGFloat progress) {
                   hud.progress = progress;
               }];
        
    } else if (hasSvg) {
        [self uploadSvgToDropbox:hud];
    }
}

- (void)uploadSvgToDropbox:(DZProgressController*)HUD {
    NSString *filename = [[[self listFiles] objectAtIndex:currentIndexPath.item] stringByAppendingPathExtension:@"svg"];
    HUD.progress = 0;
    [DropBlocks uploadFile:filename toPath:@"/"
             withParentRev:nil fromPath:[ODFileTools fullPath:filename documentsFolder:@"svg"]
           completionBlock:^(DBMetadata *metadata, NSError *error) {
               [HUD hide];
               [TestFlight passCheckpoint:@"ArcMachine and SVG uploaded to Dropbox"];
           } progressBlock:^(CGFloat progress) {
               HUD.progress = progress;
           }];
}

#pragma mark -
#pragma mark Email share
#pragma mark -

- (void)shareAsEmail {

    [TestFlight passCheckpoint:@"Email sharing"];
    
    if( [MFMailComposeViewController canSendMail] ) {
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc]init];
        mailer.mailComposeDelegate = self;
        
        NSString *filename = [[self listFiles] objectAtIndex:currentIndexPath.item];
        NSString *svgFilename = [[[self listFiles] objectAtIndex:currentIndexPath.item] stringByAppendingPathExtension:@"svg"];
        
        BOOL hasArcMachine = [[NSFileManager defaultManager] fileExistsAtPath:[ODFileTools fullPath:filename documentsFolder:@"arcmachines"]];
        BOOL hasSvg = [[NSFileManager defaultManager] fileExistsAtPath:[ODFileTools fullPath:svgFilename documentsFolder:@"svg"]];
        BOOL hasJson = [[NSFileManager defaultManager] fileExistsAtPath:[ODFileTools fullPath:filename documentsFolder:@"json"]];
        
        [mailer setSubject:NSLocalizedString(@"My Shiny New ArcMachine", nil)];
        
        if (hasSvg) {
            [mailer addAttachmentData:[ODFileTools
                                       loadNSData:svgFilename
                                       documentsFolder:@"svg"]
                             mimeType:@"image/svg+xml"
                             fileName:svgFilename];
        }
        if (hasJson) {
            [mailer addAttachmentData:[ODFileTools
                                       loadNSData:filename
                                       documentsFolder:@"json"]
                             mimeType:@"application/octet-stream"
                             fileName:[@"json-" stringByAppendingString:filename]];
        }
        if (hasArcMachine) {
            [mailer addAttachmentData:[ODFileTools
                                       loadNSData:filename
                                       documentsFolder:@"arcmachines"]
                             mimeType:@"application/octet-stream"
                             fileName:filename];
        }
        
        [self presentViewController:mailer animated:YES completion:^{
        }];
    } else {
        [[TKAlertCenter defaultCenter] postAlertWithMessage:@"Cannot Send Email"];
    }
}

#pragma mark -
#pragma mark MFMailComposeViewControllerDelegate
#pragma mark -

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
	switch (result)
	{
		case MFMailComposeResultCancelled:
          [[TKAlertCenter defaultCenter] postAlertWithMessage:NSLocalizedString(@"Email Cancelled", nil)];
            [TestFlight passCheckpoint:@"Email Cancelled"];

			break;
		case MFMailComposeResultSaved:
          [[TKAlertCenter defaultCenter] postAlertWithMessage:NSLocalizedString(@"Email Saved", nil)];
            [TestFlight passCheckpoint:@"Email Saved"];

			break;
		case MFMailComposeResultSent:
          [[TKAlertCenter defaultCenter] postAlertWithMessage:NSLocalizedString(@"Email Sent", nil)];
            [TestFlight passCheckpoint:@"Email Sent"];

			break;
		case MFMailComposeResultFailed:
          [[TKAlertCenter defaultCenter] postAlertWithMessage:NSLocalizedString(@"Email Failed", nil)];
            [TestFlight passCheckpoint:@"Email Failed"];

			break;
		default:
          [[TKAlertCenter defaultCenter] postAlertWithMessage:NSLocalizedString(@"Email Not Sent", nil)];
            [TestFlight passCheckpoint:@"Email Not Sent"];
            
			break;
	}
	[controller dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -
#pragma mark Delete
#pragma mark -

- (void)delete:(id)sender {
    
    [self.collectionView performBatchUpdates:^{
        
        NSString *filename = [[self fileList] objectAtIndex:currentIndexPath.item];
        NSString *fullpath = [[ODFileTools documentsFolder:@"arcmachines"] stringByAppendingPathComponent:filename];
        [self deleteFile:fullpath];
        
        [fileList removeObjectAtIndex:currentIndexPath.item];
        [self.collectionView deleteItemsAtIndexPaths:@[currentIndexPath]];
        
    } completion:nil];
    
}

- (void) deleteFile:(NSString *)fullpath {
    
    NSError *error;
    [[NSFileManager defaultManager] removeItemAtPath:fullpath error:&error];
    if(error)
    {
      [[TKAlertCenter defaultCenter] postAlertWithMessage:NSLocalizedString(@"Failed to delete", nil)];
        [TestFlight passCheckpoint:@"Delete fail"];

    } else {
      [[TKAlertCenter defaultCenter] postAlertWithMessage:NSLocalizedString(@"Deleted", nil)];
        [TestFlight passCheckpoint:@"Deleted arcmachine"];
    }
}

#pragma mark -
#pragma mark UICollectionViewDataSource
#pragma mark -

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return fileList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ODFilesCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    NSString *filename = [[self fileList] objectAtIndex:indexPath.row];
    cell.imageView.image = [self loadThumbnail:filename];
    return cell;
}

#pragma mark -
#pragma mark UICollectionView delegate
#pragma mark -

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *selectedFilename = [[self fileList] objectAtIndex:indexPath.item];
    [TestFlight passCheckpoint:@"File view item selected"];

    [[NSNotificationCenter defaultCenter] postNotificationName:@"selectFileToLoad" object:selectedFilename];
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)canPerformUnwindSegueAction:(SEL)action fromViewController:(UIViewController *)fromViewController withSender:(id)sender {
    return YES;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

#pragma mark -
#pragma mark Utility methods
#pragma mark -

-(UIImage *)loadThumbnail:(NSString *)filename {
    @try {
        NSString *fullPath =  [[ODFileTools documentsFolder:@"arcmachines"] stringByAppendingPathComponent:filename];
        ODArcConstruktDocument *file = [NSKeyedUnarchiver unarchiveObjectWithFile:fullPath];
        return file.thumbnail;
    }
    @catch (NSException *exception) {
        return nil;
    }
}

-(NSArray *)listFiles {
    NSArray *directoryContent = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[ODFileTools documentsFolder:@"arcmachines"] error:NULL];
    return directoryContent;
}

- (NSIndexPath*)lastIndexPath {
    NSInteger sectionsAmount = [[self collectionView] numberOfSections];
    NSInteger rowsAmount = [[self collectionView] numberOfItemsInSection:sectionsAmount-1];
    NSIndexPath *lastIndexPath = [NSIndexPath indexPathForRow:(rowsAmount - 1) inSection:(sectionsAmount - 1)];
    return lastIndexPath;
}

#pragma mark -
#pragma mark Handle Memory Warning
#pragma mark -

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
