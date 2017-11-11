//
//  WTPostReplyViewController.m
//  v2ex
//
//  Created by 无头骑士 GJ on 16/2/27.
//  Copyright © 2016年 无头骑士 GJ. All rights reserved.
//

#import "WTPostReplyViewController.h"
#import "CTAssetsPickerController.h"
#import "NetworkTool.h"
#import "WTURLConst.h"
#import "SVProgressHUD.h"
#import "WTProgressHUD.h"
#import "NSString+Regex.h"
@interface WTPostReplyViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>
/** 相册选择器 */
@property (nonatomic, strong) UIImagePickerController *imagePicker;
/** 上传图片完成之后的地址 */
@property (nonatomic, strong) NSString                *original_pic;

@property (weak, nonatomic) IBOutlet UIView           *contentView;
@end

@implementation WTPostReplyViewController


- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear: animated];
    
    [SVProgressHUD dismiss];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化View
    [self initView];
    
    // 1、添加手势
    [self addGes];
    
}

#pragma mark - Private
- (void)initView
{
    self.textView.contentInset = UIEdgeInsetsMake(0, 0, 30, 0);
    self.contentView.layer.masksToBounds = YES;
    self.contentView.layer.cornerRadius = 10;
    self.contentView.layer.shadowRadius = 5;
    self.contentView.layer.shadowColor = [UIColor grayColor].CGColor;
    self.contentView.layer.shadowOffset = CGSizeMake(5, 5);
    self.contentView.layer.shadowOpacity = 0.5;
}
- (void)addGes
{
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget: self action: @selector(pan:)];
    
    [self.contentView addGestureRecognizer: pan];
}

- (void)pan:(UIPanGestureRecognizer *)pan
{
    CGPoint center = pan.view.center;
    CGPoint translation = [pan translationInView: self.view.superview];
    
    
    pan.view.center = CGPointMake(center.x + translation.x, center.y + translation.y);
    
    
    [pan setTranslation: CGPointZero inView: self.view.superview];
    
    if (pan.state == UIGestureRecognizerStateEnded)
    {
        //计算速度向量的长度，当他小于200时，滑行会很短
        CGPoint velocity = [pan velocityInView: self.view.superview];
        CGFloat magnitude = sqrtf((velocity.x * velocity.x) + (velocity.y * velocity.y));
        CGFloat slideMult = magnitude / 200;
        //NSLog(@"magnitude: %f, slideMult: %f", magnitude, slideMult); //e.g. 397.973175, slideMult: 1.989866
        
        //基于速度和速度因素计算一个终点
        float slideFactor = 0.1 * slideMult;
        CGPoint finalPoint = CGPointMake(center.x + (velocity.x * slideFactor),center.y + (velocity.y * slideFactor));
        //限制最小widthCornerRadius,heightCornerRadius 和最大边界值HWScreenWidth - widthCornerRadius，HWScreenHeight - heightCornerRadius 以免拖动出屏幕界限
        CGFloat widthCornerRadius = pan.view.width / 2;
        CGFloat heightCornerRadius = pan.view.height / 2;
        
        
        finalPoint.y = MIN(MAX(finalPoint.y, heightCornerRadius), WTScreenHeight - 49 - heightCornerRadius);
        
        finalPoint.x = MIN(MAX(finalPoint.x, widthCornerRadius), WTScreenHeight - widthCornerRadius);
        
        //使用 UIView 动画使 view 滑行到终点
        [UIView animateWithDuration: slideFactor * 2 delay: 0 options: UIViewAnimationOptionCurveEaseOut animations: ^{
            
            pan.view.center = finalPoint;
            
        } completion: nil];
    }
}

#pragma mark - 点击事件
#pragma mark 关闭控制器
- (IBAction)closeClick
{
    self.textView.text = @"";
    if (self.closeBlock) self.closeBlock();
}

