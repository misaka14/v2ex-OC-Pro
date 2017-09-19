//
//  UIBarButtonItem+Extension.m
//  BaiDeJie
//
//  Created by 无头骑士 GJ on 16/1/19.
//  Copyright © 2016年 无头骑士 GJ. All rights reserved.
//

#import "UIBarButtonItem+Extension.h"

@implementation UIBarButtonItem (Extension)
/**
 *  设置UIBarButtonItem属性
 *
 *  @param image     图片
 *  @param highImage 图片
 *  @param target    调用者
 *  @param action    调用者的方法
 *
 *  @return UIBarButtonItem
 */
+ (UIBarButtonItem * )setupBarButtonItemWithImage:(UIImage *)image highImage:(UIImage *)highImage addTarget:(id)target action:(SEL)action
{
    UIView *view = [UIView new];
    
    UIButton *btn = [UIButton buttonWithType: UIButtonTypeCustom];
    [btn setImage: image forState: UIControlStateNormal];
    [btn setImage: highImage forState: UIControlStateHighlighted];
    
    [btn sizeToFit];
    
    [btn addTarget: target action: action forControlEvents: UIControlEventTouchUpInside];
    [view addSubview: btn];
    
    view.frame = btn.bounds;
    
    return [[UIBarButtonItem new] initWithCustomView: view];
}

/**
 *  设置UIBarButtonItem属性，并返回
 *
 *  @param image     图片
 *  @param highImage 选中图片
 *  @param target    调用者
 *  @param action    调用者的方法
 *
 *  @return UIBarButtonItem
 */
+ (UIBarButtonItem * )setupBarButtonItemWithImage:(UIImage *)image selectedImage:(UIImage *)selectedImage addTarget:(id)target action:(SEL)action
{
    UIView *view = [UIView new];
    
    UIButton *btn = [UIButton buttonWithType: UIButtonTypeCustom];
    [btn setImage: image forState: UIControlStateNormal];
    [btn setImage: selectedImage forState: UIControlStateSelected];
    
    [btn sizeToFit];
    
    [btn addTarget: target action: action forControlEvents: UIControlEventTouchUpInside];
    [view addSubview: btn];
    
    view.frame = btn.bounds;
    
    return [[UIBarButtonItem new] initWithCustomView: view];
}

/**
 *  设置UIBarButtonItem属性，并返回
 *
 *  @param image         图片
 *  @param frame         大小
 *  @param target        调用者
 *  @param action        调用者的方法
 *
 *  @return UIBarButtonItem
 */
+ (UIBarButtonItem *)setupBarButtonItemWithImage:(UIImage *)image frame:(CGRect)frame addTarget:(id)target action:(SEL)action
{
    return [self setupBarButtonItemWithImage: image highImage: nil frame: frame addTarget: target action: action];
}


/**
 *  设置UIBarButtonItem属性，并返回
 *
 *  @param image         图片
 *  @param highImage     选中图片
 *  @param frame         大小
 *  @param target        调用者
 *  @param action        调用者的方法
 *
 *  @return UIBarButtonItem
 */
+ (UIBarButtonItem *)setupBarButtonItemWithImage:(UIImage *)image highImage:(UIImage *)highImage frame:(CGRect)frame addTarget:(id)target action:(SEL)action
{
    UIView *view = [UIView new];
    
    UIButton *btn = [UIButton buttonWithType: UIButtonTypeCustom];
    [btn setImage: image forState: UIControlStateNormal];
    [btn setImage: highImage forState: UIControlStateHighlighted];
    
    [btn sizeToFit];
    if (!CGRectIsNull(frame))
    {
        btn.frame = frame;
    }
    
    [btn addTarget: target action: action forControlEvents: UIControlEventTouchUpInside];
    [view addSubview: btn];
    
    view.frame = btn.bounds;
    
    return [[UIBarButtonItem new] initWithCustomView: view];
}

// 返回按钮
+ (UIBarButtonItem *)backItemWithImage:(UIImage *)image highImage:(UIImage *)highImage target:( id)target action:(SEL)action title:(NSString *)title
{
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.titleLabel.font = [UIFont systemFontOfSize: 15];
    [backButton setTitle:title forState:UIControlStateNormal];
    
    [backButton setImage:image forState:UIControlStateNormal];
    [backButton setImage:highImage forState:UIControlStateHighlighted];
    [backButton sizeToFit];
    
    // 设置内容内边距
    backButton.contentEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0);
    backButton.titleEdgeInsets = UIEdgeInsetsMake(0, -18, 0, 0);
    [backButton setTitleColor: [UIColor colorWithHexString: WTNormalColor] forState: UIControlStateNormal];
    [backButton setTitleColor:[UIColor colorWithHexString: WTNoNormalColor] forState:UIControlStateHighlighted];
    
    [backButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
}

+ (UIBarButtonItem *)createShareItemWithTarget:(id)target action:(SEL)action
{
    return [UIBarButtonItem setupBarButtonItemWithImage: [UIImage imageNamed: @"nav_share_normal"] highImage: nil frame: CGRectMake(0, 0, 25, 25) addTarget: target action: action];
}
@end
