//
//  JCHeaderTabView.h
//
//  Created by Johnnie on 12/12/17.
//  Copyright © 2017 Johnnie Cheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JCHeaderTabViewDelegate

@required
- (void)onTabSelected:(NSInteger)index;

@end




@interface JCHeaderTabView : UIView

@property (weak, nonatomic) NSObject<JCHeaderTabViewDelegate> *delegate;

@property (assign, nonatomic) IBInspectable BOOL showSelectingAnimation;

@property (strong, nonatomic) IBInspectable NSString *leftButtonTitle;
@property (strong, nonatomic) IBInspectable NSString *rightButtonTitle;

@property (strong, nonatomic) IBInspectable UIColor *defaultButtonColor;
@property (strong, nonatomic) IBInspectable UIColor *selectedButtonColor;

@property (strong, nonatomic) IBInspectable UIColor *defaultButtonTitleColor;
@property (strong, nonatomic) IBInspectable UIColor *selectedButtonTitleColor;

@property (assign, nonatomic) CGFloat cornerRadius;
@property (assign, nonatomic) NSInteger selectedIndex;

- (void)selectTabAtIndex:(NSInteger)index animated:(BOOL)anmimated;

@end
