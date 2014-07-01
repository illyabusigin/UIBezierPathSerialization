//
//  UIBezierPathSerialization.h
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

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSUInteger, UIBezierPathReadingOptions) {
    UIBezierPathReadingIgnoreDrawingProperties = (1UL << 0),
};

typedef NS_OPTIONS(NSUInteger, UIBezierPathWritingOptions) {
    UIBezierPathWritingIgnoreDrawingProperties = (1UL << 0),
    UIBezierPathWritingPrettyPrinted = (1UL << 1)
};

// See http://www.w3.org/Graphics/SVG/WG/wiki/Path_toJSON

@interface UIBezierPathSerialization : NSObject

/// UIBezierPathSerialization provides JSON serialization/deserialization of UIBezierPath.

+ (UIBezierPath *)bezierPathWithData:(NSData *)data options:(UIBezierPathReadingOptions)options error:(NSError **)error;
+ (NSData *)dataWithBezierPath:(UIBezierPath *)path options:(UIBezierPathWritingOptions)options error:(NSError **)error;

@end

extern NSString * const UIBezierPathSerializationErrorDomain;

// Test deserializing valid bezier path from file
// Test deserializing invalid bezier path from file
// Test deserializing bezier path without drawing properties
// Test deserializing bezier path with drawing properties
// Test serializing valid bezier path to file
// Test serializing invalid bezier path to file