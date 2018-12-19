//
//  JCUIAlertController.m
//
//  Created by Johnnie on 10/01/18.
//  Copyright © 2018 Johnnie Cheng. All rights reserved.
//

#import "JCUIAlertController.h"

@interface JCUIAlertController ()

@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) UIImageView *imageView;

@end





@implementation JCUIAlertController


+ (instancetype)alertControllerWithTitle:(nullable NSString *)title
                                 message:(nullable NSString *)message
                                   image:(nullable UIImage *)image
                          preferredStyle:(UIAlertControllerStyle)preferredStyle
{
    JCUIAlertController *alert = [JCUIAlertController alertControllerWithTitle:title message:message preferredStyle:preferredStyle];
    alert.image = image;
    if(image){
        alert.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
        alert.imageView.contentMode = UIViewContentModeScaleAspectFit;
        alert.imageView.image = alert.image;
        alert.title = [NSString stringWithFormat:@"\n\n\n%@", title];
        [alert.view addSubview:alert.imageView];
    }
    return alert;
}

- (void)viewDidLayoutSubviews{
    if(!_imageView){
        [super viewDidLayoutSubviews];
        return;
    }
    
    CGPoint imageViewCenter = CGPointMake(self.view.bounds.size.width / 2, 40);
    _imageView.center = imageViewCenter;
    
    [super viewDidLayoutSubviews];
}

@end
