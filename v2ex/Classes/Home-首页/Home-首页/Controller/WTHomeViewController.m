//
//  LBBHomeViewController.m
//  v2ex
//
//  Created by 无头骑士 GJ on 16/1/14.
//  Copyright © 2016年 无头骑士 GJ. All rights reserved.
//  首页控制器

#import "WTHomeViewController.h"
#import "WTTopicDetailViewController.h"

#import "WTPublishTopicViewController.h"

#import "WTURLConst.h"
#import "UIBarButtonItem+Extension.h"
#import "UIViewController+Extension.h"

#import "MJExtension.h"

@interface WTHomeViewController ()  
/** WTNode数组*/
@property (nonatomic, strong) NSArray<WTNode *>             *nodes;
@end

@implementation WTHomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
        
    // 添加子控制器
    [self setupAllChildViewControllers];
    
    self.view.dk_backgroundColorPicker = DKColorPickerWithKey(UITableViewBackgroundColor);
    
}

#pragma mark 添加子控制器
- (void)setupAllChildViewControllers
{
    for (WTNode *node in self.nodes)
    {
        WTTopicViewController *topicVC = [WTTopicViewController new];
        topicVC.title = node.name;
        topicVC.urlString = [WTHTTPBaseUrl stringByAppendingString: node.nodeURL];
        [self addChildViewController: topicVC];
    }
}


#pragma mark - Lazy method
#pragma mark nodes
- (NSArray<WTNode *> *)nodes
{
    if (_nodes == nil)
    {
        _nodes = [WTNode mj_objectArrayWithFilename: @"nodes.plist"];
    }
    return _nodes;
}

@end
