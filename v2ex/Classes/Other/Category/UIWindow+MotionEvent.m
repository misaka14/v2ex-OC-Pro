//
//  UIWindow+MotionEvent.m
//  v2ex
//
//  Created by 无头骑士 GJ on 2017/10/4.
//  Copyright © 2017年 无头骑士 GJ. All rights reserved.
//

#import "UIWindow+MotionEvent.h"

@implementation UIWindow (MotionEvent)
- (BOOL)canBecomeFirstResponder {//默认是NO，所以得重写此方法，设成YES
    return YES;
}


- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if ([DKNightVersionManager sharedManager].themeVersion == DKThemeVersionNight)
        [[DKNightVersionManager sharedManager] dawnComing];
    else
        [[DKNightVersionManager sharedManager] nightFalling];
}

- (void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
}

@end
