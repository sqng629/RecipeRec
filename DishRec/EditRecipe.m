//
//  EditRecipe.m
//  DishRec
//
//  Created by Sherman Ng on 9/10/14.
//  Copyright (c) 2014 Sherman Ng. All rights reserved.
//

#import "EditRecipe.h"
#import "RecipeTableViewCell.h"
#import "EditRecipeDetails.h"

@interface EditRecipe ()

@end

NSMutableArray *dishes_from_file;

NSString *databasePath;

@implementation EditRecipe

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
    
    UINib *tableCell = [UINib nibWithNibName:@"RecipeTableViewCell" bundle:nil];
    
    [_recipe_table registerNib:tableCell forCellReuseIdentifier:@"RecipeTableViewCell"];
    
    
    databasePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    databasePath = [databasePath stringByAppendingPathComponent:@"Recipes.plist"];
    
    dishes_from_file = [NSMutableArray arrayWithContentsOfFile:databasePath];
    
    _recipe_table.dataSource = self;
    _recipe_table.delegate = self;
    
}


-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDictionary *recipe_entry = [dishes_from_file objectAtIndex:indexPath.row];
    
    NSString *dish_name = recipe_entry[@"Name"];
    
    
    RecipeTableViewCell *cell = [_recipe_table dequeueReusableCellWithIdentifier:@"RecipeTableViewCell"];
    
    if (cell == nil)
    {
        cell = [[RecipeTableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RecipeTableViewCell"];
        
    }
        
    //add recipe title label and adjust label size
    CGSize name_label_size = [dish_name sizeWithFont:[UIFont fontWithName:@"Helvetica-Bold" size:12] constrainedToSize:CGSizeMake(1000.0, 30)];
        
    [cell.recipe_name_label setFrame:CGRectMake(10, 10, name_label_size.width, 21)];
        
    cell.recipe_name_label.text = dish_name;
    
    cell.backgroundColor = [UIColor blackColor];
    
    cell.recipe_name_label.textColor = [UIColor whiteColor];
    
    return cell;

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dishes_from_file count];
}


-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *recipe_entry = [dishes_from_file objectAtIndex:indexPath.row];
    
    NSString *dish_name = recipe_entry[@"Name"];
    NSMutableArray *ingredients = recipe_entry[@"Ingredients"];
    
    EditRecipeDetails *details_controller = [[EditRecipeDetails alloc] init];
    details_controller.recipe_name = dish_name;
    details_controller.recipe_ingredients = ingredients;
    
    details_controller.title = dish_name;
    
    
    [_recipe_table deselectRowAtIndexPath:indexPath animated:YES];
    
    
    [self.navigationController pushViewController:details_controller animated:YES];
    
}

-(void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_recipe_table beginUpdates];
        
        [_recipe_table deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        //modify the recipes stored in the plist
        
        [dishes_from_file removeObjectAtIndex:indexPath.row];
        
        [dishes_from_file writeToFile:databasePath atomically:YES];
        
        [_recipe_table endUpdates];
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
