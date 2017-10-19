//
//  KMFTestManager.h
//  flow-test
//
//  Created by nithin.g on 12/10/17.
//

#import <XCTest/XCTest.h>
#import "KMFMethodSpec.h"

#define KMFAddMethodSpecsList(methodsList) [self addMethodSpecsList:methodsList]

@interface KMFTestManager : XCTestCase

/// @Override - This method returns the list of methods-specs to be checked.
- (NSArray<KMFMethodSpec *> * _Nullable)flowMethodSpecsList;

/// Add the method-specs. Use the KMFAddMethodSpecsList() macro instead.
- (void)addMethodSpecsList:(NSArray<KMFMethodSpec *> * _Nonnull)methodSpecsList;

@end
