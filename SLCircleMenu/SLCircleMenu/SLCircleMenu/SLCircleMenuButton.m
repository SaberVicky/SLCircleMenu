//
//  SLCircleMenuButton.m
//  Saber Tool
//
//  Created by songlong on 16/4/24.
//  Copyright © 2016年 songlong. All rights reserved.
//

#import "SLCircleMenuButton.h"
#import "SLCircleMenu.h"

@implementation SLCircleMenuButton

- (instancetype)initWithSize:(CGSize)size circleMenu:(SLCircleMenu *)circleMenu distance:(CGFloat)distance angle:(double)angle {
    if (self = [super initWithFrame:CGRectMake(0, 0, size.width, size.height)]){
        self.backgroundColor = [[UIColor alloc] initWithRed:0.79 green:0.24 blue:0.27 alpha:1];
        self.layer.cornerRadius = size.height / 2.0;
        
        UIView *aContainer = [self createContainerWithSize:CGSizeMake(size.width, distance) andCircleMenu:circleMenu];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        view.backgroundColor = [UIColor clearColor];
        [view addSubview:self];
        
        [aContainer addSubview:view];
        _container = aContainer;
        
        view.layer.transform = CATransform3DMakeRotation(-(angle * M_PI / 180.0), 0, 0, 1);
        
        [self rotatedZWithAngle:angle animated:NO duration:0 delay:0];
    }
    return self;
}

- (UIView *)createContainerWithSize:(CGSize)size andCircleMenu:(SLCircleMenu *)circleMenu {
    if (!circleMenu.superview) {
        NSLog(@"wront circle menu");
        return nil;
    }
    
    UIView *container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    container.backgroundColor = [UIColor clearColor];
    container.translatesAutoresizingMaskIntoConstraints = NO;
    container.layer.anchorPoint = CGPointMake(0.5, 1);
    
    [circleMenu.superview insertSubview:container belowSubview:circleMenu];
    
    NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:container attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1 constant:size.height];
    height.identifier = @"height";
    [container addConstraint:height];
    
    [container addConstraint:[NSLayoutConstraint constraintWithItem:container attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1 constant:size.width]];
    
    [circleMenu.superview addConstraint:[NSLayoutConstraint constraintWithItem:circleMenu attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:container attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [circleMenu.superview addConstraint:[NSLayoutConstraint constraintWithItem:circleMenu attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:container attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
    return container;
}


- (void)rotationLayerAnimationWithAngle:(double)angle andDuration:(double)duration {
    if (_container) {
        [self rotationLayerAnimationWithContainer:_container angle:angle duration:duration];
    }
}

- (void)rotationLayerAnimationWithContainer:(UIView *)view angle:(double)angle duration:(double)duration {
    CABasicAnimation *rotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotation.duration = (NSTimeInterval)duration;
    rotation.toValue = @(angle * M_PI / 180.0);
    rotation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [view.layer addAnimation:rotation forKey:@"rotation"];
}

- (void)hideAnimationWithDistance:(double)distance duration:(double)duration andDelay:(double)delay {
    
    UIView *container = _container;
    if (!_container) {
        return;
    }
    
    __block NSLayoutConstraint *heightConstraint = nil;
    [_container.constraints enumerateObjectsUsingBlock:^(__kindof NSLayoutConstraint * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.identifier isEqualToString:@"height"]) {
            heightConstraint = obj;
        }
    }];
    if (!heightConstraint) {
        return;
    }
    
    heightConstraint.constant = (CGFloat)distance;
    [UIView animateWithDuration:duration delay:delay options:UIViewAnimationOptionCurveEaseIn animations:^{
        [container layoutIfNeeded];
        self.transform = CGAffineTransformMakeScale(0.01, 0.01);
    } completion:^(BOOL finished) {
        self.alpha = 0;
        if (_container) {
            [_container removeFromSuperview];
        }
    }];
}

- (void)rotatedZWithAngle:(double)angle animated:(BOOL)animated duration:(double)duration delay:(double)delay {
    if (!_container) {
        NSLog(@"contaner don't create");
        return;
    }
    
    CATransform3D rotateTransform = CATransform3DMakeRotation((angle * M_PI / 180.0), 0, 0, 1);
    if (animated) {
        [UIView animateWithDuration:duration delay:delay options:UIViewAnimationOptionCurveEaseInOut animations:^{
            _container.layer.transform = rotateTransform;
        } completion:^(BOOL finished) {
            
        }];
    } else {
        _container.layer.transform = rotateTransform;
    }
}

- (void)showAnimationWithDistance:(double)distance duration:(double)duration andDelay:(double)delay {
    if (!_container) {
        return;
    }
    
    
    __block NSLayoutConstraint *heightConstraint = nil;
    [_container.constraints enumerateObjectsUsingBlock:^(__kindof NSLayoutConstraint * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.identifier isEqualToString:@"height"]) {
            heightConstraint = obj;
        }
    }];
    if (!heightConstraint) {
        return;
    }
    
    self.transform = CGAffineTransformMakeScale(0, 0);
    [_container layoutIfNeeded];
    self.alpha = 0;
    
    heightConstraint.constant = distance;
    [UIView animateWithDuration:duration delay:delay usingSpringWithDamping:0.7 initialSpringVelocity:0 options:UIViewAnimationOptionCurveLinear animations:^{
        [_container layoutIfNeeded];
        self.transform = CGAffineTransformMakeScale(1.0, 1.0);
        self.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)changeDistance:(CGFloat)distance andAnimated:(BOOL)animated duration:(double)duration andDelay:(double)delay {
    if (!_container) {
        return;
    }
    
    __block NSLayoutConstraint *heightConstraint = nil;
    [_container.constraints enumerateObjectsUsingBlock:^(__kindof NSLayoutConstraint * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.identifier isEqualToString:@"height"]) {
            heightConstraint = obj;
        }
    }];
    if (!heightConstraint) {
        return;
    }
    
    heightConstraint.constant = distance;
    [UIView animateWithDuration:duration delay:delay usingSpringWithDamping:0.7 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        [_container layoutIfNeeded];
        
    } completion:^(BOOL finished) {
       
    }];
}

@end
