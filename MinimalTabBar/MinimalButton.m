//
//  MinimalButton.m
//  MinimalTabBar
//
//  Created by james.dunay on 12/7/14.
//  Copyright (c) 2014 James.Dunay. All rights reserved.
//

#import "MinimalButton.h"

@implementation MinimalButton

-(id)initWithButtonWithSection:(MinimalSection*)section{
    self = [super init];
    if (self) {

        self.tag = section.index;
        self.selected = YES;
        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.buttonState = ButtonStateDisplayedInactive;
        
        [[self imageView] setContentMode:UIViewContentModeScaleAspectFit];
        
        UIImage *image = [section.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];

        [self setImage:image forState:UIControlStateNormal];
        [self setImage:image forState:UIControlStateSelected];
        
        _title = [[UILabel alloc] init];
        _title.translatesAutoresizingMaskIntoConstraints = NO;
        _title.text = section.title;
        _title.font = [UIFont fontWithName:@"Avenir-Heavy" size:10.f];
        _title.textColor = [UIColor whiteColor];
        [_title sizeToFit];
        [self addSubview:_title];
        
        [self addConstraints:[self defaultConstraints]];
    }
    return self;
}


-(NSArray*)defaultConstraints{
    
    NSMutableArray* constraints = [[NSMutableArray alloc] init];
    
    [constraints addObject:[NSLayoutConstraint constraintWithItem:_title
                                                         attribute:NSLayoutAttributeBottom
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeBottom
                                                        multiplier:1.f
                                                          constant:-5]];
    
    [constraints addObject:[NSLayoutConstraint constraintWithItem:_title
                                                        attribute:NSLayoutAttributeCenterX
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeCenterX
                                                       multiplier:1.f
                                                         constant:0]];
    
    return [constraints copy];
}


-(void)setButtonState:(ButtonState)buttonState{
    
    _buttonState = buttonState;
    if (buttonState == ButtonStateDisplayedInactive) {
        _title.alpha = .3;
    }else{
        _title.alpha = 1;
    }
}

-(void)setTintColor:(UIColor *)tintColor{
    _title.textColor = tintColor;
    self.imageView.tintColor = tintColor;
}




@end
