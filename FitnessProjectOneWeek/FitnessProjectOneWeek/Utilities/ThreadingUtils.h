//
//  ThreadingUtils.h
//  FitnessProjectOneWeek
//
//  Created by redmond\rugos on 7/22/17.
//  Copyright © 2017 Rushabh Gosar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ThreadingUtils : NSObject
+ (void) onMainThreadSyncSafe:(void (^)(void))completion;
+ (void) onMainThreadAsync:(void (^)(void))completion;
+ (void) onBackgroundThread:(void (^)(void))completion priority:(long)pri;
@end
