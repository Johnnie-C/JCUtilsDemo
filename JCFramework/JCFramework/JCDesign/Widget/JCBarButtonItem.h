//
//  JCBarButtonItem.h
//
//
//  Created by Johnnie on 11/12/17.
//  Copyright © 2017 Johnnie Cheng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, LeftBarButtonType) {
    LeftBarButtonTypeNone,
    LeftBarButtonTypeBack,
    LeftBarButtonTypeClose,
    LeftBarButtonTypeMenu,
    LeftBarButtonTypeCancel
};

typedef NS_ENUM(NSInteger, RightBarButtonType) {
    RightBarButtonTypeNone,
    RightBarButtonTypeSearch,
    RightBarButtonTypeMenu,
    RightBarButtonTypeAdd,
    RightBarButtonTypeChange,
    RightBarButtonTypeCart
};

@class JCBarButtonItem;
@protocol JCBarButtonItemDelegate <NSObject>
@optional
- (void)leftBarButtonItemTapped:(NSInteger)btnType;
- (void)rightBarButtonItemTapped:(NSInteger)btnType;
@end


typedef NSString * (^ItemTextBlock)(void);
typedef UIImage * (^ItemIconBlock)(void);

@interface JCBarButtonItem : UIBarButtonItem

@property (nonatomic, assign) id <JCBarButtonItemDelegate> delegate;

@property (strong, nonatomic) UIView *containerView;
@property (strong, nonatomic) UIButton *button;
@property (strong, nonatomic) UILabel *label;

- (instancetype)initWithLeftBarButtonType:(LeftBarButtonType)type
                                  textBlock:(ItemTextBlock)textBlock
                                  iconBlock:(ItemIconBlock)iconBlock;

- (instancetype)initWithRightBarButtonType:(RightBarButtonType)type
                                   textBlock:(ItemTextBlock)textBlock
                                   iconBlock:(ItemIconBlock)iconBlock;

- (instancetype)initWithLeftBarButtonType:(LeftBarButtonType)type;
- (instancetype)initWithRightBarButtonType:(RightBarButtonType)type;

//for customised class use, override this
- (void)setupAdditionalView;

@end
