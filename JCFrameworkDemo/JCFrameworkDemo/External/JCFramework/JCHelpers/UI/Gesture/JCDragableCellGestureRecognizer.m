//
//  JCDragableCellGestureRecognizer.m
//  JCFrameworkDemo
//
//  Created by Johnnie Cheng on 2/01/18.
//  Copyright © 2018 Johnnie Cheng. All rights reserved.
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
    _preDraggedCellIndexPath = indexPath;
    [self handDrag:panGesture indexPath:indexPath];
}

- (void)handDrag:(UIPanGestureRecognizer *)panGesture indexPath:(NSIndexPath *)indexPath{
    if(_dragableCellGRDelegate && [_dragableCellGRDelegate canDragCellForIndexPath:indexPath]){
        UIView *cell = [self cellForIndexPath:indexPath];
        UIView *topContentView = [_dragableCellGRDelegate topContentViewForCell:cell];
        CGFloat menuWidth = [_dragableCellGRDelegate bottomMenuViewForCell:cell].width;
        
        if(panGesture.state == UIGestureRecognizerStateChanged){
            CGPoint translation = [panGesture translationInView:topContentView.superview];
            CGFloat newX = topContentView.x + translation.x;
            
            if(newX  < -menuWidth){//add pull effect
                CGFloat decelerateRate = (topContentView.width - fabs(newX)) / (topContentView.width - menuWidth);
                newX = topContentView.x + translation.x * decelerateRate;
            }
            else if(newX > 0){
                newX = 0;
            }
            
            [topContentView setX:newX];
            
            [panGesture setTranslation:CGPointZero inView:topContentView.superview];
            
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
        }
    }
}

- (void)showSlideMenu:(BOOL)isOpen indexPath:(NSIndexPath *)indexPath animat:(BOOL)animat{
    [self updateMenuOpenStatusForIndexPath:indexPath isOpen:isOpen];
    UIView *cell = [self cellForIndexPath:indexPath];
    UIView *topContentView = [_dragableCellGRDelegate topContentViewForCell:cell];
    CGFloat menuWidth = [_dragableCellGRDelegate bottomMenuViewForCell:cell].width;
    
    CGFloat newX = isOpen ? -menuWidth : 0;
    
    if(animat){
        [UIView animateWithDuration:0.3
                              delay:0
             usingSpringWithDamping:0.5
              initialSpringVelocity:2
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             [topContentView setX:newX];
                         }
                         completion:nil];
        
    }
    else{
        [topContentView setX:newX];
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
