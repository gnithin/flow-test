//
//  KMFAspectHandler.m
//  flow-test
//
//  Created by nithin.g on 12/10/17.
//

#import "KMFAspectHandler.h"
#import "KMFMethodSpec+Internal.h"

@interface KMFAspectHandler()
@property (nonatomic) NSArray<KMFMethodSpec *> *specsList;
@property (nonatomic) NSArray<id<Aspect>> *flowTestAspectsList;
@end

@implementation KMFAspectHandler

+ (instancetype)instanceWithSpecs:(NSArray<KMFMethodSpec *> *)specsList{
    KMFAspectHandler *instance = [[KMFAspectHandler alloc] init];
    instance.specsList = specsList;
    return instance;
}

#pragma mark - Setting up point-cuts

- (BOOL)setupPointCutsWithBlock:(void(^)(NSInvocation *, KMFMethodSpec *))flowTestBlock{
    NSMutableArray<id<Aspect>> *aspectsList = [[NSMutableArray alloc] initWithCapacity: [self.specsList count]];
    
    for(KMFMethodSpec *spec in self.specsList){
        id<Aspect> aspectObj = [self setupPointCutForSpecDetails:spec withBlock:flowTestBlock];
        if(aspectObj != nil){
            [aspectsList addObject:aspectObj];
        }
    }
    return YES;
}

/// Setting up point cuts for every entry in the specDetails
- (id<Aspect>)setupPointCutForSpecDetails:(KMFMethodSpec *)spec
                                withBlock:(void(^)(NSInvocation *, KMFMethodSpec *))flowTestBlock
{
    NSString *className = [spec className];
    NSString *methodName = [spec methodSig];
    
    Class classVal = NSClassFromString(className);
    NSError *aspectErr = nil;
    
    void(^methodReplacement)(id, NSArray *) = ^(id instance, NSArray *args){
        NSInvocation *invocation = [args lastObject];
        flowTestBlock(invocation, spec);
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
