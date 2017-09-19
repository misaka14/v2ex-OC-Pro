//
//  WTAccount.m
//  v2ex
//
//  Created by 无头骑士 GJ on 16/2/23.
//  Copyright © 2016年 无头骑士 GJ. All rights reserved.
//

#import "WTAccount.h"

#define WTUsernameOrEmail @"usernameOrEmail"
#define WTPassword @"password"

@implementation WTAccount


#pragma mark - NSCoding
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject: self.usernameOrEmail forKey: WTUsernameOrEmail];
    [aCoder encodeObject: self.password forKey: WTPassword];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init])
    {
        self.usernameOrEmail = [aDecoder decodeObjectForKey: WTUsernameOrEmail];
        self.password = [aDecoder decodeObjectForKey: WTPassword];
    }
    return self;
}


@end
