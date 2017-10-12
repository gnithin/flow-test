//
//  KMFAspectHandler.m
//  flow-test
//
//  Created by nithin.g on 12/10/17.
//

#import "KMFAspectHandler.h"
#import "KMFSpecDetails.h"
#import "KMFMethodSpec+Internal.h"

@interface KMFAspectHandler()
@property (nonatomic) NSArray<KMFSpecDetails *> *specDetailsList;
@property (nonatomic) NSArray<id<Aspect>> *flowTestAspectsList;
@end

@implementation KMFAspectHandler

+ (instancetype)instanceWithSpecs:(NSArray<KMFMethodSpec *> *)specsList{
    KMFAspectHandler *instance = [[KMFAspectHandler alloc] init];
    [instance generateSpecDetailsFromSpecList:specsList];
    return instance;
}

- (void)generateSpecDetailsFromSpecList:(NSArray<KMFMethodSpec *> *)specsList{
    if(specsList == nil || [specsList count] == 0){
        specsList = nil;
        return;
    }
    
    NSMutableArray<KMFSpecDetails *> *specDetailsArr = [[NSMutableArray alloc] initWithCapacity:[specsList count]];
    NSUInteger specIndex = 0;
    for(KMFMethodSpec *spec in specsList){
        KMFSpecDetails *specDetails = [KMFSpecDetails instanceWithSpec:spec andIndex:specIndex];
        specIndex += 1;
        [specDetailsArr addObject:specDetails];
    }
    
    if(specDetailsArr != nil && [specDetailsArr count] > 0){
        self.specDetailsList = [NSArray arrayWithArray:specDetailsArr];
    }
}

#pragma mark - Setting up point-cuts

- (BOOL)setupPointCuts{
    NSMutableArray<id<Aspect>> *aspectsList = [[NSMutableArray alloc] initWithCapacity: [self.specDetailsList count]];
    
    for(KMFSpecDetails *specDetails in self.specDetailsList){
        id<Aspect> aspectObj = [self setupPointCutForSpecDetails:specDetails];
        if(aspectObj != nil){
            [aspectsList addObject:aspectObj];
        }
    }
    return YES;
}

/// Setting up point cuts for every entry in the specDetails
- (id<Aspect>)setupPointCutForSpecDetails:(KMFSpecDetails *)specDetails{
    KMFMethodSpec *methodSpec = [specDetails methodSpec];
    NSString *className = [methodSpec className];
    NSString *methodName = [methodSpec methodSig];
    
    Class classVal = NSClassFromString(className);
    NSError *aspectErr = nil;
    
    void(^methodReplacement)(id, NSArray *) = ^(id instance, NSArray *args){
        // TODO: Perform the test synchronization here
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

/// Remove point-cuts for specs
- (BOOL)removeAllPointCuts{
    if(self.flowTestAspectsList == nil){
        return NO;
    }
    
    for(id<Aspect> aspectObj in self.flowTestAspectsList){
        [aspectObj remove];
    }
    return YES;
}

@end
