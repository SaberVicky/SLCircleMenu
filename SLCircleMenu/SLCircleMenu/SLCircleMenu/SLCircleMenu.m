//
//  SLCircleMenu.m
//  Saber Tool
//
//  Created by songlong on 16/4/24.
//  Copyright © 2016年 songlong. All rights reserved.
//

#import "SLCircleMenu.h"
#import "SLCircleMenuLoader.h"

@interface SLCircleMenu()

@property (nonatomic, strong) UIImageView *customNormalIconView;
@property (nonatomic, strong) UIImageView *customSelectedIconView;

@property (nonatomic, assign) NSInteger buttonCount;
@property (nonatomic, assign) CGFloat distance;
@property (nonatomic, assign) double duration;
@property (nonatomic, assign) double showDelay;

@property (nonatomic, strong) NSArray *buttons;

@end

@implementation SLCircleMenu

- (instancetype)initWithFrame:(CGRect)frame imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName buttonCount:(NSInteger)buttonCount duration:(double)duration distance:(CGFloat)distance {
    if (self = [super initWithFrame:frame]) {
        
        [self setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:selectedImageName] forState:UIControlStateSelected];
        _buttonCount = buttonCount;
        _distance = distance;
        _duration = duration;
        [self commonInit];
    }
    
    return self;
}

- (void)commonInit {
    [self addActions];
    _customNormalIconView = [self addCustomImageViewWithState:UIControlStateNormal];
    _customSelectedIconView = [self addCustomImageViewWithState:UIControlStateSelected];
    if (_customSelectedIconView) {
        _customSelectedIconView.alpha = 0.0;
    }
    [self setImage:[[UIImage alloc] init] forState:UIControlStateNormal];
    [self setImage:[[UIImage alloc] init] forState:UIControlStateSelected];
}

- (void)addActions {
    [self addTarget:self action:@selector(clickCircleMenu) forControlEvents:UIControlEventTouchUpInside];
}

- (UIImageView *)addCustomImageViewWithState:(UIControlState)state {
    UIImage *image = [self imageForState:state];
    if (!image) {
        return nil;
    }
    UIImageView *iconView = [[UIImageView alloc] initWithImage:image];
    iconView.translatesAutoresizingMaskIntoConstraints = NO;
    iconView.contentMode = UIViewContentModeCenter;
    iconView.userInteractionEnabled = NO;
    [self addSubview:iconView];
    [iconView addConstraint:[NSLayoutConstraint constraintWithItem:iconView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1 constant:self.bounds.size.height]];
    [iconView addConstraint:[NSLayoutConstraint constraintWithItem:iconView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1 constant:self.bounds.size.width]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:iconView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:iconView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    return iconView;
}

- (void)clickCircleMenu {
    if (![self buttonsIsShown]) {
        _buttons = [self createButtons];
    }
    BOOL isShow = ![self buttonsIsShown];
    double duration = isShow ? 0.5 : 0.2;
    [self buttonsAnimationIsShow:isShow duration:duration hideDelay:0];
    [self tapBounceAnimation];
    [self tapRotatedAnimationWithDuration:0.3 andIsSelected:isShow];
}

- (BOOL)buttonsIsShown {
    if (!_buttons) {
        return NO;
    }
    
    for (SLCircleMenuButton *button in _buttons) {
        if (button.alpha == 0) {
            return NO;
        }
    }
    return YES;
}

- (NSArray *)createButtons {
    NSMutableArray *buttons = [NSMutableArray array];
    double step = 360.0 / _buttonCount;
    for (int i = 0; i < _buttonCount; i++) {
        double angle = i * step;
        CGFloat distance = self.bounds.size.height / 2.0;
        UIButton *button = [[SLCircleMenuButton alloc] initWithSize:self.bounds.size circleMenu:self distance:distance angle:angle];
        button.tag = i;
        button.alpha = 0.0;
        [button addTarget:self action:@selector(buttonHandler:) forControlEvents:UIControlEventTouchUpInside];
        [buttons addObject:button];
    }
    return buttons;
}

- (void)buttonHandler:(SLCircleMenuButton *)sender {
    if ([self.delegate respondsToSelector:@selector(circleMenu:buttonWillSelected:atIndex:)]) {
        [self.delegate circleMenu:self buttonWillSelected:sender atIndex:sender.tag];
    }
    
    SLCircleMenuLoader *circle = [[SLCircleMenuLoader alloc] initWithRadius:(CGFloat)_distance strokeWidth:self.bounds.size.height circleMenu:self color:sender.backgroundColor];
    UIView *container = sender.container;
    double radians = atan2(container.transform.b, container.transform.a);
    double angleZ = radians * 180.0 / M_PI;
    [sender rotationLayerAnimationWithAngle:angleZ + 360.0 andDuration:_duration];
    [container.superview bringSubviewToFront:container];
    
    [circle fillAnimationWithDuration:_duration andStartAngle:-90 + 360.0 / _buttons.count * sender.tag];
    [circle hideAnimationWithDuration:0.5 andDelay:_duration];
    
    [self hideCenterButtonWithDuration:0.3 andDelay:0];
    [self buttonsAnimationIsShow:NO duration:0 hideDelay:_duration];
    [self showCenterButtonWithDuration:0.525 andDelay:_duration];
    
    if (_customNormalIconView && _customSelectedIconView) {
        dispatch_time_t dispatchTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(_duration * NSEC_PER_SEC));
        dispatch_after(dispatchTime, dispatch_get_main_queue(), ^{
            if ([self.delegate respondsToSelector:@selector(circleMenu:buttonDidSelected:atIndex:)]) {
                [self.delegate circleMenu:self buttonDidSelected:sender atIndex:sender.tag];
            }
        });
    }
    
}

