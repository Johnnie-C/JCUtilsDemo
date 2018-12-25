//
//  JCCollectionViewFlowLayout.m
//  JCFrameworkDemo
//
//  Created by Johnnie Cheng on 10/02/18.
//  Copyright © 2018 Johnnie Cheng. All rights reserved.
//

#import "JCCollectionViewFlowLayout.h"

@interface JCCollectionViewFlowLayout()

@property (nonatomic, strong) NSMutableArray *indexPathsToAnimate;
@property (nonatomic, strong) NSMutableDictionary<NSIndexPath *, UICollectionViewLayoutAttributes *> *latstItemwLayoutAttributesInSections;//used for delete last item in section


@end





@implementation JCCollectionViewFlowLayout

- (void)prepareLayout{
    [super prepareLayout];
}

- (void)prepareForCollectionViewUpdates:(NSArray *)updateItems{
    NSLog(@"%@ prepare for updated", self);
    [super prepareForCollectionViewUpdates:updateItems];
    NSMutableArray *indexPaths = [NSMutableArray array];
    for (UICollectionViewUpdateItem *updateItem in updateItems) {
        switch (updateItem.updateAction) {
            case UICollectionUpdateActionInsert:
                [indexPaths addObject:updateItem.indexPathAfterUpdate];
                break;
            case UICollectionUpdateActionDelete:
                [indexPaths addObject:updateItem.indexPathBeforeUpdate];
                break;
            case UICollectionUpdateActionMove:
            case UICollectionUpdateActionReload:
                [indexPaths addObject:updateItem.indexPathBeforeUpdate];
                [indexPaths addObject:updateItem.indexPathAfterUpdate];
                break;
            default:
                NSLog(@"unhandled case: %@", updateItem);
                break;
        }
    }
    
    _indexPathsToAnimate = indexPaths;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewLayoutAttributes *attr;
    
    if([self.collectionView numberOfItemsInSection:indexPath.section] > 0){
        attr = [super layoutAttributesForItemAtIndexPath:indexPath];
    }
    else{
//        attr = _latstItemwLayoutAttributesInSections[indexPath];
//        [_latstItemwLayoutAttributesInSections removeObjectForKey:indexPath];
    }
    
    return attr;
}

- (UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath{
    UICollectionViewLayoutAttributes *attr;
    if ([_indexPathsToAnimate containsObject:itemIndexPath]) {
        attr = [self layoutAttributesForItemAtIndexPath:itemIndexPath];
        attr.transform = CGAffineTransformMakeTranslation(0, attr.frame.size.height);
        attr.alpha = 0;
//        attr.transform = CGAffineTransformRotate(CGAffineTransformMakeScale(0.2, 0.2), M_PI);
//        attr.center = CGPointMake(CGRectGetMidX(self.collectionView.bounds), CGRectGetMaxY(self.collectionView.bounds));
        [_indexPathsToAnimate removeObject:itemIndexPath];
    }

    return attr;
}

- (UICollectionViewLayoutAttributes*)finalLayoutAttributesForDisappearingItemAtIndexPath:(NSIndexPath *)itemIndexPath{
    UICollectionViewLayoutAttributes *attr;
    if ([_indexPathsToAnimate containsObject:itemIndexPath]) {
        attr = [self layoutAttributesForItemAtIndexPath:itemIndexPath];
        attr.transform = CGAffineTransformMakeTranslation(0, -attr.frame.size.height);
        attr.alpha = 0;
//        CATransform3D flyUpTransform = CATransform3DIdentity;
//        flyUpTransform.m34 = 1.0 / -20000;
//        flyUpTransform = CATransform3DTranslate(flyUpTransform, 50, 50, 10000);
//        attr.transform3D = flyUpTransform;
//        attr.center = self.collectionView.center;

//        attr.zIndex = 1;

        [_indexPathsToAnimate removeObject:itemIndexPath];
    }
   
    return attr;
}


@end
