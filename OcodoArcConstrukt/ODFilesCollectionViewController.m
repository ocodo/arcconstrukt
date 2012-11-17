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

@synthesize currentIndexPath, fileList;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if([[self listFiles] count] < 1) {
        [[TKAlertCenter defaultCenter] postAlertWithMessage:@"No ArcMachines saved yet"];
        return;
    }
    
    // set tiled background.
    self.collectionView.backgroundColor = [
                                   UIColor colorWithPatternImage:
                                   [UIImage imageNamed:@"outlets@2x.png"]];
    
    fileList = [[NSMutableArray alloc] initWithArray:[self listFiles]];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    [self.collectionView addGestureRecognizer:longPress];
}

- (void)handleLongPress:(UILongPressGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateBegan) {
        NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:[gesture locationInView:self.collectionView]];
        if (indexPath != nil) {
            self.currentIndexPath = indexPath;
            
            UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                          initWithTitle:nil
                                          delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          destructiveButtonTitle:@"Delete"
                                          otherButtonTitles:@"Share to Dropbox", @"Share as Email", nil];
            
            actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
            UICollectionViewCell *itemCell = [self.collectionView cellForItemAtIndexPath:indexPath];
            [actionSheet showFromRect:CGRectMake(0, 0, itemCell.frame.size.width, itemCell.frame.size.height) inView:itemCell animated:YES];
        }
    }
}

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

#pragma mark - sharing

- (void)shareToDropbox {
    if (![[DBSession sharedSession] isLinked]) {
        [[DBSession sharedSession] linkFromController:[self.navigationController.viewControllers objectAtIndex:0]];
    } else {
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
               [[TKAlertCenter defaultCenter] postAlertWithMessage:@"ArcMachine and SVG uploaded to Dropbox"];
           } progressBlock:^(CGFloat progress) {
               HUD.progress = progress;
           }];
}

- (void)shareAsEmail {
    if( [MFMailComposeViewController canSendMail] ) {
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc]init];
        mailer.mailComposeDelegate = self;
        
        NSString *filename = [[self listFiles] objectAtIndex:currentIndexPath.item];
        NSString *svgFilename = [[[self listFiles] objectAtIndex:currentIndexPath.item] stringByAppendingPathExtension:@"svg"];

        BOOL hasArcMachine = [[NSFileManager defaultManager] fileExistsAtPath:[ODFileTools fullPath:filename documentsFolder:@"arcmachines"]];
        BOOL hasSvg = [[NSFileManager defaultManager] fileExistsAtPath:[ODFileTools fullPath:svgFilename documentsFolder:@"svg"]];

        [mailer setSubject:@"My Shiny New ArcMachine"];
        
        if (hasArcMachine) {
            [mailer addAttachmentData:[ODFileTools
                                       loadNSData:svgFilename
                                       documentsFolder:@"svg"]
                             mimeType:@"image/svg+xml"
                             fileName:svgFilename];
        }
        if (hasSvg) {
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

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
	switch (result)
	{
		case MFMailComposeResultCancelled:
			[[TKAlertCenter defaultCenter] postAlertWithMessage:@"Email Cancelled"];
			break;
		case MFMailComposeResultSaved:
			[[TKAlertCenter defaultCenter] postAlertWithMessage:@"Email Saved"];
			break;
		case MFMailComposeResultSent:
			[[TKAlertCenter defaultCenter] postAlertWithMessage:@"Email Sent"];
			break;
		case MFMailComposeResultFailed:
			[[TKAlertCenter defaultCenter] postAlertWithMessage:@"Email Failed"];
			break;
		default:
			[[TKAlertCenter defaultCenter] postAlertWithMessage:@"Email Not Sent"];
			break;
	}
	[controller dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - delete
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
        [[TKAlertCenter defaultCenter] postAlertWithMessage:@"Failed to delete"];
    } else {
        [[TKAlertCenter defaultCenter] postAlertWithMessage:@"Deleted"];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UICollectionViewDataSource

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

#pragma mark - collection view delegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *selectedFilename = [[self fileList] objectAtIndex:indexPath.item];
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

#pragma mark - utility methods

-(UIImage *)loadThumbnail:(NSString *)filename {
    @try {
        NSString *fullPath =  [[ODFileTools documentsFolder:@"arcmachines"] stringByAppendingPathComponent:filename];
        ODArcConstruktFile *file = [NSKeyedUnarchiver unarchiveObjectWithFile:fullPath];
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

@end
