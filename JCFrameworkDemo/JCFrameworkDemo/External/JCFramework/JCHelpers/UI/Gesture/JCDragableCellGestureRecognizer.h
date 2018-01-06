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
- (UIView *)topContentViewForCell:(UIView *)cell;
- (UIView *)bottomMenuViewForCell:(UIView *)cell;

@end





@interface JCDragableCellGestureRecognizer : UIPanGestureRecognizer<UIGestureRecognizerDelegate>

@property (weak, nonatomic) NSObject<JCDragableCellGestureRecognizerDelegate> *dragableCellGRDelegate;

- (instancetype)initWithTargetScrollView:(UIScrollView *)scrollview;

- (void)resetPredragedCellIfNeed;
    
@end
