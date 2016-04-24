//
//  SLCircleMenuLoader.m
//  Saber Tool
//
//  Created by songlong on 16/4/24.
//  Copyright © 2016年 songlong. All rights reserved.
//

#import "SLCircleMenuLoader.h"
#import "SLCircleMenu.h"

@interface SLCircleMenuLoader()

@property (nonatomic, strong) CAShapeLayer *circle;

@end

@implementation SLCircleMenuLoader

- (instancetype)initWithRadius:(CGFloat)radius strokeWidth:(CGFloat)strokeWidth circleMenu:(SLCircleMenu *)circleMenu color:(UIColor *)color {
    if (self = [super initWithFrame:CGRectMake(0, 0, radius, radius)]) {
        UIView *aSuperView = circleMenu.superview;
        [aSuperView insertSubview:self belowSubview:circleMenu];
        
        
        _circle = [self createCircleWithRadius:radius strokeWidth:strokeWidth andColor:color];
        [self createConstraintsWithCircleMenu:circleMenu andRadius:radius];
        
        CGRect circleFrame = CGRectMake(radius * 2 - strokeWidth, radius - strokeWidth / 2, strokeWidth, strokeWidth);
        [self createRoundViewWithRect:circleFrame andColor:color];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (CAShapeLayer *)createCircleWithRadius:(CGFloat)radius strokeWidth:(CGFloat)strokeWidth andColor:(UIColor *)color {
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(radius, radius) radius:radius - strokeWidth / 2.0 startAngle:0.0 endAngle:2.0 * M_PI clockwise:YES];
    
    CAShapeLayer *circle = [[CAShapeLayer alloc] init];
    circle.path = circlePath.CGPath;
    circle.fillColor = [UIColor clearColor].CGColor;
    circle.strokeColor = color.CGColor;
    circle.lineWidth = strokeWidth;
    
    [self.layer addSublayer:circle];
    return circle;
}

- (void)createConstraintsWithCircleMenu:(SLCircleMenu *)circleMenu andRadius:(CGFloat)radius {
//    UIView *circleMenuSuperView = circleMenu.superview;
    if (!circleMenu.superview) {
        return;
    }
    
    self.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1 constant:radius * 2.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1 constant:radius * 2.0]];
    [circleMenu.superview addConstraint:[NSLayoutConstraint constraintWithItem:circleMenu attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [circleMenu.superview addConstraint:[NSLayoutConstraint constraintWithItem:circleMenu attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
}

- (void)createRoundViewWithRect:(CGRect)rect andColor:(UIColor *)color {
    UIView *roundView = [[UIView alloc] initWithFrame:rect];
    roundView.backgroundColor = [UIColor blackColor];
    roundView.layer.cornerRadius = rect.size.width / 2.0;
    roundView.backgroundColor = color;
    [self addSubview:roundView];
}

- (void)fillAnimationWithDuration:(double)duration andStartAngle:(double)angle {
    if (!_circle) {
        return;
    }
    
    CATransform3D rotateTransform = CATransform3DMakeRotation(angle * M_PI / 180.0, 0, 0, 1);
    self.layer.transform = rotateTransform;
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.duration = duration;
    animation.fromValue = @0;
    animation.toValue = @1;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [_circle addAnimation:animation forKey:nil];
}

- (void)hideAnimationWithDuration:(double)duration andDelay:(double)delay {
    CABasicAnimation *scale = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scale.toValue = @1.2;
    scale.duration = duration;
    scale.fillMode = kCAFillModeForwards;
    scale.removedOnCompletion = NO;
    scale.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    scale.beginTime = CACurrentMediaTime() + delay;
    [self.layer addAnimation:scale forKey:nil];
    
    [UIView animateWithDuration:duration delay:delay options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
