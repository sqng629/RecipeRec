//
//  IngredientsVC.h
//  DishRec
//
//  Created by Sherman Ng on 10/21/13.
//  Copyright (c) 2013 Sherman Ng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IngredientModel.h"

@interface IngredientsVC : UIViewController<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, NSFetchedResultsControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *ingredientInput_field;

- (IBAction)didChangeIngredientName:(id)sender;

- (void)searchAutocompleteEntriesWithSubstring:(NSString *)substring;

@property (nonatomic, weak) IBOutlet UIButton *saveButton;
@property (nonatomic, weak) IBOutlet UIButton *deleteButton;


@property (strong, nonatomic) NSMutableSet *ingredients_selected;

//variable to use to store selected ingredients
@property (strong, nonatomic) NSMutableSet *ingredients_to_use;


//Ingredient CoreData model variables

@property (nonatomic, strong) NSFetchedResultsController *resultsController;
@property (nonatomic, strong) NSMutableArray *fetchedIngredients;



@end
