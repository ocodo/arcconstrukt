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
    testJSONConvertedMachine = [self sampleJSONConversion];
    STAssertNotNil(testJSONConvertedMachine, @"Failed to set up test ArcMachine");
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
                       fillColor:[UIColor colorWithRGBHexString:@"ffffff"]
                       strokeColor:[UIColor colorWithRGBHexString:@"000000"]
                       ];
    return a;
}

- (ODArcConstruktDocument *) sampleJSONDocument {
    ODArcMachine *arcMachine = [self randomArcMachine];
    arcMachine.start = 3.141593; // JSONSerializer rounds to 6 places.
    arcMachine.end = 0;
    arcMachine.radius = 30;
    arcMachine.thickness = 25;
    ODArcConstruktDocument *doc = [ODArcConstruktDocument new];
    doc.filename = @"test.arcmachine";
    doc.layers = [[NSMutableArray alloc] init];
    [doc.layers addObject:[arcMachine geometryToDictionary]];
    return doc;
}

- (NSString*) jsonSampleDoc2 {
    
    return @"{\"layers\" :[{\"radius\" :  36,   \"thickness\" :28,  \"start\" : 0.6108652381980153, \"end\" : 5.532693728822025,  \"fillhexrgba\" : \"#1D181FFF\", \"strokehexrgba\" : \"#00000000\"}, {\"radius\" :  38,   \"thickness\" :27,  \"start\" : 1.6580627893946132, \"end\" : 3.9968039870670147, \"fillhexrgba\" : \"#3B424CFF\", \"strokehexrgba\" : \"#00000000\"}, {\"radius\" :  46,   \"thickness\" :15,  \"start\" : 3.7873644768276953, \"end\" : 4.590215932745087,  \"fillhexrgba\" : \"#3B424CFF\", \"strokehexrgba\" : \"#00000000\"}, {\"radius\" :  68,   \"thickness\" :27,  \"start\" : 4.537856055185257,  \"end\" : 2.8099800957108707, \"fillhexrgba\" : \"#306E73FF\", \"strokehexrgba\" : \"#00000000\"}, {\"radius\" :  68,   \"thickness\" :3,   \"start\" : 3.141592653589793,  \"end\" : 1.7627825445142729, \"fillhexrgba\" : \"#306E73FF\", \"strokehexrgba\" : \"#00000000\"}, {\"radius\" :  95,   \"thickness\" :32,  \"start\" : 6.021385919380437,  \"end\" : 1.117010721276371,  \"fillhexrgba\" : \"#B29C85FF\", \"strokehexrgba\" : \"#00000000\"}, {\"radius\" : 109,   \"thickness\" :27,  \"start\" : 4.939281783143953,  \"end\" : 5.689773361501515,  \"fillhexrgba\" : \"#B29C85FF\", \"strokehexrgba\" : \"#00000000\"}, {\"radius\" : 123,   \"thickness\" :35,  \"start\" : 5.218534463463046,  \"end\" : 1.8151424220741028, \"fillhexrgba\" : \"#B29C85FF\", \"strokehexrgba\" : \"#00000000\"}, {\"radius\" : 141,   \"thickness\" :9,   \"start\" : 1.8675022996339325, \"end\" : 2.2689280275926285, \"fillhexrgba\" : \"#FF5335FF\", \"strokehexrgba\" : \"#00000000\"}, {\"radius\" : 151,   \"thickness\" :8,   \"start\" : 3.8048177693476384, \"end\" : 1.0122909661567112, \"fillhexrgba\" : \"#FF5335FF\", \"strokehexrgba\" : \"#00000000\"}, {\"radius\" : 154,   \"thickness\" :7,   \"start\" : 5.340707511102648,  \"end\" : 5.113814708343385,  \"fillhexrgba\" : \"#FF5335FF\", \"strokehexrgba\" : \"#00000000\"}]}";
    
}

