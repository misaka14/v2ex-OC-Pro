//
//  WTProgressHUD.h
//  v2ex
//
//  Created by gengjie on 2016/10/24.
//  Copyright © 2016年 无头骑士 GJ. All rights reserved.
//

#import <JGProgressHUD/JGProgressHUD.h>

@interface WTProgressHUD : JGProgressHUD

+ (instancetype)shareProgressHUD;

- (void)errorWithMessage:(NSString *)message;

- (void)successWithMessage:(NSString *)message;

- (void)progress;

- (void)hide;
@end

