UIBezierPathSerialization
=========================

by **Illya Busigin**

- Visit my blog at [http://illyabusigin.com/](http://illyabusigin.com/)
- Follow [@illyabusigin on Twitter](http://twitter.com/illyabusigin)

## Purpose

`UIBezierPathSerialization` encodes and decodes between JSON and [UIBezierPath](https://developer.apple.com/library/ios/documentation/uikit/reference/UIBezierPath_class/Reference/Reference.html) objects, following the API conventions of Foundation's `NSJSONSerialization` class. The output JSON implements a subset of the [Path to JSON](http://www.w3.org/Graphics/SVG/WG/wiki/Path_toJSON) proposal that allows SVG Paths to be serialized as a normalized JSON object.

## Installation

To install `UIBezierPathSerialization`, just drag the class files into your project. Alternatively, if you're using [CocoaPods](http://cocoapods.org) just specify `pod 'UIBezierPathSerialization'` in your `Podfile`.

## Usage

### Encoding

```objective-c
#import "UIBezierPathSerialization.h"

UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, 100, 100)];
NSError *error = nil;
    
NSData *data = [UIBezierPathSerialization dataWithBezierPath:bezierPath options:0 error:&error];
```

### Decoding

```objective-c
#import "UIBezierPathSerialization.h"

NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:@"simple_path" ofType:@"json"];
NSData *data = [NSData dataWithContentsOfFile:path];
NSError *error = nil;
    
UIBezierPath *bezierPath = [UIBezierPathSerialization bezierPathWithData:data options:0 error:&error];
```

## Bugs & Feature Requests

There is **no support** offered with this component. If you would like a feature or find a bug, please submit a feature request through the [GitHub issue tracker](http://github.com/illyabusigin/UIBezierPathSerialization/issues).

Pull-requests for bug-fixes and features are welcome!

## License

UIBezierPathSerialization is available under the MIT license. See the LICENSE file for more info.