- (NSString*) jsonSampleDoc {
    return @"{\"layers\":[{\"radius\":100.9645,\"stroke\":{\"r\":0.2039216,\"b\":0.2196078,\"g\":0.2196078,\"a\":0},\"end\":-0.1857681,\"fill\":{\"r\":0.9294118,\"b\":0.9333333,\"g\":0.9647059,\"a\":1},\"thickness\":11.55372,\"start\":4.125194},{\"radius\":124.2789,\"stroke\":{\"r\":0.2039216,\"b\":0.2196078,\"g\":0.2196078,\"a\":0},\"end\":-1.283426,\"fill\":{\"r\":0,\"b\":0.4196078,\"g\":0.372549,\"a\":1},\"thickness\":23,\"start\":2.381765},{\"radius\":102.0465,\"stroke\":{\"r\":0.2039216,\"b\":0.2196078,\"g\":0.2196078,\"a\":0},\"end\":3.543018,\"fill\":{\"r\":0.9294118,\"b\":0.9333333,\"g\":0.9647059,\"a\":1},\"thickness\":16,\"start\":4.834562},{\"radius\":116.4717,\"stroke\":{\"r\":0,\"b\":0,\"g\":0,\"a\":0},\"end\":3.420845,\"fill\":{\"r\":0,\"b\":0.4196078,\"g\":0.372549,\"a\":1},\"thickness\":2,\"start\":8.01747},{\"radius\":96.95181,\"stroke\":{\"r\":0.2039216,\"b\":0.2196078,\"g\":0.2196078,\"a\":0},\"end\":3.968867,\"fill\":{\"r\":0.2039216,\"b\":0.2196078,\"g\":0.2196078,\"a\":1},\"thickness\":17,\"start\":1.056431},{\"radius\":92.22514,\"stroke\":{\"r\":0.2039216,\"b\":0.2196078,\"g\":0.2196078,\"a\":0},\"end\":1.291544,\"fill\":{\"r\":0,\"b\":0.6196079,\"g\":0.5490196,\"a\":1},\"thickness\":1,\"start\":3.193953},{\"radius\":90,\"stroke\":{\"r\":0.2039216,\"b\":0.2196078,\"g\":0.2196078,\"a\":0},\"end\":4.518191,\"fill\":{\"r\":0,\"b\":0.8,\"g\":0.7058824,\"a\":1},\"thickness\":5,\"start\":3.994593},{\"radius\":73.21603,\"stroke\":{\"r\":0.2039216,\"b\":0.2196078,\"g\":0.2196078,\"a\":0},\"end\":6.608941,\"fill\":{\"r\":0.9294118,\"b\":0.9333333,\"g\":0.9647059,\"a\":1},\"thickness\":16,\"start\":6.224968},{\"radius\":54,\"stroke\":{\"r\":0.2039216,\"b\":0.2196078,\"g\":0.2196078,\"a\":0},\"end\":-0.09796405,\"fill\":{\"r\":0.9294118,\"b\":0.9333333,\"g\":0.9647059,\"a\":1},\"thickness\":15,\"start\":-0.1503239},{\"radius\":69.84869,\"stroke\":{\"r\":0.2039216,\"b\":0.2196078,\"g\":0.2196078,\"a\":0},\"end\":5.919011,\"fill\":{\"r\":0.9294118,\"b\":0.9333333,\"g\":0.9647059,\"a\":1},\"thickness\":13,\"start\":3.580269},{\"radius\":63.55166,\"stroke\":{\"r\":0.2039216,\"b\":0.2196078,\"g\":0.2196078,\"a\":0},\"end\":-0.2398228,\"fill\":{\"r\":0.9294118,\"b\":0.9333333,\"g\":0.9647059,\"a\":1},\"thickness\":1,\"start\":5.572123},{\"radius\":81.48421,\"stroke\":{\"r\":0.2039216,\"b\":0.2196078,\"g\":0.2196078,\"a\":0},\"end\":6.00552,\"fill\":{\"r\":0.9294118,\"b\":0.9333333,\"g\":0.9647059,\"a\":1},\"thickness\":7,\"start\":5.010684},{\"radius\":120.877,\"stroke\":{\"r\":0.2039216,\"b\":0.2196078,\"g\":0.2196078,\"a\":0},\"end\":0.9773844,\"fill\":{\"r\":0.9294118,\"b\":0.9333333,\"g\":0.9647059,\"a\":1},\"thickness\":5,\"start\":1.884956},{\"radius\":74.13875,\"stroke\":{\"r\":0.2039216,\"b\":0.2196078,\"g\":0.2196078,\"a\":0},\"end\":3.473976,\"fill\":{\"r\":0,\"b\":0.4196078,\"g\":0.372549,\"a\":1},\"thickness\":16,\"start\":1.990447},{\"radius\":64.45893,\"stroke\":{\"r\":0.2039216,\"b\":0.2196078,\"g\":0.2196078,\"a\":0},\"end\":4.520403,\"fill\":{\"r\":0,\"b\":0.4196078,\"g\":0.372549,\"a\":1},\"thickness\":2,\"start\":3.874631},{\"radius\":58.91942,\"stroke\":{\"r\":0.2039216,\"b\":0.2196078,\"g\":0.2196078,\"a\":0},\"end\":-0.3007863,\"fill\":{\"r\":0,\"b\":0.4196078,\"g\":0.372549,\"a\":1},\"thickness\":1,\"start\":2.945526},{\"radius\":129.6853,\"stroke\":{\"r\":0.2039216,\"b\":0.2196078,\"g\":0.2196078,\"a\":0},\"end\":9.725017,\"fill\":{\"r\":0,\"b\":0.4196078,\"g\":0.372549,\"a\":1},\"thickness\":6.531326,\"start\":11.20854},{\"radius\":76.40731,\"stroke\":{\"r\":0.2039216,\"b\":0.2196078,\"g\":0.2196078,\"a\":0},\"end\":4.880646,\"fill\":{\"r\":0,\"b\":0.4196078,\"g\":0.372549,\"a\":1},\"thickness\":1,\"start\":3.414568},{\"radius\":82.35839,\"stroke\":{\"r\":0.2039216,\"b\":0.2196078,\"g\":0.2196078,\"a\":0},\"end\":2.711464,\"fill\":{\"r\":0,\"b\":0.4196078,\"g\":0.372549,\"a\":1},\"thickness\":8,\"start\":0.442536},{\"radius\":67.68328,\"stroke\":{\"r\":0.2039216,\"b\":0.2196078,\"g\":0.2196078,\"a\":0},\"end\":3.371034,\"fill\":{\"r\":0,\"b\":0.4196078,\"g\":0.372549,\"a\":1},\"thickness\":2,\"start\":7.228213}]}";
}

