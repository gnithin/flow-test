#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "KMFAspectHandler.h"
#import "KMFMethodSpec+Internal.h"
#import "KMFMethodSpec.h"
#import "KMFSpecsManager.h"
#import "KMFTestManager.h"

FOUNDATION_EXPORT double flow_testVersionNumber;
FOUNDATION_EXPORT const unsigned char flow_testVersionString[];

