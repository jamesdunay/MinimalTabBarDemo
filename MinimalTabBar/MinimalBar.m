//
//  MinimalBar.m
//  MinimalTabBar
//
//  Created by james.dunay on 11/19/14.
//  Copyright (c) 2014 James.Dunay. All rights reserved.
//

#import "MinimalBar.h"
#import <QuartzCore/QuartzCore.h>

@interface MinimalBarButton : UIButton
typedef enum : NSUInteger {
    ButtonStateDisplayed = (1 << 0),
    ButtonStateSelected = (1 << 1),
} ButtonState;
@property (nonatomic) int rowPosition;
@property(nonatomic) ButtonState buttonState;
@end

@implementation MinimalBarButton
@end


@interface MinimalBar()


@property(nonatomic) CGFloat firstX;
@property(nonatomic) CGFloat firstY;

@property(nonatomic) CGFloat lastXOffset;

@property (nonatomic, strong)NSMutableArray* buttons;
@property (nonatomic, strong)NSMutableArray* adjustableButtonConstaints;
@property (nonatomic, strong)NSArray* colors;

@property(nonatomic, strong) NSLayoutConstraint *constraintOne;
@property(nonatomic, strong) NSLayoutConstraint *constraintTwo;
@property(nonatomic, strong) NSLayoutConstraint *constraintThree;
@property(nonatomic, strong) NSLayoutConstraint *constraintFour;
@property(nonatomic, strong) NSLayoutConstraint *constraintFive;
@property(nonatomic, strong) NSLayoutConstraint *bottomPosition;

@property(nonatomic) BOOL isDisplayingAll;




@end

@implementation MinimalBar

typedef enum : NSUInteger {
    MenuStateDefault = (1 << 0),
    MenuStateDisplayed = (1 << 1),
    MenuStateFullyOpened = (1 << 2),
} MenuState;


-(id)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}

//- (id)initWithFrame:(CGRect)frame{
//    self = [super initWithFrame:frame];
//    if (self) {
//
//    }
//    return self;
//}


-(void)layoutSubviews{
    [super layoutSubviews];
    [self addConstraints:[self defaultConstraints]];    
}

-(NSArray*)defaultConstraints{
    NSMutableArray* constraints = [[NSMutableArray alloc] init];
    
    [self.buttons enumerateObjectsUsingBlock:^(MinimalBarButton *mbButton, NSUInteger idx, BOOL *stop) {
        [constraints addObject:[NSLayoutConstraint constraintWithItem:mbButton
                                                            attribute:NSLayoutAttributeWidth
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:nil
                                                            attribute:NSLayoutAttributeNotAnAttribute
                                                           multiplier:1.f
                                                             constant:self.frame.size.width/self.numberOfViews]];
        
        [constraints addObject:[NSLayoutConstraint constraintWithItem:mbButton
                                                            attribute:NSLayoutAttributeTop
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self
                                                            attribute:NSLayoutAttributeTop
                                                           multiplier:1.f
                                                             constant:0]];
        
        [constraints addObject:[NSLayoutConstraint constraintWithItem:mbButton
                                                            attribute:NSLayoutAttributeBottom
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self
                                                            attribute:NSLayoutAttributeBottom
                                                           multiplier:1.f
                                                             constant:0]];
        
    }];
    
    
    if (!self.adjustableButtonConstaints) {
        self.adjustableButtonConstaints = [[NSMutableArray alloc] init];
        
        [self.buttons enumerateObjectsUsingBlock:^(MinimalBarButton *mbButton, NSUInteger idx, BOOL *stop) {
            NSLayoutConstraint* adjustableConstraint = [NSLayoutConstraint constraintWithItem:self.buttons[idx]
                                                                                    attribute:NSLayoutAttributeLeft
                                                                                    relatedBy:NSLayoutRelationEqual
                                                                                       toItem:self
                                                                                    attribute:NSLayoutAttributeLeft
                                                                                   multiplier:1.f
                                                                                     constant:(self.frame.size.width/self.numberOfViews)*idx];
            [self.adjustableButtonConstaints addObject:adjustableConstraint];
        }];
        
        [constraints addObjectsFromArray:self.adjustableButtonConstaints];
    }
    
    return [constraints copy];
}

