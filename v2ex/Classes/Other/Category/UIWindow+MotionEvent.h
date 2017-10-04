//
//  UIWindow+MotionEvent.h
//  v2ex
//
//  Created by 无头骑士 GJ on 2017/10/4.
//  Copyright © 2017年 无头骑士 GJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIWindow (MotionEvent)

// @override
- (BOOL)canBecomeFirstResponder;

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event;

@end
