//
//  EditRecipeDetails.m
//  DishRec
//
//  Created by Sherman Ng on 9/10/14.
//  Copyright (c) 2014 Sherman Ng. All rights reserved.
//

#import "EditRecipeDetails.h"
#import "AddIngredientPopUp.h"

@interface EditRecipeDetails ()<AddIngredientsDelegate>

@end


NSString *databasePath;
NSMutableArray *stored_recipes;


@implementation EditRecipeDetails

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _ingredients_table.delegate = self;
    _ingredients_table.dataSource = self;
    
    
    
    //setup the database path
    
    databasePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    databasePath = [databasePath stringByAppendingPathComponent:@"Recipes.plist"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:databasePath]) {
        NSString *sourcePath = [[NSBundle mainBundle] pathForResource:@"Recipes" ofType:@"plist"];
        [fileManager copyItemAtPath:sourcePath toPath:databasePath error:nil];
    }
    
    stored_recipes = [[NSMutableArray alloc] initWithContentsOfFile:databasePath];

    //add the add ingredient button to the navigation controller
    //self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(add_ingredient_popup)];
    
    
    //put the add and delete ingredients buttons to the navigation controller
    
    UIBarButtonItem *add_button = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(add_ingredient_popup)];
    
    UIBarButtonItem *remove_button = self.editButtonItem;
    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:add_button, remove_button, nil];
    
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [_ingredients_table dequeueReusableCellWithIdentifier:@"ingredientsCell"];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ingredientsCell"];
        
    }
    
    cell.textLabel.text = [_recipe_ingredients objectAtIndex:indexPath.row];
    
    cell.backgroundColor = [UIColor blackColor];
    
    cell.textLabel.textColor = [UIColor whiteColor];

    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_recipe_ingredients count];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_ingredients_table deselectRowAtIndexPath:indexPath animated:YES];
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

-(void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [_ingredients_table beginUpdates];
        
        [_ingredients_table deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        //make the corresponding deletion in the data model
        
        for (int i = 0; i < [stored_recipes count]; i++)
        {
            NSDictionary *recipe = [stored_recipes objectAtIndex:i];
            if ([recipe[@"Name"] isEqualToString:_recipe_name])
            {
                NSMutableArray *ingredients = recipe[@"Ingredients"];
                
                [ingredients removeObjectAtIndex:indexPath.row];
            }
        }
        
        [stored_recipes writeToFile:databasePath atomically:YES];
        
        [_recipe_ingredients removeObjectAtIndex:indexPath.row];
        
        [_ingredients_table endUpdates];
        
    }
    
    
}


//for batch deletes

-(void) setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    [_ingredients_table setEditing:editing animated:animated];
    
}


-(void) add_ingredient_popup
{
    AddIngredientPopUp *popup_controller = [[AddIngredientPopUp alloc] init];
    
    popup_controller.delegate = self;
    
    [popup_controller presentPopUpView:self];
}


-(void) addIngredientsToDatabase:(NSMutableArray*) ingredients
{
    NSString *databasePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    databasePath = [databasePath stringByAppendingPathComponent:@"Recipes.plist"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:databasePath]) {
        NSString *sourcePath = [[NSBundle mainBundle] pathForResource:@"Recipes" ofType:@"plist"];
        [fileManager copyItemAtPath:sourcePath toPath:databasePath error:nil];
    }
    
    [_ingredients_table beginUpdates];
    
    for (int i = 0; i < [stored_recipes count]; i++)
    {
        NSDictionary *recipe = [stored_recipes objectAtIndex:i];
        if ([recipe[@"Name"] isEqualToString:_recipe_name])
        {
            
            //add in ingredient list using the JSToken interface
            NSMutableArray *ingredients_to_add_to_db = recipe[@"Ingredients"];
            
            for (int j = 0; j < [ingredients count]; j++)
            {
                NSDictionary *current_token = [ingredients objectAtIndex:j];
                
                NSEnumerator *field_enumerator = [current_token keyEnumerator];
                
                NSString* tokenName;
                
                while (tokenName = [field_enumerator nextObject])
                {
                    break;
                }
                
                [ingredients_to_add_to_db addObject:tokenName];
                
                [_recipe_ingredients addObject:tokenName];
                
                NSIndexPath *new_row_path = [NSIndexPath indexPathForRow:[_recipe_ingredients count] - 1 inSection:0];
                
                [_ingredients_table insertRowsAtIndexPaths:@[new_row_path] withRowAnimation:UITableViewRowAnimationFade];
                
            }
            
            [stored_recipes writeToFile:databasePath atomically:YES];
        }
        
        
    }
    
    [_ingredients_table endUpdates];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