- (void)createMenuItems:(NSArray*)viewControllers{
    
    self.buttons = [[NSMutableArray alloc] init];
    
    [viewControllers enumerateObjectsUsingBlock:^(UIViewController* viewController, NSUInteger idx, BOOL *stop) {
        MinimalBarButton* mbButton = [MinimalBarButton buttonWithType:UIButtonTypeCustom];
        [mbButton setTranslatesAutoresizingMaskIntoConstraints:NO];
        mbButton.tag = viewController.view.tag;
        mbButton.buttonState = ButtonStateDisplayed;
        [mbButton setTitle:[NSString stringWithFormat:@"%ld", idx] forState:UIControlStateSelected];
        [[mbButton imageView] setContentMode:UIViewContentModeScaleAspectFit];
        [mbButton setImage:nil forState:UIControlStateNormal];
        [mbButton setSelected:YES];
        
        [mbButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchedTab:)];
        UIPanGestureRecognizer* pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panSelectedButton:)];
        pan.delegate = self;
        
        UILongPressGestureRecognizer* longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(touchAndHold:)];
        
        [mbButton addGestureRecognizer:tap];
        [mbButton addGestureRecognizer:pan];
        [mbButton addGestureRecognizer:longPress];
        
        mbButton.backgroundColor = [UIColor whiteColor];
        [self.buttons addObject:mbButton];
        [self addSubview:mbButton];
    }];
}

// TO DO figure out default toggle mode
-(void)defaultToShopPressed{
    [self.buttons[0] setButtonState:ButtonStateSelected];
    [self collapseAllButtons];
    [self.mMinimalBarDelegate changeToPageIndex:[self.buttons[0] tag]];
}

- (void)touchedTab:(id)sender {
    if (!self.isDisplayingAll) {
        MinimalBarButton* mbButton = (MinimalBarButton*)[sender view];
        
        switch ([mbButton buttonState]) {
            case ButtonStateDisplayed:
                [mbButton setButtonState:ButtonStateSelected];
                [self collapseAllButtons];
                [self.mMinimalBarDelegate changeToPageIndex:mbButton.tag];
                break;
                
            case ButtonStateSelected:
                [self displayAllButtons];
                break;
                
            default:
                break;
        }
    }
}

- (void)collapseAllButtons{
    
    [self shouldEnablePanGestures:YES];
    void (^alphaAnimation)() = ^{
        [self hideNonSelectedMenuItems];
    };
    
    [self.buttons enumerateObjectsUsingBlock:^(MinimalBarButton *mbButton, NSUInteger idx, BOOL *stop) {
        [mbButton setImage:[UIImage imageNamed:@"menu_icon"] forState:UIControlStateNormal];
        [mbButton setSelected:NO];
    }];
    
    
    CGFloat mbButtonWidth = self.frame.size.width/self.buttons.count;
    
    void (^animations)(void) = ^{
        
        [self.adjustableButtonConstaints enumerateObjectsUsingBlock:^(NSLayoutConstraint* constraint, NSUInteger idx, BOOL *stop) {
            constraint.constant = mbButtonWidth * (self.adjustableButtonConstaints.count/2);
        }];
        
        [self layoutIfNeeded];
    };
    
    [UIView animateWithDuration:.65f
                          delay:0.f
         usingSpringWithDamping:.85
          initialSpringVelocity:12
                        options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction
                     animations:animations
                     completion:^(BOOL finished) {
                         
                     }];
    
    [UIView animateWithDuration:0.10
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:alphaAnimation
                     completion:^(BOOL finished){}
     ];
}

- (void)displayAllButtons{
    [self shouldEnablePanGestures:NO];
    void (^alphaAnimations)(void) = ^{
        [self showAllButtons];
    };
    
    void (^movementAnimations)(void) = ^{
        [self.adjustableButtonConstaints enumerateObjectsUsingBlock:^(NSLayoutConstraint* constraint, NSUInteger idx, BOOL *stop) {
            constraint.constant = self.frame.size.width/self.adjustableButtonConstaints.count * idx;
        }];
        
        self.frame = CGRectMake(0, (self.screenHeight-self.defaultFrameSize.height), self.defaultFrameSize.width, self.defaultFrameSize.height);
        [self layoutIfNeeded];
    };
    
    [UIView animateWithDuration:.5f
                          delay:0.f
         usingSpringWithDamping:50.f
          initialSpringVelocity:15.f
                        options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction
                     animations:movementAnimations
                     completion:^(BOOL finished) {}];
    
    [UIView animateWithDuration:.3f
                          delay:.1f
                        options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionAllowUserInteraction
                     animations:alphaAnimations
                     completion:^(BOOL finished) {}];
}



