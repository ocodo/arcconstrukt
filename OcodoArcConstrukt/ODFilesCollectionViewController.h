//
//  ODFilesCollectionViewController.h
//  OcodoArcConstrukt
//
//  Created by jason on 10/11/12.
//  Copyright (c) 2012 ocodo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ODFilesCollectionViewCell.h"
#import "ODArcConstruktFile.h"
#import "TKAlertCenter.h"

@interface ODFilesCollectionViewController : UICollectionViewController <UIActionSheetDelegate>

@property NSIndexPath *currentIndexPath;
@property NSMutableArray *fileList;

@end
