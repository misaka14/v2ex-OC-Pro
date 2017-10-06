//
//  WTRefreshView.m
//  v2ex
//
//  Created by gengjie on 16/8/26.
//  Copyright © 2016年 无头骑士 GJ. All rights reserved.
//

#import "WTRefreshView.h"
@interface WTRefreshView()

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *aiView;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;

@end
@implementation WTRefreshView

+ (instancetype)refreshView
{
    return [[NSBundle mainBundle] loadNibNamed: NSStringFromClass([WTRefreshView class]) owner: nil options: nil].lastObject;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.dk_backgroundColorPicker = DKColorPickerWithKey(UITableViewBackgroundColor);
    self.tipLabel.dk_textColorPicker = DKColorPickerWithKey(WTNoLoginTipTitleLabelTextColor);
    
    if ([[DKNightVersionManager sharedManager].themeVersion isEqualToString: DKThemeVersionNormal])
        self.aiView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    else
        self.aiView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
}

- (void)startAnim
{
    [self.aiView startAnimating];
}

- (void)stopAnim
{
    [self.aiView stopAnimating];
}

- (void)setTipText:(NSString *)tipText
{
    _tipText = tipText;
    
    self.tipLabel.text = tipText;
}

@end
