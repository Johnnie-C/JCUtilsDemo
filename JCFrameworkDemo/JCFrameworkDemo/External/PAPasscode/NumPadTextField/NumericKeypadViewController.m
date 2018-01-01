//
//  NumericKeypadViewController.m
//  NumericKeypad
//
//  Created by  on 11/12/01.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "NumericKeypadViewController.h"
#import "NumericKeypadDelegate.h"
#import "UIColor+JCUtils.h"

@implementation NumericKeypadViewController

#pragma mark - View lifecycle

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	return YES;
}

- (void)viewDidLoad {
	[super viewDidLoad];
    
    UIImage *f6 = [self imageWithColor:[UIColor colorWithRed:246.0/255.0 green:246.0/255.0 blue:246.0/255.0 alpha:1]];
    UIImage *lightGray = [self imageWithColor:[UIColor lightGrayColor]];
    
    [self.backButton setBackgroundImage:f6 forState:UIControlStateHighlighted];
    [self.btn0 setBackgroundImage:lightGray forState:UIControlStateHighlighted];
    [self.btn1 setBackgroundImage:lightGray forState:UIControlStateHighlighted];
    [self.btn2 setBackgroundImage:lightGray forState:UIControlStateHighlighted];
    [self.btn3 setBackgroundImage:lightGray forState:UIControlStateHighlighted];
    [self.btn4 setBackgroundImage:lightGray forState:UIControlStateHighlighted];
    [self.btn5 setBackgroundImage:lightGray forState:UIControlStateHighlighted];
    [self.btn6 setBackgroundImage:lightGray forState:UIControlStateHighlighted];
    [self.btn7 setBackgroundImage:lightGray forState:UIControlStateHighlighted];
    [self.btn8 setBackgroundImage:lightGray forState:UIControlStateHighlighted];
    [self.btn9 setBackgroundImage:lightGray forState:UIControlStateHighlighted];
    [self.numpadTextField deleteBackward];
}

- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)setActionSubviews:(UIView *)view {
	for (UIButton *button in view.subviews) {
		if ([button isKindOfClass:[UIButton class]]) {
			[button addTarget:self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchUpInside];
		}
	}
}

- (IBAction)buttonPress:(id)sender {
	UIButton *button = (UIButton *) sender;

	[[UIDevice currentDevice] playInputClick];

	if (button == self.backButton) {
		[self.numpadTextField deleteBackward];
	} else {
		BOOL shouldChangeCharacters = YES;
		UITextRange *selectedTextRange = self.numpadTextField.selectedTextRange;
		NSUInteger location = (NSUInteger)[self.numpadTextField offsetFromPosition:self.numpadTextField.beginningOfDocument
                                                                        toPosition:selectedTextRange.start];
		NSUInteger length = (NSUInteger)[self.numpadTextField offsetFromPosition:selectedTextRange.start
                                                                      toPosition:selectedTextRange.end];
		NSRange selectedRange = NSMakeRange(location, length);
		if ([self.numpadTextField.delegate respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)]) {
			shouldChangeCharacters = [self.numpadTextField.delegate textField:self.numpadTextField shouldChangeCharactersInRange:selectedRange replacementString:button.titleLabel.text];
		}
		if (shouldChangeCharacters) {
			[self.numpadTextField replaceRange:self.numpadTextField.selectedTextRange withText:button.titleLabel.text];
		}
	}
}

- (void)viewDidUnload {
	[self setBackButton:nil];
	[super viewDidUnload];
}

@end
