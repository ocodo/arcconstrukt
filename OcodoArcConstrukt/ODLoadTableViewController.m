//
//  ODLoadTableViewController.m
//  OcodoArcConstrukt
//
//  Created by jason on 9/11/12.
//  Copyright (c) 2012 ocodo. All rights reserved.
//

#import "ODLoadTableViewController.h"

@interface ODLoadTableViewController ()

@end

@implementation ODLoadTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self listFiles] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ArcCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.textLabel.text = [[self listFiles] objectAtIndex:[indexPath row]];
    return cell;
}

-(NSArray *)listFiles
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSArray *directoryContent = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentsDirectory error:NULL];
    return directoryContent;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *selectedFilename = [[self listFiles] objectAtIndex:indexPath.row];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"selectFileToLoad" object:selectedFilename];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
