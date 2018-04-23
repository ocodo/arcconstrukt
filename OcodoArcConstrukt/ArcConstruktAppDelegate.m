//
//  ArcConstruktAppDelegate.m
//  ArcConstrukt
//
//  Created by jason on 25/10/12.
//  Copyright (c) 2012 ocodo. All rights reserved.
//

#import "ArcConstruktAppDelegate.h"

#import <DropboxSDK/DropboxSDK.h>

@implementation ArcConstruktAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

  // Dropbox api authentication and session set up.
  NSString* appKey = @"DROPBOX_APP_KEY";
  NSString* appSecret = @"DROPBOX_APP_SECRET";
  NSString *root = kDBRootAppFolder;
  DBSession* dbSession = [[DBSession alloc] initWithAppKey:appKey appSecret:appSecret root:root];
  [DBSession setSharedSession:dbSession];

  // Testflight SDK integration:
  [TestFlight setDeviceIdentifier:  [[UIDevice currentDevice] uniqueIdentifier]];
  [TestFlight takeOff:@"TESTFLIGHT_TAKEOFF_KEY"];
  [TestFlight passCheckpoint:@"App start-up"];

  return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
  if ([[DBSession sharedSession] handleOpenURL:url]) {
    if ([[DBSession sharedSession] isLinked]) {
      // linked to Dropbox
    }
    return YES;
  }

  if([url isFileURL]) {
    [ODApplicationState sharedinstance].startUrl = url;
    return YES;
  }
  return NO;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
  NSLog(@"becoming inactive");
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
  NSLog(@"going to background");
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
  NSLog(@"becoming active");
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
  ODArcConstruktViewController *arcConstrukt = (ODArcConstruktViewController *)[_viewControllers objectForKey:@"construktView"];

  NSArray *urlParts = [[ODApplicationState sharedinstance].startUrl pathComponents];
  NSString *ext = [[ODApplicationState sharedinstance].startUrl pathExtension];

  if ([ext isEqualToString:@"arcmachine"]) {
    NSString *folder = [urlParts objectAtIndex:urlParts.count-2];
    NSString *filename = [urlParts objectAtIndex:urlParts.count-1];
    [arcConstrukt loadComposition:filename withFolder:folder];
    [ODApplicationState sharedinstance].startUrl = nil;
  }

  if ([ext isEqualToString:@"jsonarcmachine"]) {
    NSString *folder = [urlParts objectAtIndex:urlParts.count-2];
    NSString *filename = [urlParts objectAtIndex:urlParts.count-1];
    [arcConstrukt loadJSONComposition:filename withFolder:folder];
    [ODApplicationState sharedinstance].startUrl = nil;
  }

  // handle other file types... as neccessary.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
  NSLog(@"shutting down");
}

- (void)registerViewController:(NSString *)name controller:(UIViewController *)controller
{
  if(_viewControllers == nil)
    _viewControllers = [[NSMutableDictionary alloc] init];

  [_viewControllers setObject:controller forKey:name];
}

@end
