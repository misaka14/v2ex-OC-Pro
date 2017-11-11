//
//  WTURLConst.m
//  v2ex
//
//  Created by 无头骑士 GJ on 16/1/14.
//  Copyright © 2016年 无头骑士 GJ. All rights reserved.
//

#import "WTURLConst.h"

/** 协议头 */
NSString * const WTHTTP = @"https:";

/** base URL */
NSString * const WTHTTPBaseUrl = @"https://www.v2ex.com";

/** 最新节点的URL */
NSString * const WTNewestUrl = @"/recent";

/** 登陆的URL */
NSString * const WTLoginUrl = @"/signin";

/** 两步验证的URL */
NSString * const WTLogin2faUrl = @"/2fa";

/** 全部节点的URL */
NSString * const WTAllNodeUrl = @"https://www.v2ex.com/api/nodes/all.json";

/** 收藏话题URL */
NSString * const WTCollectionTopicUrl = @"https://www.v2ex.com/my/topics";



/** 消息URL*/
NSString * const WTNotificationUrl = @"https://www.v2ex.com/notifications";

/** 自己的全部主题 */
NSString * const WTMeTopicUrl = @"https://www.v2ex.com/member/misaka14/topics";

/** 回复别人的话题 */
NSString * const WTReplyTopicUrl = @"https://www.v2ex.com/member/misaka14/replies?p=1";

/** 领取今日奖励 */
NSString * const WTReceiveAwardsUrl = @"https://www.v2ex.com/mission/daily/redeem?once=";
/** 用户信息URL */
NSString * const WTUserInfoUrl = @"https://www.v2ex.com/member";
/** 上传图片 */
NSString * const WTUploadPictureUrl = @"https://pic.xiaojianjian.net/webtools/picbed/upload.htm";

/** 注册 */
NSString * const WTRegisterUrl = @"signup";

/** 继续注册 */
NSString * const WTContinueRegisterUrl = @"signup/confirm";


/** domain*/
NSString * const WTDomain = @"com.miaska14.com";
/** code */
CGFloat const WTErrorCode = -1011;
/** errorMessage的key */
NSString * const WTErrorMessageKey = @"message";

/** www.misaka14.com服务器 */
NSString * const WTMisaka14Domain = @"https://www.misaka14.com/V2EX_JAVA/";
/** 搜索话题 */
NSString * const WTSearchTopicUrl = @"worm?method=searchTopic";

