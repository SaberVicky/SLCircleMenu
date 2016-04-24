//
//  SLCircleMenu.h
//  Saber Tool
//
//  Created by songlong on 16/4/24.
//  Copyright © 2016年 songlong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SLCircleMenuButton.h"
@class SLCircleMenu;

@protocol SLCircleMenuDelegate <NSObject>

- (void)circleMenu:(SLCircleMenu *)circleMenu willDisplayButton:(SLCircleMenuButton *)button atIndex:(NSInteger)index;

- (void)circleMenu:(SLCircleMenu *)circleMenu buttonWillSelected:(SLCircleMenuButton *)button atIndex:(NSInteger)index;

- (void)circleMenu:(SLCircleMenu *)circleMenu buttonDidSelected:(SLCircleMenuButton *)button atIndex:(NSInteger)index;

@end

@interface SLCircleMenu : UIButton

- (instancetype)initWithFrame:(CGRect)frame imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName buttonCount:(NSInteger)buttonCount duration:(double)duration distance:(CGFloat)distance;

@property (nonatomic, weak) id<SLCircleMenuDelegate> delegate;

@end
