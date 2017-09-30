//
//  WTThemeCell.m
//  v2ex
//
//  Created by 无头骑士 GJ on 2017/9/19.
//  Copyright © 2017年 无头骑士 GJ. All rights reserved.
//

#import "WTThemeCell.h"

#import "WTThemeItem.h"

@interface WTThemeCell()
/** 截图 */
@property (weak, nonatomic) IBOutlet UIImageView *iconImageV;
/** 名称*/
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
/** 选中按钮 */
@property (weak, nonatomic) IBOutlet UIButton *selectedBtn;

@end
@implementation WTThemeCell

- (void)awakeFromNib
{
    [super awakeFromNib];
 
    // 1、背景色
    self.contentView.dk_backgroundColorPicker = DKColorPickerWithKey(UITableViewBackgroundColor);
    
    // 2、添加阴影
    self.iconImageV.layer.cornerRadius = 3;
    self.iconImageV.layer.shadowOpacity = 0.5;
    self.iconImageV.layer.shadowColor = [UIColor blackColor].CGColor;
    self.iconImageV.layer.shadowRadius = 4;
    self.iconImageV.layer.shadowOffset = CGSizeMake(3, 3);
}

- (void)setThemeItem:(WTThemeItem *)themeItem
{
    _themeItem = themeItem;
    
    self.iconImageV.image = themeItem.iconImage;
    
    self.titleLabel.text = themeItem.title;
    
    self.selectedBtn.selected = NO;
    
    // 换肤
    if ([[DKNightVersionManager sharedManager].themeVersion isEqualToString: DKThemeVersionNormal])
    {
        [self.selectedBtn setImage: [UIImage imageNamed: @"more_theme_normal"] forState: UIControlStateNormal];
    }
    else
    {
        [self.selectedBtn setImage: [UIImage imageNamed: @"more_theme_night"] forState: UIControlStateNormal];
    }
    
    self.titleLabel.dk_textColorPicker = DKColorPickerWithKey(WTThemeCellTitleColor);
    
    if (themeItem.isSelected)
    {
        self.titleLabel.textColor = WTSelectedColor;
        self.selectedBtn.selected = YES;
    }
}

@end
