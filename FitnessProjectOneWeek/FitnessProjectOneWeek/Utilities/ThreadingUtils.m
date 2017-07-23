//
//  ThreadingUtils.m
//  FitnessProjectOneWeek
//
//  Created by redmond\rugos on 7/22/17.
//  Copyright © 2017 Rushabh Gosar. All rights reserved.
//

#import "ThreadingUtils.h"

@implementation ThreadingUtils
+ (void) onMainThreadAsync:(void (^)(void))completion
{
    if ([NSThread isMainThread])
    {
        if (completion)
        {
            completion();
        }
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), completion);
    }
}

+ (void) onMainThreadSyncSafe:(void (^)(void))completion
{
    if ([NSThread isMainThread])
    {
        if (completion)
        {
            completion();
        }
    }
    else
    {
        dispatch_sync(dispatch_get_main_queue(), completion);
    }
}

+ (void) onBackgroundThread:(void (^)(void))completion priority:(long)pri
{
    if (![NSThread isMainThread])
    {
        if (completion)
        {
            completion();
        }
    }
    else
    {
        dispatch_async(dispatch_get_global_queue(pri, 0), completion);
    }
}
@end
