//
//  JCBarButtonItem.m
//  
//
//  Created by Johnnie on 11/12/17.
//  Copyright © 2017 Johnnie Cheng. All rights reserved.
//

#import "JCBarButtonItem.h"
#import "JCUtils.h"
#import "UIColor+JCUtils.h"
#import "UIView+JCUtils.h"
#import "UIFont+JCUtils.h"

static CGFloat const kImageWidth = 32.0;
static CGFloat const kImageHeight = 32.0;
static CGFloat const kLeftBackContainerWidth = 40.0;
static CGFloat const kLabelWidth = 50.0;

typedef NS_ENUM(NSInteger, BarButtonSide) {
    LeftBarButton,
    RightBarButton
};

@interface JCBarButtonItem(){
    LeftBarButtonType leftBarButtonType;
    RightBarButtonType rightBarButtonType;
}


@property (strong, nonatomic) UIImage *icon;
@property (strong, nonatomic) NSString *text;

@end



@implementation JCBarButtonItem

- (id)initWithLeftBarButtonType:(LeftBarButtonType)type{
    leftBarButtonType = type;
    if (type != LeftBarButtonTypeNone){
        if (self = [super initWithCustomView:[self setupView:LeftBarButton]]){
            
        }
    }
    return self;
}

- (id)initWithRightBarButtonType:(RightBarButtonType)type;{
    rightBarButtonType = type;
    if (type != RightBarButtonTypeNone){
        if (self = [super initWithCustomView:[self setupView:RightBarButton]]){
            
        }
    }
    return self;
}

- (UIView *)setupView:(BarButtonSide)side{
    self.containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kImageWidth, kImageHeight)];
    self.button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kImageWidth, kImageHeight)];
    [self.button setBackgroundColor:[UIColor clearColor]];
    [self.containerView addSubview:self.button];
    
    if (side == LeftBarButton){
        [self setupLeftButton];
        
    }
    else if (side == RightBarButton){
        [self setupRightButton];
    }
    
    [self setupContainerViewWithSide:side];
    [self setupAdditionalView];
    if(side == RightBarButton && rightBarButtonType == RightBarButtonTypeCart){
        
    }
    
//    [self.containerView setBackgroundColor:[UIColor redColor]];
//    [self.button setBackgroundColor:[UIColor blueColor]];
    return self.containerView;
}

- (void)setupLeftButton{
    [self.button addTarget:self action:@selector(leftBarButtonItemTapped:) forControlEvents:UIControlEventTouchUpInside];
    self.button.tag = leftBarButtonType;
    switch (leftBarButtonType){
        case LeftBarButtonTypeClose:
            _icon = [UIImage imageNamed:@"ic_close" inBundle:[JCUtils frameworkBundle] compatibleWithTraitCollection:nil];
            self.button.imageEdgeInsets = UIEdgeInsetsMake(8, 8, 8, 8);
            break;
            
        case LeftBarButtonTypeCancel:
            [self.button setWidth:kLabelWidth];
            [self.containerView setWidth:kLabelWidth];
            _text = @"Cancel";
            _icon = [UIImage imageNamed:@"ic_back" inBundle:[JCUtils frameworkBundle] compatibleWithTraitCollection:nil];
            break;
            
        case LeftBarButtonTypeBack:
            [self.button setWidth:kLeftBackContainerWidth];
            [self.containerView setWidth:kLeftBackContainerWidth];
            self.button.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
            [self.button addTarget:self action:@selector(leftBarButtonItemTapped:) forControlEvents:UIControlEventTouchUpInside];
            [self.containerView addSubview:self.button];
            _icon = [UIImage imageNamed:@"ic_back" inBundle:[JCUtils frameworkBundle] compatibleWithTraitCollection:nil];
            break;
            
        case LeftBarButtonTypeMenu:
            _icon = [UIImage imageNamed:@"ic_menu" inBundle:[JCUtils frameworkBundle] compatibleWithTraitCollection:nil];
            [self.button setFrame:CGRectMake(0, 0, 60, 40)];
            [self.containerView setFrame:CGRectMake(0, 0, 60, 40)];
            self.button.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
            break;
            
        case LeftBarButtonTypeNone:
        default:
            break;
    }
}

