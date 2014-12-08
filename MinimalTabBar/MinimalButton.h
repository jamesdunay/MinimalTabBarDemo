//
//  MinimalButton.h
//  MinimalTabBar
//
//  Created by james.dunay on 12/7/14.
//  Copyright (c) 2014 James.Dunay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MinimalSection.h"

typedef enum : NSUInteger {
    ButtonStateDisplayedInactive = (1 << 0),
    ButtonStateSelected = (1 << 1),
    ButtonStateDisplayedActive = (1 << 2)
} ButtonState;

@interface MinimalButton : UIButton
@property (nonatomic) UILabel* title;
@property (nonatomic) ButtonState buttonState;

-(id)initWithButtonWithSection:(MinimalSection*)section;

@end