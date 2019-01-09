//
//  JCAddCartEffictViewController.m
//  JCFrameworkDemo
//
//  Created by Johnnie Cheng on 14/01/18.
//  Copyright © 2018 Johnnie Cheng. All rights reserved.
//

#import "JCAddCartEffictViewController.h"


@interface JCAddCartEffictViewController ()

@property (strong, nonatomic) JCCartBarButtonItem *cartButton;

@end





@implementation JCAddCartEffictViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
}

- (void)setupView{
    [self setupNavBar];
    [self setupContent];
}

- (void)setupNavBar{
    self.title = @"Add cart parabola effect dome";
    [self setLeftBarButtonType:LeftBarButtonTypeBack];
    NSArray<UIBarButtonItem *> *rightBtns = [self setRightBarButtonTypes:@[@(RightBarButtonTypeCart)]];
    _cartButton = (JCCartBarButtonItem *)[rightBtns objectAtIndex:0];
}

- (void)setupContent{
    
}

- (IBAction)addToCart:(id)sender {
    UIView *clickedView = (UIView *)sender;
    UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    iv.center = clickedView.center;
    iv.image = [UIImage imageNamed:@"demo_image.jpeg"];
    iv.clipsToBounds = YES;
    iv.layer.cornerRadius = 25;
    
    CGPoint startPoint = [clickedView.superview convertPoint:clickedView.center toView:nil];
    CGPoint endPoint = [_cartButton.lbCount.superview convertPoint:_cartButton.lbCount.center toView:nil];
    
    JCParabolaAnimationHandler *animationHandler = [JCParabolaAnimationHandler new];
    animationHandler.duration = 0.5f;
    [animationHandler startAnimationandView:iv
                                 startPoint:startPoint
                                   endPoint:endPoint
                                    endSize:_cartButton.lbCount.frame.size
                              complemention:^{
                                  [_cartButton addCartCountBy:1];
                              }];
}

- (void)rightBarButtonItemTapped:(NSInteger)btnType{
    if(btnType == RightBarButtonTypeCart){
        _cartButton.cartCount = 0;
    }
}
@end
