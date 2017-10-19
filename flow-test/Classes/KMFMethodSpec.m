//
//  KMFMethodSpec.m
//  flow-test
//
//  Created by nithin.g on 12/10/17.
//

#import "KMFMethodSpec+Internal.h"

@implementation KMFMethodSpec

+ (instancetype)className:(NSString *)className
      withMethodSignature:(NSString *)methodSig
{
    KMFMethodSpec *instance = [[[self class] alloc] init];
    instance.methodSig = methodSig;
    instance.className = className;
    return instance;
}

- (NSString *)stringShortHand{
    return [NSString stringWithFormat:@"%@->%@", self.className, self.methodSig];
}

- (NSString *)description{
    return [NSString stringWithFormat:@"[%@ %@]", self.className, self.methodSig];
}

@end
