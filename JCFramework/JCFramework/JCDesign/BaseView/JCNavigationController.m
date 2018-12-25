//
//  JCNavigationController.m
//
//  Created by Johnnie on 11/12/17.
//  Copyright © 2017 Johnnie Cheng. All rights reserved.
//

#import "JCNavigationController.h"
#import "UIColor+JCUtils.h"
#import "UINavigationBar+JCUtils.h"
#import "JCUtils.h"
#import "UIImage+JCUtils.h"

@interface JCNavigationController ()

@end

@implementation JCNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationBar setBackgroundColor:[UIColor navigationbarBackgroundColor] extendToStatusBar:YES];
    self.navigationBar.shadowImage = [UIImage imageWithColor: [UIColor clearColor] size:CGSizeMake([JCUtils screenWidth], 0.5f)];
    
    [self.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor navigationbarTextColor]}];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
