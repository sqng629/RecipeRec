//
//  AddRecipeVC.h
//  DishRec
//
//  Created by Sherman Ng on 1/18/14.
//  Copyright (c) 2014 Sherman Ng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreViewController.h"
#import "RecommendationsVC.h"
#import "JSTokenField.h"

//@class JSTokenButton;

@interface AddRecipeVC : CoreViewController <UITextFieldDelegate, JSTokenFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *recipeTitle;


@property (weak, nonatomic) IBOutlet UIButton *saveRecipe;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UITextField *url;

@property (weak, nonatomic) IBOutlet UIButton *check_url;

@property (weak, nonatomic) UITabBarController *tbc;
@property (weak, nonatomic) RecommendationsVC *recVC;

@property (strong, nonatomic) NSMutableArray *input_ingredients;

@property (strong, nonatomic) JSTokenField *ingredients_field;

-(IBAction)saveRecipe:(id)sender;
-(IBAction)checkUrl:(id)sender;

-(NSMutableArray*) array_of_ingredients;

@end
