//
//  JCHomeViewController.m
//  JCFrameworkDemo
//
//  Created by Johnnie Cheng on 1/01/18.
//  Copyright © 2018 Johnnie Cheng. All rights reserved.
//

#import "JCHomeViewController.h"
#import "JCStretchHeaderViewController.h"
#import "JCScrollViewTextFieldDemoViewController.h"
#import "JCTransparentCurveTabDemoViewController.h"
#import "JCJellyEffectDemoViewController.h"
#import "JCAddCartEffictViewController.h"
#import "JCCoreDataDemoViewController.h"
#import "JCAnimatedCollectionViewDemoViewController.h"

#import "JCHomeBaseCell.h"
#import "JCHomeCell.h"
#import "JCHomeConfirmDeleteCell.h"
#import <JCFloatingView/JCFloatingView.h>


NSString *const JC_HOME_CELL_IDENTIFIER = @"jcHomeCellIdentifier";
NSString *const JC_HOME_CONFIRM_DELETE_CELL_IDENTIFIER = @"jcHomeConfirmDeleteCellIdentifier";

typedef NS_ENUM(NSInteger, JCHomeViewCellIndex){
    JCHomeViewCellIndexSlidableCell,
    JCHomeViewCellIndexSlidableCellTwo,
    JCHomeViewCellIndexScrollView,
    JCHomeViewCellIndexStretchHeaderView,
    JCHomeViewCellIndexCustomisedHeader,
    JCHomeViewCellIndexJellyEffect,
    JCHomeViewCellIndexAddCartEffect,
    JCHomeViewCellIndexCoreData,
    JCHomeViewCellIndexAnimatedCollectionView,
    JCHomeViewCellIndexFloatingView
};





@interface JCHomeViewController ()<UITableViewDataSource, UITableViewDelegate, JCDragableCellGestureRecognizerDelegate, JCFloatingViewControllerDelegate>

@property (strong, nonatomic) JCFloatingViewController *floatingView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) JCDragableCellGestureRecognizer *dragCellpanGesture;

@end





@implementation JCHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
}

- (void)setupView{
    [self setupNavBar];
    [self setupTableView];
}

- (void)setupNavBar{
    self.title = @"JCDemo";
    [self setLeftBarButtonType:LeftBarButtonTypeMenu];
    [self setRightBarButtonTypes:@[@(RightBarButtonTypeMenu), @(RightBarButtonTypeSearch)]];
}

- (void)setupTableView{
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    NSBundle *bundle = [NSBundle bundleForClass:[JCHomeCell class]];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([JCHomeCell class]) bundle:bundle] forCellReuseIdentifier:JC_HOME_CELL_IDENTIFIER];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([JCHomeConfirmDeleteCell class]) bundle:bundle] forCellReuseIdentifier:JC_HOME_CONFIRM_DELETE_CELL_IDENTIFIER];
    
    //setup dragable cell
    _dragCellpanGesture = [[JCDragableCellGestureRecognizer alloc] initWithTargetScrollView:_tableView];
    _dragCellpanGesture.dragableCellGRDelegate = self;
    [_tableView addGestureRecognizer:_dragCellpanGesture];
}

