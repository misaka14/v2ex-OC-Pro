//
//  WTTopicDetailTableViewController.m
//  v2ex
//
//  Created by 无头骑士 GJ on 16/3/13.
//  Copyright © 2016年 无头骑士 GJ. All rights reserved.
//

#import "WTTopicDetailTableViewController.h"
#import "WTWebViewController.h"
#import "WTNavigationController.h"
#import "WTPostReplyViewController.h"
#import "WTMemberDetailViewController.h"

#import "WTProgressHUD.h"
#import "WTToolBarView.h"
#import "WTTopicDetailHeadCell.h"
#import "WTTopicDetailContentCell.h"
#import "WTTopicDetailCommentCell.h"

#import "WTTopicDetailViewModel.h"

#import "WTURLConst.h"
#import "NSString+Regex.h"
#import "WTAccountViewModel.h"

#import "Masonry.h"
#import "IDMPhotoBrowser.h"
#import "SVProgressHUD.h"
#import "UITableView+FDTemplateLayoutCell.h"

@interface WTTopicDetailTableViewController () <WTTopicDetailHeadCellDelegate, WTTopicDetailContentCellDelegate, WTTopicDetailCommentCellDelegate, UITableViewDataSource, UITableViewDelegate>
/** 帖子回复ViewModel */
@property (nonatomic, strong) NSMutableArray<WTTopicDetailViewModel *> *topicDetailViewModels;
/** 当前页 */
@property (nonatomic, assign) NSInteger                                currentPage;
/** 帖子正文内容 */
@property (nonatomic, strong) WTTopicDetailContentCell                 *contentCell;
/** 帖子标题 */
@property (nonatomic, strong) WTTopicDetailViewModel                   *firstTopicDetailVM;
/** 回复话题的Url */
@property (nonatomic, strong) NSString                                 *replyTopicUrl;
/** 最后一页的Url */
@property (nonatomic, strong) NSString                                 *lastPageUrl;

@property (nonatomic, strong) WTTopicDetailViewModel                   *topicDetailVM;
/** 回复控制器 */
@property (nonatomic, weak) WTPostReplyViewController                  *postReplyVC;
/** 子控制器 */
@property (nonatomic, strong) NSMutableArray<UIViewController *>       *childVC;

@end

/** 帖子标题 */
static NSString  * const headerCellID = @"headerCellID";
/** 帖子正文 */
static NSString  * const contentCellID = @"contentCellID";
/** 帖子回复 */
static NSString  * const commentCellID = @"commentCellID";

@implementation WTTopicDetailTableViewController

+ (instancetype)topicDetailTableViewController
{
    return [UIStoryboard storyboardWithName: NSStringFromClass([WTTopicDetailTableViewController class]) bundle: nil].instantiateInitialViewController;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //self.topicDetailUrl = @"http://www.v2ex.com/t/265305#reply0";
    
    //self.topicDetailUrl = @"https:/www.v2ex.com/t/353374#reply148";  // 超过1百条评论
     //self.topicDetailUrl = @"https:/www.v2ex.com/t/346214#reply79";
    
    //self.topicDetailUrl = @"https:/www.v2ex.com/t/352921#reply5";
    
    
    //self.topicDetailUrl = @"https://www.v2ex.com/t/351304#reply19";　//附言
    
    //self.topicDetailUrl = @"https://www.v2ex.com/t/353492#reply0";  //可以回复的
    
   //self.topicDetailUrl = @"https:/www.v2ex.com/t/353415#reply11";
    //self.topicDetailUrl = @"https://www.v2ex.com/t/353501#reply0"; //代码高亮显示
    //self.topicDetailUrl = @"https://www.v2ex.com/t/372577#reply5"; // 图片不显示
    //self.topicDetailUrl = @"https:/www.v2ex.com/t/353464#reply24"; //多图，测试图片点击的
    
    //self.topicDetailUrl = @"https://www.v2ex.com/t/354606#reply70"; //需要会员登陆
    
    
    //self.topicDetailUrl = @"https:/www.v2ex.com/t/354985#reply25"; //重复跳转
    
    
    
    //self.topicDetailUrl = @"https:/www.v2ex.com/t/355494#reply14";
    
    //self.topicDetailUrl = @"https:/www.v2ex.com/t/355539#reply116"; // 评论中的爱心换行了
    
    //self.topicDetailUrl = @"https:/www.v2ex.com/t/356410#reply59";
    
    // BUG:
        // https:/www.v2ex.com/t/376552#reply1
        // https:/www.v2ex.com/t/374772#reply81 图片太大
    //self.topicDetailUrl = @"https:/www.v2ex.com/t/374772#reply81";
//    self.topicDetailUrl = @"https://cn.v2ex.com/t/404494";
    // 1、加载数据
    [self setupData];
    
    // 2、加载 View
    [self setupView];
    
    // 3、添加通知
    {
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        [center addObserver: self selector: @selector(toolbarButtonClick:) name: WTToolBarButtonClickNotification object: nil];
        [center addObserver: self selector: @selector(themeChangingNotification) name: DKNightVersionThemeChangingNotification object: nil];
        
    }
   

    
    // 3、回复帖子用的url
    if ([self.topicDetailUrl containsString: @"#"]) {
        
        self.replyTopicUrl = [NSString subStringToIndexWithStr: @"#" string: self.topicDetailUrl];
    }
    else
    {
        self.replyTopicUrl = self.topicDetailUrl;
    }
    
    // 4、帖子详情url
    self.lastPageUrl = self.topicDetailUrl;
}

