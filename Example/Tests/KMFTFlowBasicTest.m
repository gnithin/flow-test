//
//  KMFTFlowBasicTest.m
//  flow-test_Tests
//
//  Created by nithin.g on 13/10/17.
//  Copyright © 2017 gnithin. All rights reserved.
//

#import <XCTest/XCTest.h>
@import flow_test;
#import "KMFTCustomFeature.h"

@interface KMFTFlowBasicTest : KMFTestManager

@end

@implementation KMFTFlowBasicTest

- (NSArray<KMFMethodSpec *> *)flowMethodSpecsList{
    return @[
             KMFMakeMethodSpec(@"KMFTCustomFeature", @"callMethodA"),
             ];
}

- (void)testFlowForMethodA{
    KMFTCustomFeature *customFeature = [[KMFTCustomFeature alloc] init];
    NSNumber *result = [customFeature complicatedFeature: MyFeaturePathA];
    XCTAssert([result isEqualToNumber:[NSNumber numberWithInt:42]]);
}

- (void)testFlowForMethodB{
    KMFTCustomFeature *customFeature = [[KMFTCustomFeature alloc] init];
    NSNumber *result = [customFeature complicatedFeature: MyFeaturePathB];
    XCTAssert([result isEqualToNumber:[NSNumber numberWithInt:42]]);
}

@end
