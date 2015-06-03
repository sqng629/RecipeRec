//
//  RRAppDelegate.h
//  DishRec
//
//  Created by Sherman Ng on 10/21/13.
//  Copyright (c) 2013 Sherman Ng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MainVC;
@class EditRecipe;
@class AddRecipeVC;
@class RecommendationsVC;

@interface RRAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) MainVC *viewController0;
@property (strong, nonatomic) UINavigationController *viewController1;
@property (strong, nonatomic) AddRecipeVC *viewController2;

@property (strong, nonatomic) UITabBarController *tabBarContrl;

@end
