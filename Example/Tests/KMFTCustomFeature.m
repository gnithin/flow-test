//
//  KMFTCustomFeature.m
//  flow-test_Tests
//
//  Created by nithin.g on 13/10/17.
//  Copyright © 2017 gnithin. All rights reserved.
//

#import "KMFTCustomFeature.h"

@implementation KMFTCustomFeature

- (void)repeatedMethodCaller{
    [self complicatedFeature:MyFeaturePathA];
    [self commonMethod];
    [self callMethodA];
}

- (NSNumber *)complicatedFeature:(MyFeaturePath)path{
    [self commonMethod];
    switch (path) {
        case MyFeaturePathA:
            [self callMethodA];
            break;
        case MyFeaturePathB:
            [self callMethodB];
            break;
        case MyFeaturePathC:
            [self callMethodC];
            break;
        default:
            break;
    }
    
    return [NSNumber numberWithInt:42];
}

- (void)callMethodA{
    NSLog(@"MethodA called!");
}

- (void)callMethodB{
    NSLog(@"MethodB called!");
}

- (void)callMethodC{
    NSLog(@"MethodC called!");
}

- (void)commonMethod{
    NSLog(@"Common method called!");
}

@end
