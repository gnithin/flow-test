//
//  KMFTestManager.m
//  flow-test
//
//  Created by nithin.g on 12/10/17.
//

#import "KMFTestManager.h"
#import "KMFSpecDetails.h"

@interface KMFTestManager()
@property (nonatomic) NSArray<KMFMethodSpec *> *specsList;
@end

@implementation KMFTestManager

- (void)setUp{
    [super setUp];
    
    self.specsList = [self flowMethodsList];
    if(self.specsList == nil || [self.specsList count] == 0){
        self.specsList = nil;
        return;
    }
    
    // Perform the point-cuts for all the classes and the methods
    [self setupPointCutsForSpecs];
}

- (void)setupPointCutsForSpecs{
    if(self.specsList == nil){
        return;
    }
    
    NSUInteger specIndex = 0;
    for(KMFMethodSpec *spec in self.specsList){
        [self setupPointCutForSpec:spec];
        specIndex += 1;
    }
}

- (void)setupPointCutForSpec:(KMFMethodSpec *)spec{
    
}

/// This is a method that'll be implemented by the sub-class.
/// NOTE: Not going the delegate way, since this seems to be simpler (for now :p)
- (NSArray<KMFMethodSpec *> *)flowMethodsList{
    return nil;
}

- (void)tearDown{
    [super tearDown];
}

@end
