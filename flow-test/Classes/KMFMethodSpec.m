//
//  KMFMethodSpec.m
//  flow-test
//
//  Created by nithin.g on 12/10/17.
//

#import "KMFMethodSpec.h"

@interface KMFMethodSpec()
@property (nonnull) NSString *methodSig;
@property (nonnull) NSString *className;
@end

@implementation KMFMethodSpec

+ (instancetype)className:(NSString *)className
      withMethodSignature:(NSString *)methodSig
{
    KMFMethodSpec *instance = [[[self class] alloc] init];
    instance.methodSig = methodSig;
    instance.className = className;
    return instance;
}

@end
