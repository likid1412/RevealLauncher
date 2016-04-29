//
//  HookReveal.m
//  HookReveal
//
//  Created by yangchenghu on 10/21/14.
//  Copyright (c) 2014 yangch. All rights reserved.
//

#import "HookReveal.h"
#import <objc/runtime.h>

@implementation HookReveal

IMP sOriginalImp = NULL;

//void -[IBATrialModeReminderPresenter showTrialModeSheetForWindow:canDelayContinue:](void * self, void * _cmd, void * arg2, char arg3) {


+ (void)load
{
    sOriginalImp = [[self class]
                    repleaseOldClass:@"IBATrialModeReminderPresenter"
                    newClass:NSStringFromClass([self class])
                    oldMethods:@"shouldShowTrialModeSheet"
                    newMethods:@"lk_shouldShowTrialModeSheet"];

}

+ (IMP)repleaseOldClass:(NSString *)strOldClass
               newClass:(NSString *)strNewClass
             oldMethods:(NSString *)strOldMethod
             newMethods:(NSString *)strNewMethod
{
    Class originalClass = NSClassFromString(strOldClass);
    Method originalMeth = class_getInstanceMethod(originalClass, NSSelectorFromString(strOldMethod));
    IMP impOriginal = method_getImplementation(originalMeth);
    Method replacementMeth = class_getInstanceMethod(NSClassFromString(strNewClass), NSSelectorFromString(strNewMethod));
    method_exchangeImplementations(originalMeth, replacementMeth);
    
    return impOriginal;
}

// reveal V1.6.3
- (BOOL)lk_shouldShowTrialModeSheet
{
    return 0;
}
@end
