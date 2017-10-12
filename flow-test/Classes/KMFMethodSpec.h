//
//  KMFMethodSpec.h
//  flow-test
//
//  Created by nithin.g on 12/10/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KMFMethodSpec : NSObject

+ (instancetype)className:(NSString *)className withMethodSignature:(NSString *)methodSig;

- (instancetype)init __attribute__((unavailable("use '[KMFMethodSpec className:WithMethodSignature:]' instead")));

@end

NS_ASSUME_NONNULL_END
