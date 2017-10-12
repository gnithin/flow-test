//
//  KMFTestManager.h
//  flow-test
//
//  Created by nithin.g on 12/10/17.
//

#import <XCTest/XCTest.h>
#import "KMFMethodSpec.h"

@interface KMFTestManager : XCTestCase

/// Called before every test is executed.
- (void)setUpFlowTest;

/// Called after every test is executed.
- (void)tearDownFlowTest;

/// This method returns the list of methods-specs to be checked
- (NSArray<KMFMethodSpec *> * _Nullable)flowMethodSpecsList;

@end
