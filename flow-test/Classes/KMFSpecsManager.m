//
//  KMFSpecsManager.m
//  flow-test
//
//  Created by nithin.g on 19/10/17.
//

#import "KMFSpecsManager.h"
#import "KMFMethodSpec+Internal.h"

@implementation KMFSpecsManager

+ (instancetype)getInstance{
    return [[KMFSpecsManager alloc] init];
}

- (instancetype)init{
    self = [super init];
    if(self){
        _specsList = [[NSMutableArray alloc] init];
        _calledSpecsList = [[NSMutableArray alloc] init];
    }
    return self;
}

- (BOOL)updateSpecsList:(NSArray<KMFMethodSpec *> *)methodSpecsList{
    if(methodSpecsList == nil || [methodSpecsList count] == 0){
        return NO;
    }
    
    [self.specsList addObjectsFromArray:methodSpecsList];
    return YES;
}

- (void)methodCalledForSpec:(KMFMethodSpec *)spec{
    @synchronized(self){
        if(spec != nil){
            [self.calledSpecsList addObject:spec];
        }
    }
}

#pragma mark - Specs evaluation

- (void)performFlowCheckingWithErr:(NSError **)flowErr{
    NSString *flowErrStr = nil;
    if(self.specsList == nil || [self.specsList count] == 0){
        flowErrStr = @"Specs list cannot be empty!";
    }else if(self.calledSpecsList == nil || [self.calledSpecsList count] == 0){
        flowErrStr = @"It seems none of the methods in the specs list have been called at all!";
    }else if([self.calledSpecsList count] > [self.specsList count]){
        flowErrStr = @"The number of items called are more than what have been listed. Maybe some calls were duplicated!";
    }else if([self.calledSpecsList count] < [self.specsList count]){
        flowErrStr = @"The number of items called is less than what have been listed!";
    }else{
        // The counts of both the specs are equal!
        // Checking for values of specsList and calledSpecsList.
        BOOL specsAreEqual = YES;
        
        // Perform the actual mapping comparision here.
        NSUInteger i;
        KMFMethodSpec *expectedSpec = nil;
        KMFMethodSpec *actualSpec = nil;
        
        for(i = 0; i<[self.calledSpecsList count]; i++){
            expectedSpec = [self.specsList objectAtIndex:i];
            actualSpec = [self.calledSpecsList objectAtIndex:i];
            if(NO == [self areTwoSpecsEqual:expectedSpec :actualSpec]){
                specsAreEqual = NO;
                break;
            }
        }
        
        if(NO == specsAreEqual){
            flowErrStr = [NSString stringWithFormat:@"Specs are not equal starting from index - %lu. Expected %@, got %@", (unsigned long)i, [expectedSpec description], [actualSpec description]];
        }
        
    }
    
    if(flowErrStr == nil){
        // Passed all the tests!
        return;
    }
    
    NSString *specsListStr = [self getSpecsListStr:self.specsList];
    NSString *calledSpecsListStr = [self getSpecsListStr:self.calledSpecsList];
    NSString *flowVerboserErrStr = [NSString stringWithFormat:@"%@\n*** Expected methods -\n%@\n*** Called methods - \n%@\n", flowErrStr, specsListStr, calledSpecsListStr];
    
    // Add both the lists in a readable way here
    (*flowErr) = [NSError errorWithDomain:@"KMFTestManager"
                                     code:-2000
                                 userInfo:@{
                                            NSLocalizedDescriptionKey: [NSBundle.mainBundle localizedStringForKey:flowVerboserErrStr value:@"" table:nil],
                                            }];
}

- (NSString *)getSpecsListStr:(NSMutableArray<KMFMethodSpec *> *)specsList{
    if(specsList == nil || [specsList count] == 0){
        return @"Empty";
    }
    
    NSMutableString *specStr = [[NSMutableString alloc] init];
    NSUInteger index = 0;
    for(KMFMethodSpec *spec in specsList){
        [specStr appendFormat:@"%ld- %@\n", (unsigned long)index, [spec description]];
        index += 1;
    }
    
    return [NSString stringWithString:specStr];
}

- (BOOL)areTwoSpecsEqual:(KMFMethodSpec *)firstSpec :(KMFMethodSpec *)secondSpec{
    if(firstSpec == nil || secondSpec == nil){
        return NO;
    }
    
    return ([[firstSpec className] isEqualToString:[secondSpec className]] &&
            [[firstSpec methodSig] isEqualToString:[secondSpec methodSig]]);
}

@end
