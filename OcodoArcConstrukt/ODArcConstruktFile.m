//
//  ODArcConstruktFile.m
//  OcodoArcConstrukt
//
//  Created by jason on 10/11/12.
//  Copyright (c) 2012 ocodo. All rights reserved.
//

#import "ODArcConstruktFile.h"

@implementation ODArcConstruktFile 

@synthesize thumbnail, filename, layers;

-(void) encodeWithCoder:(NSCoder *) coder {
    NSData *imageData = UIImagePNGRepresentation(thumbnail);
    [coder encodeObject:imageData forKey:@"thumbnail"];
    [coder encodeObject:layers forKey:@"layers"];
    [coder encodeObject:filename forKey:@"filename"];
}

-(id)initWithCoder:(NSCoder *)decoder {
    
    if(self) {
        filename = [decoder decodeObjectForKey:@"filename"];
        NSData *imageData = [decoder decodeObjectForKey:@"thumbnail"];
        thumbnail = [UIImage imageWithData:imageData];
        layers = [decoder decodeObjectForKey:@"layers"];
    }
    
    return self;
}

@end
