//
//  WTMoreCell.m
//  v2ex
//
//  Created by 无头骑士 GJ on 16/7/25.
//  Copyright © 2016年 无头骑士 GJ. All rights reserved.
//

#import "WTMoreCell.h"
#import "WTMoreButton.h"
#import "WTSettingItem.h"
#import "UIFont+Extension.h"

/** 按钮列数 */
NSUInteger const WTColumn = 4;
/** headerView的高度 */
CGFloat const WTHeaderViewH = 44;

@interface WTMoreCell()

@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UIView *lineView;
@end

@implementation WTMoreCell

#pragma mark - LifeCycle
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle: style reuseIdentifier: reuseIdentifier])
    {
        self.backgroundColor = [UIColor clearColor];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        // 1、头部的View
        UIView *headerView = [UIView new];
        
        {
            headerView.frame = CGRectMake(0, 0, WTScreenWidth, WTHeaderViewH);
            [self.contentView addSubview: headerView];
            
            headerView.backgroundColor = [UIColor whiteColor];
        }
        
        // 2、标题Label
        UILabel *titleLabel = [UILabel new];
        
        {
            [headerView addSubview: titleLabel];
            self.titleLabel = titleLabel;
            
            
            titleLabel.font = [UIFont QiHeiforSize: 16];
            titleLabel.textColor = [UIColor colorWithHexString: @"#212121"];
            
        }
        
        // 3、分隔线
        UIView *lineView = [UIView new];
        
        {
            [headerView addSubview: lineView];
            self.lineView = lineView;
            
            lineView.backgroundColor = [UIColor colorWithHexString: @"#666666" alpha: 0.1];
        }
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.titleLabel.x = 12;
    self.titleLabel.y = 13;
    
    self.lineView.frame = CGRectMake(0, self.contentView.height - 10, WTScreenWidth, 1);
}

#pragma mark - Setter & Getter
- (void)setTitle:(NSString *)title
{
    _title = title;
    
    self.titleLabel.text = title;
    [self.titleLabel sizeToFit];
}

- (void)setSettingItems:(NSArray<WTSettingItem *> *)settingItems
{
    _settingItems = settingItems;
    
    CGFloat x, y = 0;
    
    // 1、添加设置按钮
    NSUInteger count = settingItems.count;
    for(NSUInteger i = 0; i < count; i++)
    {
        WTSettingItem *item = settingItems[i];
        
        WTMoreButton *moreBtn = [WTMoreButton buttonWithType: UIButtonTypeCustom];
        x = (i % WTColumn) * WTMoreButtonW;
        y = (i / WTColumn) * WTMoreButtonH + WTHeaderViewH;
        moreBtn.frame = CGRectMake(x, y, WTMoreButtonW, WTMoreButtonH);
        [self.contentView addSubview: moreBtn];
        
        moreBtn.tag = i;
        [moreBtn setTitle: item.title forState: UIControlStateNormal];
        [moreBtn setImage: item.image forState: UIControlStateNormal];
        [moreBtn addTarget: self action: @selector(moreBtnClick:) forControlEvents: UIControlEventTouchUpInside];
    }
    
    // 2、补足空余的位置按钮
    NSUInteger surplusCount = WTColumn - count % WTColumn;
    for(NSUInteger i = 0; i < surplusCount; i++)
    {
        WTMoreButton *surplusBtn = [WTMoreButton buttonWithType: UIButtonTypeCustom];
        x = (i + count) % WTColumn * WTMoreButtonW;
        y = (i + count) / WTColumn * WTMoreButtonH + WTHeaderViewH;
        surplusBtn.frame = CGRectMake(x, y, WTMoreButtonW, WTMoreButtonH);
        [self.contentView addSubview: surplusBtn];
    }
}

#pragma mark - 事件
- (void)moreBtnClick:(WTMoreButton *)moreBtn
{
    WTSettingItem *item = self.settingItems[moreBtn.tag];
    
    if (item.operationBlock)
    {
        item.operationBlock();
    }

}

@end
