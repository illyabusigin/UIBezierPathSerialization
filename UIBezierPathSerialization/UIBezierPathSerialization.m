//
//  UIBezierPathSerialization.m
//
//  Version 1.0.0
//
//  Created by Illya Busigin on 6/24/2014.
//  Copyright (c) 2014 Cyrillian, Inc.
//
//  Distributed under MIT license.
//  Get the latest version from here:
//
//  https://github.com/illyabusigin/UIBezierPathSerialization
//
// The MIT License (MIT)
//
// Copyright (c) 2014 Cyrillian, Inc.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of
// this software and associated documentation files (the "Software"), to deal in
// the Software without restriction, including without limitation the rights to
// use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
// the Software, and to permit persons to whom the Software is furnished to do so,
// subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
// FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
// COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
// IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
// CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import "UIBezierPathSerialization.h"
#import <CoreGraphics/CoreGraphics.h>

NSString * const UIBezierPathSerializationErrorDomain = @"com.uibezierpath.serialization.error";
static const CGPathElementType kCGPathElementTypeNotFound = NSNotFound;

#pragma mark - CGPathElementType Convenience

static inline NSString * NSStringFromCGPathElementType(CGPathElementType type)
{
    switch (type) {
        case kCGPathElementMoveToPoint:
            return @"MoveTo";
            break;
            
        case kCGPathElementAddLineToPoint:
            return @"LineTo";
            break;
            
        case kCGPathElementAddQuadCurveToPoint:
            return @"QuadraticCurveTo";
            break;
            
        case kCGPathElementAddCurveToPoint:
            return @"CubicCurveTo";
            break;
            
        case kCGPathElementCloseSubpath:
            return @"ClosePath";
            break;
            
        default:
            return nil;
            break;
    }
}

static inline CGPathElementType CGPathElementTypeFromString(NSString *string)
{
    if ([string isEqualToString:@"MoveTo"]) {
        return kCGPathElementMoveToPoint;
    } else if ([string isEqualToString:@"LineTo"]) {
        return kCGPathElementAddLineToPoint;
    } else if ([string isEqualToString:@"QuadraticCurveTo"]) {
        return kCGPathElementAddQuadCurveToPoint;
    } else if ([string isEqualToString:@"CubicCurveTo"]) {
        return kCGPathElementAddCurveToPoint;
    } else if ([string isEqualToString:@"ClosePath"]) {
        return kCGPathElementCloseSubpath;
    } else {
        return kCGPathElementTypeNotFound;
    }
}

#pragma mark - CGPathElement - Deserialization

static CGPathElement CGPathElementMoveToPointFromJSONObject(NSDictionary *jsonObject)
{
    CGPathElement moveToPointElement;
    CGPoint *points = malloc(sizeof(CGPoint) * 1);
    
    moveToPointElement.type = kCGPathElementMoveToPoint;
    
    CGFloat x = [jsonObject[@"x"] floatValue];
    CGFloat y = [jsonObject[@"y"] floatValue];
    
    points[0] = CGPointMake(x, y);
    
    moveToPointElement.points = points;
    
    return moveToPointElement;
}

static CGPathElement CGPathElementLineToPointFromJSONObject(NSDictionary *jsonObject)
{
    CGPathElement lineToPointElement;
    CGPoint *points = malloc(sizeof(CGPoint) * 1);
    
    lineToPointElement.type = kCGPathElementAddLineToPoint;
    
    CGFloat x = [jsonObject[@"x"] floatValue];
    CGFloat y = [jsonObject[@"y"] floatValue];
    
    points[0] = CGPointMake(x, y);
    
    lineToPointElement.points = points;
    
    return lineToPointElement;
}

static CGPathElement CGPathElementQuadraticCurveToPointFromJSONObject(NSDictionary *jsonObject)
{
    CGPathElement quadraticCurveToPointElement;
    CGPoint *points = malloc(sizeof(CGPoint) * 2);
    
    quadraticCurveToPointElement.type = kCGPathElementAddQuadCurveToPoint;
    
    // Point
    CGFloat x = [jsonObject[@"x"] floatValue];
    CGFloat y = [jsonObject[@"y"] floatValue];
    
    points[1] = CGPointMake(x, y);
    
    // Control point 1
    CGFloat x1 = [jsonObject[@"x1"] floatValue];
    CGFloat y1 = [jsonObject[@"y1"] floatValue];
    
    points[0] = CGPointMake(x1, y1);

    quadraticCurveToPointElement.points = points;
    
    return quadraticCurveToPointElement;
}

