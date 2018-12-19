//
//  JCDragableCellGestureRecognizer.m
//
//  Created by Johnnie Cheng on 16/07/18.
//  Copyright © 2017 Johnnie Cheng. All rights reserved.
//

#import "JCDragableCellGestureRecognizer.h"

#import "UIView+JCUtils.h"

@interface JCDragableCellGestureRecognizer()


/**
 should be UICollection view or UITableView
 */
@property (weak, nonatomic) UIScrollView *scrollView;

@property (weak, nonatomic) NSIndexPath *preDraggedCellIndexPath;
@property (strong, nonatomic) NSMutableDictionary *menuStatus;

@end





@implementation JCDragableCellGestureRecognizer

- (instancetype)initWithTargetScrollView:(UIScrollView *)scrollview{
    if(self = [super initWithTarget:self action:@selector(handleCollectionViewGesture:)]){
        self.scrollView = scrollview;
        self.menuStatus = [NSMutableDictionary dictionary];
        self.delegate = self;
    }
    
    return self;
}

- (void)handleCollectionViewGesture:(UIPanGestureRecognizer *)panGesture {
    CGPoint location = [panGesture locationInView:_scrollView];
    NSIndexPath *indexPath;
    
    if([_scrollView isKindOfClass:[UICollectionView class]]){
        indexPath = [(UICollectionView *)_scrollView indexPathForItemAtPoint:location];
    }
    else if([_scrollView isKindOfClass:[UITableView class]]){
        indexPath = [(UITableView *)_scrollView indexPathForRowAtPoint:location];
    }
    
    if(_preDraggedCellIndexPath
       && (_preDraggedCellIndexPath.section != indexPath.section || _preDraggedCellIndexPath.row != indexPath.row))
    {
        [self showSlideMenu:NO indexPath:_preDraggedCellIndexPath animat:YES];
    }
    
    if(indexPath){
        _preDraggedCellIndexPath = indexPath;
    }
    [self handDrag:panGesture indexPath:indexPath];
}

- (void)handDrag:(UIPanGestureRecognizer *)panGesture indexPath:(NSIndexPath *)indexPath{
    if(_dragableCellGRDelegate && [_dragableCellGRDelegate canDragCellForIndexPath:indexPath]){
        UIView *cell = [self cellForIndexPath:indexPath];
        if(!cell){
            [self resetPredragedCellIfNeed];
            return;
        }
        UIView *topContentView = [_dragableCellGRDelegate topContentViewForCell:cell indexPath:indexPath];
        CGFloat menuWidth = [_dragableCellGRDelegate bottomMenuWidthForCell:cell indexPath:indexPath];
        
        NSLayoutConstraint *const_topContentLeft;
        if(_dragableCellGRDelegate && [_dragableCellGRDelegate respondsToSelector:@selector(topContentLeftConstraintForCell:indexPath:)]){
            const_topContentLeft = [_dragableCellGRDelegate topContentLeftConstraintForCell:cell indexPath:indexPath];
        }
        
        NSLayoutConstraint *const_topContentRight;
        if(_dragableCellGRDelegate && [_dragableCellGRDelegate respondsToSelector:@selector(topContentRightConstraintForCell:indexPath:)]){
            const_topContentRight = [_dragableCellGRDelegate topContentRightConstraintForCell:cell indexPath:indexPath];
        }
        
        if(panGesture.state == UIGestureRecognizerStateChanged){
            CGPoint translation = [panGesture translationInView:topContentView.superview];
            CGFloat newX = topContentView.x + translation.x;
            if(newX  < -menuWidth / 2){//add pull effect
                CGFloat decelerateRate = (topContentView.width - fabs(newX)) / (topContentView.width);
                newX = topContentView.x + translation.x * decelerateRate;
            }
            else if(newX > 0){
                newX = 0;
            }
            
            if(const_topContentLeft && const_topContentRight){
                const_topContentLeft.constant = newX;
                const_topContentRight.constant = -newX;
            }
            else{
                [topContentView setX:newX];
            }
            
            [panGesture setTranslation:CGPointZero inView:topContentView.superview];
            
            if(_dragableCellGRDelegate && [_dragableCellGRDelegate respondsToSelector:@selector(onDragingCell:indexPath:)]){
                [_dragableCellGRDelegate onDragingCell:cell indexPath:indexPath];
            }
            
        }
        else if(panGesture.state == UIGestureRecognizerStateEnded || panGesture.state == UIGestureRecognizerStateCancelled){
            
            BOOL shouldShowMenu;
            if(![self isMenuOpenForIndexPath:indexPath]){
                shouldShowMenu = fabs(topContentView.x) >  menuWidth / 4;
            }
            else{
                shouldShowMenu = fabs(topContentView.x) >  menuWidth * 3 / 4;
            }
            
            [self showSlideMenu:shouldShowMenu indexPath:indexPath animat:YES];
            
            if(_dragableCellGRDelegate && [_dragableCellGRDelegate respondsToSelector:@selector(onStopDragingCell:indexPath:)]){
                [_dragableCellGRDelegate onStopDragingCell:cell indexPath:indexPath];
            }
        }
    }
}

