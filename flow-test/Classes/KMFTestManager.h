//
//  KMFTestManager.h
//  flow-test
//
//  Created by nithin.g on 12/10/17.
//

#import <XCTest/XCTest.h>
#import "KMFMethodSpec.h"

@interface KMFTestManager : XCTest

- (void)setUp;
- (void)tearDown;
- (NSArray<KMFMethodSpec *> * _Nullable)flowMethodsList;

@end