static CGPathElement CGPathElementCubicCurveToPointFromJSONObject(NSDictionary *jsonObject)
{
    CGPathElement cubicCurveToPointElement;
    CGPoint *points = malloc(sizeof(CGPoint) * 3);
    
    cubicCurveToPointElement.type = kCGPathElementAddCurveToPoint;
    
    // Point
    CGFloat x = [jsonObject[@"x"] floatValue];
    CGFloat y = [jsonObject[@"y"] floatValue];
    
    points[2] = CGPointMake(x, y);
    
    // Control point 1
    CGFloat x1 = [jsonObject[@"x1"] floatValue];
    CGFloat y1 = [jsonObject[@"y1"] floatValue];
    
    points[0] = CGPointMake(x1, y1);
    
    // Control point 2
    CGFloat x2 = [jsonObject[@"x2"] floatValue];
    CGFloat y2 = [jsonObject[@"y2"] floatValue];
    
    points[1] = CGPointMake(x2, y2);
    
    cubicCurveToPointElement.points = points;
    
    return cubicCurveToPointElement;
}

static CGPathElement CGPathElementClosePathFromJSONObject(NSDictionary *jsonObject)
{
    CGPathElement closePathElement;
    closePathElement.type = kCGPathElementCloseSubpath;
    
    return closePathElement;
}

static CGPathElement CGPathElementFromJSONObject(NSDictionary *jsonObject)
{
    NSCParameterAssert(jsonObject[@"type"]);
    
    CGPathElementType type = CGPathElementTypeFromString(jsonObject[@"type"]);
    NSCParameterAssert(type != kCGPathElementTypeNotFound);
    
    CGPathElement element;
    
    switch (type) {
        case kCGPathElementMoveToPoint:
            element = CGPathElementMoveToPointFromJSONObject(jsonObject);
            break;
            
        case kCGPathElementAddLineToPoint:
            element = CGPathElementLineToPointFromJSONObject(jsonObject);
            break;
            
        case kCGPathElementAddQuadCurveToPoint:
            element = CGPathElementQuadraticCurveToPointFromJSONObject(jsonObject);
            break;
            
        case kCGPathElementAddCurveToPoint:
            element = CGPathElementCubicCurveToPointFromJSONObject(jsonObject);
            break;
            
        case kCGPathElementCloseSubpath:
            element = CGPathElementClosePathFromJSONObject(jsonObject);
            break;
            
        default:
            break;
    }
    
    return element;
}

#pragma mark - CGPathElement - Serialization

static NSDictionary * JSONObjectForMoveToPointElement(const CGPathElement *element)
{
    NSMutableDictionary *jsonObject = [NSMutableDictionary dictionary];
    
    jsonObject[@"type"] = NSStringFromCGPathElementType(element->type);
    jsonObject[@"x"] = @(element->points[0].x);
    jsonObject[@"y"] = @(element->points[0].y);
    
    return jsonObject;
}

static NSDictionary * JSONObjectForLineToPointElement(const CGPathElement *element)
{
    NSMutableDictionary *jsonObject = [NSMutableDictionary dictionary];
    
    jsonObject[@"type"] = NSStringFromCGPathElementType(element->type);
    jsonObject[@"x"] = @(element->points[0].x);
    jsonObject[@"y"] = @(element->points[0].y);
    
    return jsonObject;
}

static NSDictionary * JSONObjectForQuadraticCurveToPointElement(const CGPathElement *element)
{
    NSMutableDictionary *jsonObject = [NSMutableDictionary dictionary];
    
    jsonObject[@"type"] = NSStringFromCGPathElementType(element->type);
    jsonObject[@"x"] = @(element->points[1].x);
    jsonObject[@"y"] = @(element->points[1].y);
    jsonObject[@"x1"] = @(element->points[0].x);
    jsonObject[@"y1"] = @(element->points[0].y);
    
    return jsonObject;
}

