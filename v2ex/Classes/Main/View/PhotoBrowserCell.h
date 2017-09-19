//
//  PhotoBrowserCell.h
//  v2ex
//
//  Created by 无头骑士 GJ on 16/3/8.
//  Copyright © 2016年 无头骑士 GJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoBrowserCell : UICollectionViewCell
/** 图片的url */
@property (nonatomic, strong) NSURL         *imageUrl;

@property (nonatomic, weak) UIImageView  *imageView;
@end
