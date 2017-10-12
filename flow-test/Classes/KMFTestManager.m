//
//  KMFTestManager.m
//  flow-test
//
//  Created by nithin.g on 12/10/17.
//

#import "KMFTestManager.h"
#import "KMFSpecDetails.h"
#import "KMFMethodSpec+Internal.h"
@import Aspects;

@interface KMFTestManager()
@property (nonatomic) NSArray<KMFMethodSpec *> *specsList;
@end

@implementation KMFTestManager

#pragma mark - Public methods

- (void)setUp{
    [super setUp];
    
    self.specsList = [self flowMethodSpecsList];
    if(self.specsList == nil || [self.specsList count] == 0){
        self.specsList = nil;
        return;
    }
    
    // Perform the point-cuts for all the classes and the methods
    [self setupPointCutsForSpecs];
}

/// This is a method that'll be implemented by the sub-class.
/// NOTE: Not going the delegate way, since this seems to be simpler (for now :p)
- (NSArray<KMFMethodSpec *> *)flowMethodSpecsList{
    return nil;
}

- (void)tearDown{
    [super tearDown];
}

#pragma mark - point-cut setup

/// Setup point-cuts for specs
- (void)setupPointCutsForSpecs{
    if(self.specsList == nil){
        return;
    }
    
    NSUInteger specIndex = 0;
    for(KMFMethodSpec *spec in self.specsList){
        KMFSpecDetails *specdetails = [KMFSpecDetails instanceWithSpec:spec andIndex:specIndex];
        [self setupPointCutForSpec:specdetails];
        specIndex += 1;
    }
}

/// Setting up point cuts for every entry in the specDetails
- (void)setupPointCutForSpec:(KMFSpecDetails *)specDetails{
    // TODO: Perform point cuts with default methods
}

@end
