//
//  UIMinimalBarController.m
//  MinimalTabBar
//
//  Created by james.dunay on 11/19/14.
//  Copyright (c) 2014 James.Dunay. All rights reserved.
//

#import "UIMinimalBarController.h"


static CGFloat minimalBarHeight = 70.f;

@interface UIMinimalBarController ()

@property (nonatomic, strong) UIScrollView* scrollView;

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
    
    CATransform3D theTransform = self.view.layer.sublayerTransform;
    theTransform.m34 = 1.0 / -500;
    self.view.layer.sublayerTransform = theTransform;
}

-(void)setupViews{
 
    _minimalBar = [[MinimalBar alloc] init];
    _viewControllers = [[NSArray alloc] init];
    _scrollView = [[UIScrollView alloc] init];
    
    [self defaultScrollViewSetup];
    
    [_scrollView setPagingEnabled:YES];
    [_scrollView setDelegate:self];
    [_scrollView setClipsToBounds:NO];
    [_scrollView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:_scrollView];
    
    _minimalBar.mMinimalBarDelegate = self;
    _minimalBar.displayOverviewYCoord = self.view.frame.size.height - (self.view.frame.size.height/overviewScreenDimensionMultiplyer) + 64;
    _minimalBar.screenHeight = self.view.frame.size.height;
    _minimalBar.defaultFrameSize = CGSizeMake(self.view.frame.size.width, 70);
    _minimalBar.translatesAutoresizingMaskIntoConstraints = NO;
    _minimalBar.backgroundColor = [UIColor blueColor];
    [self.view addSubview:_minimalBar];

    [self.view addConstraints:[self defaultConstraints]];
    
}


-(NSArray*)defaultConstraints{
    
    NSMutableArray* constraints = [[NSMutableArray alloc] init];
    
    [constraints addObjectsFromArray:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_scrollView]|"
                                          options:0
                                          metrics:0
                                            views:NSDictionaryOfVariableBindings(_scrollView)]];

    [constraints addObjectsFromArray:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_scrollView]|"
                                          options:0
                                          metrics:0
                                            views:NSDictionaryOfVariableBindings(_scrollView)]];

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

#pragma Mark Setup Methods

-(void)defaultScrollViewSetup{
//    [_scrollView setUserInteractionEnabled:NO];
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
        [self.scrollView addSubview:viewController.view];
    }];
    
    [self.view addConstraints:[self defaultConstraints]];
    [_minimalBar createMenuItems:_viewControllers];
}

@end