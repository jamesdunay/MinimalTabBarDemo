//
//  MinimalTab.h
//  MinimalTabBar
//
//  Created by james.dunay on 12/7/14.
//  Copyright (c) 2014 James.Dunay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MinimalSection : NSObject
-(id)initWithViewController:(UIViewController*)viewController tabImage:(UIImage*)image andTitle:(NSString*)title;

@property(nonatomic, strong)UIViewController* viewController;
@property(nonatomic, strong)UIImage* image;
@property(nonatomic, strong)NSString* title;
@property(nonatomic) NSUInteger index;

@end
