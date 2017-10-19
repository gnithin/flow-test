//
//  KMFAspectHandler.m
//  flow-test
//
//  Created by nithin.g on 12/10/17.
//

#import "KMFAspectHandler.h"
#import "KMFMethodSpec+Internal.h"

@interface KMFAspectHandler()
@property (nonatomic) NSMutableDictionary<NSString *, id<Aspect>> *flowTestAspectsMap;
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
    if(self){
        _flowTestAspectsMap = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

#pragma mark - Setting up point-cuts

- (BOOL)setupPointCutsWithBlock:(void(^)(NSInvocation *, KMFMethodSpec *))flowTestBlock
                       forSpecs:(NSArray<KMFMethodSpec *> *)specsList
{
    for(KMFMethodSpec *spec in specsList){
        NSString *specNameStr = [spec stringShortHand];
        if([[self.flowTestAspectsMap allKeys] containsObject:specNameStr]){
            continue;
        }
        
        id<Aspect> aspectObj = [self setupPointCutForSpec:spec withBlock:flowTestBlock];
        [self.flowTestAspectsMap setObject:aspectObj forKey:specNameStr];
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
    if(self.flowTestAspectsMap == nil || [self.flowTestAspectsMap count] == 0){
        return NO;
    }
    
    NSArray<id<Aspect>> *aspectsList = [self.flowTestAspectsMap allValues];
    for(id<Aspect> aspectObj in aspectsList){
        [aspectObj remove];
    }
    self.flowTestAspectsMap = nil;
    return YES;
}

@end
