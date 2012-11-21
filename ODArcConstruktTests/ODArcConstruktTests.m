//
//  ODArcConstruktTests.m
//  ODArcConstruktTests
//
//  Created by jason on 21/11/12.
//  Copyright (c) 2012 ocodo. All rights reserved.
//

#import "ODArcConstruktTests.h"

@implementation ODArcConstruktTests

- (void)setUp
{
    [super setUp];
    testMachine = [self randomArcMachine];
    STAssertNotNil(testMachine, @"Failed to set up test ArcMachine");
    
    testDocument = [self randomDocument];
    STAssertNotNil(testDocument, @"Failed to setup test ArcMachine Document");
}
                
- (ODArcConstruktDocument*)randomDocument {

    ODArcConstruktDocument *doc = [[ODArcConstruktDocument alloc] init];
    doc.filename = @"testdoc";
    doc.layers = [NSMutableArray new];
    for(int i=0; i<7; i++) {
        [doc.layers addObject:[self randomArcMachine]];
    }
    
    return doc;
}

- (ODArcMachine*)randomArcMachine {
    ODArcMachine *a = [
                       [ODArcMachine alloc]
                       initRandomWithFrame:CGRectMake(0,0,320,320)
                       fillColor:[UIColor colorWithRGBHexString:@"FFFFFF"]
                       strokeColor:[UIColor colorWithRGBHexString:@"000000"]
                       ];
    return a;
}

- (void)tearDown
{
    // Tear-down code here.
    testMachine = nil;
    testDocument = nil;
    [super tearDown];
}

//- (void) testArcMachineToJSON {
//
//    NSData *json = [testDocument asJSONEncoded];
//    
//    NSString *jsonString = [[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding];
//
//    NSLog(@" JSON : %@", jsonString);
//    // NSLog(@" NSData : %@", json);
//    
//    STAssertNotNil(json, @"Failed to create JSON version of Arc Document");
//}

- (void)testArcSaveJsonLoadJson {
    ODArcMachine *arcMachine = [self randomArcMachine];
    arcMachine.start = 3.141592653589793;
    arcMachine.end = 0;
    arcMachine.radius = 30;
    arcMachine.thickness = 25;
    
    ODArcConstruktDocument *doc = [ODArcConstruktDocument new];
    
    doc.layers = [NSMutableArray new];
    
    [doc.layers addObject:[arcMachine geometryToDictionary]];

    NSData *jsonData = [doc asJSONEncoded];
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSError *error;
    
    NSMutableArray *arr = [[NSMutableArray alloc]
                           initWithArray:[NSJSONSerialization
                                          JSONObjectWithData:jsonData
                                          options:NSJSONReadingAllowFragments |
                                          NSJSONReadingMutableContainers
                                          error:&error]];

    NSLog(@"%@", arr[0]);
}

@end