#pragma mark - TableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [JCHomeBaseCell heightForCellWithTitle:[self cellTitleForIndexPath:indexPath]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JCHomeBaseCell *cell;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.disableClick = NO;
    switch (indexPath.row) {
        case JCHomeViewCellIndexSlidableCellTwo:
            cell = [tableView dequeueReusableCellWithIdentifier:JC_HOME_CONFIRM_DELETE_CELL_IDENTIFIER];
            break;
            
        default:
            cell = [tableView dequeueReusableCellWithIdentifier:JC_HOME_CELL_IDENTIFIER];
            break;
    }
    
    [cell updateUIWithTitle:[self cellTitleForIndexPath:indexPath]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [_dragCellpanGesture resetPredragedCellIfNeed];
    
    switch (indexPath.row) {
        case JCHomeViewCellIndexScrollView:
            [self pushViewController:[JCScrollViewTextFieldDemoViewController new]];
            break;
            
        case JCHomeViewCellIndexStretchHeaderView:
            [self pushViewController:[JCStretchHeaderViewController new]];
            break;
            
        case JCHomeViewCellIndexCustomisedHeader:
            [self pushViewController:[JCTransparentCurveTabDemoViewController new]];
            break;
            
        case JCHomeViewCellIndexJellyEffect:
            [self pushViewController:[JCJellyEffectDemoViewController new]];
            break;
            
        case JCHomeViewCellIndexAddCartEffect:
            [self pushViewController:[JCAddCartEffictViewController new]];
            break;
            
        case JCHomeViewCellIndexSlidableCell:
        case JCHomeViewCellIndexSlidableCellTwo:
            [_dragCellpanGesture resetPredragedCellIfNeed];
            [JCUIAlertUtils toastWithMessage:[NSString stringWithFormat:@"Cell clicked at section: %ld, row: %ld", indexPath.section, indexPath.row]
                                      colour:TOAST_MESSAGE_ORANGE];
            break;
            
        case JCHomeViewCellIndexCoreData:
            [self pushViewController:[JCCoreDataDemoViewController new]];
            break;
            
        case JCHomeViewCellIndexAnimatedCollectionView:
            [self pushViewController:[JCAnimatedCollectionViewDemoViewController new]];
            break;
        
        case JCHomeViewCellIndexFloatingView:
            if(!_floatingView){
                JCFloatingViewConfig *config = [JCFloatingViewConfig new];
                config.overMargin = 5;
                config.stickyToEdge = NO;
                config.floatingViewBorderColor = [UIColor orangeColor];
                config.floatingViewWidth = 80;
                config.floatingViewHeight = 110;
                config.floatingViewCornerRadius = 10;
                _floatingView = [JCFloatingViewController FloatingViewWithConfig:config];
                _floatingView.delegate = self;
            }
            _floatingView.isShowing ? [_floatingView hideFloatingView] : [_floatingView showFloatingView];
            break;
    }
}

#pragma mark -- cell title
- (NSString *)cellTitleForIndexPath:(NSIndexPath *)indexPath{
    NSString *title;
    switch (indexPath.row) {
        case JCHomeViewCellIndexSlidableCell:
            title = @"This is a slidable cell by using JCDragableCellGestureRecognizer.\nDemo for drawer bottom menu (Bottm menu stay still).";
            break;
            
        case JCHomeViewCellIndexSlidableCellTwo:
            title = @"This is an another slidable cell with confirm delete effect.\nDemo for opening menu (menu opening with dragging). Can be used with transparent background cell";
            break;
            
        case JCHomeViewCellIndexScrollView:
             title = @"ScrollView & customised UITextField demo";
            break;
            
        case JCHomeViewCellIndexStretchHeaderView:
             title = @"Stretchable header demo";
            break;
            
        case JCHomeViewCellIndexCustomisedHeader:
             title = @"Curve transparent tab & local authentication demo";
            break;
            
        case JCHomeViewCellIndexJellyEffect:
             title = @"Jelly effect demo";
            break;
            
        case JCHomeViewCellIndexAddCartEffect:
             title = @"Add cart parabola effect dome";
            break;
            
        case JCHomeViewCellIndexCoreData:
            title = @"CoreData with MagicalRecord demo";
            break;
            
        case JCHomeViewCellIndexAnimatedCollectionView:
            title = @"Animated CollectionView demo";
            break;
        
        case JCHomeViewCellIndexFloatingView:
        title = @"Floating View demo";
          break;
    }
    
    return title;
}

#pragma mark - JCDragableCellGestureRecognizerDelegate
- (BOOL)canDragCellForIndexPath:(NSIndexPath *)indexPath{
    return indexPath.row == JCHomeViewCellIndexSlidableCell
        || indexPath.row == JCHomeViewCellIndexSlidableCellTwo;
}

