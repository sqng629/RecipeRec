//
//  RefrigeratorTable.m
//  DishRec
//
//  Created by Sherman Ng on 10/30/13.
//  Copyright (c) 2013 Sherman Ng. All rights reserved.
//

#import "RefrigeratorTable.h"

@implementation RefrigeratorTable

@synthesize ingredients_selected_array;

@synthesize ingredients_selected_info;
@synthesize ingredients_table;
@synthesize ingredients_to_delete;

@synthesize parentController;




- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.ingredients_selected_array = [[NSMutableArray alloc] init];
        self.ingredients_selected_info = [[NSMutableDictionary alloc] init];
        self.ingredients_to_delete = [[NSMutableArray alloc] init];
        
        self.ingredients_table = [[UITableView alloc] initWithFrame:
                              CGRectMake(0, 150, 280, 240) style:UITableViewStylePlain];
        self.ingredients_table.dataSource = self;
        self.ingredients_table.delegate = self;
        
    }
    return self;
}

-(void) viewDidLoad
{
    [super viewDidLoad];
    
    
    [ingredients_table reloadData];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    UITableViewCell *cell = [self.ingredients_table dequeueReusableCellWithIdentifier:@"itCell"];
        
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"itCell"];
        
        //add in a label to display the value of the stepper
        UILabel *ingredient_count = [[UILabel alloc] initWithFrame:CGRectMake(100, 15, 20, 15)];
        [cell.contentView addSubview:ingredient_count];
        [ingredient_count setTag:150];
        
        //add a stepper in for each cell
        UIStepper *stepper = [[UIStepper alloc] initWithFrame:CGRectMake(140, 10, 100, 10)];
        
        stepper.minimumValue = 1;
        [cell.contentView addSubview:stepper];
        [stepper setTag:123];
        [stepper addTarget:self action:@selector(incrementIngredientStepper:) forControlEvents:UIControlEventValueChanged];
        
    }
    cell.textLabel.text = [self.ingredients_selected_array objectAtIndex:indexPath.row];
    [cell.textLabel sizeToFit];
    [cell setTag:indexPath.row];
   
    //set the stepper and label values
    if ([ingredients_selected_array count] > 0) {
        
        int amount_value_int = [ingredients_selected_info[[ingredients_selected_array objectAtIndex:indexPath.row]]intValue];
        
        
        [(UIStepper*)[cell.contentView viewWithTag:123] setValue:(float)amount_value_int];
        [(UILabel*)[cell.contentView viewWithTag:150] setText:[NSString stringWithFormat:@"%d", amount_value_int]];
    }
    else
    {
        [(UIStepper*)[cell.contentView viewWithTag:123] setValue:0.0f];
        [(UILabel*)[cell.contentView viewWithTag:150] setText:[NSString stringWithFormat:@"%d", 0]];
    }
    
    
    
    
    return cell;
    
}

//use ios swipe delete method
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        UITableViewCell *current_cell = [tableView cellForRowAtIndexPath:indexPath];
        
        [ingredients_table beginUpdates];
        
        NSString* ingredients_info_key = [ingredients_selected_array objectAtIndex:indexPath.row];
        [ingredients_selected_array removeObjectAtIndex:indexPath.row];
        [ingredients_selected_info removeObjectForKey:ingredients_info_key];
        
        [ingredients_to_delete addObject:current_cell.textLabel.text];
        
        //keep the data consistent in ingredients array consistent with that of the Ingredients controller
        [parentController.ingredients_selected removeObject:current_cell.textLabel.text];
        
        
        [ingredients_table deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationFade];
        
        [ingredients_table endUpdates];

    }
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

-(void) delete_row:(id)sender
{
    UIButton *delete_button = (UIButton*) sender;
    
    UIView *current_cell_contentview = delete_button.superview;
    
    UITableViewCell *current_cell = (UITableViewCell*)current_cell_contentview.superview.superview;
    
    NSIndexPath *indexpath = [ingredients_table indexPathForCell:current_cell];
    
    [ingredients_table beginUpdates];
    
    NSString* ingredients_info_key = [ingredients_selected_array objectAtIndex:indexpath.row];
    [ingredients_selected_array removeObjectAtIndex:indexpath.row];
    [ingredients_selected_info removeObjectForKey:ingredients_info_key];
    
    [ingredients_to_delete addObject:current_cell.textLabel.text];
    
    //keep the data consistent in ingredients array consistent with that of the Ingredients controller
    [parentController.ingredients_selected removeObject:current_cell.textLabel.text];
    
    
    [ingredients_table deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexpath, nil] withRowAnimation:UITableViewRowAnimationFade];
    
    [ingredients_table endUpdates];
    
}

-(void)incrementIngredientStepper:(id)sender
{
    UIStepper *stepper = (UIStepper*)sender;
    UIView *cell_view = [stepper superview];
    
    UIView* subview = [cell_view viewWithTag:150];
    
    if ([subview isKindOfClass:[UILabel class]])
    {
        ((UILabel*)subview).text = [NSString stringWithFormat:@"%d", (int)stepper.value];
    }
    
    UITableViewCell *current_cell = (UITableViewCell*)cell_view.superview.superview;
    NSIndexPath *indexpath = [ingredients_table indexPathForCell:current_cell];
    
    NSString* ingredients_info_key = [ingredients_selected_array objectAtIndex:indexpath.row];
    ingredients_selected_info[ingredients_info_key] = [NSNumber numberWithInt:(int)stepper.value];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.ingredients_selected_array count];
    
}

#pragma mark UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.ingredients_table deselectRowAtIndexPath:indexPath animated:YES];

}

@end
