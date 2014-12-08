//
//  AppDelegate.m
//  MinimalTabBar
//
//  Created by james.dunay on 11/19/14.
//  Copyright (c) 2014 James.Dunay. All rights reserved.
//

#import "AppDelegate.h"
#import "UIMinimalBarController.h"
#import "MinimalSection.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor blackColor];
    [self.window makeKeyAndVisible];
    
    UIMinimalBarController* minimalTabBarViewController = [[UIMinimalBarController alloc] init];
    
    UIImageView* sectionOneBackground = [[UIImageView alloc]initWithFrame:self.window.frame];
    [sectionOneBackground setImage:[UIImage imageNamed:@"mb_1"]];
    
    UIImageView* sectionTwoBackground = [[UIImageView alloc]initWithFrame:self.window.frame];
    [sectionTwoBackground setImage:[UIImage imageNamed:@"mb_2"]];
    
    UIViewController* sectionOneVC = [[UIViewController alloc] init];
    [sectionOneVC.view addSubview:sectionOneBackground];
    
    UIViewController* sectionTwoVC = [[UIViewController alloc] init];
    [sectionTwoVC.view addSubview:sectionTwoBackground];
    
    UIViewController* blueVC = [[UIViewController alloc] init];
    blueVC.view.backgroundColor = [UIColor blueColor];
    
    UIViewController* yellowVC = [[UIViewController alloc] init];
    yellowVC.view.backgroundColor = [UIColor yellowColor];
    
    UIViewController* orangeVC = [[UIViewController alloc] init];
    orangeVC.view.backgroundColor = [UIColor orangeColor];

    [self.window setRootViewController:minimalTabBarViewController];

    //Currently Broken with 2 sections
    MinimalSection* tabOne = [[MinimalSection alloc] initWithViewController:sectionOneVC tabImage:[UIImage imageNamed:@"icon_1"] andTitle:@"HOME"];
    MinimalSection* tabTwo = [[MinimalSection alloc] initWithViewController:sectionTwoVC tabImage:[UIImage imageNamed:@"icon_2"] andTitle:@"LOCATION"];
    MinimalSection* tabThree = [[MinimalSection alloc] initWithViewController:blueVC tabImage:[UIImage imageNamed:@"icon_3"] andTitle:@"SPEAK"];
    MinimalSection* tabFour = [[MinimalSection alloc] initWithViewController:yellowVC tabImage:[UIImage imageNamed:@"icon_4"] andTitle:@"LEVELS"];
    MinimalSection* tabFive = [[MinimalSection alloc] initWithViewController:orangeVC tabImage:[UIImage imageNamed:@"icon_5"] andTitle:@"SOUNDS"];
    minimalTabBarViewController.tintColor = [UIColor greenColor];
    [minimalTabBarViewController setSections:@[tabOne, tabTwo, tabThree, tabFour, tabFive]];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end