- (UIView *)topContentViewForCell:(UIView *)cell indexPath:(NSIndexPath *)indexPath{
    UIView *topContentView;
    if([cell isKindOfClass:[JCHomeCell class]]){
        topContentView = ((JCHomeCell *)cell).topContentView;
    }
    else if([cell isKindOfClass:[JCHomeConfirmDeleteCell class]]){
        topContentView = ((JCHomeConfirmDeleteCell *)cell).topContentView;
    }
    
    return topContentView;
}

- (NSLayoutConstraint *)topContentLeftConstraintForCell:(UIView *)cell indexPath:(NSIndexPath *)indexPath{
    NSLayoutConstraint *constraint;
    if(indexPath.row == JCHomeViewCellIndexSlidableCellTwo){
        constraint = ((JCHomeConfirmDeleteCell *)cell).const_topViewLeft;
    }

    return constraint;
}

- (NSLayoutConstraint *)topContentRightConstraintForCell:(UIView *)cell indexPath:(NSIndexPath *)indexPath{
    NSLayoutConstraint *constraint;
    if(indexPath.row == JCHomeViewCellIndexSlidableCellTwo){
        constraint = ((JCHomeConfirmDeleteCell *)cell).const_topViewRight;
    }

    return constraint;
}

- (CGFloat)bottomMenuWidthForCell:(UIView *)cell indexPath:(NSIndexPath *)indexPath{
    CGFloat width = 0;
    
    if([cell isKindOfClass:[JCHomeCell class]]){
        width = ((JCHomeCell *)cell).bottomMenuView.width;
    }
    else if([cell isKindOfClass:[JCHomeConfirmDeleteCell class]]){
        width = [(JCHomeConfirmDeleteCell *)cell menuWidth];
    }
    
    return width;
}

- (void)didResetCell:(UIView *)cell indexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == JCHomeViewCellIndexSlidableCellTwo){
        [((JCHomeConfirmDeleteCell *)cell) resetDeleteBtn];
    }
}

#pragma mark - RvrBarButtonItem Delegate
- (void)leftBarButtonItemTapped:(NSInteger)btnType{
    [JCUIAlertUtils toastWithMessage:@"Left menu clicked" colour:TOAST_MESSAGE_GREEN];
}

- (void)rightBarButtonItemTapped:(NSInteger)btnType{
    switch (btnType) {
        case RightBarButtonTypeMenu:
            [JCUIAlertUtils showConfirmDialog:@"this is title"
                                      content:@"right menu button clicked"
                                   okBtnTitle:@"Dismiss"
                                    okHandler:nil];
            break;
        case RightBarButtonTypeSearch:
            [JCUIAlertUtils showYesNoDialog:@"this is title"
                                    content:@"right search button clicked"
                                yesBtnTitle:@"Yes"
                                 yesHandler:^(UIAlertAction *action) {
                                     [JCUIAlertUtils toastWithMessage:@"Yes button clicked" colour:TOAST_MESSAGE_GREEN];
                                 }
                                 noBtnTitle:@"No"
                                  noHandler:^(UIAlertAction *action) {
                                      [JCUIAlertUtils toastWithMessage:@"No button clicked" colour:TOAST_MESSAGE_RED];
                                  }];
            break;
            
    }
}


#pragma mark - JCFloatingViewControllerDelegate
- (void)didClickedFloatingView:(JCFloatingViewController *)floatingView{
    [JCUIAlertUtils toastWithMessage:@"Did clicked floating view"
                              colour:TOAST_MESSAGE_GREEN];
}

- (void)didDismissFloatingView:(JCFloatingViewController *)floatingView{
    [JCUIAlertUtils toastWithMessage:@"Floating view dismiss success"
                              colour:TOAST_MESSAGE_GREEN];
}

@end