- (void)setupRightButton{
    [self.button addTarget:self action:@selector(rightBarButtonItemTapped:) forControlEvents:UIControlEventTouchUpInside];
    self.button.tag = rightBarButtonType;
    
    switch (rightBarButtonType){
        case RightBarButtonTypeAdd:
            _text = @"+";
            break;
            
        case RightBarButtonTypeChange:
            _text = @"Change";
            break;
            
        case RightBarButtonTypeSearch:
            _icon = [UIImage imageNamed:@"search_white" inBundle:[JCUtils frameworkBundle] compatibleWithTraitCollection:nil];
            break;
            
        case RightBarButtonTypeMenu:
            _icon = [UIImage imageNamed:@"ic_menu" inBundle:[JCUtils frameworkBundle] compatibleWithTraitCollection:nil];
            break;
            
        case RightBarButtonTypeCart:
            _icon = [UIImage imageNamed:@"nav_cart" inBundle:[JCUtils frameworkBundle] compatibleWithTraitCollection:nil];
            break;
            
        case RightBarButtonTypeNone:
        default:
            break;
    }
}

- (void)setupContainerViewWithSide:(BarButtonSide)side{
    if (_icon){
        UIColor *iconColor = [UIColor navigationbarIconColor];
        [self.button.imageView setContentMode:UIViewContentModeScaleAspectFit];
        
        NSInteger btnType = side == LeftBarButton ? leftBarButtonType : rightBarButtonType;
        if(iconColor && ![self shouldUseOriginalIconWithSide:side btnType:btnType]){
            _icon = [_icon imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            [self.button setImage:_icon forState:UIControlStateNormal];
            self.button.tintColor = iconColor;
        }
        else{
            [self.button setImage:_icon forState:UIControlStateNormal];
        }
        
    }
    
    if (_text){
        UIColor *txtColor = [UIColor navigationbarTextColor];
        [self.button setTitle:_text forState:UIControlStateNormal];
        [self.button.titleLabel sizeToFit];
        [self.button sizeToFit];
        [self.button setBackgroundColor:[UIColor clearColor]];
        [self.button.titleLabel setFont:[UIFont fontWithSize:[self getFontSize]]];
        [self.button.titleLabel setTextAlignment:NSTextAlignmentRight];
        [self.button setTitleColor:txtColor ? txtColor : [UIColor whiteColor] forState:UIControlStateNormal];
        [self.button setTitleColor:[UIColor navigationbarTextHighlitColor] forState:UIControlStateHighlighted];
        self.containerView.frame = self.button.frame;
    }
}

//for customised class use
- (void)setupAdditionalView{
    
}

- (CGFloat)getFontSize{
    CGFloat size = 15;
    if(rightBarButtonType == RightBarButtonTypeAdd){
        size = 22;
    }
    
    return size;
}

- (BOOL)shouldUseOriginalIconWithSide:(BarButtonSide)side btnType:(NSInteger)btnType{
    BOOL shouldUserOriginalIcon = NO;
    if(side == LeftBarButton){//left
        
    }
    else{//right
        if(btnType == RightBarButtonTypeSearch){
            shouldUserOriginalIcon = YES;
        }
    }
    return shouldUserOriginalIcon;
}

- (void)leftBarButtonItemTapped:(UIButton *)sender{
    if (sender == self.button){
        [self.delegate leftBarButtonItemTapped:self.button.tag];
    }
}

- (void)rightBarButtonItemTapped:(UIButton *)sender{
    if (sender == self.button){
        if (self.delegate && [self.delegate respondsToSelector:@selector(rightBarButtonItemTapped:)]){
            [self.delegate rightBarButtonItemTapped:self.button.tag];
        }
    }
}

@end




