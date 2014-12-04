//
//  UIMinimalBarController.m
//  MinimalTabBar
//
//  Created by james.dunay on 11/19/14.
//  Copyright (c) 2014 James.Dunay. All rights reserved.
//

#import "UIMinimalBarController.h"
#import "UIViewHitTestOverride.h"
#import <QuartzCore/QuartzCore.h>

static CGFloat minimalBarHeight = 70.f;

@interface UIMinimalBarController ()

@property (nonatomic, strong) UIScrollView* scrollView;
@property (nonatomic, strong) UIView* touchableViewCover;
@property (nonatomic, strong) UIViewHitTestOverride* coverView;
@property (nonatomic) CGAffineTransform viewControllertransform;

@end

static CGFloat overviewScreenDimensionMultiplyer = 3.5f;

@implementation UIMinimalBarController

-(id)init{
    self = [super init];
    if (self) {
    }
    return self;
}


-(void)viewDidLoad{

    [self setupViews];
}

-(void)setupViews{
 
    _minimalBar = [[MinimalBar alloc] init];
    _viewControllers = [[NSArray alloc] init];
    _scrollView = [[UIScrollView alloc] init];
    
    [self defaultScrollViewSetup];
    
    _coverView = [[UIViewHitTestOverride alloc] init];
    _coverView.translatesAutoresizingMaskIntoConstraints = NO;
    _coverView.scrollView = _scrollView;
    [self.view addSubview:_coverView];
    
    [_scrollView setPagingEnabled:YES];
    [_scrollView setDelegate:self];
    [_scrollView setClipsToBounds:NO];
    [_scrollView setAutoresizesSubviews:NO];
    [self defaultScrollViewSetup];
//    [_scrollView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_scrollView setFrame:self.view.frame];
    [_coverView addSubview:_scrollView];
    
    _minimalBar.mMinimalBarDelegate = self;
    _minimalBar.displayOverviewYCoord = self.view.frame.size.height - (self.view.frame.size.height/overviewScreenDimensionMultiplyer) + 64;
    _minimalBar.screenHeight = self.view.frame.size.height;
    _minimalBar.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_minimalBar];
    
    self.touchableViewCover = [[UIView alloc] init];

    [self.view addConstraints:[self defaultConstraints]];
}

-(void)viewDidAppear:(BOOL)animated{

}

-(NSArray*)defaultConstraints{
    
    NSMutableArray* constraints = [[NSMutableArray alloc] init];
    
    [constraints addObjectsFromArray:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_coverView]|"
                                          options:0
                                          metrics:0
                                            views:NSDictionaryOfVariableBindings(_coverView)]];

    [constraints addObjectsFromArray:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_coverView]|"
                                          options:0
                                          metrics:0
                                            views:NSDictionaryOfVariableBindings(_coverView)]];

    [constraints addObjectsFromArray:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_minimalBar]|"
                                             options:0
                                             metrics:0
                                               views:NSDictionaryOfVariableBindings(_minimalBar)
                                      ]];


    [constraints addObject:[NSLayoutConstraint constraintWithItem:_minimalBar
                                                        attribute:NSLayoutAttributeTop
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self.view
                                                        attribute:NSLayoutAttributeTop
                                                       multiplier:1
                                                         constant:self.view.frame.size.height - minimalBarHeight
                            ]];
    
    [constraints addObject:[NSLayoutConstraint constraintWithItem:_minimalBar
                                                        attribute:NSLayoutAttributeBottom
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self.view
                                                        attribute:NSLayoutAttributeBottom
                                                       multiplier:1
                                                         constant:0.f
                            ]];
    
    return [constraints copy];
}

#pragma Mark Delegate Methods

#pragma Mark Tapped Delegates
-(void)fadeToIndex:(NSUInteger)pageIndex{


    CGFloat xPoint = pageIndex * self.view.frame.size.width;
    [self.scrollView setContentOffset:CGPointMake(xPoint, 0)];

//    ToDo
//    [UIView animateWithDuration:.1f animations:^{
//        [self.scrollView setAlpha:0.f];
//    } completion:^(BOOL finished){
//
//        
//        [UIView animateWithDuration:.2f animations:^{
//            [self.scrollView setAlpha:1.f];
//        }];
//    }];
}

