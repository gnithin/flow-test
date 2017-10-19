//
//  KMFMethodSpec+Internal.h
//  flow-test
//
//  Created by nithin.g on 12/10/17.
//

#ifndef KMFMethodSpec_Internal_h
#define KMFMethodSpec_Internal_h

#import "KMFMethodSpec.h"

NS_ASSUME_NONNULL_BEGIN

@interface KMFMethodSpec()
@property (nonnull) NSString *methodSig;
@property (nonnull) NSString *className;

/// This will return a verbose description of the method-signature and class-name
- (NSString *)description;

/// This will return a succinct classname and method-signature string back.
- (NSString *)stringShortHand;
@end

NS_ASSUME_NONNULL_END

#endif /* KMFMethodSpec_Internal_h */
