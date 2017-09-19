//
//  WTNode.m
//  v2ex
//
//  Created by 无头骑士 GJ on 16/7/21.
//  Copyright © 2016年 无头骑士 GJ. All rights reserved.
//

#import "WTNodeItem.h"
#import "UIFont+Extension.h"
#import "MJExtension.h"
@implementation WTNodeItem

MJCodingImplementation

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"uid" : @"id"};
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    
    self.width = [title boundingRectWithSize: CGSizeMake(WTScreenWidth, 15) options: NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes: @{NSFontAttributeName: [UIFont QiHeiforSize: 15]} context: nil].size.width;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"uid:%@, title:%@", self.uid, self.title];
}

@end
