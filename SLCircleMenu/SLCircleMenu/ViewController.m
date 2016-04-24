//
//  ViewController.m
//  SLCircleMenu
//
//  Created by songlong on 16/4/24.
//  Copyright © 2016年 songlong. All rights reserved.
//

#import "ViewController.h"
#import "SLCircleMenu.h"

@interface ViewController ()<SLCircleMenuDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    SLCircleMenu *menuButton = [[SLCircleMenu alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width / 2 - 50 / 2, [UIScreen mainScreen].bounds.size.height / 2 - 50 / 2, 50, 50) imageName:@"icon_menu" selectedImageName:@"icon_close" buttonCount:5 duration:2 distance:120];
    menuButton.backgroundColor = [UIColor lightGrayColor];
    menuButton.delegate = self;
    menuButton.layer.cornerRadius = menuButton.frame.size.width / 2.0;
    [self.view addSubview:menuButton];
}


#pragma  mark - SLCircleMenuDelegate

- (void)circleMenu:(SLCircleMenu *)circleMenu willDisplayButton:(SLCircleMenuButton *)button atIndex:(NSInteger)index {
    
    NSArray *imageArray = @[@"icon_home", @"icon_search", @"notifications-btn", @"settings-btn", @"nearby-btn"];
    NSArray *colorArray = @[
            [[UIColor alloc] initWithRed:0.19 green:0.57 blue:1 alpha:1],
            [[UIColor alloc] initWithRed:0.22 green:0.74 blue:0 alpha:1],
            [[UIColor alloc] initWithRed:0.96 green:0.23 blue:0.21 alpha:1],
            [[UIColor alloc] initWithRed:0.51 green:0.15 blue:1 alpha:1],
            [[UIColor alloc] initWithRed:1 green:0.39 blue:0 alpha:1]
                            ];
    
    button.backgroundColor = colorArray[index];
    [button setImage:[UIImage imageNamed:imageArray[index]] forState:UIControlStateNormal];
}

- (void)circleMenu:(SLCircleMenu *)circleMenu buttonWillSelected:(SLCircleMenuButton *)button atIndex:(NSInteger)index {
    NSLog(@"button will selected: %zd", index);
}

- (void)circleMenu:(SLCircleMenu *)circleMenu buttonDidSelected:(SLCircleMenuButton *)button atIndex:(NSInteger)index {
    NSLog(@"button did selected: %zd", index);
}


@end
