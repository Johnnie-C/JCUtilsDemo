//
//  JCStretchHeaderHandler.m
//
//  Created by Johnnie Cheng on 10/12/17.
//  Copyright © 2017 Johnnie Cheng. All rights reserved.
//

#import "JCStretchHeaderHandler.h"

#import "JCUtils.h"
#import "UIView+JCUtils.h"
#import "UIImage+JCUtils.h"
#import "UINavigationBar+JCUtils.h"


@interface JCStretchHeaderHandler()

@property (nonatomic, weak) UIView *headerView;
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, weak) UINavigationBar *navigationBar;
@property (nonatomic, weak) UINavigationItem *navigationItem;

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) UIImage *navShadowImage;
@property (nonatomic, strong) UIColor *navBGColor;
@property (nonatomic, strong) CAGradientLayer *gradientLayer;
@property (nonatomic, assign) UIStatusBarStyle originalStatusBarStyle;

@end




@implementation JCStretchHeaderHandler


- (nonnull instancetype)initWithHeader:(nonnull UIView *)headerView
                            scrollView:(nonnull UIScrollView *)scrollView
                         navigationBar:(nullable UINavigationBar *)navigationBar
                        navigationItem:(nullable UINavigationItem *)navigationItem
{
    if (self = [super init])
    {
        _headerView = headerView;
        _scrollView = scrollView;
        _navigationBar = navigationBar;
        _navigationItem = navigationItem;
        
        //setup origianl value
        _title = navigationItem.title;
        _headerView.clipsToBounds = YES;
        _headerViewHeight = 240;
        _navShadowImage = navigationBar.shadowImage;
        _originalStatusBarStyle = [UIApplication sharedApplication].statusBarStyle;
        
        _navBGColor = navigationBar.barTintColor;
        if(!_navBGColor){
            _navBGColor = [UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1];
        }
        
        [self setup];
    }
    
    return self;
}

- (void)setup{
    //setup scroll view
    _navigationBar.barTintColor = _navBGColor;
    UIEdgeInsets contentInset = _scrollView.contentInset;
    contentInset.top += _headerViewHeight;
    _scrollView.contentInset = contentInset;
    _scrollView.contentOffset = CGPointMake(0, -_headerViewHeight);
    if (@available(iOS 11.0, *)) {
        _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    //setup status bar
    _navigationBar.barStyle = UIStatusBarStyleLightContent;
    [self addGradientView];
    
    //setup navigation bar
    _navigationItem.title = nil;
    _navigationBar.shadowImage = [UIImage imageWithColor: [UIColor clearColor] size:CGSizeMake([JCUtils screenWidth], 0.5f)];
    
    //setup header view
    [_scrollView addSubview:_headerView];
    [self updateHeaderViewPosition];
    [self updateHeaderView];
    
    [_scrollView addObserver:self
                      forKeyPath:NSStringFromSelector(@selector(contentOffset))
                         options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
}

- (void)addGradientView{
    _gradientLayer = [CAGradientLayer layer];
    _gradientLayer.frame = CGRectMake(0, 0, [JCUtils screenWidth], _navigationBar.height + [JCUtils statusBarHeight]);

    _gradientLayer.colors = @[(id)[[UIColor blackColor] colorWithAlphaComponent:0.5f].CGColor,
                             (id)[[UIColor blackColor] colorWithAlphaComponent:0.0f].CGColor];
    _gradientLayer.locations = @[[NSNumber numberWithFloat:0.0f],
                                [NSNumber numberWithFloat:1.0f]];

    [_scrollView.superview.layer insertSublayer:_gradientLayer atIndex:INT_MAX];
}



- (void)observeValueForKeyPath:(nullable NSString *)keyPath
                      ofObject:(nullable id)object
                        change:(nullable NSDictionary<NSString *, NSValue *> *)change
                       context:(nullable void *)context
{
    if (object == self.scrollView){
        if (![keyPath isEqualToString:@"contentOffset"]){
            NSAssert(NO, @"keyPath '%@' is not being observed", keyPath);
        }
        [self updateHeaderView];
    }
}

- (void)updateHeaderViewPosition{
    _headerView.frame = CGRectMake(0, -_headerViewHeight, [JCUtils screenWidth], _headerViewHeight);
}

- (void)destory{
    [self.scrollView removeObserver:self forKeyPath:NSStringFromSelector(@selector(contentOffset))];
    _headerView = nil;
    _scrollView = nil;
    _navigationBar = nil;
    _navShadowImage = nil;
    _navBGColor = nil;
}


- (void)updateHeaderView{
    CGFloat navigationBarAlpha = 1;
    CGFloat headerViewHeight = _headerViewHeight;
    
    //update header view height and Y position
    if(_scrollView.contentOffset.y < 0 && fabs(_scrollView.contentOffset.y) > _navigationBar.bottom){
        navigationBarAlpha = (_headerViewHeight - fabs(_scrollView.contentOffset.y)) / (_headerViewHeight - _navigationBar.bottom);
        headerViewHeight = MAX(_headerViewHeight, fabs(_scrollView.contentOffset.y));
    }
    [_headerView setHeight:headerViewHeight];
    [_headerView setY:MIN(_scrollView.contentOffset.y, -_headerViewHeight)];
    [_headerView setWidth:[JCUtils screenWidth]];

    [self updateStatusBarAndNavigationBarIfNeedWithNavigationBarAlpha:navigationBarAlpha];
}

- (void)updateStatusBarAndNavigationBarIfNeedWithNavigationBarAlpha:(CGFloat)navigationBarAlpha{
    //TODO: improve navigationBarAlpha
    //if scrollable size Y is not high enough for navigationBarAlpha = 1, disable change nav alpha
    
    
//    if(_scrollView.contentSize.height + _headerViewHeight > _scrollView.height){//if scrollable
        //update status bar style
        _navigationBar.barStyle = navigationBarAlpha > 0.5 ? _originalStatusBarStyle : UIStatusBarStyleLightContent;
        _gradientLayer.frame = CGRectMake(0, 0, [JCUtils screenWidth], _navigationBar.height);
    
        //setup navigation bar title
        _navigationItem.title = navigationBarAlpha > 0.5 ? _title : nil;
    
        //update navigation bar shadow image (bottom divider)
        _navigationBar.shadowImage = navigationBarAlpha >= 1 ?
                                        _navShadowImage
                                        : [UIImage imageWithColor: [UIColor clearColor] size:CGSizeMake([JCUtils screenWidth], 0.5f)];
        
        //update navigation bar transparent
        UIColor *navBG = [_navBGColor colorWithAlphaComponent:navigationBarAlpha];
    
        [_navigationBar setBackgroundColor:navBG extendToStatusBar:YES];
        [_navigationBar setTranslucent:navigationBarAlpha < 1];
//    }
}

@end
