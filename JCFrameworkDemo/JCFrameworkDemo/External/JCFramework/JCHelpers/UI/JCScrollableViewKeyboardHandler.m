//
//  JCScrollableViewKeyboardHandler.m
//  
//
//  Created by Johnnie on 8/09/17.
//  Copyright © 2017 Moa Creative. All rights reserved.
//

#import "JCScrollableViewKeyboardHandler.h"

@interface JCScrollableViewKeyboardHandler ()

@property (nonatomic, assign) BOOL isKeyBoardShown;
@property (nonatomic, assign) CGSize keyoardSize;
@property (nonatomic, weak) UIScrollView *scrollView;

@property (nonatomic, assign) CGFloat insetTop;
@property (nonatomic, assign) CGFloat insetLeft;
@property (nonatomic, assign) CGFloat insetRight;
@property (nonatomic, assign) CGFloat insetBottom;

@end




@implementation JCScrollableViewKeyboardHandler

- (void)registerResposeScrollViewForKeyBoard:(UIScrollView *)scrollView{
    _scrollView = scrollView;
    [self addKeyboardNotificationsObserver];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(releaseKB:)];
    tapGesture.cancelsTouchesInView = NO;
    
    [[[UIApplication sharedApplication] delegate].window.rootViewController.view addGestureRecognizer:tapGesture];
}

- (void)unregister{
    _scrollView = nil;
    [self removeKeyboardNotificationsObserver];
}

- (void)addKeyboardNotificationsObserver {
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
}


- (void)removeKeyboardNotificationsObserver {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidHideNotification
                                                  object:nil];
}


- (void)releaseKB:(id)sender{
    UIView *view = ((UITapGestureRecognizer *)sender).view;

    if(![view isKindOfClass:[UITextField class]]){
        [_scrollView endEditing:YES];
    }
}

- (void)keyboardDidShow:(NSNotification *)notification{
    if(!_scrollView){
        return;
    }
    
    NSDictionary* keyboardInfo = [notification userInfo];
    NSValue* keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardFrameBeginRect = [keyboardFrameBegin CGRectValue];
    
    if(!_isKeyBoardShown){
        _insetTop = _scrollView.contentInset.top;
        _insetBottom = _scrollView.contentInset.bottom;
        _insetLeft = _scrollView.contentInset.left;
        _insetRight = _scrollView.contentInset.right;
    }
    
    CGFloat bottomInsetToAdjust = [self calculateaBottomInsetDiffWithKeyboardHeight:keyboardFrameBeginRect.size.height];
    _scrollView.contentInset = UIEdgeInsetsMake(_insetTop, _insetLeft, _insetBottom + MAX(bottomInsetToAdjust, 0), _insetRight);

    _isKeyBoardShown = YES;
    _keyoardSize = keyboardFrameBeginRect.size;
}

- (void) keyboardDidHide:(NSNotification *) notification{
    if(!_isKeyBoardShown || !_scrollView){
        return;
    }
    _scrollView.contentInset = UIEdgeInsetsMake(_insetTop, _insetLeft, _insetBottom, _insetRight);
    _isKeyBoardShown = NO;
    [self validContentOffset];
}

- (CGFloat)calculateaBottomInsetDiffWithKeyboardHeight:(CGFloat)keyboardHeight{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGRect scrollViewRectInScreen = [_scrollView.superview convertRect:_scrollView.frame toView:nil];
    CGFloat scrollViewBottom = scrollViewRectInScreen.origin.y + scrollViewRectInScreen.size.height;
    CGFloat kbTopInScreen = screenRect.size.height - keyboardHeight;
    
    CGFloat contentBottomSpace = 0;
    if(_scrollView.contentSize.height + _insetBottom < _scrollView.frame.size.height){
        contentBottomSpace += (_scrollView.frame.size.height - _scrollView.contentSize.height - _insetBottom);
    }
    
    return scrollViewBottom - kbTopInScreen + _insetBottom + 20 + contentBottomSpace;
}

- (void)validContentOffset{
    if(_scrollView.contentOffset.y + _scrollView.frame.size.height - _insetBottom > _scrollView.contentSize.height){
        CGFloat targetY = _scrollView.contentSize.height - _scrollView.frame.size.height;
        if(targetY < 0){
            targetY = 0;
        }
        [_scrollView setContentOffset:CGPointMake(0, targetY) animated:NO];
    }
}

@end