#pragma mark 设置View
- (void)setupView
{
    self.tableView.dk_backgroundColorPicker = DKColorPickerWithKey(UITableViewBackgroundColor);
    
    self.childVC = [NSMutableArray array];
}

#pragma mark - 加载数据
- (void)setupData
{
    [self parseUrl];
    
    
    [[NetworkTool shareInstance] GETWithUrlString: self.topicDetailUrl success:^(NSData *data) {
        
        self.topicDetailVM = [WTTopicDetailViewModel topicDetailWithData: data];
        
        
        // 更新页数
        self.currentPage = self.topicDetailVM.currentPage;
        
        // 说明帖子需要登陆
        if (self.topicDetailVM == nil)
        {
            if (self.updateTopicDetailComplection)
            {
                NSError *error = [[NSError alloc] initWithDomain: WTDomain code: -1011 userInfo: @{@"errorMessage" : @"查看本主题需要登录"}];
                self.updateTopicDetailComplection(nil, error);
            }
            
        }
        else
        {
            if (self.updateTopicDetailComplection)
                self.updateTopicDetailComplection(self.topicDetailVM, nil);
            
            [self.tableView reloadData];
        }
        
        
    } failure:^(NSError *error) {
    }];
}

- (void)closePostReplyView
{
    [self.postReplyVC.view endEditing: YES];
    self.postReplyVC.view.alpha = 0;
}

- (BOOL)isLogin
{
    
    // 1、先判断是否登陆
    if (![[WTAccountViewModel shareInstance] isLogin])
    {
        // 1.1、跳转至登陆控制器
        WTLoginViewController *loginVC = [WTLoginViewController new];
        
        // 1.2、登陆之后的操作
        __weak typeof(self) weakSelf = self;
        loginVC.loginSuccessBlock = ^(){
            [weakSelf setupData];
        };
        
        [self presentViewController: loginVC animated: YES completion: nil];
        return NO;
    }
    return YES;
}

