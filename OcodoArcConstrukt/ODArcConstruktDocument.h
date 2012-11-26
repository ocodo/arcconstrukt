//
//  ODArcConstruktFile.h
//  OcodoArcConstrukt
//
//  Created by jason on 10/11/12.
//  Copyright (c) 2012 ocodo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ODArcMachine.h"
#import "TKAlertCenter.h"
#import "DZProgressController.h"
#import "NSData+Base64.h"

@interface ODArcConstruktDocument : NSObject <NSCoding>

@property (strong, nonatomic) NSMutableArray *layers;
@property (strong, nonatomic) UIImage *thumbnail;
@property (strong, nonatomic) NSString *filename;

- (id)initWithArcMachineSubviews:(NSArray*)subviews;
- (id)initWithJSONData:(NSData*)data;
- (id)initWithJSON:(NSString*)json;

- (NSData*)asSVGEncoded;
- (NSData*)asJSONEncoded;
- (NSString*)asSVG;
- (NSArray*)layersToArcMachines;

@end
