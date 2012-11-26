//
//  ODArcConstruktFile.m
//  OcodoArcConstrukt
//
//  Created by jason on 10/11/12.
//  Copyright (c) 2012 ocodo. All rights reserved.
//

#import "ODArcConstruktDocument.h"

@implementation ODArcConstruktDocument

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

#pragma json

- (id)initWithJSONData:(NSData *)data {
    return [self initWithJSON:[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]];
}

- (id)initWithJSON:(NSString*)json {
    @try {
        self = [super init];
        if (self) {
            NSError *error;
            
            NSDictionary *fileDict = [NSJSONSerialization
                                      JSONObjectWithData:[json
                                                          dataUsingEncoding:
                                                          NSUTF8StringEncoding]
                                      options:0
                                      error:&error];

            self.layers = [[NSMutableArray alloc] init];
            
            if(error) {
                NSLog(@"JSON Error loading:%@", error);
                [[TKAlertCenter defaultCenter] postAlertWithMessage:[NSString stringWithFormat:NSLocalizedString(@"Failed to load %@", nil), @"[JSON 007]"]];
            }
            
            for (id obj in [fileDict valueForKey:@"layers"]) {
                NSDictionary *plist = (NSDictionary*)obj;
                [self.layers addObject:plist];
            }
            
            if(error) {
                NSLog(@"JSON Error creating layers:%@", error);
                [[TKAlertCenter defaultCenter] postAlertWithMessage:[NSString stringWithFormat:NSLocalizedString(@"Failed to load %@", nil), @"[JSON 008]"]];
            }
        }        
        return self;
    }
    @catch (NSException *exception) {
        NSLog(@"%@", exception);
        [[TKAlertCenter defaultCenter] postAlertWithMessage:[NSString stringWithFormat:NSLocalizedString(@"Failed to load %@", nil), @""]];
        return nil;
    }
    
}

- (NSString*)layersAsJSON {
    NSMutableArray *arrayOfDicts = [[NSMutableArray alloc] init];
    
    for (ODArcMachine* arc in [self layersToArcMachines]) {
        [arrayOfDicts addObject:[arc geometryToDictionary]];
    }
    
    NSError *error;
    NSArray *data = [NSArray arrayWithArray:arrayOfDicts];
    
    return [[NSString alloc] initWithData:[NSJSONSerialization
                                           dataWithJSONObject:data
                                           options:0
                                           error:&error] encoding:NSUTF8StringEncoding];
}

- (NSData*)asJSONEncoded {
    
    NSDictionary *fileDict = @{
    @"layers" : layers
    };
    
    NSError *error;
    
    return [NSJSONSerialization
             dataWithJSONObject:fileDict
             options:0
             error:&error];
}

#pragma svg

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