#pragma mark - 事件
- (void)toolbarButtonClick:(NSNotification *)noti
{
    NSUInteger buttonType = [noti.userInfo[@"buttonType"] integerValue];
    
    switch (buttonType)
    {
        // 感谢 操作
        case WTToolBarButtonTypeLove:
        {
            [self topicOperationWithMethod: HTTPMethodTypePOST urlString: self.topicDetailVM.thankUrl allowOperation:^{
                if (self.topicDetailVM.thankType == WTThankTypeAlready)    // 已经感谢过
                {
                    [SVProgressHUD showErrorWithStatus: @"不能取消感谢"];
                    return NO;
                }
                else if(self.topicDetailVM.thankType == WTThankTypeUnknown)    // 未知原因不能感谢
                {
                    [SVProgressHUD showErrorWithStatus: @"未知原因不能感谢"];
                    
                    return NO;
                }
                return YES;
            }];
        
            break;
        }
        // 收藏话题
        case WTToolBarButtonTypeCollection:
            [self topicOperationWithMethod: HTTPMethodTypeGET urlString: self.topicDetailVM.collectionUrl allowOperation: nil];
            break;
        // 上一页
        case WTToolBarButtonTypePrev:
        {
            self.currentPage--;
            [self setupData];
            break;
        }
        // 下一页
        case WTToolBarButtonTypeNext:
        {
            self.currentPage++;
            [self setupData];
            break;
        }
        case WTToolBarButtonTypeIgnore:
            [self showIgnoreView];             // 忽略主题
            break;
        case WTToolBarButtonTypeReply:      // 回复话题
            [self replyTopic];
            break;
    }
}

#pragma mark 换肤通知
- (void)themeChangingNotification
{
    WTTopicDetailContentCell *cell = self.tableView.visibleCells.lastObject;
    [cell themeChangingNotification];
}

#pragma mark 回复话题
- (void)replyTopic
{
    // 1、先判断是否登陆
    if (![[WTAccountViewModel shareInstance] isLogin])
    {
        WTLoginViewController *loginVC = [WTLoginViewController new];
        [self presentViewController: loginVC animated: YES completion: nil];
        return;
    }
    
    // 2、moda回复话题控制器
    //WTPostReplyViewController *postReplyVC = [WTPostReplyViewController new];
    // 2.1、回复话题的必备参数
    self.postReplyVC.urlString = self.replyTopicUrl;
    self.postReplyVC.once = self.topicDetailVM.once;
    
    // 3、显示回复的View
    self.postReplyVC.view.alpha = 1;
    [self.postReplyVC.textView becomeFirstResponder];
}