#pragma mark 选择图片
- (IBAction)photoClick
{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle: @"上传图片"
                                                                     message: nil
                                                              preferredStyle: UIAlertControllerStyleActionSheet];
    
    UIAlertAction *photoAction = [UIAlertAction actionWithTitle: @"拍照" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        self.imagePicker.allowsEditing = YES;
        [self presentViewController: self.imagePicker animated: YES completion: nil];
        
    }];
    
    
    UIAlertAction *albumAction = [UIAlertAction actionWithTitle: @"从相册中选择" style: UIAlertActionStyleDefault handler: ^(UIAlertAction * _Nonnull action) {
        WTLog(@"albumAction");
        
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        [self presentViewController: self.imagePicker animated: YES completion: nil];
        
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle: @"取消" style: UIAlertActionStyleCancel handler: nil];
    
    [alertVC addAction: photoAction];
    [alertVC addAction: albumAction];
    [alertVC addAction: cancelAction];
    [self presentViewController: alertVC animated: YES completion: nil];
}

#pragma mark 发表回复
- (IBAction)postClick
{
    NSString *content = self.textView.text;
    if (content.length == 0)
    {
        return;
    }
    
    if (self.once == nil)
    {
        [[WTProgressHUD shareProgressHUD] errorWithMessage: @"请求参数出错，请重新打开回复框"];
        return;
    }
    
    [SVProgressHUD show];
    __weak typeof(self) weakSelf = self;
    [[NetworkTool shareInstance] replyTopicWithUrlString: self.urlString once: self.once content: content success:^(id responseObject) {
        
        NSString *html = [[NSString alloc] initWithData: responseObject encoding: NSUTF8StringEncoding];
        if ([html containsString: @"你回复过于频繁了"])
        {
            
            [SVProgressHUD showErrorWithStatus: @"你回复过于频繁了，请稍等1800秒之后再试"];
        }
        else
        {
            [SVProgressHUD showSuccessWithStatus: @"回复成功"];
            
            
            [SVProgressHUD dismissWithDelay: 0.5 completion:^{
                weakSelf.textView.text = @"";
                if (weakSelf.completionBlock) weakSelf.completionBlock(YES);
                
                [weakSelf dismissViewControllerAnimated: YES completion: nil];
            }];
            
            
        }
    } failure:^(NSError *error) {
        
        WTLog(@"error:%@", error)
        
        [SVProgressHUD showSuccessWithStatus: @"回复失败，请稍候重试"];
        [SVProgressHUD dismissWithDelay: 0.5 completion:^{
            if (weakSelf.completionBlock) weakSelf.completionBlock(NO);
            [weakSelf dismissViewControllerAnimated: YES completion: nil];
        }];
        
    }];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    WTLog(@"info:%@", info);
    
    [self dismissViewControllerAnimated: YES completion: nil];
    //先把图片转成NSData
    UIImage *image = [info objectForKey: UIImagePickerControllerOriginalImage];
    
    // 上传图片
    [self uploadImage: image];
}

#pragma mark - 上传图片
- (void)uploadImage:(UIImage *)image
{
    [[NetworkTool shareInstance] uploadImageWithUrlString: WTUploadPictureUrl image: image progress:^(NSProgress *uploadProgress) {

        WTLog(@"上传中:%lld, 总大小:%lld", uploadProgress.completedUnitCount, uploadProgress.totalUnitCount);
    } success:^(id responseObject) {
        
        if (responseObject[@"original_pic"])
        {
            self.textView.text = [self.textView.text stringByAppendingFormat: @"\n%@", responseObject[@"original_pic"]];
            
        }
    } failure:^(NSError *error) {
 
        WTLog(@"error:%@", error)
    
    }];
    self.textView.text = @"123";
}


#pragma mark - 懒加载
- (UIImagePickerController *)imagePicker
{
    if (_imagePicker == nil)
    {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        _imagePicker = imagePicker;
    }
    return _imagePicker;
}

#pragma mark - Setter
- (void)setAusername:(NSString *)ausername
{
    self.textView.text = [NSString stringWithFormat: @"@%@ ", ausername];
}

- (void)dealloc
{
    WTLog(@"销毁");
}

@end
