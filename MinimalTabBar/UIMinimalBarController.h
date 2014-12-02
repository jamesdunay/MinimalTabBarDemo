//
//  UIMinimalBarController.h
//  MinimalTabBar
//
//  Created by james.dunay on 11/19/14.
//  Copyright (c) 2014 James.Dunay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MinimalBar.h"

@interface UIMinimalBarController : UIViewController <MinimalBarDelegate, UIScrollViewDelegate>

@property(nonatomic, strong) NSArray * viewControllers;
@property(nonatomic, strong) MinimalBar * minimalBar;

- (void)setViewControllers:( NSArray * )viewControllers;

@end