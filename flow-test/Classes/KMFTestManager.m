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
@property (nonatomic) NSArray<id<Aspect>> *flowTestAspectsList;

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
/// NOTE: Since I am going the base-class route, have to think about supporting c-type methods as well (In the future of-course. Always in the future)
- (NSArray<KMFMethodSpec *> *)flowMethodSpecsList{
    return nil;
}

- (void)tearDown{
    [self removeAllPointCutsForSpecs];
    [super tearDown];
}

#pragma mark - Point-cut setup

#pragma mark - Add the point-cuts

/// Setup point-cuts for specs
- (void)setupPointCutsForSpecs{
    if(self.specsList == nil || [self.specsList count] == 0){
        return;
    }
    
    NSMutableArray<id<Aspect>> *aspectsList = [[NSMutableArray alloc] initWithCapacity: [self.specsList count]];
    
    NSUInteger specIndex = 0;
    for(KMFMethodSpec *spec in self.specsList){
        KMFSpecDetails *specDetails = [KMFSpecDetails instanceWithSpec:spec andIndex:specIndex];
        specIndex += 1;
        
        id<Aspect> aspectObj = [self setupPointCutForSpecDetails:specDetails];
        if(aspectObj != nil){
            [aspectsList addObject:aspectObj];
        }
    }
}

/// Setting up point cuts for every entry in the specDetails
- (id<Aspect>)setupPointCutForSpecDetails:(KMFSpecDetails *)specDetails{
    KMFMethodSpec *methodSpec = [specDetails methodSpec];
    NSString *className = [methodSpec className];
    NSString *methodName = [methodSpec methodSig];
    NSError *aspectErr = nil;
    Class classVal = NSClassFromString(className);
    
    void(^methodReplacement)(id, NSArray *) = ^(id instance, NSArray *args){ 
        
        NSInvocation *invocation = [args lastObject];
        [invocation invoke];
    };
    
    id<Aspect> aspectObj = [classVal aspect_hookSelector:NSSelectorFromString(methodName)
                                             withOptions:AspectPositionInstead
                                              usingBlock:methodReplacement
                                                   error:&aspectErr];
    if(aspectErr != nil){
        NSLog(@"Failed point-cutting aspect - %@ %@ with error - %@", className, methodName, aspectErr);
        return nil;
    }
    
    return aspectObj;
}

#pragma mark - Remove the point-cuts

// Remove point-cuts for specs
- (void)removeAllPointCutsForSpecs{
    if(self.flowTestAspectsList == nil){
        return;
    }
    
    for(id<Aspect> aspectObj in self.flowTestAspectsList){
        [aspectObj remove];
    }
}

@end
