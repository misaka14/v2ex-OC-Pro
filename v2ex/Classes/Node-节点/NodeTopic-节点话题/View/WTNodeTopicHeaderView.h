//
//  WTNodeTopicHeaderView.h
//  v2ex
//
//  Created by 无头骑士 GJ on 16/7/23.
//  Copyright © 2016年 无头骑士 GJ. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WTNodeItem;
@interface WTNodeTopicHeaderView : UIView

@property (nonatomic, strong) WTNodeItem *nodeItem;

+ (instancetype)nodeTopicHeaderView;

@end
