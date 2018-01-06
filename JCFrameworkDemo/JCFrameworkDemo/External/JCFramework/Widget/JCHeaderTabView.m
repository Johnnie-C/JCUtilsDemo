//
//  JCHeaderTabView.m
//
//  Created by Johnnie on 12/12/17.
//  Copyright © 2017 Johnnie Cheng. All rights reserved.
//

#import "JCHeaderTabView.h"

#import "UIColor+JCUtils.h"
#import "UIView+JCUtils.h"

@interface JCHeaderTabView()

@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIButton *btnLeft;
@property (weak, nonatomic) IBOutlet UIButton *btnRight;

@property (weak, nonatomic) IBOutlet UIView *selectedIndicator;
@property (strong, nonatomic) CAShapeLayer *selectedIndexLayer;

@end





@implementation JCHeaderTabView

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]){
        _selectedIndex = 0;
        _cornerRadius = 12;
        _showSelectingAnimation = YES;
        [self setupUI];
    }
    return self;
}


- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        _selectedIndex = 0;
        _cornerRadius = 12;
        _showSelectingAnimation = YES;
        [self setupUI];
    }
    
    return self;
}

- (void)dealloc{
    [_selectedIndicator removeObserver:self forKeyPath:@"bounds"];
}

- (void)setupUI{
    //init View
    NSString *className = NSStringFromClass([self class]);
    _contentView = [[[NSBundle mainBundle] loadNibNamed:className owner:self options:nil] firstObject];
    [self addSubview:_contentView];
    [_contentView fillInSuperView];
    self.clipsToBounds = YES;
    
    [_selectedIndicator addObserver:self forKeyPath:@"bounds" options:0 context:nil];
    
    [self setupTransparentLayer];
    [self updateUI];
}

- (void)setupTransparentLayer{
    [_selectedIndexLayer removeFromSuperlayer];
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    CGFloat totalWidth = 1.5 * self.width + _cornerRadius;
    
    CGFloat x = -(self.width / 2 + _cornerRadius), y = self.height;
    [path moveToPoint:CGPointMake(x, y)];//1
    
    y = 0;
    [path addLineToPoint:CGPointMake(x, y)];//2
    
    x += totalWidth; y = 0;
    [path addLineToPoint:CGPointMake(x, y)];//3
    
    y = _selectedIndicator.height;
    [path addLineToPoint:CGPointMake(x, y)];//4
    
    x = x - self.width / 2 + _cornerRadius;
    [path addLineToPoint:CGPointMake(x, y)];//5
    
    x -= _cornerRadius; y -= _cornerRadius;
    [path addQuadCurveToPoint:CGPointMake(x, y)
                 controlPoint:CGPointMake(x, y + _cornerRadius)];//6
    
    y = _cornerRadius;
    [path addLineToPoint:CGPointMake(x, y)];//7
    
    x -= _cornerRadius; y = 0;
    [path addQuadCurveToPoint:CGPointMake(x, y)
                 controlPoint:CGPointMake(x + _cornerRadius, y)];//8
    
    x -= self.width / 2 - _cornerRadius; y = 0;
    [path addLineToPoint:CGPointMake(x, y)];//9
    
    x -= _cornerRadius; y += _cornerRadius;
    [path addQuadCurveToPoint:CGPointMake(x, y)
                 controlPoint:CGPointMake(x, y - _cornerRadius)];//10
    
    y = self.height - _cornerRadius;
    [path addLineToPoint:CGPointMake(x, y)];//11
    
    x -= _cornerRadius; y += _cornerRadius;
    [path addQuadCurveToPoint:CGPointMake(x, y)
                 controlPoint:CGPointMake(x + _cornerRadius, y)];//12
    
    x = -(self.width + _cornerRadius); y = self.height;
    [path addLineToPoint:CGPointMake(x, y)];//13
    
    [path setUsesEvenOddFillRule:YES];
    _selectedIndexLayer = [CAShapeLayer layer];
    _selectedIndexLayer.path = path.CGPath;
    _selectedIndexLayer.fillRule = kCAFillRuleEvenOdd;
    _selectedIndexLayer.fillColor = [self getDefaultButtonColor].CGColor;
    _selectedIndexLayer.opacity = 1;
    
    [_selectedIndicator.layer insertSublayer:_selectedIndexLayer atIndex:0];
    
    [self onTabSelected:_selectedIndex animated:NO];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object == _selectedIndicator && [keyPath isEqualToString:@"bounds"]) {
        [self setupTransparentLayer];
    }
}

