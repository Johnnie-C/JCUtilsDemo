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

#import "JCUIAlertUtils.h"
#import "JCHomeCell.h"
#import "JCDragableCellGestureRecognizer.h"


NSString *const JC_HOME_CELL_IDENTIFIER = @"jcHomeCellIdentifier";

typedef NS_ENUM(NSInteger, JCHomeViewCellIndex){
    JCHomeViewCellIndexScrollView,
    JCHomeViewCellIndexStretchHeaderView,
    JCHomeViewCellIndexCustomisedHeader,
    JCHomeViewCellIndexSlidableCell,
    JCHomeViewCellIndexSlidableCellTwo
};





@interface JCHomeViewController ()<UITableViewDataSource, UITableViewDelegate, JCDragableCellGestureRecognizerDelegate>

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
    
    //setup dragable cell
    _dragCellpanGesture = [[JCDragableCellGestureRecognizer alloc] initWithTargetScrollView:_tableView];
    _dragCellpanGesture.dragableCellGRDelegate = self;
    [_tableView addGestureRecognizer:_dragCellpanGesture];
}

#pragma mark - TableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 60;
    if(indexPath.row == JCHomeViewCellIndexCustomisedHeader){
        height = 80;
    }
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JCHomeCell *cell = [tableView dequeueReusableCellWithIdentifier:JC_HOME_CELL_IDENTIFIER];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.disableClick = NO;
    switch (indexPath.row) {
        case JCHomeViewCellIndexScrollView:
            [cell updateUIWithTitle:@"ScrollView and TextField demo"];
            break;
            
        case JCHomeViewCellIndexStretchHeaderView:
            [cell updateUIWithTitle:@"Stretchable header demo"];
            break;
            
        case JCHomeViewCellIndexCustomisedHeader:
            [cell updateUIWithTitle:@"Curve transparent tab & local authentication demo"];
            break;
            
        case JCHomeViewCellIndexSlidableCell:
            [cell updateUIWithTitle:@"This is a slidable cell"];
            break;
            
        case JCHomeViewCellIndexSlidableCellTwo:
            [cell updateUIWithTitle:@"This is an another slidable cell"];
            break;
            
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
            
        case JCHomeViewCellIndexSlidableCell:
        case JCHomeViewCellIndexSlidableCellTwo:
            [_dragCellpanGesture resetPredragedCellIfNeed];
            [JCUIAlertUtils toastWithMessage:[NSString stringWithFormat:@"Cell clicked at: %ld-%ld", indexPath.section, indexPath.row]
                                      colour:TOAST_MESSAGE_ORANGE];
            break;
            
    }
}

#pragma mark - JCDragableCellGestureRecognizerDelegate
- (BOOL)canDragCellForIndexPath:(NSIndexPath *)indexPath{
    return indexPath.row == JCHomeViewCellIndexSlidableCell
        || indexPath.row == JCHomeViewCellIndexSlidableCellTwo;
}

- (UIView *)topContentViewForCell:(UIView *)cell{
    UIView *topContentView;
    if([cell isKindOfClass:[JCHomeCell class]]){
        topContentView = ((JCHomeCell *)cell).topContentView;
    }
    
    return topContentView;
}

- (UIView *)bottomMenuViewForCell:(UIView *)cell{
    UIView *topContentView;
    if([cell isKindOfClass:[JCHomeCell class]]){
        topContentView = ((JCHomeCell *)cell).bottomMenuView;
    }
    
    return topContentView;
}

#pragma mark - RvrBarButtonItem Delegate
- (void)leftBarButtonItemTapped:(NSInteger)btnType{
    [JCUIAlertUtils toastWithMessage:@"Left menu clicked" colour:TOAST_MESSAGE_GREEN];
}

- (void)rightBarButtonItemTapped:(NSInteger)btnType
{
    switch (btnType) {
        case RightBarButtonTypeMenu:
            [JCUIAlertUtils showConfirmDialog:@"this is title"
                                       content:@"right menu button clicked"
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

@end
