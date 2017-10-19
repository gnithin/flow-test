//
//  KMFSpecsManager.h
//  flow-test
//
//  Created by nithin.g on 19/10/17.
//

#import <Foundation/Foundation.h>
#import "KMFMethodSpec.h"

@interface KMFSpecsManager : NSObject
@property (nonatomic) NSMutableArray<KMFMethodSpec *> *specsList;
@property (nonatomic) NSMutableArray<KMFMethodSpec *> *calledSpecsList;

+ (instancetype)getInstance;

/// Adds the methods-specs list to the existing list. Creates if there are none.
- (BOOL)updateSpecsList:(NSArray<KMFMethodSpec *> *)methodSpecsList;

/// Registers that a particular method-spec is called.
- (void)methodCalledForSpec:(KMFMethodSpec *)spec;

/// Evaluates the method-specs that are expected to be called, over the ones that were
/// actually called. The error argument will contain detailed message of the error.
- (void)performFlowCheckingWithErr:(NSError **)flowErr;

@end
