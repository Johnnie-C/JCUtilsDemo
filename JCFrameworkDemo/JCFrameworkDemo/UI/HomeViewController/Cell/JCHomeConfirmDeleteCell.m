//
//  JCHomeConfirmDeleteCell.m
//  JCFrameworkDemo
//
//  Created by Johnnie Cheng on 18/02/18.
//  Copyright © 2018 Johnnie Cheng. All rights reserved.
//

#import "JCHomeConfirmDeleteCell.h"

#import "JCUtils.h"
#import "JCUIAlertUtils.h"
#import "UIColor+JCUtils.h"
#import "UIView+JCUtils.h"
#import "UIFont+JCUtils.h"

CGFloat const JC_HOME_CONFIRM_DELETE_CELL_MAX_MENU_WIDTH_NORMAL = 130;
NSString *const JC_HOME_CONFIRM_DELETE_CELL_LEFT_BUTTON_TITLE = @"One";

@interface JCHomeConfirmDeleteCell()

@property (weak, nonatomic) IBOutlet UIButton *btnLeft;
@property (weak, nonatomic) IBOutlet UIButton *btnDelete;

@property (weak, nonatomic) IBOutlet UILabel *lbTitle;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *const_menuWidth;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *cosnt_deleteBtnWidth;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *const_btnWidth;

@property (assign, nonatomic) BOOL hasShowConfirmDelete;

@end





@implementation JCHomeConfirmDeleteCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _cosnt_deleteBtnWidth.active = NO;
    [_topContentView addObserver:self forKeyPath:@"center" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)dealloc{
    _cosnt_deleteBtnWidth = nil;
    _const_btnWidth = nil;
    [_topContentView removeObserver:self forKeyPath:@"center"];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if(object == _topContentView && [keyPath isEqualToString:@"center"]){
        CGFloat currentMenuWidth = [JCUtils screenWidth] - _topContentView.right;
        _const_menuWidth.constant = currentMenuWidth;
        CGFloat leftBtnWidth = currentMenuWidth / (1 + _const_btnWidth.multiplier);
        CGFloat minLeftBtnTitleWidth = [self minTitleWidthFroBtn:_btnLeft];
        if(leftBtnWidth > minLeftBtnTitleWidth){
            [_btnLeft setTitle:JC_HOME_CONFIRM_DELETE_CELL_LEFT_BUTTON_TITLE forState:UIControlStateNormal];
        }
        else{
            [_btnLeft setTitle:@"" forState:UIControlStateNormal];
        }
        
        CGFloat rightBtnWidth = currentMenuWidth - leftBtnWidth;
        CGFloat minDeleteBtnTitleWidth = [self minTitleWidthFroBtn:_btnDelete];
        if(rightBtnWidth > minDeleteBtnTitleWidth){
            [_btnDelete setTitle:_hasShowConfirmDelete ? @"Confirm Delete" : @"Delete" forState:UIControlStateNormal];
        }
        else{
            [_btnDelete setTitle:@"" forState:UIControlStateNormal];
        }
    }
}

- (CGFloat)minTitleWidthFroBtn:(UIButton *)btn{
    return [btn.titleLabel.text
            boundingRectWithSize:CGSizeMake(0, 0)
            options:NSStringDrawingUsesLineFragmentOrigin
            attributes:@{
                         NSFontAttributeName : [UIFont fontWithType:JCFontTypeRegular size:btn.titleLabel.font.pointSize]
                         }
            context:nil].size.width;
}

- (void)updateUIWithTitle:(NSString *)title{
    _lbTitle.text = title;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    [super setHighlighted:highlighted animated:animated];
    if(!self.disableClick){
        _topContentView.backgroundColor = highlighted ? [[UIColor whiteColor] darkerColor] : [UIColor whiteColor];
    }
}

- (void)resetDeleteBtn{
    _hasShowConfirmDelete = NO;
    _cosnt_deleteBtnWidth.active = NO;
    _const_btnWidth.active = YES;
    [self layoutIfNeeded];
    [_btnDelete setTitle:@"Delete" forState:UIControlStateNormal];
}

- (CGFloat)menuWidth{
    return _hasShowConfirmDelete ? [JCUtils screenWidth] / 2 : JC_HOME_CONFIRM_DELETE_CELL_MAX_MENU_WIDTH_NORMAL;
}

- (CGFloat)btnDeleteWidth{
    return _hasShowConfirmDelete ? [self menuWidth] : 70;
}

#pragma mark - actions
- (IBAction)leftButtonClicked:(id)sender {
    [JCUIAlertUtils toastWithMessage:@"One clicked" colour:TOAST_MESSAGE_ORANGE];
}

- (IBAction)deleteButtonClicked:(id)sender {
    if(!_hasShowConfirmDelete){
        _hasShowConfirmDelete = YES;
        [_btnDelete setTitle:@"Confirm Delete" forState:UIControlStateNormal];
        _const_topViewRight.constant = [self menuWidth];
        _const_topViewLeft.constant = -[self menuWidth];
        
        _cosnt_deleteBtnWidth.active = YES;
        _cosnt_deleteBtnWidth.constant = [self btnDeleteWidth];
        _const_btnWidth.active = NO;
        
        
        [UIView animateWithDuration:0.2 animations:^{
            [self layoutIfNeeded];
        }];
    }
    else{
        [JCUIAlertUtils toastWithMessage:@"Confirm delete clicked" colour:TOAST_MESSAGE_ORANGE];
    }
}

@end
