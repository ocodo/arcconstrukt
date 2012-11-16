//
//  ODFilesCollectionViewController.h
//  OcodoArcConstrukt
//
//  Created by jason on 10/11/12.
//  Copyright (c) 2012 ocodo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DropboxSDK/DropboxSDK.h>
#import <MessageUI/MessageUI.h>

#import "ODFilesCollectionViewCell.h"
#import "ODArcConstruktFile.h"
#import "TKAlertCenter.h"
#import "DropBlocks.h"
#import "ODFileTools.h"
#import "DZProgressController.h"

@interface ODFilesCollectionViewController : UICollectionViewController <MFMailComposeViewControllerDelegate>

@property NSIndexPath *currentIndexPath;
@property NSMutableArray *fileList;

@end
