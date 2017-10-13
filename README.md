# flow-test

A pod to unit-test a particular flow(not UI) based on method-names, to make sure that the corresponding methods are being ccalled.

## Why

When writing unit-tests for non-UI parts of an app, say like some kind of local in-memory store, I've found that basic unit-tests is not suitable for scenarios where there could be multiple ways of acheiving the same final result. So, although the unit-test passes, it may so happen that only one-route is being tested, while the other routes, which could also give the same result, are not. 

Ofcourse, this means that you are not treating your apis like a black-box. So, this should be useful particularly to the person implementing the flow and making sure that it does not break :) 

The point of this was to explicitly make sure that for a particular test, a certain list of methods need to be called, in a particular order, for it to be deemed successful, along with the assertions in the final state.

## Usage

You can install `flow-test` using Cocoapods, by adding this to the test-target in your podFile -

```Ruby
pod 'flow-test'
```

So that your final test target looks like this - 

```Ruby
target 'MyApp_Tests' do
  inherit! :search_paths
  pod 'flow-test'
end
```


### Example

Suppose you have a flow of logic that looks like this - 

```ObjC
@interface MyFeature:NSObject
- (NSNumber *)complicatedFeature:(NSUInteger)path;
@end

@implementation MyFeature
- (NSUInteger)complicatedFeature:(NSUInteger)index{
    if(index == 0){
        [self callSampleMethod];
    }
    return 42
}

- (void)callSampleMethod{
    // ...
}
@end
```

`MyFeature` is a class that consists of a `complicatedFeature` that calls different methods based on what is passed as it's arguments. The problem is the return value will always be the same.

So let's test the flow of the method `complicatedFeature` with arguments as `0` and `1`. Note that when the argument passed is `0`, `callSampleMethod` method is called. We can assert that.

The final test will look like - 

```ObjC
#import "MyFeature.h"
@import flow_test;

@interface MyFeatureTests : KMFTestManager
@end

@implementation MyFeatureTests

/// Note that the flow-test starts with `testFlow`
- (void)testFlowFeatureWithZero{
    // Add the class-name and the method-name that will be
    // encountered when calling `complicatedFeature`.
    KMFAddMethodSpecsList(@[
                            KMFMakeMethodSpec(@"MyFeature", @"callSampleMethod")
                            ]);
    
    // Regular tests from here on
    MyFeature *featureObj = [[MyFeature alloc] init];
    NSUInteger result = [featureObj complicatedFeature:0];
    XCTAssert(result == 42);
}

- (void)testFlowFeatureWithNonZero{
    MyFeature *featureObj = [[MyFeature alloc] init];
    NSUInteger result = [featureObj complicatedFeature:0];
    XCTAssert(result == 42);
}

@end

```

You can import the pod using `@import` and instead of your tests extending from `XCTestCase`, they will extend from `KMFTestManager`.
```Objc
@import flow_test;

@interface MyFeatureTests : KMFTestManager
...
@end
```

Make sure that the tests in which the you'd like the test the flow begins with `testFlow`. If not, the methods will not be asserted in those tests. You can add the class and method selector string in an array.

```ObjC
- (void)testFlowFeatureWithZero{
    // Add the class-name and the method-name that will be
    // encountered when calling `complicatedFeature`.
    KMFAddMethodSpecsList(@[
                            KMFMakeMethodSpec(@"MyFeature", @"callSampleMethod")
                            ]);
    
    // Regular tests from here on...
}

```

And that's all!

### Multiple method checks

You can add multiple entries to the list, and `test-flow` will check if these methods were called, in the given order of the list.

Note that this does not mean that, only these methods need to be called! Other methods can also be called, and the test will succeed as long as the methods specified in the method-specs list are called.

```ObjC
- (void)testFlowFeatureWithMultipleMethods{
    // This asserts that first callSampleMethod will be called, followed by callMethod1 and callMethod2
    KMFAddMethodSpecsList(@[
                            KMFMakeMethodSpec(@"MyFeature", @"callSampleMethod"),
                            KMFMakeMethodSpec(@"MyFeature", @"callMethod1"),
                            KMFMakeMethodSpec(@"MyFeature", @"callMethod2"),
                            ]);
    
    // Regular tests from here on...
}

```


### `flowMethodSpecsList` method

Note that there is a special method - `flowMethodSpecsList`, which can specify the methods that will be common to multiple tests in the current test class.

So if there's a `commonMethod` that's called before any of these methods, the tests will look like this - 

```ObjC
// The commonMethod is added to the method-specs list before running every test. 
- (NSArray<KMFMethodSpec *> *)flowMethodSpecsList{
    return @[
             KMFMakeMethodSpec(@"MyFeature", @"commonMethod")
             ];
}

- (void)testFlowFeatureWithZero{
    KMFAddMethodSpecsList(@[
                            KMFMakeMethodSpec(@"MyFeature", @"callSampleMethod")
                            ]);
    
    // ... Rest of the test
}

- (void)testFlowFeatureWithNonZero{
    // ... Rest of the test
}
```

## Author

gnithin, nithin.linkin@gmail.com

## License

flow-test is available under the MIT license. See the LICENSE file for more info.
