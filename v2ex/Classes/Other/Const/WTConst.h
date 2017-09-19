//
//  WTConst.h
//  v2ex
//
//  Created by 无头骑士 GJ on 16/1/30.
//  Copyright © 2016年 无头骑士 GJ. All rights reserved.
//
#import <UIKit/UIKit.h>


typedef NS_ENUM(NSUInteger, WTTableViewType) {
    WTTableViewTypeRefresh,
    WTTableViewTypeNoData,
    WTTableViewTypeLogout,
    WTTableViewTypeNormal,
    WTTableViewTypeError,
};
/** 标题View的高度 */
UIKIT_EXTERN CGFloat const WTTitleViewHeight;
/** 导航栏的Y的最大值  */
UIKIT_EXTERN CGFloat const WTNavigationBarMaxY;
/** TabBar的高度*/
UIKIT_EXTERN CGFloat const WTTabBarHeight;
/** 通用边距*/
UIKIT_EXTERN CGFloat const WTMargin;
/** 工具条的高度 */
UIKIT_EXTERN CGFloat const WTToolBarHeight;
/** 导航栏的高度 */
UIKIT_EXTERN CGFloat const WTNavigationBarHeight;
/** 状态栏的高度 */
UIKIT_EXTERN CGFloat const WTStatusBarHeight;

/** App白天主色调 */
UIKIT_EXTERN NSString * const WTAppLightColor;

/** 正常颜色*/
UIKIT_EXTERN NSString * const WTNormalColor;
/** 非正常颜色*/
UIKIT_EXTERN NSString * const WTNoNormalColor;

/** 工具栏上按钮点击的通知 */
UIKIT_EXTERN NSString * const WTToolBarButtonClickNotification;

/** 登陆状态发生变化 通知　*/
UIKIT_EXTERN NSString * const WTLoginStateChangeNotification;

/** 用户控制器头部View的高度 */
UIKIT_EXTERN CGFloat const WTUserInfoHeadViewHeight;
/** 用户控制器toolBar的高度*/
UIKIT_EXTERN CGFloat const WTUserInfoToolBarHeight;
/** 用户控制器占位的View高度*/
UIKIT_EXTERN CGFloat const WTUserInfoPlaceHolderViewHeight;

/** 不存在这个用户的提示 */
UIKIT_EXTERN NSString * const WTNoExistMemberTip;

/** 话题主颜色　*/
UIKIT_EXTERN NSString * const WTTopicCellMainColor;

/** 未读通知 */
UIKIT_EXTERN NSString * const WTUnReadNotificationNotification;

/** 未读通知个数 */
UIKIT_EXTERN NSString * const WTUnReadNumKey;
