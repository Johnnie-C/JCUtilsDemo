//
//  JCHomeBaseCell.h
//  JCFrameworkDemo
//
//  Created by Johnnie Cheng on 18/02/18.
//  Copyright © 2018 Johnnie Cheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JCHomeBaseCell : UITableViewCell

@property (assign, nonatomic) BOOL disableClick;

+ (CGFloat)heightForCellWithTitle:(NSString *)title;

- (void)updateUIWithTitle:(NSString *)title;

@end
