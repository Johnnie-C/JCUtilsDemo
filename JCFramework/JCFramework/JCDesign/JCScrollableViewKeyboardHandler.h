//
//  JCScrollableViewKeyboardHandler.h
//  
//
//  Created by Johnnie on 8/09/17.
//  Copyright © 2017 Johnnie Cheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIkit.h>

@interface JCScrollableViewKeyboardHandler : NSObject

- (void)registerResposeScrollViewForKeyBoard:(UIScrollView *)scrollView;
- (void)unregister;

@end
