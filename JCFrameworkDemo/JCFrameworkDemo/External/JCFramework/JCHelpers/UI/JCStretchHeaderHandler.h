//
//  JCStretchHeaderHandler.h
//  JCStretchHeaderView
//
//  Created by Johnnie Cheng on 10/12/17.
//  Copyright © 2017 Johnnie Cheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface JCStretchHeaderHandler : NSObject


/**
 header view height, 240 by default
 */
@property (nonatomic, assign) CGFloat headerViewHeight;


- (nonnull instancetype)initWithHeader:(nonnull UIView *)headerView
                            scrollView:(nonnull UIScrollView *)scrollView
                         navigationBar:(nullable UINavigationBar *)navigationBar
                        navigationItem:(nullable UINavigationItem *)navigationItem;

- (void)destory;

@end