static NSDictionary * JSONObjectForCubicCurveToPointElement(const CGPathElement *element)
{
    NSMutableDictionary *jsonObject = [NSMutableDictionary dictionary];
    
    jsonObject[@"type"] = NSStringFromCGPathElementType(element->type);
    jsonObject[@"x"] = @(element->points[2].x);
    jsonObject[@"y"] = @(element->points[2].y);
    jsonObject[@"x1"] = @(element->points[0].x);
    jsonObject[@"y1"] = @(element->points[0].y);
    jsonObject[@"x2"] = @(element->points[1].x);
    jsonObject[@"y2"] = @(element->points[1].y);
    
    return jsonObject;
}

static NSDictionary * JSONObjectForClosePathElement(const CGPathElement *element)
{
    NSMutableDictionary *jsonObject = [NSMutableDictionary dictionary];
    
    jsonObject[@"type"] = NSStringFromCGPathElementType(element->type);
    
    return jsonObject;
}

static NSDictionary * JSONObjectForPathElement(const CGPathElement *element)
{
    NSDictionary *jsonObject = nil;
    
    switch (element->type)
	{
		case kCGPathElementMoveToPoint:
			jsonObject = JSONObjectForMoveToPointElement(element);
			break;
            
		case kCGPathElementAddLineToPoint:
			jsonObject = JSONObjectForLineToPointElement(element);
			break;
            
		case kCGPathElementAddQuadCurveToPoint:
			jsonObject = JSONObjectForQuadraticCurveToPointElement(element);
			break;
            
		case kCGPathElementAddCurveToPoint:
			jsonObject = JSONObjectForCubicCurveToPointElement(element);
			break;
            
		case kCGPathElementCloseSubpath:
			jsonObject = JSONObjectForClosePathElement(element);
			break;
            
		default:
			break;
	}
    
    return jsonObject;
}

static void savePathElementsApplier(void *info, const CGPathElement *element)
{
	NSMutableArray *pathElements = (__bridge NSMutableArray *)info;
    NSDictionary *jsonObject = JSONObjectForPathElement(element);
    
    [pathElements addObject:jsonObject];
}

#pragma mark - UIBezierPath Drawing Properties

static NSDictionary * drawingPropertiesJSONObjectForUIBezierPath(UIBezierPath *path)
{
    NSCParameterAssert(path);
    
    NSMutableDictionary *properties = [NSMutableDictionary dictionary];
    
    properties[@"lineWidth"] = @(path.lineWidth);
    properties[@"lineCapStyle"] = @(path.lineCapStyle);
    properties[@"lineJoinStyle"] = @(path.lineJoinStyle);
    properties[@"miterLimit"] = @(path.miterLimit);
    properties[@"flatness"] = @(path.flatness);
    properties[@"usesEvenOddFillRule"] = @(path.usesEvenOddFillRule);
    
    NSMutableDictionary *lineStrokingProperties = [NSMutableDictionary dictionary];
    
    CGFloat *pattern = nil;
    NSInteger *count = nil;
    CGFloat *phase = nil;
    
    [path getLineDash:pattern count:count phase:phase];
    
    if (count != nil) {
        NSMutableArray *patternValues = [NSMutableArray array];
        
        for (int i = 0; i < *count; i++) {
            [patternValues addObject:@(pattern[i])];
        }
        
        lineStrokingProperties[@"pattern"] = patternValues;
        
        if (phase != nil) {
            lineStrokingProperties[@"phase"] = @(*phase);
        }
        
        properties[@"lineStrokingProperties"] = lineStrokingProperties;
    }
    
    return properties;
}

static void updateDrawingPropertiesForBezierPathWithProperties(UIBezierPath *path, NSDictionary *properties)
{
    path.lineWidth = [properties[@"lineWidth"] floatValue];
    path.lineCapStyle = [properties[@"lineCapStyle"] integerValue];
    path.lineJoinStyle = [properties[@"lineJoinStyle"] integerValue];
    path.miterLimit = [properties[@"miterLimit"] floatValue];
    path.flatness = [properties[@"flatness"] floatValue];
    path.usesEvenOddFillRule =[properties[@"usesEvenOddFillRule"] boolValue];
    
    if (properties[@"lineStrokingProperties"] != nil) {
        NSDictionary *lineStrokingProperties = properties[@"lineStrokingProperties"];
        NSArray *patternValues = lineStrokingProperties[@"pattern"];
        CGFloat *pattern = malloc(sizeof(CGFloat) * patternValues.count);
        CGFloat *phase = nil;
        *phase = [lineStrokingProperties[@"phase"] floatValue];
        
        for (int i = 0; i < patternValues.count; i++) {
            pattern[i] = [patternValues[i] floatValue];
        }
        
        [path setLineDash:pattern count:patternValues.count phase:*phase];
    }
}

