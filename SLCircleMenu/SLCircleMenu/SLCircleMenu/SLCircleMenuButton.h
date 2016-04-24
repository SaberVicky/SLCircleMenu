//
//  SLCircleMenuButton.h
//  Saber Tool
//
//  Created by songlong on 16/4/24.
//  Copyright © 2016年 songlong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SLCircleMenu;

@interface SLCircleMenuButton : UIButton

@property (nonatomic, strong) UIView *container;
- (void)rotatedZWithAngle:(double)angle animated:(BOOL)animated duration:(double)duration delay:(double)delay;
- (void)showAnimationWithDistance:(double)distance duration:(double)duration andDelay:(double)delay;
- (void)hideAnimationWithDistance:(double)distance duration:(double)duration andDelay:(double)delay;
- (void)rotationLayerAnimationWithAngle:(double)angle andDuration:(double)duration;
- (instancetype)initWithSize:(CGSize)size circleMenu:(SLCircleMenu *)circleMenu distance:(CGFloat)distance angle:(double)angle;

- (void)changeDistance:(CGFloat)distance andAnimated:(BOOL)animated duration:(double)duration andDelay:(double)delay;
@end
