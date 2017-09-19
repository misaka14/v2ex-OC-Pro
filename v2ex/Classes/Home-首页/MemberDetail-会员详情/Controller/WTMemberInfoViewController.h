//
//  WTTMemberInfoViewController.h
//  v2ex
//
//  Created by gengjie on 2016/10/21.
//  Copyright © 2016年 无头骑士 GJ. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WTMemberItem, WTUserItem;
@interface WTMemberInfoViewController : UIViewController


+ (instancetype)memberInfoVC;
/**
 快速创建的类方法

 @param memberItem v2ex用户信息
 @param userItem   misaka14用户信息

 @return    WTTMemberInfoViewController
 */
- (instancetype)initWithMemberItem:(WTMemberItem *)memberItem userItem:(WTUserItem *)userItem;

@end
