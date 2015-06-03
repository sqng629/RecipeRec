//
//  AddRecipeVC.m
//  DishRec
//
//  Created by Sherman Ng on 1/18/14.
//  Copyright (c) 2014 Sherman Ng. All rights reserved.
//

#import "AddRecipeVC.h"
#import "RecommendationsVC.h"
#import "JSTokenField.h"
#import "JSTokenButton.h"

@interface AddRecipeVC ()

@end

@implementation AddRecipeVC

UIGestureRecognizer *tap;

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
    
    
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignTextfield:)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
    
    _recipeTitle.tag = 0;
   
    
    _recipeTitle.delegate = self;
    
    _url.tag = 1;
    
    _url.delegate = self;
    
    //add JSToken ingredients input field
    
    
    
    _input_ingredients = [[NSMutableArray alloc] init];
    
    _ingredients_field = [[JSTokenField alloc] initWithFrame:CGRectMake(20, 270, 245, 31)];
	[[_ingredients_field label] setText:@""];
	[_ingredients_field setDelegate:self];
    _ingredients_field.scrollView = _scrollView;
	[self.scrollView addSubview:_ingredients_field];
    
    UIView *separator1 = [[UIView alloc] initWithFrame:CGRectMake(0, _ingredients_field.bounds.size.height-1, _ingredients_field.bounds.size.width, 1)];
    [separator1 setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin];
    [_ingredients_field addSubview:separator1];
    [separator1 setBackgroundColor:[UIColor lightGrayColor]];
    
}

- (void) viewDidLayoutSubviews {
    [_scrollView setContentSize:CGSizeMake(320, 900)];
}


-(void) resignTextfield:(UIGestureRecognizer*) sender
{
    [self.view endEditing:YES];
}


-(void) textFieldDidBeginEditing:(UITextField*)textField
{
    if (textField.tag == 0) {
        [_recipeTitle becomeFirstResponder];
    }
    else if (textField.tag == 1)
    {
        [_url becomeFirstResponder];
    }
    
    CGRect rc = [textField bounds];
    rc = [textField convertRect:rc toView:_scrollView];
    rc.origin.x = 0;
    rc.origin.y -=60;
    
    rc.size.height = 400;
    
    [_scrollView scrollRectToVisible:rc animated:YES];
    
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    if (textField.tag == 0)
    {
        [_recipeTitle resignFirstResponder];
    }
    else if (textField.tag == 1)
    {
        [_url resignFirstResponder];
    }
    
    return NO;
}




-(IBAction)saveRecipe:(id)sender
{
    NSString *databasePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    databasePath = [databasePath stringByAppendingPathComponent:@"Recipes.plist"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:databasePath]) {
        NSString *sourcePath = [[NSBundle mainBundle] pathForResource:@"Recipes" ofType:@"plist"];
        [fileManager copyItemAtPath:sourcePath toPath:databasePath error:nil];
    }
    
    NSMutableArray *dishesFromFile = [[NSMutableArray alloc] initWithContentsOfFile:databasePath];
    
    
    //initialize a new dictionary object with recipe information
    
    NSMutableDictionary *recipeD = [[NSMutableDictionary alloc] init];
    recipeD[@"Name"] = self.recipeTitle.text;
    recipeD[@"Image"] = @"blank.jpg";
    
    //add in ingredient list using the JSToken interface
    NSMutableArray *ingredients_to_add_to_db = [[NSMutableArray alloc] init];
    
    for (int j = 0; j < [_input_ingredients count]; j++)
    {
        NSDictionary *current_token = [_input_ingredients objectAtIndex:j];
        
        NSEnumerator *field_enumerator = [current_token keyEnumerator];
        
        NSString* tokenName;
        
        while (tokenName = [field_enumerator nextObject])
        {
            break;
        }
        
        [ingredients_to_add_to_db addObject:tokenName];
        
    }
    
    recipeD[@"Ingredients"] = ingredients_to_add_to_db;
    
    recipeD[@"URL"] = _url.text;
    
    [dishesFromFile addObject:recipeD];
    
    [dishesFromFile writeToFile:databasePath atomically:YES];
    
    
    //go back to main menu after adding in dish
    [self.tbc setSelectedIndex:0];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction)checkUrl:(id)sender
{
    //NSMutableArray* list_of_search_ingredients = [self array_of_ingredients];
    
    NSURL *website_url = [NSURL URLWithString:_url.text];
    
    NSError *error;
    NSString *resultString = [NSString stringWithContentsOfURL:website_url encoding:NSUTF8StringEncoding error:&error];
    
    NSLog(@"JSON results: %@", resultString);
    
    
}

-(NSMutableArray*)array_of_ingredients
{
    NSMutableArray* ingredients_search_list = [[NSMutableArray alloc] init];
    
    [ingredients_search_list addObject:@"beef"];
    [ingredients_search_list addObject:@"chicken"];
    [ingredients_search_list addObject:@"broccoli"];
    [ingredients_search_list addObject:@"onion"];
    [ingredients_search_list addObject:@"eggs"];
    [ingredients_search_list addObject:@"potato"];
    
    
    return ingredients_search_list;
}


//JSToken methods

- (void)tokenField:(JSTokenField *)tokenField didAddToken:(NSString *)title representedObject:(id)obj
{
	NSDictionary *ingredient = [NSDictionary dictionaryWithObject:obj forKey:title];
	[_input_ingredients addObject:ingredient];
	NSLog(@"Added token for < %@ : %@ >\n%@", title, obj, _input_ingredients);
    
}

- (void)tokenField:(JSTokenField *)tokenField didRemoveTokenAtIndex:(NSUInteger)index
{
	[_input_ingredients removeObjectAtIndex:index];
	NSLog(@"Deleted token %d\n%@", index, _input_ingredients);
}

- (BOOL)tokenFieldShouldReturn:(JSTokenField *)tokenField {
    NSMutableString *recipient = [NSMutableString string];
	
	NSMutableCharacterSet *charSet = [[NSCharacterSet whitespaceCharacterSet] mutableCopy];
	[charSet formUnionWithCharacterSet:[NSCharacterSet punctuationCharacterSet]];
	
    NSString *rawStr = [[tokenField textField] text];
	for (int i = 0; i < [rawStr length]; i++)
	{
		if (![charSet characterIsMember:[rawStr characterAtIndex:i]])
		{
			[recipient appendFormat:@"%@",[NSString stringWithFormat:@"%c", [rawStr characterAtIndex:i]]];
		}
	}
    
    if ([rawStr length])
	{
		[tokenField addTokenWithTitle:rawStr representedObject:recipient];
	}
    
    [tokenField.textField setText:nil];
    
    return NO;
}




/*- (void)handleTokenFieldFrameDidChange:(NSNotification *)note
{
	if ([[note object] isEqual:_toField])
	{
		[UIView animateWithDuration:0.0
						 animations:^{
							 [_ccField setFrame:CGRectMake(0, [_toField frame].size.height + [_toField frame].origin.y, [_ccField frame].size.width, [_ccField frame].size.height)];
						 }
						 completion:nil];
	}
}*/




@end
