//
//  KMFSpecDetails.h
//  flow-test
//
//  Created by nithin.g on 12/10/17.
//

#import <Foundation/Foundation.h>
#import "KMFMethodSpec.h"

NS_ASSUME_NONNULL_BEGIN

@interface KMFSpecDetails : NSObject

@property (nonnull) KMFMethodSpec *methodSpec;
@property (nonatomic) NSUInteger specIndex;

+ (instancetype)instanceWithSpec:(KMFMethodSpec *)spec andIndex:(NSUInteger)index;

@end

NS_ASSUME_NONNULL_END
