//
//  SLCircleMenuLoader.h
//  Saber Tool
//
//  Created by songlong on 16/4/24.
//  Copyright © 2016年 songlong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SLCircleMenu;

@interface SLCircleMenuLoader : UIView

- (instancetype)initWithRadius:(CGFloat)radius strokeWidth:(CGFloat)strokeWidth circleMenu:(SLCircleMenu *)circleMenu color:(UIColor *)color;

- (void)fillAnimationWithDuration:(double)duration andStartAngle:(double)angle;
- (void)hideAnimationWithDuration:(double)duration andDelay:(double)delay;
@end
