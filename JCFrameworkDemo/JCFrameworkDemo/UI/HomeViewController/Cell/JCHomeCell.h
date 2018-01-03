//
//  JCHomeCell.h
//  JCFrameworkDemo
//
//  Created by Johnnie Cheng on 1/01/18.
//  Copyright © 2018 Johnnie Cheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JCHomeCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *bottomMenuView;
@property (weak, nonatomic) IBOutlet UIView *topContentView;

@property (assign, nonatomic) BOOL disableClick;

- (void)updateUIWithTitle:(NSString *)title;

@end
