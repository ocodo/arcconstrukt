//
//  ODArcConstruktFile.h
//  OcodoArcConstrukt
//
//  Created by jason on 10/11/12.
//  Copyright (c) 2012 ocodo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ODArcMachine.h"

@interface ODArcConstruktFile : NSObject <NSCoding>

@property (strong, nonatomic) NSMutableArray *layers;
@property (strong, nonatomic) UIImage *thumbnail;
@property (strong, nonatomic) NSString *filename;

@end
