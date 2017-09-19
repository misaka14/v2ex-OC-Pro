//
//  WTSearchTopicCell.h
//  v2ex
//
//  Created by 无头骑士 GJ on 2017/7/9.
//  Copyright © 2017年 无头骑士 GJ. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WTSearchTopic;
@interface WTSearchTopicCell : UITableViewCell

@property (nonatomic, strong) NSString *keywords;

@property (nonatomic, strong) WTSearchTopic *searchTopic;

@end
