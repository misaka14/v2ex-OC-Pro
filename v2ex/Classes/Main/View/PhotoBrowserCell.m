//
//  PhotoBrowserCell.m
//  v2ex
//
//  Created by 无头骑士 GJ on 16/3/8.
//  Copyright © 2016年 无头骑士 GJ. All rights reserved.
//

#import "PhotoBrowserCell.h"
#import "TYImageCache.h"
@interface PhotoBrowserCell() <UIScrollViewDelegate>

@property (nonatomic, weak) UIScrollView *scrollView;


@end
@implementation PhotoBrowserCell

- (void)setImageUrl:(NSURL *)imageUrl
{
    _imageUrl = imageUrl;
    
    [[TYImageCache cache] imageForURL: self.imageUrl.absoluteString needThumImage: NO found:^(UIImage *loaceImage) {
        
        [self setupImage: loaceImage];
        
    } notFound: nil];
}

#pragma mark 设置图片
- (void)setupImage:(UIImage *)image
{
    self.imageView.image = image;
    self.scrollView.zoomScale = 1.0;
    CGFloat imageH = WTScreenWidth / image.size.width * image.size.height;
    self.imageView.frame = CGRectMake(0, 0, WTScreenWidth, imageH);

    CGFloat topInset = 0;
    if (imageH < WTScreenHeight)
    {
        topInset = (WTScreenHeight - imageH) * 0.5;
    }
    else
    {
        topInset = 0;
        self.scrollView.contentOffset = CGPointZero;
    }
    
    CGFloat scale = image.size.width / WTScreenWidth;
    self.scrollView.maximumZoomScale = scale;
    
    self.scrollView.contentInset = UIEdgeInsetsMake(topInset, 0, 0, 0);
    self.scrollView.contentSize = self.imageView.frame.size;
}

#pragma mark - 懒加载
- (UIScrollView *)scrollView
{
    if (_scrollView == nil)
    {
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        _scrollView = scrollView;
        [self.contentView addSubview: scrollView];
        
        scrollView.frame = self.contentView.bounds;
        scrollView.delegate = self;
        scrollView.minimumZoomScale = 0.5;
        scrollView.maximumZoomScale = 2;
    }
    return _scrollView;
}

- (UIImageView *)imageView
{
    if (_imageView == nil)
    {
        UIImageView *imageView = [[UIImageView alloc] init];
        _imageView = imageView;
        [self.scrollView addSubview: imageView];
    }
    return _imageView;
}

#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    WTLog(@"view:%@", view)
    
    CGFloat viewH = view.height;
    CGFloat viewW = view.width;
    CGFloat topInset = viewH < WTScreenHeight ? (WTScreenHeight - viewH) * 0.5 : 0;
    CGFloat leftInset = viewW < WTScreenWidth ? (WTScreenWidth - viewW) * 0.5 : 0;
    
    scrollView.contentInset = UIEdgeInsetsMake(topInset, leftInset, 0, 0);
}

@end
