//
//  WTSearchTopicCell.m
//  v2ex
//
//  Created by 无头骑士 GJ on 2017/7/9.
//  Copyright © 2017年 无头骑士 GJ. All rights reserved.
//

#import "WTSearchTopicCell.h"

#import "WTSearchTopic.h"

#import "NSString+YYAdd.h"

@interface WTSearchTopicCell()
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIView *bgView;
@end
@implementation WTSearchTopicCell

- (void)awakeFromNib
{
    [super awakeFromNib];

    self.timeLabel.textColor = [UIColor blackColor];
    
    self.detailLabel.textColor = WTColor(118, 118, 118);
    
    self.timeLabel.textColor = WTColor(140, 140, 140);
    
    self.contentView.dk_backgroundColorPicker = DKColorPickerWithKey(UITableViewBackgroundColor);
    
    self.bgView.layer.cornerRadius = 3;
}

- (void)setSearchTopic:(WTSearchTopic *)searchTopic
{
    _searchTopic = searchTopic;

    self.titleLabel.attributedText = [self setAttributeStringWithContent: searchTopic.title normalColor: [UIColor blackColor]];
    
    self.detailLabel.attributedText = [self setAttributeStringWithContent: searchTopic.detail normalColor: WTColor(110, 110, 110)];
    
    self.timeLabel.text = searchTopic.published_time;
    
    
}

- (NSMutableAttributedString *)setAttributeStringWithContent:(NSString *)content normalColor:(UIColor *)normalColor
{
    
    NSString *keywordsTemp = [self.keywords lowercaseString];
    NSString *contentTemp = [content lowercaseString];
    
//    NSRange keywordsRange = [contentTemp rangeOfString: keywordsTemp];
    NSArray *keywordsRanges = [self rangeOfSubString: keywordsTemp inString: contentTemp];
    
    NSMutableAttributedString *newContent = [[NSMutableAttributedString alloc] initWithString: content attributes: @{NSForegroundColorAttributeName: normalColor}];
    
    for (NSString *keywordsRange in keywordsRanges)
    {
        NSRange range = NSRangeFromString(keywordsRange);
        [newContent addAttributes: @{NSForegroundColorAttributeName: [UIColor orangeColor]} range: range];
    }
    
    return newContent;
}

- (NSArray *)rangeOfSubString:(NSString *)subStr inString:(NSString *)string {
    
    NSMutableArray *rangeArray = [NSMutableArray array];
    
    NSString *string1 = [string stringByAppendingString:subStr];
    
    NSString *temp;
    
    for (int i = 0; i < string.length; i ++) {
        
        temp = [string1 substringWithRange:NSMakeRange(i, subStr.length)];
        
        if ([temp isEqualToString:subStr]) {
            
            NSRange range = {i,subStr.length};
            
            [rangeArray addObject:NSStringFromRange(range)];
            
        }
        
    }
    
    return rangeArray;
}
@end
