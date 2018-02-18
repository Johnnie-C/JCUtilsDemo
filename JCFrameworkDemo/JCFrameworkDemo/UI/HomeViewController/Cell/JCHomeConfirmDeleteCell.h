//
//  JCHomeConfirmDeleteCell.h
//  JCFrameworkDemo
//
//  Created by Johnnie Cheng on 18/02/18.
//  Copyright © 2018 Johnnie Cheng. All rights reserved.
//

#import "JCHomeBaseCell.h"


@interface JCHomeConfirmDeleteCell : JCHomeBaseCell

@property (weak, nonatomic) IBOutlet UIView *topContentView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *const_topViewLeft;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *const_topViewRight;

- (void)resetDeleteBtn;
- (CGFloat)menuWidth;

@end
