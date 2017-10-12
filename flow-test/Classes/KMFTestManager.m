//
//  KMFTestManager.m
//  flow-test
//
//  Created by nithin.g on 12/10/17.
//

#import "KMFTestManager.h"
#import "KMFAspectHandler.h"
#import "KMFMethodSpec+Internal.h"

static NSString *FLOW_TEST_PREFIX = @"testFlow";

@interface KMFTestManager()
@property (nonatomic) NSArray<KMFMethodSpec *> *specsList;
@property (nonatomic) NSMutableArray<KMFMethodSpec *> *calledSpecsList;
@property (nonatomic) KMFAspectHandler *aspectHandler;
@end

@implementation KMFTestManager

- (void)setUp{
    [super setUp];
    if([self doesTestNameBeginWithFlow]){
        [self setUpFlowTest];
    }
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
    self.calledSpecsList = [[NSMutableArray alloc] initWithCapacity:[self.specsList count]];
    
    __weak KMFTestManager *weakSelf = self;
    void(^flowTestBlock)(NSInvocation *, KMFMethodSpec *) = ^(NSInvocation *invocation, KMFMethodSpec *spec){
        KMFTestManager *strongSelf = weakSelf;
        if(strongSelf != nil){
            [strongSelf methodCalledForSpec:spec];
        }
        
        [invocation invoke];
    };
    
    self.aspectHandler = [KMFAspectHandler instanceWithSpecs:self.specsList
                                            andFlowTestBlock:flowTestBlock];
}

- (void)tearDownFlowTest{
    if(self.aspectHandler == nil){
        return;
    }
    
    [self.aspectHandler removeAllPointCuts];
    
    // Perform flow-checking here
    NSError *flowErr;
    [self performFlowCheckingWithErr:&flowErr];
    if(flowErr != nil){
        // Something went wrong
        XCTFail("Failed flow-test - %@, with error - %@", self.name, [flowErr localizedDescription]);
    }
}

/// This is a method that'll be implemented by the sub-class
- (NSArray<KMFMethodSpec *> *)flowMethodSpecsList{
    return nil;
}
#pragma mark - Helpers

- (void)methodCalledForSpec:(KMFMethodSpec *)spec{
    @synchronized(self){
        if(spec != nil){
            [self.calledSpecsList addObject:spec];
        }
    }
}

- (void)performFlowCheckingWithErr:(NSError **)flowErr{
    NSString *flowErrStr = nil;
    if(self.specsList == nil){
        flowErrStr = @"Specs list cannot be empty!";
    }else if(self.calledSpecsList == nil){
        flowErrStr = @"It seems none of the methods in the specs list have been called at all!";
    }else if([self.calledSpecsList count] > [self.specsList count]){
        flowErrStr = @"The number of items called are more than what have been listed. Maybe some calls were duplicated!";
    }else if([self.calledSpecsList count] < [self.specsList count]){
        flowErrStr = @"The number of items called is less than what have been listed. Maybe some calls were duplicated!";
    }
    
    if(flowErrStr == nil){
        BOOL specsAreEqual = YES;
        
        // Perform the actual mapping comparision here.
        NSUInteger i;
        for(i = 0; i<[self.calledSpecsList count]; i++){
            KMFMethodSpec *expectedSpec = [self.specsList objectAtIndex:i];
            KMFMethodSpec *actualSpec = [self.calledSpecsList objectAtIndex:i];
            if(NO == [self areTwoSpecsEqual:expectedSpec :actualSpec]){
                specsAreEqual = NO;
                break;
            }
        }
        
        if(specsAreEqual){
            return;
        }
        flowErrStr = [NSString stringWithFormat:@"Specs are not equal starting from index - %lu", (unsigned long)i];;
    }
    
    // TODO: Add both the lists in a readable way here
    (*flowErr) = [NSError errorWithDomain:@"KMFTestManager"
                               code:-2000
                           userInfo:@{
                                      NSLocalizedDescriptionKey: [NSBundle.mainBundle localizedStringForKey:flowErrStr value:@"" table:nil],
                                      }];
}

- (BOOL)areTwoSpecsEqual:(KMFMethodSpec *)firstSpec :(KMFMethodSpec *)secondSpec{
    if(firstSpec == nil || secondSpec == nil){
        return NO;
    }
    
    return ([[firstSpec className] isEqualToString:[secondSpec className]] &&
            [[firstSpec methodSig] isEqualToString:[secondSpec methodSig]]);
}

- (BOOL)doesTestNameBeginWithFlow{
    NSString *fullTestName = self.name;
    NSString *testNameStr = [[fullTestName componentsSeparatedByString:@" "] lastObject];
    return [testNameStr hasPrefix:FLOW_TEST_PREFIX];
}

@end
