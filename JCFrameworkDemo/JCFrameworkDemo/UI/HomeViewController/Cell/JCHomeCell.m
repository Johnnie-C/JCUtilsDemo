//
//  JCHomeCell.m
//  JCFrameworkDemo
//
//  Created by Johnnie Cheng on 1/01/18.
//  Copyright © 2018 Johnnie Cheng. All rights reserved.
//

#import "JCHomeCell.h"
#import <JCFramework/JCFramework.h>


@interface JCHomeCell()

@property (weak, nonatomic) IBOutlet UILabel *lbTitle;

@end





@implementation JCHomeCell

- (void)updateUIWithTitle:(NSString *)title{
    _lbTitle.text = title;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    [super setHighlighted:highlighted animated:animated];
    if(!self.disableClick){
        _topContentView.backgroundColor = highlighted ? [[UIColor whiteColor] darkerColor] : [UIColor whiteColor];
    }
}


- (IBAction)leftButtonClicked:(id)sender {
    [JCToast toastWithMessage:@"One clicked" colour:[UIColor toastMessageOrange]];
}

- (IBAction)rightButtonClicked:(id)sender {
    [JCToast toastWithMessage:@"Two clicked" colour:[UIColor toastMessageOrange]];
}

@end
