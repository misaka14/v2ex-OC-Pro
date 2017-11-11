//
//  TodayViewController.m
//  Today
//
//  Created by gengjie on 16/10/12.
//  Copyright © 2016年 无头骑士 GJ. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>
#import "WTTopicApiItem.h"
#import "AFNetworking.h"
#import "MJExtension.h"
#import "TodayNetworkTool.h"
#import "WTTopicApiItem.h"
#import "TodayCell.h"
#import "YYCache.h"

static YYCache *_dataCache;
static NSString *const HotTopicKey = @"HotTopicKey";

static NSString *const TodayCellIdentifier = @"TodayCellIdentifier";

@interface TodayViewController () <NCWidgetProviding, UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<WTTopicApiItem *> *topicApiItems;
@end

@implementation TodayViewController

+ (void)initialize
{
    _dataCache = [YYCache cacheWithName: @"TodayCache"];
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.preferredContentSize = CGSizeMake(0, 44 * 3);
    
    //因为是iOS10才有的，还请记得适配
    if ([[UIDevice currentDevice].systemVersion doubleValue] >= 10.0)
        self.extensionContext.widgetLargestAvailableDisplayMode = NCWidgetDisplayModeExpanded;
    
    [self initData];
}


- (void)initData
{
    __weak typeof(self) weakSelf = self;
    [weakSelf.tableView reloadData];

    weakSelf.topicApiItems = [WTTopicApiItem mj_objectArrayWithKeyValuesArray: [_dataCache objectForKey: HotTopicKey]];
    
    NSString *url = @"https://www.v2ex.com/api/topics/hot.json";
    
    [[TodayNetworkTool shareInstance] GET: url parameters: nil progress: nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        weakSelf.topicApiItems = [WTTopicApiItem mj_objectArrayWithKeyValuesArray: responseObject];
        [_dataCache setObject: responseObject forKey: HotTopicKey];
        [weakSelf.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData

    completionHandler(NCUpdateResultNewData);
}

#pragma mark - UITableView Datasource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TodayCell *cell = [tableView dequeueReusableCellWithIdentifier: TodayCellIdentifier];
    
    WTTopicApiItem *item = self.topicApiItems[indexPath.row];
    
    cell.topicApiItem = item;
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.topicApiItems.count;
}

#pragma mark - UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WTTopicApiItem *item = self.topicApiItems[indexPath.row];
    NSString *urlStr = [NSString stringWithFormat: @"v2exclient://skip=topicDetail?urlString=%@", item.url];
    [self.extensionContext openURL: [NSURL URLWithString: urlStr] completionHandler: nil];
}

- (void)widgetActiveDisplayModeDidChange:(NCWidgetDisplayMode)activeDisplayMode withMaximumSize:(CGSize)maxSize
{
    if (activeDisplayMode == NCWidgetDisplayModeExpanded)
    {
        self.preferredContentSize = CGSizeMake(0, 44 * self.topicApiItems.count);
    }
    else
    {
        self.preferredContentSize = CGSizeMake(0, 44 * 3);
    }
}

@end