- (void)hideCenterButtonWithDuration:(double)duration andDelay:(double)delay {
    [UIView animateWithDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.transform = CGAffineTransformMakeScale(0.001, 0.001);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)buttonsAnimationIsShow:(BOOL)isShow duration:(double)duration hideDelay:(double)hideDelay {
    if (!_buttons) {
        return;
    }
    
    double step = 360.0 / _buttonCount;
    for (int i = 0; i < _buttonCount; i++) {
        SLCircleMenuButton *button = _buttons[i];
        double angle = i * step;
        if (isShow) {
            if ([self.delegate respondsToSelector:@selector(circleMenu:willDisplayButton:atIndex:)]) {
                [self.delegate circleMenu:self willDisplayButton:button atIndex:i];
            }
            
            [button rotatedZWithAngle:angle animated:NO duration:duration delay:i * _showDelay];
            [button showAnimationWithDistance:_distance duration:duration andDelay:i * _showDelay];
        } else {
            [button hideAnimationWithDistance:self.bounds.size.height / 2.0 duration:duration andDelay:hideDelay];
        }
    }
    if (!isShow) {
        _buttons = nil;
    }
}

- (void)showCenterButtonWithDuration:(double)duration andDelay:(double)delay {
    [UIView animateWithDuration:duration delay:delay usingSpringWithDamping:0.78 initialSpringVelocity:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.transform = CGAffineTransformMakeScale(1, 1);
        self.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
    
    CASpringAnimation *rotation = [CASpringAnimation animationWithKeyPath:@"transform.rotation"];
    rotation.duration = 1.5;
    rotation.toValue = @0;
    rotation.fromValue = @(-180 * M_PI / 180.0);
    rotation.damping = 10;
    rotation.initialVelocity = 0;
    rotation.beginTime = CACurrentMediaTime() + delay;
    
    CABasicAnimation *fade = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fade.duration = 0.01;
    fade.toValue = @0;
    fade.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    fade.fillMode = kCAFillModeForwards;
    fade.removedOnCompletion = NO;
    fade.beginTime = CACurrentMediaTime() + delay;
    
    CABasicAnimation *show = [CABasicAnimation animationWithKeyPath:@"opacity"];
    show.duration = duration;
    show.toValue = @1;
    show.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    show.fillMode = kCAFillModeForwards;
    show.removedOnCompletion = NO;
    show.beginTime = CACurrentMediaTime() + delay;
    
    if (_customNormalIconView) {
        [_customNormalIconView.layer addAnimation:rotation forKey:nil];
        [_customNormalIconView.layer addAnimation:show forKey:nil];
    }
    
    if (_customSelectedIconView) {
        [_customSelectedIconView.layer addAnimation:fade forKey:nil];
    }
}

- (void)tapBounceAnimation {
    self.transform = CGAffineTransformMakeScale(0.9, 0.9);
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.3 initialSpringVelocity:5 options:UIViewAnimationOptionCurveLinear animations:^{
        self.transform = CGAffineTransformMakeScale(1, 1);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)tapRotatedAnimationWithDuration:(double)duraton andIsSelected:(BOOL)isSelected {
    if (_customNormalIconView && _customSelectedIconView) {
        [self addAnimationsWithView:_customNormalIconView andIsShow:!isSelected andDuration:duraton];
        [self addAnimationsWithView:_customSelectedIconView andIsShow:isSelected andDuration:duraton];
    }
}

- (void)addAnimationsWithView:(UIImageView *)view andIsShow:(BOOL)isShow andDuration:(double)duration{
    double toAngle = 180.0;
    double fromAngle = 0;
    double fromScale = 1.0;
    double toScale = 0.2;
    double fromOpacity = 1;
    double toOpacity = 0;
    if (isShow) {
        toAngle     = 0;
        fromAngle   = -180;
        fromScale   = 0.2;
        toScale     = 1.0;
        fromOpacity = 0;
        toOpacity   = 1;
    }
    CASpringAnimation *rotation = [CASpringAnimation animationWithKeyPath:@"transform.rotation"];
    rotation.duration = duration;
    rotation.toValue = @(toAngle * M_PI / 180.0);
    rotation.fromValue = @(fromAngle * M_PI / 180.0);
    rotation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    CABasicAnimation *fade = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fade.duration = duration;
    fade.fromValue = @(fromOpacity);
    fade.toValue = @(toOpacity);
    fade.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    fade.fillMode = kCAFillModeForwards;
    fade.removedOnCompletion = NO;
    
    CABasicAnimation *scale = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scale.duration = duration;
    scale.toValue = @(toScale);
    scale.fromValue = @(fromScale);
    scale.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    [view.layer addAnimation:rotation forKey:nil];
    [view.layer addAnimation:fade forKey:nil];
    [view.layer addAnimation:scale forKey:nil];
}


@end
