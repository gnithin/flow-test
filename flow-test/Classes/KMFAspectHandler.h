//
//  KMFAspectHandler.h
//  flow-test
//
//  Created by nithin.g on 12/10/17.
//

#import <Foundation/Foundation.h>
#import "KMFMethodSpec.h"
@import Aspects;

@interface KMFAspectHandler : NSObject

+ (instancetype)instanceWithSpecs:(NSArray<KMFMethodSpec *> *)specsList;
- (BOOL)setupPointCuts;
- (BOOL)removeAllPointCuts;

@end
