//
//  JCHomeCell.m
//  JCFrameworkDemo
//
//  Created by Johnnie Cheng on 1/01/18.
//  Copyright © 2018 Johnnie Cheng. All rights reserved.
//

#import "JCHomeCell.h"
#import "UIColor+JCUtils.h"


@interface JCHomeCell()

@property (weak, nonatomic) IBOutlet UIView *bottomMenuView;
@property (weak, nonatomic) IBOutlet UIView *topContentView;
@property (weak, nonatomic) IBOutlet UILabel *lbTitle;

@end





@implementation JCHomeCell

- (void)updateUIWithTitle:(NSString *)title{
    _lbTitle.text = title;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    [super setHighlighted:highlighted animated:animated];
    
    _topContentView.backgroundColor = highlighted ? [[UIColor whiteColor] darkerColor] : [UIColor whiteColor];
}


- (IBAction)leftButtonClicked:(id)sender {
}

- (IBAction)rightButtonClicked:(id)sender {
}

@end
