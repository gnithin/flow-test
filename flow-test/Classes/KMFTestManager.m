//
//  KMFTestManager.m
//  flow-test
//
//  Created by nithin.g on 12/10/17.
//

#import "KMFTestManager.h"
#import "KMFSpecsManager.h"
#import "KMFAspectHandler.h"

static NSString *FLOW_TEST_PREFIX = @"testFlow";

@interface KMFTestManager()
@property (nonatomic) KMFAspectHandler *aspectHandler;
@property (nonatomic) KMFSpecsManager *specsManager;
@end

@implementation KMFTestManager

- (void)setUp{
    [super setUp];
    if([self doesTestNameBeginWithFlow]){
        [self setUpFlowTest];
    }
}

- (void)setUpFlowTest{
    self.specsManager = [KMFSpecsManager getInstance];
    
    NSArray<KMFMethodSpec *> *specsList = [self flowMethodSpecsList];
    [self addMethodSpecsList:specsList];
}

- (void)tearDown{
    [self tearDownFlowTest];
    [super tearDown];
}

- (void)tearDownFlowTest{
    if(self.aspectHandler == nil){
        return;
    }
    [self.aspectHandler removeAllPointCuts];
    
    NSError *flowErr;
    [self.specsManager performFlowCheckingWithErr:&flowErr];
    
    if(flowErr != nil){
        // Something went wrong
        XCTFail("Failed flow-test - %@, with error - %@", self.name, [flowErr localizedDescription]);
    }
}

#pragma mark - Public methods

- (void)addMethodSpecsList:(NSArray<KMFMethodSpec *> * _Nonnull)methodSpecsList{
    BOOL didUpdateSpecs = [self.specsManager updateSpecsList:methodSpecsList];
    if(NO == didUpdateSpecs){
        return;
    }
    
    __weak KMFTestManager *weakSelf = self;
    void(^flowTestBlock)(NSInvocation *, KMFMethodSpec *) = ^(NSInvocation *invocation, KMFMethodSpec *spec){
        KMFTestManager *strongSelf = weakSelf;
        if(strongSelf != nil){
            [strongSelf.specsManager methodCalledForSpec:spec];
        }
        
        [invocation invoke];
    };
    
    if(self.aspectHandler == nil){
        self.aspectHandler = [KMFAspectHandler instanceWithSpecs:methodSpecsList
                                                andFlowTestBlock:flowTestBlock];
    }else{
        [self.aspectHandler setupPointCutsWithBlock:flowTestBlock forSpecs:methodSpecsList];
    }
}

// This is a method that'll be implemented by the sub-class
- (NSArray<KMFMethodSpec *> *)flowMethodSpecsList{
    return nil;
}

#pragma mark - Helpers

/// Returns if the current test name begins with `testFlow`.
- (BOOL)doesTestNameBeginWithFlow{
    NSString *fullTestName = [self.name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *testNameStr = [[fullTestName componentsSeparatedByString:@" "] lastObject];
    return [testNameStr hasPrefix:FLOW_TEST_PREFIX];
}

@end
