//
//  JCErrorTextField.h
//
//  Created by Johnnie on 18/12/17.
//  Copyright © 2017 Johnnie Cheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JCTextField.h"

@class JCTextField, JCErrorTextField;

@protocol JCErrorTextFieldDelegate

@required

@optional
- (void)textFieldDidBeginEditing:(JCErrorTextField *)textField;
- (void)textFieldDidEndEditing:(JCErrorTextField *)textField;
- (BOOL)textFieldShouldReturn:(JCErrorTextField *)textField;

@end


IB_DESIGNABLE
@interface JCErrorTextField : UIView<UITextFieldDelegate>

@property (nonatomic, weak) NSObject<JCErrorTextFieldDelegate> *delegate;

@property (nonatomic, strong) IBInspectable NSString *placeholder;
@property (nonatomic, strong, getter=getText) IBInspectable NSString *text;
@property (nonatomic, strong, setter=setError:) NSString *error;
@property (nonatomic, strong) IBInspectable UIImage *leftImage;
@property (nonatomic, strong) IBInspectable UIColor *floatingPlaceholderTextColor;
@property (nonatomic, strong) IBInspectable UIColor *floatingErrorTextColor;

@property (nonatomic, strong) JCTextField *textField;

- (void)becomeFirstResponder;

@end
