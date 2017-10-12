//
//  KMFSpecDetails.m
//  flow-test
//
//  Created by nithin.g on 12/10/17.
//

#import "KMFSpecDetails.h"

@implementation KMFSpecDetails

+ (instancetype)instanceWithSpec:(KMFMethodSpec *)spec andIndex:(NSUInteger)index{
    KMFSpecDetails *specDetails = [[KMFSpecDetails alloc] init];
    specDetails.methodSpec = spec;
    specDetails.specIndex = index;
    return specDetails;
}

@end
