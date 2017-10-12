//
//  KMFAspectHandler.h
//  flow-test
//
//  Created by nithin.g on 12/10/17.
//

#import <Foundation/Foundation.h>
#import "KMFMethodSpec.h"
@import Aspects;

NS_ASSUME_NONNULL_BEGIN

@interface KMFAspectHandler : NSObject

+ (instancetype)instanceWithSpecs:(NSArray<KMFMethodSpec *> *)specsList andFlowTestBlock:(void(^)(NSInvocation *, KMFMethodSpec *))flowTestBlock;
- (BOOL)removeAllPointCuts;

@end

NS_ASSUME_NONNULL_END
