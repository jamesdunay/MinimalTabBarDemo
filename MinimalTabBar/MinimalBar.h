//
//  MinimalBar.h
//  MinimalTabBar
//
//  Created by james.dunay on 11/19/14.
//  Copyright (c) 2014 James.Dunay. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MinimalBarDelegate <NSObject>

- (void)didSwitchToIndex:(NSUInteger)pageIndex;
- (void)changeToPageIndex:(NSUInteger)pageIndex;
- (void)manualOffsetScrollview:(CGFloat)offset;
- (void)displayAllScreensWithStartingDisplayOn:(CGFloat)startingPosition;
- (void)sendScrollViewToPoint:(CGPoint)point;

@end



@interface MinimalBar : UIView <UIGestureRecognizerDelegate>

@property (nonatomic) id <MinimalBarDelegate> mMinimalBarDelegate;
@property (nonatomic) CGFloat displayOverviewYCoord;
@property (nonatomic) CGFloat screenHeight;
@property (nonatomic) CGSize defaultFrameSize;
@property (nonatomic, strong) UIColor* defaultTintColor;
@property (nonatomic, strong) UIColor* selectedTintColor;
@property (nonatomic) BOOL showTitles;

- (void)scrollOverviewButtonsWithPercentage:(CGFloat)offsetPercentage;
- (void)returnMenuToSelected:(NSUInteger)index;
- (void)createMenuItems:(NSArray *)viewControllers;


@end