#pragma makr 忽略主题
- (void)showIgnoreView
{
    // 1、先判断是否登陆
    if (![[WTAccountViewModel shareInstance] isLogin])
    {
        WTLoginViewController *loginVC = [WTLoginViewController new];
        [self presentViewController: loginVC animated: YES completion: nil];
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您确定要投拆这个帖子?" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        // 忽略主题
        [weakSelf ignoreTopic];
        
    }];
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [alert dismissViewControllerAnimated: YES completion: nil];
    }];
    
    [alert addAction: defaultAction];
    [alert addAction: cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - 帖子操作
- (void)topicOperationWithMethod:(HTTPMethodType)method urlString:(NSString *)urlString allowOperation:(BOOL(^)())allowOperation
{
    __weak typeof(self) weakSelf = self;
    if (![self isLogin])
        return;
    
    // 允许登陆之后的操作
    if (allowOperation)
    {
        BOOL isAllow = allowOperation();
        if (!isAllow)
        {
            return;
        }
    }
    
    
    [SVProgressHUD show];
    [WTTopicDetailViewModel topicOperationWithMethod: method urlString: urlString topicDetailUrl: self.topicDetailUrl completion:^(WTTopicDetailViewModel *topicDetailVM, NSError *error) {
        
        [SVProgressHUD dismiss];
        if (error != nil)
        {
            WTLog(@"error:%@", error)
            [SVProgressHUD showErrorWithStatus: @"操作异常,请稍候重试"];
            return;
        }
        
        weakSelf.topicDetailVM = topicDetailVM;
        if (weakSelf.updateTopicDetailComplection)
        {
            weakSelf.updateTopicDetailComplection(topicDetailVM, nil);
        }
    }];
    
}

#pragma mark - 感谢主题
- (void)thankActionWithParam:(NSString *)param
{
    NSString *url = [WTHTTPBaseUrl stringByAppendingPathComponent: [NSString stringWithFormat: @"/thank/reply/%@", param]];
    [[WTProgressHUD shareProgressHUD] progress];
    [[NetworkTool shareInstance] requestWithMethod: HTTPMethodTypePOST url: url param: nil success:^(id responseObject) {
        
//        [[WTProgressHUD shareProgressHUD] dismiss];
        
        [[WTProgressHUD shareProgressHUD] successWithMessage: @"已感谢"];
        
    } failure:^(NSError *error) {
        
        [[WTProgressHUD shareProgressHUD] errorWithMessage: @"服务器异常"];
        
    }];
}

#pragma mark - 忽略主题
- (void)ignoreTopic
{
    __weak typeof(self) weakSelf = self;
    [[WTProgressHUD shareProgressHUD] progress];
    [[NetworkTool shareInstance] requestWithMethod: HTTPMethodTypeGET url: self.topicDetailVM.ignoreUrl param: nil success:^(id responseObject) {
        
        [[WTProgressHUD shareProgressHUD] dismiss];
        [weakSelf.navigationController popViewControllerAnimated: YES];
        if (weakSelf.ignoreTopicBlock) weakSelf.ignoreTopicBlock();
        
    } failure:^(NSError *error) {
        
        [[WTProgressHUD shareProgressHUD] errorWithMessage: @"服务器异常"];
        
    }];
}

#pragma mark - 解析url
- (void)parseUrl
{
    if (self.currentPage > 0)
    {
        NSString *url = self.topicDetailUrl;
        NSRange range = [url rangeOfString: @"#" options: NSBackwardsSearch];
        // 说明没查找到#号
        if (range.location == NSNotFound)
        {
            range = [url rangeOfString: @"=" options: NSBackwardsSearch];
            
            if (range.location != NSNotFound)
            {
                url = [url substringToIndex: range.location];
                self.topicDetailUrl = [url stringByAppendingFormat: @"=%ld", self.currentPage];
            }
            else
            {
                self.topicDetailUrl = [url stringByAppendingFormat: @"?p=%ld", self.currentPage];
            }
            
        }
        else
        {
            url = [url substringToIndex: range.location];
            self.topicDetailUrl = [url stringByAppendingFormat: @"?p=%ld", self.currentPage];
        }
    }
}


#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.topicDetailVM ? 2 : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) // 帖子标题
    {
        WTTopicDetailHeadCell *cell = [tableView dequeueReusableCellWithIdentifier: headerCellID forIndexPath: indexPath];
        cell.topicDetailVM = self.topicDetailVM;
        cell.delegate = self;
        return cell;
    }
    else if(indexPath.row == 1) // 帖子正文
    {
        WTTopicDetailContentCell *cell = [tableView dequeueReusableCellWithIdentifier: contentCellID forIndexPath: indexPath];
        cell.topicDetailVM = self.topicDetailVM;
        cell.delegate = self;
        self.contentCell = cell;
        
        __weak typeof(self) weakSelf = self;
        cell.updateCellHeightBlock = ^(CGFloat height)
        {
            if ([weakSelf.tableView.visibleCells containsObject: weakSelf.contentCell])
            {
                [weakSelf.tableView beginUpdates];
                [weakSelf.tableView endUpdates];
            }
        };
        return cell;
    }
    return nil;
}

#pragma mark - Table view delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.updateScrollViewOffsetComplecation)
    {
        self.updateScrollViewOffsetComplecation(scrollView.contentOffset.y);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)   // 帖子标题
    {
        return [tableView fd_heightForCellWithIdentifier: headerCellID cacheByIndexPath: indexPath configuration:^(WTTopicDetailHeadCell *cell) {
            cell.topicDetailVM = self.topicDetailVM;
        }];
    }
    else if(indexPath.row == 1) // 帖子正文
    {
        return self.contentCell.cellHeight;
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //WTMemberDetailViewController *memeberDetailVC = [WTMemberDetailViewController new];
    //[self.navigationController pushViewController: memeberDetailVC animated: YES];
}

- (void)topicDetailHeadCell:(WTTopicDetailHeadCell *)topDetailHeadCell didClickiconImageViewWithTopicDetailVM:(WTTopicDetailViewModel *)topicDetailVM
{
    WTMemberDetailViewController *memeberDetailVC = [[WTMemberDetailViewController alloc] initWithtopicDetailVM: topicDetailVM];
    [self.navigationController pushViewController: memeberDetailVC animated: YES];
}


