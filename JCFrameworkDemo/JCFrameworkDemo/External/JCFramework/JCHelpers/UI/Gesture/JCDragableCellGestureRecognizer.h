//
//  JCDragableCellGestureRecognizer.h
//  JCFrameworkDemo
//
//  Created by Johnnie Cheng on 2/01/18.
//  Copyright © 2018 Johnnie Cheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JCDragableCellGestureRecognizerDelegate

@required
- (BOOL)canDragCellForIndexPath:(NSIndexPath *)indexPath;
- (UIView *)topContentViewForCell:(UIView *)cell;
- (UIView *)bottomMenuViewForCell:(UIView *)cell;

@end





@interface JCDragableCellGestureRecognizer : UIPanGestureRecognizer<UIGestureRecognizerDelegate>

@property (weak, nonatomic) NSObject<JCDragableCellGestureRecognizerDelegate> *dragableCellGRDelegate;

- (instancetype)initWithTargetScrollView:(UIScrollView *)scrollview;

- (void)resetPredragedCellIfNeed;
    
@end
