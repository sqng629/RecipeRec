//
//  IngredientsVC.m
//  DishRec
//
//  Created by Sherman Ng on 10/21/13.
//  Copyright (c) 2013 Sherman Ng. All rights reserved.
//

#import "IngredientsVC.h"
#import "RefrigeratorTable.h"
#import "QuartzCore/QuartzCore.h"

@interface IngredientsVC ()


//array containing all ingredient values for autocomplete
@property (strong, nonatomic) NSMutableArray *autocomplete_ingredient_list;

//autocomplete table
@property (strong, nonatomic) UITableView *autocompleteTableView;


//autocomplete matchingElements
@property (strong, nonatomic) NSMutableArray *autocompleteMatchingElements;

//class containing delegate and datasource of ingredients table
@property (strong, nonatomic) RefrigeratorTable *RT;

@end

@implementation IngredientsVC

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
    
    _ingredients_selected = [[NSMutableSet alloc] init];
    
    self.ingredientInput_field.tag = 0;
    
    //fill in autocomplete ingredient list
    _autocomplete_ingredient_list = [[NSMutableArray alloc] init];
    _autocompleteMatchingElements = [[NSMutableArray alloc] init];
    
    NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"Recipes" ofType:@"plist"];
    
    NSArray *dishes_from_file = [NSArray arrayWithContentsOfFile:plistPath];
    NSArray *ingredients_of_dish;
    
    NSDictionary *dish_obj;
    for (int i = 0; i < [dishes_from_file count]; i++)
    {
        dish_obj = [dishes_from_file objectAtIndex:i];
        ingredients_of_dish = dish_obj[@"Ingredients"];
        
        for (int j = 0; j < [ingredients_of_dish count]; j++)
        {
            
            if (![_autocomplete_ingredient_list containsObject:[ingredients_of_dish objectAtIndex:j]])
            {
                [_autocomplete_ingredient_list addObject:[ingredients_of_dish objectAtIndex:j]];
            }
            
        }
        
    }
    
    //autocomplete table
    
    _autocompleteTableView = [[UITableView alloc] initWithFrame:
                             CGRectMake(0, 150, 280, 120) style:UITableViewStylePlain];
    
    _autocompleteTableView.backgroundColor = [UIColor greenColor];
    
    
    _autocompleteTableView.delegate = self;
    _autocompleteTableView.dataSource = self;
    _autocompleteTableView.scrollEnabled = YES;
    _autocompleteTableView.hidden = YES;
    [self.view addSubview:_autocompleteTableView];
    
    //ingredients table
    _RT = [[RefrigeratorTable alloc] init];
    _RT.parentController = self;
    
    _RT.ingredients_table.scrollEnabled = YES;
    _RT.ingredients_table.hidden = NO;
    [self.view addSubview:_RT.ingredients_table];
    
    
    //load in CoreData ingredients data stored on device
    NSArray *fetchedObjects = [self.resultsController fetchedObjects];
    IngredientEntity *ingEnt;
    for (int i = 0; i < [fetchedObjects count]; i++) {
        ingEnt = [fetchedObjects objectAtIndex:i];
        
        [_ingredients_selected addObject:ingEnt.name];
        [_RT.ingredients_selected_array addObject:ingEnt.name];
        [_RT.ingredients_selected_info setObject:ingEnt.ing_amount forKey:ingEnt.name];
        
    }
    
    [self.saveButton setBackgroundColor:[UIColor greenColor]];
    [self.saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    self.saveButton.layer.cornerRadius = 16.0f;
    
    [self.deleteButton setBackgroundColor:[UIColor redColor]];
    [self.deleteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    self.deleteButton.layer.cornerRadius = 16.0f;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark UITextFieldDelegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ((textField.tag == 0) && (![_ingredients_selected containsObject:textField.text]))
    {
        
        [self addIngredientToList:textField.text];
        
        _RT.ingredients_table.hidden = NO;
        
        
        //add a new row to the table of ingredients
        NSIndexPath *path1 = [NSIndexPath indexPathForRow:[_ingredients_selected count]-1 inSection:0];
        NSArray *indexArray = [NSArray arrayWithObjects:path1,nil];
        [_RT.ingredients_table beginUpdates];
        [_RT.ingredients_table insertRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationFade];
        [_RT.ingredients_table endUpdates];
    }
    else
    {
        //close the autocomplete table and redisplay ingredients selected table
        [self.ingredientInput_field resignFirstResponder];
        self.ingredientInput_field.text = @"";
        _autocompleteTableView.hidden = YES;
        _RT.ingredients_table.hidden = NO;
    }
    
    
    return NO;
}




-(void)addIngredientToList:(NSString*)newIng
{
    [self.ingredientInput_field resignFirstResponder];
    
    if (![_ingredients_selected containsObject:newIng])
    {
        
        [_ingredients_selected addObject:newIng];
        [_RT.ingredients_selected_array addObject:newIng];
        [_RT.ingredients_selected_info setObject:[NSNumber numberWithInt:1] forKey:newIng];
        
        
    }
    
    self.ingredientInput_field.text = @"";
    _autocompleteTableView.hidden = YES;
    
}

//input ingredient text field changed
- (IBAction)didChangeIngredientName:(UITextField*)sender
{
    
    if ([sender tag] ==0)
    {
        _autocompleteTableView.hidden = NO;
        _RT.ingredients_table.hidden = YES;
        NSString *substring = [NSString stringWithString:sender.text];
        [self searchAutocompleteEntriesWithSubstring:substring];
        
    }
    
}

//search for all possible autocomplete strings
- (void)searchAutocompleteEntriesWithSubstring:(NSString *)substring {
    
    
    [_autocompleteMatchingElements removeAllObjects];
    for(NSString *curString in _autocomplete_ingredient_list) {
        NSRange substringRange = [curString rangeOfString:substring];
        if (substringRange.location == 0) {
            [_autocompleteMatchingElements addObject:curString];
        }
    }
    [_autocompleteTableView reloadData];
}


//autocomplete table methods
#pragma mark UITableViewDataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [self.autocompleteTableView dequeueReusableCellWithIdentifier:@"acCell"];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]
                    initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"acCell"];
    }
    
    cell.textLabel.text = [self.autocompleteMatchingElements objectAtIndex:indexPath.row];
    
    
    return cell;
    
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.autocompleteMatchingElements count];
    
}

