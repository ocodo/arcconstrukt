//
//  ODArcConstruktFile.m
//  OcodoArcConstrukt
//
//  Created by jason on 10/11/12.
//  Copyright (c) 2012 ocodo. All rights reserved.
//

#import "ODArcConstruktFile.h"
#import "TKAlertCenter.h"
#import "DZProgressController.h"

@implementation ODArcConstruktFile 

@synthesize thumbnail, filename, layers;

- (void) encodeWithCoder:(NSCoder *) coder {
    NSData *imageData = UIImagePNGRepresentation(thumbnail);
    [coder encodeObject:imageData forKey:@"thumbnail"];
    [coder encodeObject:layers forKey:@"layers"];
    [coder encodeObject:filename forKey:@"filename"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if(self) {
        filename = [decoder decodeObjectForKey:@"filename"];
        NSData *imageData = [decoder decodeObjectForKey:@"thumbnail"];
        thumbnail = [UIImage imageWithData:imageData];
        layers = [decoder decodeObjectForKey:@"layers"];
    }
    return self;
}

- (id)initWithArcMachineSubviews:(NSArray*)subviews {
    self = [super init];
    if (self) {
        layers = [[NSMutableArray alloc] init];
        for (ODArcMachine *arcMachine in subviews) {
                [layers addObject:[arcMachine geometryToDictionary]];
        }
    }
    return self;
}

- (NSData*)asSVGEncoded {
    return [[self asSVG] dataUsingEncoding:NSUTF8StringEncoding];
}

- (NSString *)asSVG {
    NSMutableArray *a = [[NSMutableArray alloc] initWithArray:
                         @[@"<svg xmlns=\"http://www.w3.org/2000/svg\" viewBox=\"0 0 320 320\">",
                         @"<g transform=\"translate(160,160)\">"]];
    
    for (NSDictionary *plist in layers) {
        ODArcMachine *arcMachine = [[ODArcMachine alloc] initWithDictionary:plist frame:CGRectMake(0, 0, 320, 320)];
        [a addObject:[arcMachine SVGArc]];
    }
    
    [a addObjectsFromArray:@[@"</g>", @"</svg>"]];
    return [a componentsJoinedByString:@"\n"];
}

- (NSArray *)layersToArcMachines {
    NSMutableArray *a = [[NSMutableArray alloc] init];
    for (NSDictionary *plist in layers) {
        ODArcMachine *arcMachine = [[ODArcMachine alloc] initWithDictionary:plist frame:CGRectMake(0, 0, 320, 320)];
        [a addObject:arcMachine];
    }
    return [[NSArray alloc] initWithArray:a];
}

@end