#pragma Mark Pan Methods

-(void)panSelectedButton:(UIPanGestureRecognizer *)gesture{
    CGPoint translatedPoint = [gesture translationInView:self];
    if ([gesture state] == UIGestureRecognizerStateBegan) {
        self.firstX = [[gesture view] center].x;
        self.firstY = [[gesture view] center].y;
    }
    
    //Matching swipe with scrollview
    [self.mMinimalBarDelegate manualOffsetScrollview:(self.lastXOffset - translatedPoint.x)];
    self.lastXOffset = translatedPoint.x;
    
    //Reset View center to match finger swiping
    translatedPoint = CGPointMake(self.firstX + translatedPoint.x, self.firstY);
    [[gesture view] setCenter:translatedPoint];
    
    if ([gesture state] == UIGestureRecognizerStateEnded) {
        CGPoint endingLocation = [gesture translationInView:self];
        if (endingLocation.x <= -50) {
            [self switchToPageNext:YES];
        }else if (endingLocation.x >= 50) {
            [self switchToPageNext:NO];
        }else{
            [self returnScrollViewToSelectedTab];
        }
        
        CGFloat velocityX = (0.2*[gesture velocityInView:self].x);
        CGFloat animationDuration = (ABS(velocityX)*.0002)+.2;
        void (^animations)(void) = ^{
            [[gesture view] setCenter:CGPointMake(self.firstX, self.firstY)];
        };
        
        [UIView animateWithDuration:animationDuration animations:animations completion:nil];
        
        self.lastXOffset = 0;
    }
}

-(void)switchToPageNext:(BOOL)next{
    
    NSInteger indextAdjustment = next ? next : -1;
    NSInteger activeIndex = [self indexOfActiveButton];
    NSInteger targetedIndex = activeIndex + indextAdjustment;
    
    if (targetedIndex >= 0 && targetedIndex < self.buttons.count) {
        
        MinimalBarButton* activeButton = self.buttons[activeIndex];
        MinimalBarButton* nextButton = self.buttons[activeIndex+indextAdjustment];
        
        nextButton.backgroundColor = [UIColor whiteColor];
        activeButton.backgroundColor = [UIColor clearColor];
        
        [activeButton setButtonState:ButtonStateDisplayed];
        [nextButton setButtonState:ButtonStateSelected];
        
        [self bringSubviewToFront:nextButton];
        void (^animations)(void) = ^{
            [self.adjustableButtonConstaints enumerateObjectsUsingBlock:^(NSLayoutConstraint *constraint, NSUInteger idx, BOOL *stop) {
                if ([(MinimalBarButton*)constraint.firstItem isEqual:self.buttons[[self indexOfActiveButton]]]) {
                    constraint.constant = self.frame.size.width/5 * 2;
                }
            }];
            activeButton.alpha = 0;
            nextButton.alpha = 1;
        };
        
        [UIView animateWithDuration:.2 animations:animations completion:nil];
        
        [self.mMinimalBarDelegate didSwitchToIndex:nextButton.tag];
    }
}

-(void)returnScrollViewToSelectedTab{
    NSInteger activeIndex = [self indexOfActiveButton];
    [self.mMinimalBarDelegate sendScrollViewToPoint:CGPointMake(activeIndex * self.frame.size.width, 0)];
}


-(void)showAllButtons{
    [self.buttons enumerateObjectsUsingBlock:^(MinimalBarButton* mbButton, NSUInteger idx, BOOL *stop) {
        mbButton.buttonState = ButtonStateDisplayed;
        mbButton.backgroundColor = [UIColor whiteColor];
        mbButton.alpha = 1.f;
        
        [mbButton setImage:nil forState:UIControlStateNormal];
        [mbButton setSelected:YES];
    }];
}

-(void)hideNonSelectedMenuItems{
    [self.buttons enumerateObjectsUsingBlock:^(MinimalBarButton* mbButton, NSUInteger idx, BOOL *stop) {
        if (mbButton.buttonState != ButtonStateSelected) {
            mbButton.alpha = 0.f;
            mbButton.backgroundColor = [UIColor clearColor];
        }
    }];
}

