//
//  ODFileTools.m
//
//  Created by jason on 16/11/12.
//  Copyright (c) 2012 ocodo. All rights reserved.
//

#import "ODFileTools.h"
#import "TKAlertCenter.h"

@implementation ODFileTools

+ (void) save:(NSString *)filename documentsFolder:(NSString*)folder data:(NSData*)data {
    [[NSFileManager defaultManager] createFileAtPath:[ODFileTools fullPath:filename documentsFolder:folder] contents:data attributes:nil];
}

+ (void) save:(NSString *)filename extension:(NSString*)extension documentsFolder:(NSString*)folder data:(NSData*)data {
    [[NSFileManager defaultManager] createFileAtPath:[ODFileTools fullPath:filename extension:extension documentsFolder:folder] contents:data attributes:nil];
}

+ (id) load:(NSString *)filename documentsFolder:(NSString*)folder {
    return [NSKeyedUnarchiver unarchiveObjectWithFile:[ODFileTools fullPath:filename documentsFolder:folder]];
}

+ (NSData*) loadNSData:(NSString *)filename documentsFolder:(NSString*)folder {
    return [NSData dataWithContentsOfFile:[ODFileTools fullPath:filename documentsFolder:folder]];
}

+ (id) load:(NSString *)filename extension:(NSString*)extension documentsFolder:(NSString*)folder {
    return [NSKeyedUnarchiver unarchiveObjectWithFile:[ODFileTools fullPath:filename extension:extension documentsFolder:folder]];
}

+ (void) delete:(NSString *)filename documentsFolder:(NSString*)folder {
    NSError *error = [ODFileTools delete:[ODFileTools fullPath:filename documentsFolder:folder]];
    if(error) {
        [[TKAlertCenter defaultCenter] postAlertWithMessage:[NSString stringWithFormat:@"There was a problem deleting : %@", filename]];
    } else {
        [[TKAlertCenter defaultCenter] postAlertWithMessage:[NSString stringWithFormat:@"Deleted : %@", filename]];
    }
}

+ (void) delete:(NSString *)filename extension:(NSString*)extension documentsFolder:(NSString*)folder {
    NSError *error = [ODFileTools delete:[ODFileTools fullPath:filename documentsFolder:folder]];
    if(error) {
        [[TKAlertCenter defaultCenter] postAlertWithMessage:[NSString stringWithFormat:@"There was a problem deleting : %@", filename]];
    } else {
        [[TKAlertCenter defaultCenter] postAlertWithMessage:[NSString stringWithFormat:@"Deleted : %@", filename]];
    }
}

+ (NSError*) delete:(NSString *)fullpath {
    NSError *error;
    [[NSFileManager defaultManager] removeItemAtPath:fullpath error:&error];
    return error;
}

+ (NSString*) documentsFolder:(NSString*)folder {
    NSString *docs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *docsFolder = [docs stringByAppendingPathComponent:folder];
    NSFileManager *fm = [NSFileManager defaultManager];
    
    if(![fm fileExistsAtPath:docsFolder]) {
        NSError *error;
        [fm createDirectoryAtPath:docsFolder withIntermediateDirectories:NO attributes:nil error:&error];
    }

    return docsFolder;
}

+ (NSString*) fullPath:(NSString*)filename documentsFolder:(NSString*)folder {
    NSString *docsFolder = [ODFileTools documentsFolder:folder];
    return [docsFolder stringByAppendingPathComponent:filename];
}

+ (NSString*) fullPath:(NSString*)filename extension:(NSString*)extension documentsFolder:(NSString*)folder {
    NSString *docsFolder = [ODFileTools documentsFolder:folder];
    return [[docsFolder stringByAppendingPathComponent:filename] stringByAppendingPathExtension:extension];
}

@end
