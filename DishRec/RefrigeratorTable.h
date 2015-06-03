//
//  RefrigeratorTable.h
//  DishRec
//
//  Created by Sherman Ng on 10/30/13.
//  Copyright (c) 2013 Sherman Ng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IngredientsVC.h"
#import "IngredientEntity.h"
#import "IngredientModel.h"



@interface RefrigeratorTable : UITableViewController<UITableViewDataSource, UITableViewDelegate>


@property (strong, nonatomic) NSMutableArray *ingredients_selected_array;

@property (strong, nonatomic) NSMutableDictionary *ingredients_selected_info;

@property (strong, nonatomic) NSMutableArray *ingredients_to_delete;

@property (strong, nonatomic) UITableView *ingredients_table;

@property (strong, nonatomic) IngredientsVC *parentController;

//Ingredient CoreData model variables

@property (nonatomic, strong) NSFetchedResultsController *resultsController;
@property (nonatomic, strong) NSMutableArray *fetchedIngredients;

@end
