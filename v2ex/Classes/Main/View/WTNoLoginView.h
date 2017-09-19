//
//  WTNoLoginView.h
//  v2ex
//
//  Created by 无头骑士 GJ on 2017/4/22.
//  Copyright © 2017年 无头骑士 GJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WTNoLoginView : UIView
/** 登陆成功的回调 */
@property (nonatomic, copy) void (^loginSuccessBlock)();
/** 标题 */
@property (nonatomic, strong) NSString *title;
@end
