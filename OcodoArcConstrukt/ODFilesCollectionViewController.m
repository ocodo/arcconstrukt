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
        [[TKAlertCenter defaultCenter] postAlertWithMessage:@"No ArcConstrukt saved yet"];
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
                                          otherButtonTitles:nil];
            actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
            
            UICollectionViewCell *itemCell = [self.collectionView cellForItemAtIndexPath:indexPath];
            [actionSheet showFromRect:CGRectMake(0, 0, itemCell.frame.size.width, itemCell.frame.size.height) inView:itemCell animated:YES];
        }
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSLog(@"Button: %i : %@", buttonIndex, [actionSheet buttonTitleAtIndex:buttonIndex]);
    if(buttonIndex == 0)
    {
        [self delete:currentIndexPath];
    }
}

#pragma mark - delete
- (void)delete:(id)sender {
    
    [self.collectionView performBatchUpdates:^{
        
        NSString *filename = [[self fileList] objectAtIndex:currentIndexPath.item];
        NSString *fullpath = [[self compositionsDirectory] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", filename]];
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

- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

#pragma mark - utility methods

-(UIImage *)loadThumbnail:(NSString *)filename {
    NSString *fullPath =  [[self compositionsDirectory] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", filename]];
    ODArcConstruktFile *file = [NSKeyedUnarchiver unarchiveObjectWithFile:fullPath];
    return file.thumbnail;
}

-(NSArray *)listFiles
{
    NSArray *directoryContent = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[self compositionsDirectory] error:NULL];
    return directoryContent;
}

-(NSString *) compositionsDirectory {
    
    NSString *docs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *compositions = [docs stringByAppendingPathComponent:@"compositions"];
    
    NSFileManager *fm = [NSFileManager defaultManager];
    
    if(![fm fileExistsAtPath:compositions]) {
        NSError *error;
        [fm createDirectoryAtPath:compositions withIntermediateDirectories:NO attributes:nil error:&error];
    }
    
    return compositions;
}

@end
