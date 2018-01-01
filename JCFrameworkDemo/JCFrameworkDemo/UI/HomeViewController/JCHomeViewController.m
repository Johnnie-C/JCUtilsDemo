//
//  JCHomeViewController.m
//  JCFrameworkDemo
//
//  Created by Johnnie Cheng on 1/01/18.
//  Copyright © 2018 Johnnie Cheng. All rights reserved.
//

#import "JCHomeViewController.h"
#import "JCUIAlertUtils.h"
#import "JCHomeCell.h"


NSString *const JC_HOME_CELL_IDENTIFIER = @"jcHomeCellIdentifier";

typedef NS_ENUM(NSInteger, JCHomeViewCellIndex){
    JCHomeViewCellIndexScrollView,
    JCHomeViewCellIndexStretchHeaderView,
    JCHomeViewCellIndexSlidableCell
};

@interface JCHomeViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

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
    [self setLeftBarButtonType:LeftBarButtonTypeMenu];
    [self setRightBarButtonTypes:@[@(RightBarButtonTypeMenu), @(RightBarButtonTypeSearch)]];
}

- (void)setupTableView{
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    NSBundle *bundle = [NSBundle bundleForClass:[JCHomeCell class]];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([JCHomeCell class]) bundle:bundle] forCellReuseIdentifier:JC_HOME_CELL_IDENTIFIER];
}

#pragma mark - TableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JCHomeCell *cell = [tableView dequeueReusableCellWithIdentifier:JC_HOME_CELL_IDENTIFIER];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    switch (indexPath.row) {
        case JCHomeViewCellIndexScrollView:
            [cell updateUIWithTitle:@"ScrollView and TextField demo"];
            break;
            
        case JCHomeViewCellIndexStretchHeaderView:
            [cell updateUIWithTitle:@"Stretchable header demo"];
            break;
            
        case JCHomeViewCellIndexSlidableCell:
            [cell updateUIWithTitle:@"This is a slidable cell"];
            break;
            
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case JCHomeViewCellIndexScrollView:
            
            break;
            
        case JCHomeViewCellIndexStretchHeaderView:
            
            break;
            
        case JCHomeViewCellIndexSlidableCell:
            
            break;
            
    }
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
