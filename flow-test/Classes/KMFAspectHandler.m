//
//  KMFAspectHandler.m
//  flow-test
//
//  Created by nithin.g on 12/10/17.
//

#import "KMFAspectHandler.h"
#import "KMFMethodSpec+Internal.h"

@interface KMFAspectHandler()
@property (nonatomic) NSMutableArray<id<Aspect>> *flowTestAspectsList;
@end

@implementation KMFAspectHandler

+ (instancetype)instanceWithSpecs:(NSArray<KMFMethodSpec *> *)specsList
                 andFlowTestBlock:(void(^)(NSInvocation *, KMFMethodSpec *))flowTestBlock{
    KMFAspectHandler *instance = [[KMFAspectHandler alloc] init];
    [instance setupPointCutsWithBlock:flowTestBlock
                             forSpecs:specsList];
    return instance;
}

- (instancetype)init{
    self = [super init];
    _flowTestAspectsList = [[NSMutableArray alloc] init];
    return self;
}

#pragma mark - Setting up point-cuts

- (BOOL)setupPointCutsWithBlock:(void(^)(NSInvocation *, KMFMethodSpec *))flowTestBlock
                       forSpecs:(NSArray<KMFMethodSpec *> *)specsList
{
    for(KMFMethodSpec *spec in specsList){
        id<Aspect> aspectObj = [self setupPointCutForSpec:spec withBlock:flowTestBlock];
        if(aspectObj != nil){
            [self.flowTestAspectsList addObject:aspectObj];
        }
    }
    return YES;
}

/// Setting up point cuts for every entry in the specDetails
- (id<Aspect>)setupPointCutForSpec:(KMFMethodSpec *)spec
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
    if(aspectErr != nil || aspectObj == nil){
        NSLog(@"Failed point-cutting aspect - %@ %@", className, methodName);
        if(aspectErr != nil){
            NSLog(@"With error - %@", aspectErr);
        }
        
        [NSException raise:@"flowTestUnexpectedMethodSpec" format:@"An unexpected method-spec was encountered! - [%@ %@]. It could be a spelling issue or it could be a static method(static methods aren't supported)", className, methodName];
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
