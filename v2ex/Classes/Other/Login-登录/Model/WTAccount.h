//
//  WTAccount.h
//  v2ex
//
//  Created by 无头骑士 GJ on 16/2/23.
//  Copyright © 2016年 无头骑士 GJ. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface WTAccount : NSObject <NSCoding>
/** 用户名或邮箱 */
@property (nonatomic, strong) NSString                              *usernameOrEmail;
/** 密码 */
@property (nonatomic, strong) NSString                              *password;
/** 是否已经领取过奖励 */
@property (nonatomic, assign, getter=isReceiveAwards) BOOL          receiveAwards;
/** 领取奖励需要的once的值 */
@property (nonatomic, strong) NSString                              *once;
/** 签名 */
@property (nonatomic, strong) NSString                              *signature;
/** 头像*/
@property (nonatomic, strong) NSURL                                 *avatarURL;

@property (nonatomic, strong) NSString                              *pastUrl;

@end
