//
//  WDProfileTextField.h
//  Wendys_iOS
//
//  Created by Johnnie on 18/12/17.
//  Copyright © 2017 Putti. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JCTextField.h"

@class JCTextField, WDProfileTextField;

@protocol WDProfileTextFieldDelegate

@required

@optional
- (void)textFieldDidBeginEditing:(WDProfileTextField *)textField;
- (void)textFieldDidEndEditing:(WDProfileTextField *)textField;
- (BOOL)textFieldShouldReturn:(WDProfileTextField *)textField;

@end


IB_DESIGNABLE
@interface WDProfileTextField : UIView<UITextFieldDelegate>

@property (nonatomic, weak) NSObject<WDProfileTextFieldDelegate> *delegate;

@property (nonatomic, strong) IBInspectable NSString *placeholder;
@property (nonatomic, strong, getter=getText) IBInspectable NSString *text;
@property (nonatomic, strong, setter=setError:) NSString *error;
@property (nonatomic, strong) IBInspectable UIImage *leftImage;

@property (nonatomic, strong) JCTextField *textField;

- (void)becomeFirstResponder;

@end
