//
//  MinimalTab.m
//  MinimalTabBar
//
//  Created by james.dunay on 12/7/14.
//  Copyright (c) 2014 James.Dunay. All rights reserved.
//

#import "MinimalSection.h"
@implementation MinimalSection

-(id)initWithViewController:(UIViewController*)viewController tabImage:(UIImage*)image andTitle:(NSString*)title{
    self = [super init];
    if (self) {
        self.title = title;
        self.image = image;
        self.viewController = viewController;
    }
    return self;
}

@end