-(void)shouldEnablePanGestures:(BOOL)enable{
    [self.buttons enumerateObjectsUsingBlock:^(MinimalBarButton* mbButton, NSUInteger idx, BOOL *stop) {
        [mbButton.gestureRecognizers enumerateObjectsUsingBlock:^(UIGestureRecognizer* gesture, NSUInteger idx, BOOL *stop) {
            if ([gesture isKindOfClass:[UIPanGestureRecognizer class]]) {
                gesture.enabled = enable;
            }
        }];
    }];
}

-(NSUInteger)indexOfActiveButton{
    //Needs Polish
    __block NSUInteger index = 0;
    [self.buttons enumerateObjectsUsingBlock:^(MinimalBarButton* mbButton, NSUInteger idx, BOOL *stop) {
        if (mbButton.buttonState == ButtonStateSelected) {
            index = idx;
        }
    }];
    
    return index;
}

- (CGFloat)screenDivisionSize{
    return self.frame.size.width/12;
}

-(void)selectedButtonAtIndex:(NSInteger)index{
    [self.buttons[index] setButtonState:ButtonStateSelected];
    [self bringSubviewToFront:self.buttons[index]];
}

#pragma Mark Touch And Hold

- (void) touchAndHold:(UIGestureRecognizer*)longPressGesture{
    if (!self.isDisplayingAll) {
        [self.mMinimalBarDelegate displayAllScreensWithStartingDisplayOn:[self indexOfActiveButton]];
        [self positionAllButtonsForOverView];
        self.isDisplayingAll = YES;
    }
}


- (void)positionAllButtonsForOverView{
    
    [self shouldEnablePanGestures:NO];
    
    CGFloat spacingMultiplyer = ([self indexOfActiveButton] * 10);
    CGFloat defaultPosition = (self.frame.size.width - (self.frame.size.width/5))/2;
    CGFloat buttonOffset = [self indexOfActiveButton] * (self.frame.size.width/5);
    
    CGFloat xPosToScrollButtonsTo = defaultPosition - spacingMultiplyer - buttonOffset;
    
    CGFloat squareButtonDimension = self.frame.size.width/5.f;
    CGFloat heightUnderScreens = self.screenHeight - self.displayOverviewYCoord;
    
    
    
    void (^animations)(void) = ^{};
    animations = ^{
        [self showAllButtonsInOverviewMode];
        [self.adjustableButtonConstaints enumerateObjectsUsingBlock:^(NSLayoutConstraint* constraint, NSUInteger idx, BOOL *stop) {
            constraint.constant = (self.frame.size.width/self.adjustableButtonConstaints.count * idx) + (idx * 10);
        }];
        
        self.frame = CGRectMake(xPosToScrollButtonsTo, self.displayOverviewYCoord + ((heightUnderScreens - squareButtonDimension)/2), self.frame.size.width, squareButtonDimension);
        [self layoutIfNeeded];
    };
    
    [UIView animateWithDuration:.25f
                          delay:0.f
         usingSpringWithDamping:.98
          initialSpringVelocity:11
                        options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction
                     animations:animations
                     completion:^(BOOL finished) {
                         
                     }];
}

-(void)returnMenuToSelected:(NSUInteger)index{
    _isDisplayingAll = NO;
    
    [self selectedButtonAtIndex:index];
    [self collapseAllButtons];
}

-(void)showAllButtonsInOverviewMode{
    [self.buttons enumerateObjectsUsingBlock:^(MinimalBarButton* mbButton, NSUInteger idx, BOOL *stop) {
        mbButton.buttonState = ButtonStateDisplayed;
        mbButton.backgroundColor = [UIColor whiteColor];
        mbButton.alpha = 1.f;
        [mbButton setImage:nil forState:UIControlStateNormal];
        [mbButton setSelected:YES];
    }];
}

-(void)scrollOverviewButtonsWithPercentage:(CGFloat)offsetPercentage{
    
    if (self.isDisplayingAll) {
        CGFloat squareButtonDimension = self.frame.size.width/self.buttons.count;
        CGFloat defaultPosition = (self.frame.size.width - squareButtonDimension)/2;
        CGFloat offsetAmount = offsetPercentage * (squareButtonDimension + 10);
        
        self.frame = CGRectMake(defaultPosition - offsetAmount, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
    }
}

-(NSUInteger)numberOfViews{
    return [self.buttons count];
}

@end
