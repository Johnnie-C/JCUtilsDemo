//
//  JCDragableCellGestureRecognizer.h
//
//  Created by Johnnie Cheng on 16/07/18.
//  Copyright © 2017 Johnnie Cheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JCDragableCellGestureRecognizerDelegate

@required
- (BOOL)canDragCellForIndexPath:(NSIndexPath *)indexPath;
- (UIView *)topContentViewForCell:(UIView *)cell indexPath:(NSIndexPath *)indexPath;
- (CGFloat)bottomMenuWidthForCell:(UIView *)cell indexPath:(NSIndexPath *)indexPath;

@optional
- (void)onDragingCell:(UIView *)cell indexPath:(NSIndexPath *)indexPath;
- (void)onStopDragingCell:(UIView *)cell indexPath:(NSIndexPath *)indexPath;
- (void)didResetCell:(UIView *)cell indexPath:(NSIndexPath *)indexPath;


- (NSLayoutConstraint *)topContentLeftConstraintForCell:(UIView *)cell indexPath:(NSIndexPath *)indexPath;
- (NSLayoutConstraint *)topContentRightConstraintForCell:(UIView *)cell indexPath:(NSIndexPath *)indexPath;

@end





@interface JCDragableCellGestureRecognizer : UIPanGestureRecognizer<UIGestureRecognizerDelegate>

@property (weak, nonatomic) NSObject<JCDragableCellGestureRecognizerDelegate> *dragableCellGRDelegate;

- (instancetype)initWithTargetScrollView:(UIScrollView *)scrollview;

- (void)resetPredragedCellIfNeed;

@end

