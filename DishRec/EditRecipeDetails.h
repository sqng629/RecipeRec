//
//  EditRecipeDetails.h
//  DishRec
//
//  Created by Sherman Ng on 9/10/14.
//  Copyright (c) 2014 Sherman Ng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditRecipeDetails : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSString *recipe_name;

@property (nonatomic, strong) NSMutableArray *recipe_ingredients;

@property (nonatomic, weak) IBOutlet UITableView *ingredients_table;


-(void) add_ingredient_popup;

@end