- (ODArcMachine *) sampleJSONConversion {

    // Export to JSON String
    NSString *jsonString = [[NSString alloc] initWithData:[[self sampleJSONDocument] asJSONEncoded] encoding:NSUTF8StringEncoding];

    // Import from JSON String
    ODArcConstruktDocument *loadedDoc = [[ODArcConstruktDocument alloc]
                                         initWithJSON:jsonString];
    
    ODArcMachine *converted;
    for (NSDictionary *plist in loadedDoc.layers) {
        converted = [[ODArcMachine alloc] initWithDictionary:plist frame:CGRectMake(0, 0, 320, 320)];
    }
    return converted;
}

- (void)tearDown
{
    // Tear-down code here.
    testJSONConvertedMachine = nil;
    [super tearDown];
}

- (void)testJSONConvertedMachineInMemory {
   
    STAssertEquals((CGFloat)30,       testJSONConvertedMachine.radius, @"Compare radius of reloaed ODArcMachine with 30");
    STAssertEquals((CGFloat)25,       testJSONConvertedMachine.thickness, @"Compare thickness of reloaed ODArcMachine with 25");
    STAssertEquals((CGFloat)3.141593, testJSONConvertedMachine.start, @"Compare start angle of reloaded ArcMachine with 3.141593");
    STAssertEquals((CGFloat)0,        testJSONConvertedMachine.end, @"Compare end angle of reloaded ODArcMachine with 0.");
    STAssertTrue(        [@"ffffff"   isEqualToString:[testJSONConvertedMachine.fill RGBHexString]], @"Compare fill color of reloaded ODArcMachine with ffffff.");
    STAssertTrue(        [@"000000"   isEqualToString:[testJSONConvertedMachine.stroke RGBHexString]], @"Compare stroke color of reloaded ODArcMachine with 000000.");

}

- (void)testJSONToFromFile {

    ODArcConstruktDocument *doc = [self sampleJSONDocument];
    NSString *jsonString = [[NSString alloc] initWithData:[doc asJSONEncoded] encoding:NSUTF8StringEncoding];
    
    [ODFileTools save:doc.filename documentsFolder:@"test" data:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSString *loadedJSON = [[NSString alloc] initWithData:[ODFileTools loadNSData:doc.filename documentsFolder:@"test"] encoding:NSUTF8StringEncoding];
       
    // Import from JSON String
    ODArcConstruktDocument *loadedDoc = [[ODArcConstruktDocument alloc]
                                         initWithJSON:loadedJSON];
    
    NSDictionary *layer = loadedDoc.layers[0];
    ODArcMachine *arcMachine = [[ODArcMachine alloc] initWithDictionary:layer frame:CGRectMake(0, 0, 320, 320)];
    
    STAssertEquals((CGFloat)30,       arcMachine.radius, @"Compare radius of reloaed ODArcMachine with 30");
    STAssertEquals((CGFloat)25,       arcMachine.thickness, @"Compare thickness of reloaed ODArcMachine with 25");
    STAssertEquals((CGFloat)3.141593, arcMachine.start, @"Compare start angle of reloaded ArcMachine with 3.141593");
    STAssertEquals((CGFloat)0,        arcMachine.end, @"Compare end angle of reloaded ODArcMachine with 0.");
    STAssertTrue(        [@"ffffff"   isEqualToString:[arcMachine.fill RGBHexString]], @"Compare fill color of reloaded ODArcMachine with ffffff.");
    STAssertTrue(        [@"000000"   isEqualToString:[arcMachine.stroke RGBHexString]], @"Compare stroke color of reloaded ODArcMachine with 000000.");
    
}

- (void)testJSONFromSample {
    ODArcConstruktDocument *doc = [[ODArcConstruktDocument alloc] initWithJSON:[self jsonSampleDoc]];    
    STAssertNotNil(doc, @"We have a valid doc");
    STAssertEquals((CGFloat)100.9645, (CGFloat)[[(NSDictionary*)[doc.layers objectAtIndex:0] valueForKey:@"radius"] floatValue], @"Check our JSON data made it.");
}

- (void)testJSONFromSample2 {
    ODArcConstruktDocument *doc = [[ODArcConstruktDocument alloc] initWithJSON:[self jsonSampleDoc2]];
    STAssertNotNil(doc, @"We have a valid doc");
    STAssertEquals((CGFloat)0.6108652381980153, (CGFloat)[[(NSDictionary*)[doc.layers objectAtIndex:0] valueForKey:@"start"] floatValue], @"Check our JSON data made it.");
}


@end