- (void)onTabSelected:(NSInteger)index animated:(BOOL)animated{
    _selectedIndex = index;
    if(animated){
        [UIView animateWithDuration:0.3 animations:^{
            [self didSelectTab];
        } completion:^(BOOL finished) {
        }];
    }
    else{
        [self didSelectTab];
    }
}

- (void)didSelectTab{
    CGFloat x = _selectedIndex == 0 ? 0 : self.width / 2 + _cornerRadius;
    _selectedIndicator.layer.frame = CGRectMake(x, 0, _selectedIndicator.layer.frame.size.width, _selectedIndicator.layer.frame.size.height);
    
    [_btnLeft setTitleColor:_selectedIndex ? [self getDefaultButtonTitleColor] : [self getSelectedButtonTitleColor] forState:UIControlStateNormal];
    [_btnRight setTitleColor:_selectedIndex ? [self getSelectedButtonTitleColor] : [self getDefaultButtonTitleColor] forState:UIControlStateNormal];
}



- (void)setLeftButtonTitle:(NSString *)leftButtonTitle{
    _leftButtonTitle = leftButtonTitle;
    [self updateUI];
}

- (void)setRightButtonTitle:(NSString *)rightButtonTitle{
    _rightButtonTitle = rightButtonTitle;
    [self updateUI];
}

- (void)setDefaultButtonColor:(UIColor *)defaultButtonColor{
    _defaultButtonColor = defaultButtonColor;
    [self updateUI];
}

- (void)setSelectedButtonColor:(UIColor *)selectedButtonColor{
    _selectedButtonColor = selectedButtonColor;
    [self updateUI];
}

- (void)setDefaultButtonTitleColor:(UIColor *)defaultButtonTitleColor{
    _defaultButtonTitleColor = defaultButtonTitleColor;
    [self updateUI];
}

- (void)setSelectedButtonTitleColor:(UIColor *)selectedButtonTitleColor{
    _selectedButtonTitleColor = selectedButtonTitleColor;
    [self updateUI];
}




- (UIColor *)getDefaultButtonColor{
    return _defaultButtonColor ? _defaultButtonColor : [UIColor appMainColor];
}

- (UIColor *)getSelectedButtonColor{
    return _selectedButtonColor ? _selectedButtonColor : [UIColor clearColor];
}

- (UIColor *)getDefaultButtonTitleColor{
    return _defaultButtonTitleColor ? _defaultButtonTitleColor : [UIColor appMainColorLight];
}

- (UIColor *)getSelectedButtonTitleColor{
    return _selectedButtonTitleColor ? _selectedButtonTitleColor : [UIColor whiteColor];
}


- (void)updateUI{
    [_btnLeft setTitle:_leftButtonTitle forState:UIControlStateNormal];
    [_btnRight setTitle:_rightButtonTitle forState:UIControlStateNormal];
    self.backgroundColor = [self getSelectedButtonColor];
    
    [_btnLeft setTitleColor:_selectedIndex ? [self getDefaultButtonTitleColor] : [self getSelectedButtonTitleColor] forState:UIControlStateNormal];
    [_btnRight setTitleColor:_selectedIndex ? [self getSelectedButtonTitleColor] : [self getDefaultButtonTitleColor] forState:UIControlStateNormal];
}


#pragma mark - action
- (void)selectTabAtIndex:(NSInteger)index animated:(BOOL)anmimated{
    [self onTabSelected:index animated:anmimated];
}

- (IBAction)onLeftButtonClicked:(id)sender {
    NSInteger preIndex = _selectedIndex;
    [self onTabSelected:0 animated:_showSelectingAnimation];
    if(_delegate && preIndex != _selectedIndex){
        [_delegate onTabSelected:0];
    }
}

- (IBAction)onRightButtonClicked:(id)sender {
    NSInteger preIndex = _selectedIndex;
    [self onTabSelected:1 animated:_showSelectingAnimation];
    if(_delegate && preIndex != _selectedIndex){
        [_delegate onTabSelected:1];
    }
}
@end

