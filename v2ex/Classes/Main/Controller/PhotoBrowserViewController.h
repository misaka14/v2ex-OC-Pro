//
//  PhotoBrowserViewController.h
//  v2ex
//
//  Created by 无头骑士 GJ on 16/3/8.
//  Copyright © 2016年 无头骑士 GJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoBrowserViewController : UIViewController
/** 图片数组 */
@property (nonatomic, strong) NSArray           *imageUrls;
/** 当前点击图片URL */
@property (nonatomic, strong) NSURL             *clickImageUrl;
@end
