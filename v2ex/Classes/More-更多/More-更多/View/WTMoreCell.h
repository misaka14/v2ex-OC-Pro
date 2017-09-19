//
//  WTMoreCell.h
//  v2ex
//
//  Created by 无头骑士 GJ on 16/7/25.
//  Copyright © 2016年 无头骑士 GJ. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WTSettingItem;
@interface WTMoreCell : UITableViewCell

@property (nonatomic, strong) NSString *title;

@property (nonatomic, strong) NSArray<WTSettingItem *> *settingItems;

@end
