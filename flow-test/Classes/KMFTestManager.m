//
//  KMFTestManager.m
//  flow-test
//
//  Created by nithin.g on 12/10/17.
//

#import "KMFTestManager.h"
#import "KMFAspectHandler.h"

@interface KMFTestManager()
@property (nonatomic) NSArray<KMFMethodSpec *> *specsList;
@property (nonatomic) KMFAspectHandler *aspectHandler;
@end

@implementation KMFTestManager

- (void)setUp{
    [super setUp];
    [self setUpFlowTest];
}

- (void)tearDown{
    [self tearDownFlowTest];
    [super tearDown];
}

#pragma mark - Public methods

- (void)setUpFlowTest{
    NSArray<KMFMethodSpec *> *specsList = [self flowMethodSpecsList];
    if(specsList == nil || [specsList count] == 0){
        specsList = nil;
        return;
    }
    self.specsList = specsList;
    
    void(^flowTestBlock)(NSInvocation *, KMFMethodSpec *) = ^(NSInvocation *invocation, KMFMethodSpec *spec){
        // TODO: Perform the test synchronization here
        [invocation invoke];
    };
    // Perform the point-cuts for all the classes and the methods
    self.aspectHandler = [KMFAspectHandler instanceWithSpecs:self.specsList
                                            andFlowTestBlock:flowTestBlock];
    
}

- (void)tearDownFlowTest{
    if(self.aspectHandler == nil){
        return;
    }
    
    [self.aspectHandler removeAllPointCuts];
}

/// This is a method that'll be implemented by the sub-class.
/// NOTE: Not going the delegate way, since this seems to be simpler (for now :p)
/// NOTE: Since I am going the base-class route, have to think about supporting c-type methods as well (In the future of-course. Always in the future)
- (NSArray<KMFMethodSpec *> *)flowMethodSpecsList{
    return nil;
}

@end
