//
//  KMFSpecDetails.h
//  flow-test
//
//  Created by nithin.g on 12/10/17.
//

#import <Foundation/Foundation.h>
#import "KMFMethodSpec.h"

@interface KMFSpecDetails : NSObject

@property (nonnull) KMFMethodSpec *methodSpec;
@property (nonatomic) NSUInteger specIndex;

@end
