//
//  TestsTests.m
//  TestsTests
//
//  Created by Guest User  on 6/29/14.
//  Copyright (c) 2014 Cyrillian, Inc. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <UIKit/UIKit.h>

#import "UIBezierPathSerialization.h"

@interface Tests : XCTestCase

@end

@implementation Tests

- (void)testSerializingValidBezierPathToFile
{
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, 100, 100)];
    NSError *error = nil;
    
    NSData *data = [UIBezierPathSerialization dataWithBezierPath:bezierPath options:0 error:&error];
    
    XCTAssertNotNil(data, @"The bezier path data should not be nil!");
    XCTAssertNil(error, @"There shouldn't be an error!");
}

- (void)testSerializingInvalidBezierPathToFile
{
    NSError *error = nil;
    NSData *data = [UIBezierPathSerialization dataWithBezierPath:(UIBezierPath *)@"junk data" options:0 error:&error];
    
    XCTAssertNotNil(error, @"The error should not be nil");
    XCTAssertTrue([error.domain isEqualToString:UIBezierPathSerializationErrorDomain], @"The error domain should be UIBezierPathSerializationErrorDomain");
    XCTAssertNil(data, @"Data object should be empty!");
}

- (void)testDeserializingSimpleBezierPathFromFile
{
    NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:@"simple_path" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSError *error = nil;
    
    UIBezierPath *bezierPath = [UIBezierPathSerialization bezierPathWithData:data options:0 error:&error];
    
    XCTAssertNotNil(bezierPath, @"The bezier path should not be nil!");
    XCTAssertTrue([bezierPath isKindOfClass:[UIBezierPath class]], @"The bezierpath object should be of UIBezierPath type");
    XCTAssertNil(error, @"The error should be nil!");
}

- (void)testDeserializingComplexBezierPathFromFile
{
    NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:@"complex_path" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSError *error = nil;
    
    UIBezierPath *bezierPath = [UIBezierPathSerialization bezierPathWithData:data options:0 error:&error];
    
    XCTAssertNotNil(bezierPath, @"The bezier path should not be nil!");
    XCTAssertTrue([bezierPath isKindOfClass:[UIBezierPath class]], @"The bezierpath object should be of UIBezierPath type");
    XCTAssertNil(error, @"The error should be nil!");
}

- (void)testDeserializingInvalidBezierPathFromFile
{
    NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:@"invalid_path" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSError *error = nil;
    
    UIBezierPath *bezierPath = [UIBezierPathSerialization bezierPathWithData:data options:0 error:&error];
    
    XCTAssertNil(bezierPath, @"The bezier path should be nil!");
    XCTAssertNotNil(error, @"The error should not be nil!");
    XCTAssertTrue([error.domain isEqualToString:UIBezierPathSerializationErrorDomain], @"The error domain should be UIBezierPathSerializationErrorDomain");
}

- (void)testDeserializingBezierPathWithPropertiesFromFile
{
    NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:@"simple_path" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSError *error = nil;
    
    UIBezierPath *bezierPath = [UIBezierPathSerialization bezierPathWithData:data options:0 error:&error];

    XCTAssertTrue(bezierPath.usesEvenOddFillRule == YES, @"usesEvenOddFillRule should be true!");
    XCTAssertTrue(bezierPath.lineWidth == 5.0, @"The line width should be 5.0");
    XCTAssertTrue(bezierPath.miterLimit == 20, @"The miter limit should be 20");
    XCTAssertTrue(bezierPath.lineJoinStyle == kCGLineJoinRound, @"The lineJoinStyle should be kCGLineJoinRound");
    XCTAssertTrue(bezierPath.lineCapStyle == kCGLineCapRound, @"The lineCapStyle should be kCGLineCapRound");
    XCTAssertTrue(bezierPath.flatness == 2.0, @"The flatness should equal 2.0!");
}

- (void)testDeserializingBezierPathWithoutPropertiesFromFile
{
    NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:@"complex_path" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSError *error = nil;
    
    UIBezierPath *bezierPath = [UIBezierPathSerialization bezierPathWithData:data options:0 error:&error];
    
    XCTAssertTrue(bezierPath.usesEvenOddFillRule == NO, @"usesEvenOddFillRule should be false!");
    XCTAssertTrue(bezierPath.lineWidth == 5.0, @"The line width should be 5.0");
    XCTAssertTrue(bezierPath.miterLimit == 10, @"The miter limit should be 10");
    XCTAssertTrue(bezierPath.lineJoinStyle == kCGLineJoinMiter, @"The lineJoinStyle should be kCGLineJoinMiter");
    XCTAssertTrue(bezierPath.lineCapStyle == kCGLineCapButt, @"The lineCapStyle should be kCGLineCapButt");
    XCTAssertTrue(bezierPath.flatness == 0.6f, @"The flatness should equal 0.6!");
}

@end