#pragma mark -

@implementation UIBezierPathSerialization

+ (UIBezierPath *)bezierPathWithData:(NSData *)data options:(UIBezierPathReadingOptions)options error:(NSError **)error
{
    UIBezierPath *bezierPath = nil;
    
    @try {
        CGMutablePathRef path = CGPathCreateMutable();
        NSError *deserializationError = nil;
        
        NSDictionary *pathData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&deserializationError];
        
        if (deserializationError) {
            *error = [NSError errorWithDomain:UIBezierPathSerializationErrorDomain code:deserializationError.code userInfo:deserializationError.userInfo];
            return nil;
        }
        
        NSArray *elements = pathData[@"elements"];
        NSDictionary *properties = pathData[@"properties"];
        
        for (NSDictionary *jsonObject in elements) {
            CGPathElement element = CGPathElementFromJSONObject(jsonObject);
            CGPoint *points = element.points;
            
            switch (element.type)
            {
                case kCGPathElementMoveToPoint:
                    CGPathMoveToPoint(path, NULL, points[0].x, points[0].y);
                    break;
                    
                case kCGPathElementAddLineToPoint:
                    CGPathAddLineToPoint(path, NULL, points[0].x, points[0].y);
                    break;
                    
                case kCGPathElementAddQuadCurveToPoint:
                    CGPathAddQuadCurveToPoint(path, NULL, points[0].x, points[0].y, points[1].x, points[1].y);
                    break;
                    
                case kCGPathElementAddCurveToPoint:
                    CGPathAddCurveToPoint(path, NULL, points[0].x, points[0].y, points[1].x, points[1].y, points[2].x, points[2].y);
                    break;
                    
                case kCGPathElementCloseSubpath:
                    CGPathCloseSubpath(path);
                    break;
                    
                default:
                    break;
            }
        }
        
        bezierPath = [UIBezierPath bezierPathWithCGPath:path];
        
        if (!(options & UIBezierPathWritingIgnoreDrawingProperties)) {
            updateDrawingPropertiesForBezierPathWithProperties(bezierPath, properties);
        }
        CGPathRelease(path);

    }
    @catch (NSException *exception) {
        if (error) {
            NSDictionary *userInfo = @{
                                       NSLocalizedDescriptionKey: exception.name,
                                       NSLocalizedFailureReasonErrorKey: exception.reason
                                       };
            
            *error = [NSError errorWithDomain:UIBezierPathSerializationErrorDomain code:-1 userInfo:userInfo];
        }
        
        return nil;
    }
    
    return bezierPath;
}

+ (NSData *)dataWithBezierPath:(UIBezierPath *)path options:(UIBezierPathWritingOptions)options error:(NSError **)error
{
    NSData *data = nil;
    
    @try {
        NSMutableDictionary *pathData = [NSMutableDictionary dictionary];
        
        if (!(options & UIBezierPathWritingIgnoreDrawingProperties)) {
            pathData[@"properties"] = drawingPropertiesJSONObjectForUIBezierPath(path);
        }
        
        NSMutableArray *elements = [NSMutableArray array];

        CGPathApply(path.CGPath, (__bridge void *)(elements), savePathElementsApplier);
        pathData[@"elements"] = elements;
        
        NSJSONWritingOptions writingOptions = (options & UIBezierPathWritingPrettyPrinted ? NSJSONWritingPrettyPrinted : 0);
        
        data = [NSJSONSerialization dataWithJSONObject:pathData options:writingOptions error:error];
    }
    @catch (NSException *exception) {
        if (error) {
            NSDictionary *userInfo = @{
                                       NSLocalizedDescriptionKey: exception.name,
                                       NSLocalizedFailureReasonErrorKey: exception.reason
                                       };
            
            *error = [NSError errorWithDomain:UIBezierPathSerializationErrorDomain code:-1 userInfo:userInfo];
        }
        
        return nil;
    }
    
    return data;
}

@end
