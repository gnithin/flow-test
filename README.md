# flow-test

A pod to unit-test non-UI flow based on method selectors strings

## Why

When writing unit-tests for non-UI parts of an app, say like some kind of local in-memory store, for some scenarios, where there could be multiple ways of arriving at the same final result, basic unit-tests seem insufficient. So, although the unit-test passes, it may so happen that only one-route is being tested, while the other routes, which could also give the same result, are not. This pod helps to explicitly cover alternate paths.

`flow-test` makes it explicit that for a particular test, a certain list of methods need to be called, in a particular order, for it to be successful.

This means that you would not treat your apis like a black-box. So, this should be useful particularly to the person implementing the flow and making sure that it does not break on future changes :)

## Usage

You can install `flow-test` using Cocoapods, by adding this to the test-target in your podFile -

```Ruby
pod 'flow-test'
```

So the final test target for your app named `MyApp` will look like this -

```Ruby
target 'MyApp_Tests' do
  inherit! :search_paths
  pod 'flow-test'
end
```

### Usage Example

Suppose you have a flow of logic that looks like this - 

```ObjC
@implementation MyFeature
- (NSUInteger)complicatedFeature:(NSUInteger)index{
    if(index == 0){
        [self callSampleMethod];
    }
    return 42
}

- (void)callSampleMethod{
    // ... Some more code here.
}
@end
```

`MyFeature` is a class that consists of a `complicatedFeature` method that calls different methods based on what is passed to it's arguments, although it returns the same response everytime.

So let's test the flow for `complicatedFeature` with arguments as `0` and `1`. Note that when the argument passed is `0`, `callSampleMethod` method is called. We can assert that.

The final test will look like - 

```ObjC
@import flow_test;
#import "MyFeature.h"

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

So let's break this down -

You can import the pod using `@import` and instead of your tests extending from `XCTestCase`, they will extend from `KMFTestManager` class.

```Objc
@import flow_test;

@interface MyFeatureTests : KMFTestManager
...
@end
```

When testing the flow of methods, make sure that the test-name begins with `testFlow`. If not, the methods will not be asserted in those tests and they'll work similar to vanilla `XCTestCase`.

The methods can be specified using the classname and method selector string. It's internally called a method-spec. You can create a method-spec using the macro - `KMFMakeMethodSpec(@"classname", @"methodSelector")`.

You can add a list of method-specs to assert that these selectors will be called in the order specified by the list. You need to add the method-specs list to the `KMFAddMethodSpecsList(@[...])`.

So the flow-test for the `complicatedFeature` will look like -

```ObjC
- (void)testFlowFeatureWithZero{
    // Add the class-name and the method-name that will be
    // encountered when calling `complicatedFeature`.
    KMFAddMethodSpecsList(@[
                            KMFMakeMethodSpec(@"MyFeature", @"callSampleMethod")
                            // You can add more method-specs here
                            ]);
    
    // Regular XCTestCase assertions from this point...
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

Note that there is a special method - `flowMethodSpecsList`, in which one can specify the method-specs that will be common to multiple tests in the current test class.

So, in the above `MyFeature` class, if there's a `commonMethod` that's called in every method, including the `complicatedFeature`, then tests will look like this -

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

This is just to make the flow-tests cleaner. It's perfectly fine to omit `flowMethodSpecsList` and specify the method-specs list using `KMFAddMethodSpecsList()` inside every `testFlow` tests.

## Dependencies

`flow-test` depends upon, and works because of, the awesome [`Aspects`](https://github.com/steipete/Aspects) library. 

## Author

gnithin, nithin.linkin@gmail.com

## License

flow-test is available under the MIT license. See the LICENSE file for more info.


## Tasks remaining - (To be deleted once done)

- The error messages need to be helpful. This will need some careful, thoughtful work
- Have a feature where you assert that certain methods are not to be called at all!
- Arguments assertions as well in the method-specs
- Support for static classes as well (not possible right now, in the Aspects lib. Have to dig around)
- Make sure everything is testable.
- Add the extra features in the README
- CI - travis-ci for this
- Test this out for swift. It should not cause too many pain-points since XCTestCase is used similarly :fingerscrossed: 
    - If it does not work, then fine. Support it in future releases.
- Update the stickers
- Push to cocoapods