- (void)showSlideMenu:(BOOL)isOpen indexPath:(NSIndexPath *)indexPath animat:(BOOL)animat{
    [self updateMenuOpenStatusForIndexPath:indexPath isOpen:isOpen];
    UIView *cell = [self cellForIndexPath:indexPath];
    UIView *topContentView = [_dragableCellGRDelegate topContentViewForCell:cell indexPath:indexPath];
    CGFloat menuWidth = [_dragableCellGRDelegate bottomMenuWidthForCell:cell indexPath:indexPath];
    NSLayoutConstraint *const_topContentLeft, *const_topContentRight;
    if(_dragableCellGRDelegate && [_dragableCellGRDelegate respondsToSelector:@selector(topContentLeftConstraintForCell:indexPath:)]){
        const_topContentLeft = [_dragableCellGRDelegate topContentLeftConstraintForCell:cell indexPath:indexPath];
    }
    
    if(_dragableCellGRDelegate && [_dragableCellGRDelegate respondsToSelector:@selector(topContentRightConstraintForCell:indexPath:)]){
        const_topContentRight = [_dragableCellGRDelegate topContentRightConstraintForCell:cell indexPath:indexPath];
    }
    
    CGFloat newX = isOpen ? -menuWidth : 0;
    
    if(const_topContentLeft && const_topContentRight){
        const_topContentLeft.constant = newX;
        const_topContentRight.constant = -newX;
    }
    
    if(animat){
        [UIView animateWithDuration:0.3
                              delay:0
             usingSpringWithDamping:0.5
              initialSpringVelocity:2
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             if(const_topContentLeft){
                                 [cell layoutIfNeeded];
                             }
                             else{
                                 [topContentView setX:newX];
                             }
                         }
                         completion:nil];
        
    }
    else{
        [topContentView setX:newX];
    }
    
    if(!isOpen){
        if(_dragableCellGRDelegate && [_dragableCellGRDelegate respondsToSelector:@selector(didResetCell:indexPath:)]){
            [_dragableCellGRDelegate didResetCell:cell indexPath:indexPath];
        }
    }
}

- (void)resetPredragedCellIfNeed{
    [self showSlideMenu:NO indexPath:_preDraggedCellIndexPath animat:YES];
}

- (UIView *)cellForIndexPath:(NSIndexPath *)indexPath{
    UIView *cell;
    if([_scrollView isKindOfClass:[UICollectionView class]]){
        cell = [(UICollectionView *)_scrollView cellForItemAtIndexPath:indexPath];
    }
    else if([_scrollView isKindOfClass:[UITableView class]]){
        cell = [(UITableView *)_scrollView cellForRowAtIndexPath:indexPath];
    }
    
    return cell;
}

- (BOOL)isMenuOpenForIndexPath:(NSIndexPath *)indexPath{
    NSString *key = [NSString stringWithFormat:@"%ld,%ld", indexPath.section, indexPath.row];
    return ((NSNumber *)[_menuStatus objectForKey:key]).boolValue;
}

- (void)updateMenuOpenStatusForIndexPath:(NSIndexPath *)indexPath isOpen:(BOOL)isOpen{
    NSString *key = [NSString stringWithFormat:@"%ld,%ld", indexPath.section, indexPath.row];
    [_menuStatus setObject:@(isOpen) forKey:key];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        CGPoint translation = [(UIPanGestureRecognizer*)gestureRecognizer translationInView:_scrollView.superview];
        if (fabs(translation.x) > fabs(translation.y)) {
            return YES;
        }
        return NO;
    }
    return YES;
}


@end
