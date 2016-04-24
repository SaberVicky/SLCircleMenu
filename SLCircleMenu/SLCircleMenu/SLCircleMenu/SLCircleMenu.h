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

@optional
//子按钮出现前，可以设置图片和颜色之类
- (void)circleMenu:(SLCircleMenu *)circleMenu willDisplayButton:(SLCircleMenuButton *)button atIndex:(NSInteger)index;
//子按钮刚被点击的时候
- (void)circleMenu:(SLCircleMenu *)circleMenu buttonWillSelected:(SLCircleMenuButton *)button atIndex:(NSInteger)index;
//子按钮点击动画完成
- (void)circleMenu:(SLCircleMenu *)circleMenu buttonDidSelected:(SLCircleMenuButton *)button atIndex:(NSInteger)index;

@end

@interface SLCircleMenu : UIButton

/*
imageName           : Normal状态图片名字
selectedImageName   : Selected状态图片名字
buttonCount         : 子按钮数量
duration            : 动画时长
distance            : 子按钮距离中心按钮的距离
*/
- (instancetype)initWithFrame:(CGRect)frame imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName buttonCount:(NSInteger)buttonCount duration:(double)duration distance:(CGFloat)distance;

@property (nonatomic, weak) id<SLCircleMenuDelegate> delegate;

@end
