//
//  KMFTCustomFeature.h
//  flow-test_Tests
//
//  Created by nithin.g on 13/10/17.
//  Copyright © 2017 gnithin. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    MyFeatureNone,
    MyFeaturePathA,
    MyFeaturePathB,
    MyFeaturePathC,
} MyFeaturePath;

@interface KMFTCustomFeature : NSObject

- (NSNumber *)complicatedFeature:(MyFeaturePath)path;
- (void)repeatedMethodCaller;

@end
