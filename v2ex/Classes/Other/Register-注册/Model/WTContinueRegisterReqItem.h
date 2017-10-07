//
//  WTContineRegisterReqItem.h
//  v2ex
//
//  Created by 无头骑士 GJ on 2017/10/6.
//  Copyright © 2017年 无头骑士 GJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WTContinueRegisterReqItem : NSObject

/** once　*/
@property (nonatomic ,strong) NSString *once;

/** code　*/
@property (nonatomic ,strong) NSString *code;


/**
 快速初始化

 @param once once
 @param code code
 @return WTContinueRegisterReqItem
 */
- (instancetype)initWithOnce:(NSString *)once code:(NSString *)code;
@end
