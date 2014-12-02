//
//  MinimalBar.h
//  MinimalTabBar
//
//  Created by james.dunay on 11/19/14.
//  Copyright (c) 2014 James.Dunay. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MinimalBarDelegate <NSObject>
-(void)didSwitchToIndex:(NSUInteger)pageIndex;
-(void)fadeToIndex:(NSUInteger)pageIndex;
-(void)manualOffsetScrollview:(CGFloat)offset;
-(void)darkenScreen;
-(void)lightenScreen;
-(void)displayAllScreensWithStartingDisplayOn:(CGFloat)startingPosition;
@end

@interface MinimalBar : UIView <UIGestureRecognizerDelegate>

@property(nonatomic) id <MinimalBarDelegate> mMinimalBarDelegate;
@property(nonatomic) CGFloat displayOverviewYCoord;
@property(nonatomic) CGFloat screenHeight;
@property(nonatomic) CGSize defaultFrameSize;

-(void)scrollOverviewButtonsWithPercentage:(CGFloat)offsetPercentage;
-(void)returnMenuToSelected:(NSUInteger)index;
-(void)defaultToShopPressed;

- (void)createMenuItems:(NSArray*)viewControllers;

@end