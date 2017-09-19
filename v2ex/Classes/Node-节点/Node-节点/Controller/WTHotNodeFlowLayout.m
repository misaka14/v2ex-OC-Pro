//
//  WTHotNodeFlowLayout.m
//  v2ex
//
//  Created by 无头骑士 GJ on 16/7/22.
//  Copyright © 2016年 无头骑士 GJ. All rights reserved.
//

#import "WTHotNodeFlowLayout.h"

const CGFloat WTHotNodeSectionLeft = 15;

const CGFloat WTHotNodeCellSpacing = 10;

const CGFloat WTHotNodeMinimumInteritemSpacing = 15;

@implementation WTHotNodeFlowLayout



#pragma mark 返回collectionView视图中所有视图的属性
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray *originalLayoutAttrs = [[super layoutAttributesForElementsInRect: rect] copy];
    NSArray *layoutAttrs = [[NSArray alloc] initWithArray: originalLayoutAttrs copyItems: YES];
    
    for (UICollectionViewLayoutAttributes *layoutAttr in layoutAttrs)
    {
        if (layoutAttr.representedElementKind == nil)
        {
            NSIndexPath *indexPath = layoutAttr.indexPath;
            layoutAttr.frame = [self layoutAttributesForItemAtIndexPath: indexPath].frame;
        }
    }
    
    return layoutAttrs;
}

#pragma mark 返回每个cell的布局属性
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *layoutAttr = [super layoutAttributesForItemAtIndexPath: indexPath];
    
    UIEdgeInsets inset = self.sectionInset;
    
    CGRect currentFrame = layoutAttr.frame;
    if (indexPath.item == 0)
    {
        
        currentFrame.origin.x = inset.left;
        layoutAttr.frame = currentFrame;
        
        return layoutAttr;
    }
    
    NSIndexPath *previousIndexPath = [NSIndexPath indexPathForItem: indexPath.item - 1 inSection: indexPath.section];
    CGRect previousFrame = [self layoutAttributesForItemAtIndexPath: previousIndexPath].frame;
    
    CGFloat previousFrameRightPoint = previousFrame.origin.x + previousFrame.size.width + WTHotNodeMinimumInteritemSpacing;
    
    CGRect strecthedCurrentFrame = CGRectMake(0, currentFrame.origin.y, self.collectionView.width - WTHotNodeSectionLeft, currentFrame.size.height);
    
    
    if (!CGRectIntersectsRect(previousFrame, strecthedCurrentFrame))
    {
        currentFrame.origin.x = inset.left;
        layoutAttr.frame = currentFrame;
        return layoutAttr;
    }
    
    currentFrame.origin.x = previousFrameRightPoint;
    layoutAttr.frame = currentFrame;
    return layoutAttr;
}

@end