- (void)_updateVisibleContentRects {}

#pragma mark - WTTopicDetailContentCellDelegate
- (void)topicDetailContentCell:(WTTopicDetailContentCell *)contentCell didClickedWithLinkURL:(NSURL *)linkURL
{
    // 跳转至自定义的网页浏览器
    WTWebViewController *webViewVC = [WTWebViewController new];
    webViewVC.url = linkURL;
    [self.navigationController pushViewController: webViewVC animated: nil];
}

- (void)topicDetailContentCell:(WTTopicDetailContentCell *)contentCell didClickedWithContentImages:(NSMutableArray *)images currentIndex:(NSUInteger)currentIndex
{
    NSMutableArray *photos = [NSMutableArray new];
    
    for (NSURL *url in images) {
        IDMPhoto *photo = [IDMPhoto photoWithURL:url];
        [photos addObject:photo];
    }
    IDMPhotoBrowser *browser = [[IDMPhotoBrowser alloc] initWithPhotos: photos];
    [browser setInitialPageIndex: currentIndex];
    [self presentViewController:browser animated: YES completion: nil];
    
}

- (void)topicDetailContentCell:(WTTopicDetailContentCell *)contentCell didClickedWithCommentAvatar:(NSString *)username
{
    WTMemberDetailViewController *memeberDetailVC = [[WTMemberDetailViewController alloc] initWithUsername: username];
    [self.navigationController pushViewController: memeberDetailVC animated: YES];
}
- (void)topicDetailContentCell:(WTTopicDetailContentCell *)contentCell didClickedCellWithParam:(NSString *)param
{
    [self isLogin];
    
    NSArray<NSString *> *params = [param componentsSeparatedByString: @","];
    
    __weak typeof(self) weakSelf = self;
    UIAlertController *ac = [UIAlertController alertControllerWithTitle: nil message: nil preferredStyle: UIAlertControllerStyleActionSheet];
    
    
    UIAlertAction *thankAction = [UIAlertAction actionWithTitle: @"感谢" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if (params.count > 1)
        {
            NSString *t = params[1];
            [weakSelf thankActionWithParam: t];
        }
        
        
        
    }];
    
    UIAlertAction *replyAction = [UIAlertAction actionWithTitle: @"回复" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

        if (params.count > 0)
        {
            weakSelf.postReplyVC.ausername = params.firstObject;
            [weakSelf replyTopic];
        }
        
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle: @"取消" style: UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    if (params.count > 1 && ![params[1] containsString: @"null"])
    {
        [ac addAction: thankAction];
    }
    [ac addAction: replyAction];
    [ac addAction: cancelAction];
    
    [self presentViewController: ac animated: YES completion: nil];
}
    
#pragma mark - WTTopicDetailContentCellDelegate
- (void)topicDetailCommentCell:(WTTopicDetailCommentCell *)cell iconImageViewClickWithTopicDetailVM:(WTTopicDetailViewModel *)topicDetailVM
{
    WTMemberDetailViewController *memeberDetailVC = [[WTMemberDetailViewController alloc] initWithtopicDetailVM: topicDetailVM];
    [self.navigationController pushViewController: memeberDetailVC animated: YES];

}

#pragma mark - dealloc
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver: self];
}

#pragma mark - Lazy Method
- (WTPostReplyViewController *)postReplyVC
{
    if (_postReplyVC == nil)
    {
        WTPostReplyViewController *vc = [WTPostReplyViewController new];
        _postReplyVC = vc;
        [self.childVC addObject: vc];
        [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview: vc.view];
        
        vc.view.alpha = 0;
        [vc.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.offset(0);
        }];
        
        // 、回复之后的block操作
        __weak typeof(self) weakSelf = self;
        vc.completionBlock = ^(BOOL isSuccess){
            weakSelf.topicDetailUrl = weakSelf.lastPageUrl;
            [weakSelf setupData];
            [weakSelf closePostReplyView];
        };
        vc.closeBlock = ^(){
            [weakSelf closePostReplyView];
        };
    }
    return _postReplyVC;
}

@end
