//
//  AppDelegate.m
//  MinimalTabBar
//
//  Created by james.dunay on 11/19/14.
//  Copyright (c) 2014 James.Dunay. All rights reserved.
//

#import "AppDelegate.h"
#import "JDMinimalTabBarController.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor blackColor];
    [self.window makeKeyAndVisible];
    
    JDMinimalTabBarController *minimalTabBarViewController = [[JDMinimalTabBarController alloc] init];
    
    UIImageView *sectionOneBackground = [[UIImageView alloc]initWithFrame:self.window.frame];
    [sectionOneBackground setImage:[UIImage imageNamed:@"mb_1"]];
    
    UIImageView *sectionTwoBackground = [[UIImageView alloc]initWithFrame:self.window.frame];
    [sectionTwoBackground setImage:[UIImage imageNamed:@"mb_2"]];
    
    UIImageView *sectionThreeBackground = [[UIImageView alloc]initWithFrame:self.window.frame];
    [sectionThreeBackground setImage:[UIImage imageNamed:@"mb_3"]];
    
    UIImageView *sectionFourBackground = [[UIImageView alloc]initWithFrame:self.window.frame];
    [sectionFourBackground setImage:[UIImage imageNamed:@"mb_4"]];
    
    UIImageView *sectionFiveBackground = [[UIImageView alloc]initWithFrame:self.window.frame];
    [sectionFiveBackground setImage:[UIImage imageNamed:@"mb_5"]];
    
    UITabBarItem* tabBarItemOne = [[UITabBarItem alloc] initWithTitle:@"HOME" image:[UIImage imageNamed:@"icon_1"] selectedImage:[UIImage imageNamed:@"icon_menu"]];
    UITabBarItem* tabBarItemTwo = [[UITabBarItem alloc] initWithTitle:@"LOCATION" image:[UIImage imageNamed:@"icon_2"] selectedImage:[UIImage imageNamed:@"icon_menu"]];
    UITabBarItem* tabBarItemThree = [[UITabBarItem alloc] initWithTitle:@"SPEAK" image:[UIImage imageNamed:@"icon_3"] selectedImage:[UIImage imageNamed:@"icon_menu"]];
    UITabBarItem* tabBarItemFour = [[UITabBarItem alloc] initWithTitle:@"LEVELS" image:[UIImage imageNamed:@"icon_4"] selectedImage:[UIImage imageNamed:@"icon_menu"]];
    UITabBarItem* tabBarItemFive = [[UITabBarItem alloc] initWithTitle:@"SOUNDS" image:[UIImage imageNamed:@"icon_5"] selectedImage:[UIImage imageNamed:@"icon_menu"]];
    
    UIViewController *sectionOneVC = [[UIViewController alloc] init];
    sectionOneVC.tabBarItem = tabBarItemOne;
    [sectionOneVC.view addSubview:sectionOneBackground];
    UIViewController *sectionTwoVC = [[UIViewController alloc] init];
    
    [sectionTwoVC.view addSubview:sectionTwoBackground];

    UIViewController *sectionThreeVC = [[UIViewController alloc] init];
    sectionTwoVC.tabBarItem = tabBarItemTwo;
    sectionThreeVC.tabBarItem = tabBarItemThree;
    [sectionThreeVC.view addSubview:sectionThreeBackground];
    
    UIViewController *sectionFourVC = [[UIViewController alloc] init];
    sectionFourVC.tabBarItem = tabBarItemFour;
    [sectionFourVC.view addSubview:sectionFourBackground];
    
    UIViewController *sectionFiveVC = [[UIViewController alloc] init];
    sectionFiveVC.tabBarItem = tabBarItemFive;
    [sectionFiveVC.view addSubview:sectionFiveBackground];
    
    [self.window setRootViewController:minimalTabBarViewController];

    // Highlight selected section -- DONE
    // Toggle Titles -- DONE
    // Main menu icon or logo -- DONE
    // Navigation controller check -- DONE
    // Menu Icon -- DONE
    // Background Color -- DONE
    // Hide titles when selected toggle -- DONE
    // On release change image icon    
    
    
    // Landscape view
    // GIF -- Quicktime, or
    // Cocoapod -- http://blog.grio.com/2014/11/creating-a-private-cocoapod.html?utm_source=TapFame&utm_campaign=TapFame+newsletter&utm_medium=email
    
    
    minimalTabBarViewController.minimalBar.defaultTintColor = [UIColor whiteColor];
    minimalTabBarViewController.minimalBar.selectedTintColor = [UIColor colorWithRed:222.0f/255.f green:157.0f/255.f blue:0.0f/255.f alpha:1.f];
    minimalTabBarViewController.minimalBar.showTitles = YES;
    minimalTabBarViewController.minimalBar.hidesTitlesWhenSelected = YES;
    minimalTabBarViewController.minimalBar.backgroundColor = [UIColor clearColor];
    [minimalTabBarViewController setViewControllers:@[sectionOneVC, sectionTwoVC, sectionThreeVC, sectionFourVC, sectionFiveVC]];
    
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
