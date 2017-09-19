//
//  WTMyFollowingCell.m
//  v2ex
//
//  Created by 无头骑士 GJ on 16/8/9.
//  Copyright © 2016年 无头骑士 GJ. All rights reserved.
//

#import "WTMyFollowingCell.h"
#import "WTMyFollowingItem.h"

#import "UIImage+Extension.h"
#import "NSString+Regex.h"

#import "UIImageView+WebCache.h"
@interface WTMyFollowingCell()
/** 头像*/
@property (weak, nonatomic) IBOutlet UIImageView            *iconImageV;
/** 标题 */
@property (weak, nonatomic) IBOutlet UILabel                *titleLabel;
/** 节点 */
@property (weak, nonatomic) IBOutlet UIButton               *nodeBtn;
/** 最后回复时间 */
@property (weak, nonatomic) IBOutlet UILabel                *lastReplyTimeLabel;
/** 作者 */
@property (weak, nonatomic) IBOutlet UILabel                *authorLabel;
/** 回复数 */
@property (weak, nonatomic) IBOutlet UIImageView            *commentCountImageView;
/** 回复数 */
@property (weak, nonatomic) IBOutlet UILabel                *commentCountLabel;
@end
@implementation WTMyFollowingCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    // 2、节点
    self.nodeBtn.layer.cornerRadius = 1.5;
    self.iconImageV.layer.cornerRadius = 5;
    self.iconImageV.layer.masksToBounds = YES;
}

// 重写 blog set方法，初始化数据
- (void)setMyFollowingItem:(WTMyFollowingItem *)myFollowingItem
{
    _myFollowingItem = myFollowingItem;
    
    // 1、头像
    [self.iconImageV sd_setImageWithURL: myFollowingItem.avatarURL placeholderImage: WTIconPlaceholderImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.iconImageV.image = [image roundImageWithCornerRadius: 3];
        self.iconImageV.image = image;
    }];
    
    // 2、标题
    self.titleLabel.text = myFollowingItem.title;
    
    // 3、节点
    if (myFollowingItem.node.length > 0)
    {
        //self.nodeBtn.hidden = NO;
        NSString *node = myFollowingItem.node;
        // 判断是否包含中文字符串
        if ([NSString isChineseCharactersWithString: node] || node.length > 4)
        {
            //NSLog(@"中文:%@", _blog.node);
            node = [NSString stringWithFormat: @" %@ ", myFollowingItem.node];
        }
        [self.nodeBtn setTitle: node forState: UIControlStateNormal];
    }
    else
    {
        //self.nodeBtn.hidden = YES;
        [self.nodeBtn setTitle: @"" forState: UIControlStateNormal];
    }
    
    // 4、最后回复时间
    self.lastReplyTimeLabel.text = myFollowingItem.lastReplyTime;
    
    // 6、作者
    self.authorLabel.text = myFollowingItem.author;
    
    // 7、评论数
    self.commentCountLabel.text = myFollowingItem.commentCount;
    self.commentCountImageView.hidden = !(myFollowingItem.commentCount.length > 0);
}

@end