#pragma Mark Pan Delegates

-(void)manualOffsetScrollview:(CGFloat)offset{
    CGPoint newOffset = CGPointMake(self.scrollView.contentOffset.x + offset, 0);
    if (newOffset.x >= 0 && newOffset.x <= self.scrollView.contentSize.width) {
        self.scrollView.contentOffset = newOffset;
    }
}

-(void)sendScrollViewToPoint:(CGPoint)point{
    [self.scrollView setContentOffset:point animated:YES];
}

-(void)didSwitchToIndex:(NSUInteger)pageIndex{
    CGFloat xPoint = pageIndex*320;
    [UIView animateWithDuration:.2f animations:^{
        [self.scrollView setContentOffset:CGPointMake(xPoint, 0)];
    }];
}

#pragma Mark Global UI Adjustments
/*
-(void)darkenScreen{
    [UIView animateWithDuration:.2
                          delay:.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         [self.screenShadow setAlpha:.1];
                     } completion:nil];
}

-(void)lightenScreen{
    [UIView animateWithDuration:.4
                          delay:.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         [self.screenShadow setAlpha:0];
                     } completion:nil];
}
*/

#pragma Display/Overview Methods

#pragma Mark Touch-n-Hold Delegate

-(void)displayAllScreensWithStartingDisplayOn:(CGFloat)startingPosition{
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [self sendViewsToBackPosition:YES];
    
    [_scrollView setUserInteractionEnabled:YES];
    
//    self.scrollView.contentSize = CGSizeMake(self.scrollView.contentSize.width), self.scrollView.contentSize.height);
    
    [self.scrollView.subviews enumerateObjectsUsingBlock:^(UIView* view, NSUInteger idx, BOOL *stop) {
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectedView:)];
        [view addGestureRecognizer:tap];
        
        view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, view.frame.size.height);
    }];
    

    
    
    /*
    CGFloat widthReduction = (self.view.frame.size.width/overviewScreenDimensionMultiplyer);
    CGFloat heightReduction = (self.view.frame.size.height/overviewScreenDimensionMultiplyer);
    
    CGSize reducedSize = CGSizeMake(self.view.frame.size.width - widthReduction, self.view.frame.size.height - heightReduction);
    
    [self.scrollView.subviews enumerateObjectsUsingBlock:^(UIView* view, NSUInteger idx, BOOL *stop) {
        
        view.clipsToBounds = YES;
        
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        animation.fromValue = [NSNumber numberWithFloat:0.0f];
        animation.toValue = [NSNumber numberWithFloat:8.0f];
        animation.duration = .17;
        [view.layer addAnimation:animation forKey:@"cornerRadius"];
        [view.layer setCornerRadius:8.0];
        
        CGFloat newXPos = (reducedSize.width + 10)  * idx + 5;
        
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectedView:)];
        [view addGestureRecognizer:tap];
        
        view.userInteractionEnabled = YES;
        
        void(^animations)(void) = ^{
            
            //            self.logout.alpha = 1;
            //            self.settings.alpha = 1;
            
            view.frame = CGRectMake(newXPos, 64, reducedSize.width, reducedSize.height);
            [view setNeedsUpdateConstraints];
            [self.scrollView setFrame:CGRectMake((widthReduction/2) - 5, 0, reducedSize.width + 10, self.scrollView.frame.size.height)];
            self.scrollView.contentOffset = CGPointMake(startingPosition * (reducedSize.width + 10), 0);
        };
        
        [UIView animateWithDuration:.25f
                              delay:0.f
             usingSpringWithDamping:.98
              initialSpringVelocity:11
                            options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction
                         animations:animations
                         completion:^(BOOL finished) {
                             
                         }];
    }];
    
    self.scrollView.contentSize = CGSizeMake((self.scrollView.subviews.count-2) * (reducedSize.width + 10), self.scrollView.contentSize.height);
    self.scrollView.userInteractionEnabled = YES;
     */
}

