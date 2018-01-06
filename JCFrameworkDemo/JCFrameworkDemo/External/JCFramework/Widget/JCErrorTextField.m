//
//  JCErrorTextField.m
//
//  Created by Johnnie on 18/12/17.
//  Copyright © 2017 Johnnie Cheng. All rights reserved.
//

#import "JCErrorTextField.h"
#import "JCTextField.h"
#import "JCLabel.h"

#import "UIView+JCUtils.h"
#import "UIColor+JCUtils.h"

@interface JCErrorTextField()

@property (nonatomic, strong) NSLayoutConstraint *heightConstraint;
@property (nonatomic, assign) CGFloat originalHeight;
@property (nonatomic, strong) JCLabel *floatLabel;

@property (nonatomic, strong) UIView *leftImageBaseView;
@property (nonatomic, strong) UIImageView *leftImageView;

@end




@implementation JCErrorTextField


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        [self initDefaults];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initDefaults];
}

- (void)prepareForInterfaceBuilder{
    [super prepareForInterfaceBuilder];
    [self initDefaults];
    
    //for xib display only, to clearly see the border
    self.clipsToBounds = YES;
    self.layer.cornerRadius = 5;
    self.layer.borderWidth = 1;
    self.layer.borderColor = [UIColor borderColor].CGColor;
}

- (void)setPlaceholder:(NSString *)placeholder{
    _placeholder = placeholder;
    _textField.placeholder = _placeholder;
}

- (void)setText:(NSString *)text{
    _textField.text = text;
    [self showFloatingLabel:YES completion:nil];
}

- (NSString *)getText{
    return _textField.text;
}

- (void)setError:(NSString *)error{
    _error = error;
    if(error.length){
        _floatLabel.text = error;
        _floatLabel.textColor = _floatingErrorTextColor ? _floatingErrorTextColor : [UIColor redColor];
        [self showFloatingLabel:YES completion:nil];
    }
    else{
        _floatLabel.text = _placeholder;
        _floatLabel.textColor = _floatingPlaceholderTextColor ? _floatingPlaceholderTextColor : [UIColor lightGrayColor];
    }
    
    [_floatLabel sizeToFit];
}

- (void)setLeftImage:(UIImage *)leftImage{
    _leftImage = leftImage;
    [self updateLeftImage];
}

- (void)setFloatingPlaceholderTextColor:(UIColor *)floatingPlaceholderTextColor{
    _floatingPlaceholderTextColor = floatingPlaceholderTextColor;
    if(!_error){
        _floatLabel.textColor = _floatingPlaceholderTextColor;
    }
}

- (void)setfloatingErrorTextColor:(UIColor *)floatingErrorTextColor{
    _floatingErrorTextColor = floatingErrorTextColor;
    if(_error){
        _floatLabel.textColor = _floatingErrorTextColor;
    }
}

- (void)initDefaults {
    [self findHeightConstraint];
    [self addTextField];
    [self addFloatingLabel];
    [self setupSelfView];
}

- (void)findHeightConstraint{
    for (NSLayoutConstraint *constraint in self.constraints) {
        if (constraint.firstAttribute == NSLayoutAttributeHeight) {
            _heightConstraint = constraint;
            _originalHeight = constraint.constant;
            break;
        }
    }
}

- (void)addTextField{
    _textField = [JCTextField new];
    [self addSubview:_textField];
    [_textField addHeightConstraint:_heightConstraint.constant];
    [_textField alignParentBottomFillWidth];
    _textField.placeholder = _placeholder;
    _textField.delegate = self;
    
    _textField.clipsToBounds = YES;
    _textField.layer.cornerRadius = 5;
    _textField.layer.borderWidth = 1;
    _textField.layer.borderColor = [UIColor borderColor].CGColor;
    
    [self updateLeftImage];
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    _textField.rightView = paddingView;
    _textField.rightViewMode = UITextFieldViewModeUnlessEditing;
    
    _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
}

- (void)updateLeftImage{
    if(_leftImage){
        _leftImageBaseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, _heightConstraint.constant)];
        _leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, (_heightConstraint.constant - 20) / 2, 20, 20)];
        _leftImageView.image = _leftImage;
        [_leftImageBaseView addSubview:_leftImageView];
        _textField.leftView = _leftImageBaseView;
    }
    else{
        UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
        _textField.leftView = paddingView;
    }
    _textField.leftViewMode = UITextFieldViewModeAlways;
}

- (void)addFloatingLabel{
    _floatLabel = [[JCLabel alloc] initWithFrame:CGRectMake(10, 20, self.width, 15)];
    _floatLabel.text = _placeholder;
    _floatLabel.textColor = _floatingPlaceholderTextColor ? _floatingPlaceholderTextColor : [UIColor lightGrayColor];
    _floatLabel.font = [_floatLabel.font fontWithSize:12];
    [_floatLabel sizeToFit];
    [self addSubview:_floatLabel];
    _floatLabel.alpha = 0;
}

- (void)setupSelfView{
    self.clipsToBounds = YES;
    self.layer.cornerRadius = 5;
    self.backgroundColor = [UIColor clearColor];
    _textField.backgroundColor = [UIColor whiteColor];
}


#pragma mark - UITextField
- (void)becomeFirstResponder{
    [_textField becomeFirstResponder];
}

#pragma mark - Action
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    _textField.layer.borderColor = [UIColor borderSelectedColor].CGColor;
    self.error = nil;
    [self showFloatingLabel:YES completion:nil];
    
    if(_delegate && [_delegate respondsToSelector:@selector(textFieldDidBeginEditing:)]){
        [_delegate textFieldDidBeginEditing:self];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    _textField.layer.borderColor = [UIColor borderColor].CGColor;
    [self showFloatingLabel:NO completion:nil];
    
    if(_delegate && [_delegate respondsToSelector:@selector(textFieldDidEndEditing:)]){
        [_delegate textFieldDidEndEditing:self];
    }
}

- (void)showFloatingLabel:(BOOL)isShow completion:(void (^)(BOOL finished))completion{
    if(isShow){
        if(_placeholder.length){
            if(_floatLabel.alpha != 1){
                [_floatLabel setX:_leftImage ? 50 : 10];
                [_floatLabel setY:20];
                _heightConstraint.constant = _originalHeight + _floatLabel.height + 5;
            }
            _textField.placeholder = _error.length ? _placeholder : @"";
            
            [UIView animateWithDuration:0.3 animations:^{
                [_floatLabel setX:0];
                [_floatLabel setY:0];
                _floatLabel.alpha = 1;
                [self layoutIfNeeded];
            } completion:completion];
        }
    }
    else{
        if(!_textField.text.length ){//keep showing floating label if input text is not empty
            if(_floatLabel.alpha != 0){
                [_floatLabel setX:_leftImage ? 50 : 10];
                [_floatLabel setY:20];
                _floatLabel.alpha = 0;
                _heightConstraint.constant = _originalHeight;
            }
            _textField.placeholder = _placeholder;
            
            [UIView animateWithDuration:0.3 animations:^{
                [self layoutIfNeeded];
            } completion:completion];
        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if(_delegate && [_delegate respondsToSelector:@selector(textFieldShouldReturn:)]){
        return [_delegate textFieldShouldReturn:self];
    }
    
    return NO;
}

@end
