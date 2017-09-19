//
//  WTLoginViewController.h
//  v2ex
//
//  Created by 无头骑士 GJ on 16/2/23.
//  Copyright © 2016年 无头骑士 GJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WTLoginViewController : UIViewController
/** 登陆成功的回调 */
@property (nonatomic, copy) void (^loginSuccessBlock)();
@end
