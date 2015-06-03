//
//  RRAppDelegate.m
//  DishRec
//
//  Created by Sherman Ng on 10/21/13.
//  Copyright (c) 2013 Sherman Ng. All rights reserved.
//

#import "RRAppDelegate.h"
#import "MainVC.h"
#import "AddRecipeVC.h"
#import "EditRecipe.h"
#import "RecommendationsVC.h"

@implementation RRAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    
    //initialize tab bar controller, and add in all the view controllers to the tab bar controller's viewcontroller array
    
    self.tabBarContrl = [[UITabBarController alloc] init];
    
    self.viewController0 = [[MainVC alloc] initWithNibName:@"MainVC" bundle:nil];
    
    //setup Recommendations VC
    /*self.viewController0.recViewController = [[RecommendationsVC alloc] initWithNibName:@"RecommendationsVC" bundle:nil];
    self.viewController0.recViewController.view.tag = 1;
    self.viewController0.recViewController.delegate = self;
    self.viewController0.recViewController.leftButton.tag = 1;
    
    [self.viewController0.view addSubview:self.viewController0.recViewController.view];
    [self.viewController0 addChildViewController:self.viewController0.recViewController];
    [self.viewController0.recViewController didMoveToParentViewController:self];
    */
    
    //UIImage* tbImage0 = [UIImage imageNamed:@"food.png"];
    UITabBarItem* tbItem0 = [[UITabBarItem alloc] initWithTitle:@"Recommendations" image:nil tag:0];
    
    self.viewController0.tabBarItem = tbItem0;
    
    
    
    //edit recipe view controller
    EditRecipe *edit_recipe_view_controller = [[EditRecipe alloc] initWithNibName:@"EditRecipe" bundle:nil];
    UINavigationController *edit_recipe_nav_controller = [[UINavigationController alloc] initWithRootViewController:edit_recipe_view_controller];
    
    edit_recipe_view_controller.title = @"Edit Recipes";
    
    self.viewController1 = edit_recipe_nav_controller;
    
    //UIImage* tbImage1 = [UIImage imageNamed:@"food.png"];
    UITabBarItem* tbItem1 = [[UITabBarItem alloc] initWithTitle:@"Edit Recipes" image:nil tag:1];
    
    self.viewController1.tabBarItem = tbItem1;
    
    
    self.viewController2 = [[AddRecipeVC alloc] initWithNibName:@"AddRecipeVC" bundle:nil];
    
    self.viewController2.tbc = self.tabBarContrl;
    
    self.viewController2.recVC = self.viewController0.recViewController;
    
    //UIImage* tbImage2 = [UIImage imageNamed:@"food.png"];
    UITabBarItem* tbItem2 = [[UITabBarItem alloc] initWithTitle:@"Add Recipe" image:nil tag:2];
    
    self.viewController2.tabBarItem = tbItem2;
    
    //set the tab bar controller's view controllers
    NSArray *viewControllers = [NSArray arrayWithObjects:self.viewController0, self.viewController2, self.viewController1, nil];
    
    
   
    
    //self.tabBarContrl.viewControllers = viewControllers;
    [self.tabBarContrl setViewControllers:viewControllers];
    
    self.window.rootViewController = self.tabBarContrl;
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