#pragma mark UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *selected_ing = [self.autocompleteMatchingElements objectAtIndex:indexPath.row];
    if (![_ingredients_selected containsObject:selected_ing]) {
        
        
        [_autocompleteTableView deselectRowAtIndexPath:indexPath animated:YES];
        [self addIngredientToList:selected_ing];
        _RT.ingredients_table.hidden = NO;
        
        //add a new row to the table of ingredients
        NSIndexPath *path1 = [NSIndexPath indexPathForRow:[_ingredients_selected count]-1 inSection:0];
        NSArray *indexArray = [NSArray arrayWithObjects:path1,nil];
        [_RT.ingredients_table beginUpdates];
        [_RT.ingredients_table insertRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationFade];
        [_RT.ingredients_table endUpdates];
    }
    else
    {
        //close the autocomplete table
        [self.ingredientInput_field resignFirstResponder];
        self.ingredientInput_field.text = @"";
        _autocompleteTableView.hidden = YES;
        _RT.ingredients_table.hidden = NO;
    }
}


- (IBAction)deleteAction:(id)sender
{
    NSManagedObjectContext *context = [IngredientModel sharedInstance].managedObjectContext;
    
    NSArray *resultsfetched = [_resultsController fetchedObjects];
    
    for (int i = 0; i < [resultsfetched count]; i++) {
        [context deleteObject:[resultsfetched objectAtIndex:i]];
    }
    
    [[IngredientModel sharedInstance] saveChanges];
}

- (IBAction)saveAction:(id)sender
{
   
    NSManagedObjectContext *context = [IngredientModel sharedInstance].managedObjectContext;
    
    NSArray *resultsfetched = [_resultsController fetchedObjects];
    
    NSMutableArray *iids = [NSMutableArray array];
    IngredientEntity *ingEnt;
    
    for (int i = 0; i < [resultsfetched count]; i++)
    {
        ingEnt = [resultsfetched objectAtIndex:i];
        [iids addObject:ingEnt.name];
    }

    NSMutableDictionary *existingIngredients = [[IngredientModel sharedInstance] getExistingIngredientsWithIIDs:iids];
    
    IngredientEntity *ingredient_to_add;
    NSString *iid;
    
    for (int i = 0; i < [_RT.ingredients_selected_array count]; i++)
    {
        iid = [_RT.ingredients_selected_array objectAtIndex:i];
        ingredient_to_add = existingIngredients[iid];
        
        if (ingredient_to_add)
        {
            //ingredient already exists
            //check for modifications on ingredient amount
            
            ingredient_to_add.ing_amount = _RT.ingredients_selected_info[iid];
        }
        else
        {
            ingredient_to_add = [NSEntityDescription insertNewObjectForEntityForName:@"IngredientEntity" inManagedObjectContext:context];
        
            ingredient_to_add.name = [_RT.ingredients_selected_array objectAtIndex:i];
            
            //get ingredient amount
            
            NSNumber *ing_amt;
            ing_amt = _RT.ingredients_selected_info[iid];
            
            ingredient_to_add.ing_amount = ing_amt;
            
            existingIngredients[iid] = ingredient_to_add;
            ingredient_to_add.iid = iid;
        }
    }
    
    //delete removed elements from table
    
    NSMutableDictionary *existingEntriesToDelete = [[IngredientModel sharedInstance] getExistingIngredientsWithIIDs:_RT.ingredients_to_delete];

    NSString* ingredientToDelete;
    for (int i = 0; i < [_RT.ingredients_to_delete count]; i++)
    {
        ingredientToDelete = [_RT.ingredients_to_delete objectAtIndex:i];
        if (![_ingredients_selected containsObject:ingredientToDelete])
        {
            ingEnt = existingEntriesToDelete[ingredientToDelete];
            [context deleteObject:ingEnt];
        }
    }
    
    [[IngredientModel sharedInstance] saveChanges];
}

-(NSFetchedResultsController*) resultsController
{
    if (_resultsController == nil)
    {
        NSFetchRequest *fReq = [[NSFetchRequest alloc] init];
        NSManagedObjectContext *ctxt = [IngredientModel sharedInstance].managedObjectContext;
        
        NSEntityDescription *ent = [NSEntityDescription entityForName:@"IngredientEntity" inManagedObjectContext:ctxt];
        fReq.entity = ent;
        
        NSSortDescriptor *sDesc = [[NSSortDescriptor alloc] initWithKey:@"ing_amount" ascending:YES];
        
        NSArray *sDescs = [[NSArray alloc] initWithObjects:sDesc, nil];
        fReq.sortDescriptors = sDescs;
        
        self.resultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fReq managedObjectContext:ctxt sectionNameKeyPath:nil cacheName:nil];
        
        self.resultsController.delegate = self;
        NSError *error = nil;
        
        if (![self.resultsController performFetch:&error])
        {
            NSLog(@"fetched results error: %@ %@", error, [error userInfo]);
            abort();
        }
    }
    
    return _resultsController;
}

#pragma mark NSFetchedResultsControllerDelegate

-(void) controllerDidChangeContent: (NSFetchedResultsController*) controller
{
}


@end