#pragma Mark End Delegate

-(void)selectedView:(UITapGestureRecognizer*)tap{
    
    [self sendViewsToBackPosition:NO];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    NSInteger selectedTag = [tap view].tag;
    [self.minimalBar returnMenuToSelected:selectedTag];
    
    [UIView animateWithDuration:.25f
                          delay:0.f
         usingSpringWithDamping:.98
          initialSpringVelocity:11
                        options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         [self defaultScrollViewSetup];
                         [self resetScrollViewSubviews];
                         self.scrollView.contentOffset = CGPointMake(self.view.frame.size.width * selectedTag, 0);
                     }
                     completion:nil];
}

-(void)resetScrollViewSubviews{
    [self.scrollView.subviews enumerateObjectsUsingBlock:^(UIImageView* view, NSUInteger idx, BOOL *stop) {
        
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        animation.fromValue = [NSNumber numberWithFloat:0.0f];
        animation.toValue = [NSNumber numberWithFloat:0.f];
        animation.duration = .17;
        [view.layer addAnimation:animation forKey:@"cornerRadius"];
        [view.layer setCornerRadius:0.f];
        
        view.userInteractionEnabled = NO;
        view.frame = CGRectMake(self.view.frame.size.width * idx, 0, self.view.frame.size.width, self.view.frame.size.height);
        
//        self.logout.alpha = 0;
//        self.settings.alpha = 0;
    }];
}

#pragma Mark ScrollView Depth Toggle
-(void)sendViewsToBackPosition:(BOOL)sendBack{
        
    void (^scrollViewAnimation)(void) = ^{
        CATransform3D transform = CATransform3DIdentity;
        transform.m34 = 1.0f / -500.f;
        CGFloat zPos = -400.f * (CGFloat)sendBack;
        transform = CATransform3DTranslate(transform, 0.f, 0.f, zPos);
        _scrollView.layer.transform = transform;
    };
    
    [UIView animateWithDuration:.2f animations:scrollViewAnimation];
//
    void (^viewControllerAnimation)(void) = ^{
        [_scrollView.subviews enumerateObjectsUsingBlock:^(UIView* view, NSUInteger idx, BOOL *stop) {
            CGFloat scaleAmount = sendBack ? .9f : 1.f;
            view.transform = CGAffineTransformScale(_viewControllertransform, scaleAmount, scaleAmount);
        }];
    };
    
    [UIView animateWithDuration:.2f animations:viewControllerAnimation];
}

#pragma ScrollView Delegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat contentOffSet = scrollView.contentOffset.x;
    [_minimalBar scrollOverviewButtonsWithPercentage:contentOffSet/_coverView.frame.size.width];
}

#pragma End Display/Overview Methods



#pragma Mark Setup Methods

-(void)defaultScrollViewSetup{
    [_scrollView setUserInteractionEnabled:NO];
}

-(void)setViewControllers:(NSArray *)viewControllers{
    _viewControllers = viewControllers;
    
    [_scrollView setContentSize:CGSizeMake(self.view.frame.size.width * _viewControllers.count, self.view.frame.size.height)];

    if (self.scrollView.subviews) {
        [self.scrollView.subviews enumerateObjectsUsingBlock:^(UIView* view, NSUInteger idx, BOOL *stop) {
            [view removeFromSuperview];
        }];
    }
    
    [_viewControllers enumerateObjectsUsingBlock:^(UIViewController* viewController, NSUInteger idx, BOOL *stop) {
        viewController.view.frame = CGRectMake(self.view.frame.size.width * idx, 0, self.view.frame.size.width, self.view.frame.size.height);
        viewController.view.tag = idx;
        _viewControllertransform = viewController.view.transform;
        [self.scrollView addSubview:viewController.view];
    }];
    
    [self.view addConstraints:[self defaultConstraints]];
    [_minimalBar createMenuItems:_viewControllers];
}

@end