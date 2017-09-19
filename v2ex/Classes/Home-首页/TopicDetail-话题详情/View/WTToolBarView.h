//
//  WTTopicToolBarView.h
//  v2ex
//
//  Created by 无头骑士 GJ on 16/2/19.
//  Copyright © 2016年 无头骑士 GJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WTToolBarView, WTTopicDetailViewModel;

// toolBarView 各个按钮的tag
typedef NS_ENUM(NSInteger, WTToolBarButtonType) {
    WTToolBarButtonTypeLove = 0,        // 喜欢
    WTToolBarButtonTypeCollection,      // 收藏
    WTToolBarButtonTypePrev,            // 上一页
    WTToolBarButtonTypeNext,            // 下一页
    WTToolBarButtonTypeSafari,          // safari
    WTToolBarButtonTypeReply            // 回复
};

@interface WTToolBarView : UIView


@property (nonatomic, strong) WTTopicDetailViewModel *topicDetailVM;


/**
 *  快速创建的类方法
 *
 */
+ (instancetype)toolBarView;

@end
